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

    NSDictionary *currentVersion;
    NSDictionary *latestVersion;
    NSArray *currentAlbums;
    NSArray *counters;
    NSUInteger newItemsCount;
    NSArray *userInfo;
    NSArray *favorites;

    BOOL alertShowed;
    Reachability *internetReachable;
    Reachability *hostReachable;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) NSDictionary *currentVersion;
@property (nonatomic, retain) NSDictionary *latestVersion;
@property (nonatomic, retain) NSArray *currentAlbums;
@property (nonatomic, retain) NSArray *counters;
@property (nonatomic, assign) NSUInteger newItemsCount;
@property (nonatomic, retain) NSArray *userInfo;
@property (nonatomic, retain) NSArray *favorites;
@property (nonatomic, assign) BOOL alertShowed;
@property (nonatomic, retain) Reachability *internetReachable;
@property (nonatomic, retain) Reachability *hostReachable;

- (BOOL)applicationWillLaunchFirstTime;
- (void)checkNetworkStatus:(NSNotification *)notice;
- (void)checkLatest;
- (void)sendAndReceiveCounters;

@end
