//
//  iMortacciAppDelegate.m
//  iMortacci
//
//  Created by Ali Servet Donmez on 25.2.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import "iMortacciAppDelegate.h"
#import "QuickFunctions.h"
#import "NSFileManager+Extensions.h"
#import "JSON+Extensions.h"
#import "SHK.h"
#import "Reachability.h"
#import "GTMHTTPFetcher.h"


@implementation iMortacciAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize currentVersion;
@synthesize latestVersion;
@synthesize currentAlbums;
@synthesize counters;
@synthesize newItemsCount;
@synthesize userInfo;
@synthesize favorites;
@synthesize alertShowed;
@synthesize internetReachable;
@synthesize hostReachable;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    
    if ([self applicationWillLaunchFirstTime]) {
        // This will copy initial data from bundle
        [[QuickFunctions sharedQuickFunctions] saveCurrentVersion:nil];
        [[QuickFunctions sharedQuickFunctions] saveAlbums:nil];
        [[QuickFunctions sharedQuickFunctions] saveUserInfo:nil];
        [[QuickFunctions sharedQuickFunctions] saveCounters:nil];
        [[QuickFunctions sharedQuickFunctions] saveFavorites:nil];
    }
    
    [[QuickFunctions sharedQuickFunctions] updateCurrentVersion:nil];
    [[QuickFunctions sharedQuickFunctions] updateAlbums:nil];
    [[QuickFunctions sharedQuickFunctions] updateUserInfo:nil];
    [[QuickFunctions sharedQuickFunctions] updateCounters:nil];
    [[QuickFunctions sharedQuickFunctions] updateFavorites:nil];
    
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkNetworkStatus:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    internetReachable = [[Reachability reachabilityForInternetConnection] retain];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [[Reachability reachabilityWithHostName:kIMORHostName] retain];
    [hostReachable startNotifier];
    
    // now patiently wait for the notification...
    
    // Add the tab bar controller's view to the window and display.
    [self.window addSubview:tabBarController.view];
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    
    [[QuickFunctions sharedQuickFunctions] saveUserInfo:userInfo];
    [[QuickFunctions sharedQuickFunctions] saveFavorites:favorites];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark UITabBarControllerDelegate methods

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [tabBarController release];
    [window release];
    [currentVersion release];
    [latestVersion release];
    [currentAlbums release];
    [counters release];
    [userInfo release];
    [favorites release];
    [internetReachable release];
    [hostReachable release];
    [super dealloc];
}


#pragma -
#pragma mark Internal methods

- (BOOL)applicationWillLaunchFirstTime {
    return !([NSFileManager fileExistsInApplicationSupportDirectory:kCurrentVersionFileName] &&
             [NSFileManager fileExistsInApplicationSupportDirectory:kAlbumsFileName] &&
             [NSFileManager fileExistsInApplicationSupportDirectory:kCountersFileName]);
}

- (void)checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    
    // Alert user about connection status
    if (!alertShowed) {
        switch (internetStatus)
        {
            case NotReachable:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Infame!"
                                                                message:@"A quanto pare non sei connesso a internet, ma non ti preoccupare. iMortacci funzionerà però non sarà possibile aggiornarla con gli ultimi mortaccioni."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Pazienza"
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
                alertShowed = YES;
                break;
            }
                
            case ReachableViaWWAN:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Che palle!"
                                                                message:@"Non sei connesso ad una rete senza fili. iMortacci funzionerà però gli aggiornamenti potrebbero essere molto lenti."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Vabè"
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
                alertShowed = YES;
                break;
            }
                
            default:
                break;
        }
    }

    // Send&receive various stuff if connection is active
    switch (internetStatus)
    {
        case ReachableViaWiFi:
        case ReachableViaWWAN:
        {
            [self checkLatest];
            [self sendAndReceiveCounters];
            break;
        }
            
        default:
            break;
    }
}

- (void)checkLatest {
    // checks latest version and update badge accordingly
    NSString *urlString = [NSString stringWithFormat:@"%@/latest", kIMORAPIURL];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    GTMHTTPFetcher* itemsFetcher = [GTMHTTPFetcher fetcherWithRequest:request];
//    [itemsFetcher.fetchHistory removeCachedDataForRequest:request];
    [itemsFetcher beginFetchWithDelegate:self didFinishSelector:@selector(checkLatestFetcher:finishedWithData:error:)];
}

- (void)sendAndReceiveCounters {
    // send&receive 'like_status' and 'user_playback_count' information
    NSString *urlString = [NSString stringWithFormat:@"%@/counters", kIMORAPIURL];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    GTMHTTPFetcher* itemsFetcher = [GTMHTTPFetcher fetcherWithRequest:request];

    SBJsonWriter *jsonWriter = [SBJsonWriter new];

    NSError *error = nil;
    NSString *userInfoString = [jsonWriter stringWithObject:userInfo error:&error];
    if (error == nil) {
        [itemsFetcher setPostData:[userInfoString dataUsingEncoding:NSUTF8StringEncoding
                                               allowLossyConversion:YES]];
    }
    else {
        NSLog(@"Unable to serialize user info: %@", error);
    }
    
    [jsonWriter release];

    [itemsFetcher beginFetchWithDelegate:self didFinishSelector:@selector(sendAndReceiveCountersFetcher:finishedWithData:error:)];
}


#pragma mark -
#pragma mark GTMHTTPFetcher callback

- (void)checkLatestFetcher:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)retrievedData error:(NSError *)error {
    
    if (error == nil) {
        // fetch succeeded
        
        latestVersion = [[[[NSString alloc] initWithData:retrievedData encoding:NSUTF8StringEncoding] JSONValue] retain];
        
        if (![[latestVersion valueForKey:@"hash"] isEqualToString:[currentVersion valueForKey:@"hash"]]) {
            newItemsCount = [[latestVersion valueForKey:@"object_count"] intValue] - [[currentVersion valueForKey:@"object_count"] intValue];
            
            // Any change on SoundCloud will generate a new version of albums database, but
            // it doesn't necessarly have to have new tracks available, e.g. modified titles or descriptions, etc.
            // Therefore here we check if remote object_count is greater than locale count.
            if (newItemsCount > 0) {
                [[tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%d", newItemsCount]];
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:newItemsCount];
            }
            else {
                [[tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:nil];
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            }
        }
    }
}

- (void)sendAndReceiveCountersFetcher:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)retrievedData error:(NSError *)error {
    
    if (error == nil) {
        // fetch succeeded
        
        NSString *jsonString = [[NSString alloc] initWithData:retrievedData encoding:NSUTF8StringEncoding];
        counters = [[jsonString JSONValue] retain];
    }
}

@end
