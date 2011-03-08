//
//  iMortacciAppDelegate.h
//  iMortacci
//
//  Created by Ali Servet Donmez on 25.2.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iMortacciAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
    NSDictionary *latestVersion;
    NSArray *albums;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) NSDictionary *latestVersion;
@property (nonatomic, retain) NSArray *albums;

- (BOOL) applicationWillLaunchFirstTime;
- (void) saveLatestVersion:(NSString *)_latestVersion WithAlbums:(NSString *)_albums;
- (void) writeLatestVersion:(NSString *)jsonContent;
- (void) writeAlbums:(NSString *)jsonContent;
- (void) loadLatestData;
- (id) getTrackWithId:(NSUInteger)trackId;

@end
