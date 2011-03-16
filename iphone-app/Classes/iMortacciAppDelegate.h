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
    NSArray *albums;

    Reachability *internetReachable;
    Reachability *hostReachable;
    BOOL internetActive;
    BOOL hostActive;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) NSDictionary *latestVersion;
@property (nonatomic, retain) NSArray *albums;
@property (nonatomic, assign) BOOL internetActive;
@property (nonatomic, assign) BOOL hostActive;

- (BOOL) applicationWillLaunchFirstTime;
- (void) saveLatestVersion:(NSString *)_latestVersion WithAlbums:(NSString *)_albums;
- (void) writeLatestVersion:(NSString *)jsonContent;
- (void) writeAlbums:(NSString *)jsonContent;
- (void) loadLatestData;
- (id) getFileByName:(NSString *)filename;
- (id) getTrackWithId:(NSUInteger)trackId;
- (id) getAlbumArtworkWithSlug:(NSString *)albumSlug;
- (void) checkNetworkStatus:(NSNotification *)notice;
- (void) proceedLaunch;

@end
