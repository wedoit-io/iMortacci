//
//  iMortacciAppDelegate.h
//  iMortacci
//
//  Created by Ali Servet Donmez on 25.2.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Reachability;


@interface iMortacciAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;

    NSDictionary *latestVersion;
    NSString *latestVersionRemoteString;
    NSDictionary *latestVersionRemote;
    NSArray *albums;
    NSArray *counters;
    NSUInteger newItemsCount;

    Reachability *internetReachable;
    Reachability *hostReachable;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) NSDictionary *latestVersion;
@property (nonatomic, retain) NSString *latestVersionRemoteString;
@property (nonatomic, retain) NSDictionary *latestVersionRemote;
@property (nonatomic, retain) NSArray *albums;
@property (nonatomic, retain) NSArray *counters;
@property (nonatomic, assign) NSUInteger newItemsCount;
@property (nonatomic, retain) Reachability *internetReachable;
@property (nonatomic, retain) Reachability *hostReachable;

- (BOOL)applicationWillLaunchFirstTime;
- (void)saveLatestVersion:(NSString *)_latestVersion WithAlbums:(NSString *)_albums AndCounters:(NSString *)_counters;
- (void)writeLatestVersion:(NSString *)jsonContent;
- (void)writeAlbums:(NSString *)jsonContent;
- (void)writeCounters:(NSString *)jsonContent;
- (void)loadLatestData;
- (id)getFileByName:(NSString *)filename;
- (id)getTrackWithId:(NSUInteger)trackId;
- (id)getAlbumArtworkWithSlug:(NSString *)albumSlug;
- (void)saveTrack:(NSData*)data WithId:(NSUInteger)trackId;
- (void)checkNetworkStatus:(NSNotification *)notice;
- (void)checkLatest;

@end
