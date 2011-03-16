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
#import "GTMHTTPFetcher.h"


@implementation iMortacciAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize latestVersion;
@synthesize latestVersionRemoteString;
@synthesize latestVersionRemote;
@synthesize albums;
@synthesize counters;
@synthesize newItemsCount;
@synthesize internetReachable;
@synthesize hostReachable;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.

    if ([self applicationWillLaunchFirstTime]) {
        // This will copy initial data from bundle
        [self saveLatestVersion:nil WithAlbums:nil AndCounters:nil];
    }
    
    [self loadLatestData];
    
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
    [latestVersionRemoteString release];
    [latestVersionRemote release];
    [albums release];
    [counters release];
    [internetReachable release];
    [hostReachable release];
    [super dealloc];
}


#pragma -
#pragma mark Internal methods

- (BOOL)applicationWillLaunchFirstTime {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // This will look like:
    // /User/Applications/<APP_UUID>/Library/Application Support/<APP_NAME>/<FILENAME>
    NSString *_latestVersion = [((NSString *)[fileManager applicationSupportDirectory])
                               stringByAppendingPathComponent:kLatestVersionFileName];
    NSString *_albums = [((NSString *)[fileManager applicationSupportDirectory])
                         stringByAppendingPathComponent:kAlbumsFileName];
    NSString *_counters = [((NSString *)[fileManager applicationSupportDirectory])
                           stringByAppendingPathComponent:kCountersFileName];
    
    return
    ![fileManager fileExistsAtPath:_latestVersion] ||
    ![fileManager fileExistsAtPath:_albums] ||
    ![fileManager fileExistsAtPath:_counters];
}

- (void)saveLatestVersion:(NSString *)_latestVersion WithAlbums:(NSString *)_albums AndCounters:(NSString *)_counters {
    
    // Either if all input has to be empty (first launch of this app.) or
    // all parameters have to be non-empty strings.
    if (([_latestVersion length] == 0 && [_albums length] == 0 && [_counters length] == 0) ||
        ([_latestVersion length] > 0 && [_albums length] > 0 && [_counters length] > 0))
    {
        [self writeLatestVersion:_latestVersion];
        [self writeAlbums:_albums];
        [self writeCounters:_counters];
    }
    else
    {
        NSLog(@"Wrong usage of 'saveLatestVersion:WithAlbums:AndCounters:' method.");
    }
}

- (void)writeLatestVersion:(NSString *)jsonContent {
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

- (void)writeAlbums:(NSString *)jsonContent {
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

- (void)writeCounters:(NSString *)jsonContent {
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([jsonContent length] == 0) {
        BOOL success = [fileManager copyItemAtPath:[[NSBundle mainBundle] pathForResource:kCountersFileName ofType:nil]
                                            toPath:[((NSString *)[fileManager applicationSupportDirectory])
                                                    stringByAppendingPathComponent:kCountersFileName]
                                             error:&error];
        if (!success) {
            NSLog(@"Unable to copy counters file:\n%@", error);
        }
    }
    else {
        BOOL success = [jsonContent writeToFile:[((NSString *)[fileManager applicationSupportDirectory])
                                                 stringByAppendingPathComponent:kCountersFileName]
                                     atomically:YES
                                       encoding:NSUTF8StringEncoding
                                          error:&error];
        if (!success) {
            NSLog(@"Unable to write counters data:\n%@", error);
        }
    }
}

- (void)loadLatestData {
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
    self.counters = [[[NSString stringWithContentsOfFile:[((NSString *)[fileManager applicationSupportDirectory])
                                                          stringByAppendingPathComponent:kCountersFileName]
                                                encoding:NSUTF8StringEncoding
                                                   error:&error]
                      JSONValue] retain];
}

- (id)getFileByName:(NSString *)filename {
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

- (id)getTrackWithId:(NSUInteger)trackId {
    return [self getFileByName:[[NSString stringWithFormat:@"%d", trackId] stringByAppendingPathExtension:kTrackFileExtension]];
}

- (id)getAlbumArtworkWithSlug:(NSString *)albumSlug {
    return [self getFileByName:[albumSlug stringByAppendingPathExtension:kAlbumArtworkFileExtension]];
}

- (void)saveTrack:(NSData*)data WithId:(NSUInteger)trackId {
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filename = [[NSString stringWithFormat:@"%d", trackId] stringByAppendingPathExtension:kTrackFileExtension];
    BOOL success = [data writeToFile:[((NSString *)[fileManager applicationSupportDirectory])
                                      stringByAppendingPathComponent:filename]
                             options:NSDataWritingAtomic
                               error:&error];
    if (!success) {
        NSLog(@"Unable save track:\n%@", error);
    }
}

- (void)checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    
    // Alert user about connection status
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
            // TODO: send&receive playback counters
            // TODO: send likes
            break;
        }
    }
}

- (void)checkLatest {
    // checks latest version and update badge accordingly
    NSString *urlString = [NSString stringWithFormat:@"%@/latest", kIMORAPIURL];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    GTMHTTPFetcher* itemsFetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    [itemsFetcher.fetchHistory removeCachedDataForRequest:request];
    [itemsFetcher beginFetchWithDelegate:self didFinishSelector:@selector(checkLatestFetcher:finishedWithData:error:)];
}


#pragma mark -
#pragma mark GTMHTTPFetcher callback

- (void)checkLatestFetcher:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)retrievedData error:(NSError *)error {
    
    if (error == nil) {
        // fetch succeeded
        
        latestVersionRemoteString = [[NSString alloc] initWithData:retrievedData encoding:NSUTF8StringEncoding];
        latestVersionRemote = [[latestVersionRemoteString JSONValue] retain];
        
        if (![[latestVersionRemote valueForKey:@"hash"] isEqualToString:[latestVersion valueForKey:@"hash"]]) {
            newItemsCount = [[latestVersionRemote valueForKey:@"object_count"] intValue] - [[latestVersion valueForKey:@"object_count"] intValue];
            
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

@end
