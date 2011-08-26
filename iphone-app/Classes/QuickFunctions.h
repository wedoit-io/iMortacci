//
//  iMortacci.h
//  iMortacci
//
//  Created by Ali Servet Donmez on 22.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iMortacciAppDelegate.h"


@interface QuickFunctions : NSObject {
    iMortacciAppDelegate *app;
    NSFileManager *filemanager;
}

@property (nonatomic, retain) iMortacciAppDelegate *app;
@property (nonatomic, retain) NSFileManager *filemanager;

+ (QuickFunctions *)sharedQuickFunctions;

- (id)readJSONValueFromFileInApplicationDirectoryWithName:(NSString *)filename;
- (void)writeJSONRepresentationInApplicationDirectory:(id)jsonObject WithName:(NSString *)filename;

// update
- (void)updateCurrentVersion:(NSDictionary *)version;
- (void)updateAlbums:(NSArray *)albums;
- (void)updateUserInfo:(NSArray *)userInfo;
- (void)updateCounters:(NSArray *)counters;
- (void)updateFavorites:(NSArray *)favorites;

// save
- (void)saveCurrentVersion:(NSDictionary *)latest;
- (void)saveAlbums:(NSArray *)albums;
- (void)saveUserInfo:(NSArray *)userInfo;
- (void)saveCounters:(NSArray *)counters;
- (void)saveFavorites:(NSArray *)favorites;

- (NSString *)getPathForFile:(NSString *)filename;
- (id)getFileByName:(NSString *)filename;
- (NSString *)getTrackNameWithId:(NSUInteger)trackId;
- (id)getTrackWithId:(NSUInteger)trackId;
- (UIImage *)getAlbumArtworkWithSlug:(NSString *)albumSlug AndSize:(NSString *)size;
- (void)saveTrack:(NSData*)data WithId:(NSUInteger)trackId;

@end
