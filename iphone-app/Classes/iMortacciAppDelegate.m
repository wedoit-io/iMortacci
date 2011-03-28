//
//  iMortacciAppDelegate.m
//  iMortacci
//
//  Created by Ali Servet Donmez on 25.2.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import "iMortacciAppDelegate.h"
#import "iMortacci.h"
#import "QuickFunctions.h"
#import "NSFileManager+Extensions.h"
#import "JSON+Extensions.h"
#import "SHK.h"
#import "Reachability.h"
#import "GTMHTTPFetcher.h"
#import "SHKFacebook.h"


@implementation iMortacciAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize currentVersion;
@synthesize latestVersion;
@synthesize currentAlbums;
@synthesize counters;
@synthesize newItemsCount;
@synthesize localUserInfo;
@synthesize favorites;
@synthesize firstPlay;
@synthesize internetReachable;
@synthesize hostReachable;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    
    firstPlay = YES;
    
    // Let's sleep a little before doing anything else: this will assure that
    // the user will see iMortacco launch image for at least given amount of
    // seconds below
    sleep(3);
    
    // Register with the Apple Push Notification service ("push service")
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    
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
    hostReachable = [[Reachability reachabilityWithHostName:kReachabilityHostName] retain];
    [hostReachable startNotifier];
    
    // now patiently wait for the notification...
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
    
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
    
    [[QuickFunctions sharedQuickFunctions] saveUserInfo:localUserInfo];
    [[QuickFunctions sharedQuickFunctions] saveFavorites:favorites];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    
    firstPlay = YES;
    
    [self checkNetworkStatus:nil];
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
    
    [self applicationDidEnterBackground:nil];
}


#pragma mark -
#pragma mark Url handling


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    SHKFacebook *fbSharer = [[[SHKFacebook alloc] init] autorelease];
    return [[fbSharer facebook] handleOpenURL:url]; 
}


#pragma mark -
#pragma mark Push notifications

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    // Call APNS Server
    NSString *tokenDescription = [deviceToken description];
    NSString *tokenTrimmed = [tokenDescription stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSString *tokenWithoutSpaces = [tokenTrimmed stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *myToken = tokenWithoutSpaces;
    
    NSString *urlString = [NSString stringWithFormat:@"%@?CMD=initapp&appkey=%@&devtoken=%@", kAppServerUrl, kAppKey, myToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    GTMHTTPFetcher* fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    [fetcher beginFetchWithDelegate:nil didFinishSelector:nil];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSString *alertMsg;
    
    // Check alert param
    if( [[userInfo objectForKey:@"aps"] objectForKey:@"alert"] != NULL) {
        alertMsg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"iMortacci" message:alertMsg delegate:self cancelButtonTitle:@"Chiudi"  otherButtonTitles:@"Visualizza", nil];
        [alert show]; 
        [alert release];
    }
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
    [localUserInfo release];
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
    switch (internetStatus)
    {
        case ReachableViaWiFi:
        case ReachableViaWWAN:
        {
            // Send&receive various stuff if connection is active
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
    NSString *urlString = [NSString stringWithFormat:@"%@/latest", kAPIURL];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    GTMHTTPFetcher* itemsFetcher = [GTMHTTPFetcher fetcherWithRequest:request];
//    [itemsFetcher.fetchHistory removeCachedDataForRequest:request];
    [itemsFetcher beginFetchWithDelegate:self didFinishSelector:@selector(checkLatestFetcher:finishedWithData:error:)];
}

- (void)sendAndReceiveCounters {
    // send&receive 'like_status' and 'user_playback_count' information
    NSString *urlString = [NSString stringWithFormat:@"%@/counters", kAPIURL];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"PUT"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    GTMHTTPFetcher* itemsFetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    [itemsFetcher setPostData:[[localUserInfo JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding]];
    [itemsFetcher beginFetchWithDelegate:self didFinishSelector:@selector(sendAndReceiveCountersFetcher:finishedWithData:error:)];
}


#pragma mark -
#pragma mark GTMHTTPFetcher callback

- (void)checkLatestFetcher:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)retrievedData error:(NSError *)error {
    
    if (error == nil) {
        // fetch succeeded
        
        latestVersion = [[[[NSString alloc] initWithData:retrievedData encoding:NSUTF8StringEncoding] JSONValue] retain];
        
        if (latestVersion != nil && ![[latestVersion valueForKey:@"hash"] isEqualToString:[currentVersion valueForKey:@"hash"]]) {
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
        
        NSArray *newCounters = [[[[NSString alloc] initWithData:retrievedData encoding:NSUTF8StringEncoding] JSONValue] retain];
        if (newCounters != nil) {
            [[QuickFunctions sharedQuickFunctions] updateCounters:newCounters];
            for (int i = 0; i < [localUserInfo count]; i++) {
                NSNumber *newLikeStatus = [[[localUserInfo objectAtIndex:i] valueForKey:@"like_status"] isEqualToNumber:[NSNumber numberWithInt:1]]
                ? [NSNumber numberWithInt:2]
                : [[localUserInfo objectAtIndex:i] valueForKey:@"like_status"];

                [localUserInfo replaceObjectAtIndex:i withObject:[NSDictionary dictionaryWithObjects:
                                                                  [NSArray arrayWithObjects:
                                                                   [[localUserInfo objectAtIndex:i] valueForKey:@"id"],
                                                                   newLikeStatus,
                                                                   [NSNumber numberWithInt:0],
                                                                   nil]
                                                                                             forKeys:
                                                                  [NSArray arrayWithObjects:
                                                                   @"id",
                                                                   @"like_status",
                                                                   @"user_playback_count",
                                                                   nil]]];
            }
        }
    }
}

@end
