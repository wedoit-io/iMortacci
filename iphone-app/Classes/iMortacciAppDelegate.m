//
//  iMortacciAppDelegate.m
//  iMortacci
//
//  Created by Ali Servet Donmez on 25.2.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import "iMortacciAppDelegate.h"
#import "NSFileManager+DirectoryLocations.h"
#import "JSON.h"
#import "SHK.h"
#import "Reachability.h"


@implementation iMortacciAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize latestVersion;
@synthesize albums;
@synthesize internetActive;
@synthesize hostActive;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.

    if ([self applicationWillLaunchFirstTime]) {
        // This will copy initial data from bundle
        [self saveLatestVersion:nil WithAlbums:nil];
    }
    
    [self loadLatestData];
    
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkNetworkStatus:)
                                                 name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [[Reachability reachabilityForInternetConnection] retain];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [[Reachability reachabilityWithHostName: @"www.google.com"] retain];
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
    [latestVersion release];
    [albums release];
    [super dealloc];
}


#pragma -
#pragma mark Internal methods

- (BOOL) applicationWillLaunchFirstTime {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // This will look like:
    // /User/Applications/<APP_UUID>/Library/Application Support/<APP_NAME>/<FILENAME>
    NSString *_latestVersion = [((NSString *)[fileManager applicationSupportDirectory])
                               stringByAppendingPathComponent:kLatestVersionFileName];
    NSString *_albums = [((NSString *)[fileManager applicationSupportDirectory])
                        stringByAppendingPathComponent:kAlbumsFileName];
    
    return ![fileManager fileExistsAtPath:_latestVersion] || ![fileManager fileExistsAtPath:_albums];
}

- (void) saveLatestVersion:(NSString *)_latestVersion WithAlbums:(NSString *)_albums {
    
    // Either if both 'latestVersion' and 'albums' are empty strings( or nil),
    // or they both are non-empty strings:
    if (([_latestVersion length] == 0 && [_albums length] == 0) ||
        ([_latestVersion length] > 0 && [_albums length] > 0))
    {
        [self writeLatestVersion:_latestVersion];
        [self writeAlbums:_albums];
    }
    else
    {
        NSLog(@"Wrong usage of 'saveLatestVersion:WithAlbums:' method.");
    }
}

- (void) writeLatestVersion:(NSString *)jsonContent {
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([jsonContent length] == 0) {
        BOOL success = [fileManager copyItemAtPath:[[NSBundle mainBundle] pathForResource:kLatestVersionFileName ofType:nil]
                                            toPath:[((NSString *)[fileManager applicationSupportDirectory])
                                                    stringByAppendingPathComponent:kLatestVersionFileName]
                                             error:&error];
        if (!success) {
            NSLog(@"Unable to copy latest version file:\n%@", error);
        }
    }
    else {
        BOOL success = [jsonContent writeToFile:[((NSString *)[fileManager applicationSupportDirectory])
                                                 stringByAppendingPathComponent:kLatestVersionFileName]
                                     atomically:YES
                                       encoding:NSUTF8StringEncoding
                                          error:&error];
        if (!success) {
            NSLog(@"Unable to write latest version data:\n%@", error);
        }
    }
}

- (void) writeAlbums:(NSString *)jsonContent {
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([jsonContent length] == 0) {
        BOOL success = [fileManager copyItemAtPath:[[NSBundle mainBundle] pathForResource:kAlbumsFileName ofType:nil]
                                            toPath:[((NSString *)[fileManager applicationSupportDirectory])
                                                    stringByAppendingPathComponent:kAlbumsFileName]
                                             error:&error];
        if (!success) {
            NSLog(@"Unable to copy albums file:\n%@", error);
        }
    }
    else {
        BOOL success = [jsonContent writeToFile:[((NSString *)[fileManager applicationSupportDirectory])
                                                 stringByAppendingPathComponent:kAlbumsFileName]
                                     atomically:YES
                                       encoding:NSUTF8StringEncoding
                                          error:&error];
        if (!success) {
            NSLog(@"Unable to write albums data:\n%@", error);
        }
    }
}

- (void) loadLatestData {
    NSError *error = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    self.latestVersion = [[[NSString stringWithContentsOfFile:[((NSString *)[fileManager applicationSupportDirectory])
                                                               stringByAppendingPathComponent:kLatestVersionFileName]
                                                     encoding:NSUTF8StringEncoding
                                                        error:&error]
                           JSONValue] retain];
    self.albums = [[[NSString stringWithContentsOfFile:[((NSString *)[fileManager applicationSupportDirectory])
                                                        stringByAppendingPathComponent:kAlbumsFileName]
                                              encoding:NSUTF8StringEncoding
                                                 error:&error]
                    JSONValue] retain];
}

- (id) getFileByName:(NSString *)filename {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // First read from app bundle
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:filename];
    
    // If file isn't in bundle then read from app support directory
    // (this means user has a previous version of iMortacci, but has downloaded
    // some new tracks via update.
    if (![fileManager fileExistsAtPath:path]) {
        path = [((NSString *)[fileManager applicationSupportDirectory]) stringByAppendingPathComponent:filename];
    }
    
    // Returns a data object by reading every byte from the file specified by path
    // or nil if the data object could not be created.
    return [NSData dataWithContentsOfFile:path];
}

- (id) getTrackWithId:(NSUInteger)trackId {
    return [self getFileByName:[[NSString stringWithFormat:@"%d", trackId] stringByAppendingPathExtension:kTrackFileExtension]];
}

- (id) getAlbumArtworkWithSlug:(NSString *)albumSlug {
    return [self getFileByName:[albumSlug stringByAppendingPathExtension:kAlbumArtworkFileExtension]];
}

- (void) checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            self.internetActive = NO;
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            self.internetActive = YES;
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            self.internetActive = YES;
            break;
        }
    }
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    
    {
        case NotReachable:
        {
            NSLog(@"A gateway to the host server is down.");
            self.hostActive = NO;
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"A gateway to the host server is working via WIFI.");
            self.hostActive = YES;
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"A gateway to the host server is working via WWAN.");
            self.hostActive = YES;
            break;
        }
    }

    [self proceedLaunch];
}

- (void) proceedLaunch {
    NSLog(@"internetActive = %d", internetActive);
    NSLog(@"hostActive = %d", hostActive);
}

@end
