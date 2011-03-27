//
//  iMortacci.m
//  iMortacci
//
//  Created by Ali Servet Donmez on 22.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import "QuickFunctions.h"
#import "SynthesizeSingleton.h"
#import "JSON+Extensions.h"
#import "NSFileManager+Extensions.h"


@implementation QuickFunctions

@synthesize app;
@synthesize filemanager;

SYNTHESIZE_SINGLETON_FOR_CLASS(QuickFunctions);

-(id)init {
	self = [super init];
	if (self != nil) {
        app = (iMortacciAppDelegate *)[[UIApplication sharedApplication] delegate];
        filemanager = [NSFileManager defaultManager];
	}
    
	return self;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [app release];
    [filemanager release];
    [super dealloc];
}


#pragma mark -
#pragma mark Internal methods

- (id)readJSONValueFromFileInApplicationDirectoryWithName:(NSString *)filename {
    return [NSObject readJSONValueFromFile:
            [((NSString *)[filemanager applicationSupportDirectory]) stringByAppendingPathComponent:filename]];
}

- (void)writeJSONRepresentationInApplicationDirectory:(id)jsonObject WithName:(NSString *)filename{
    [jsonObject writeJSONRepresentationToFile:
     [((NSString *)[filemanager applicationSupportDirectory]) stringByAppendingPathComponent:filename]];
}



#pragma mark -
#pragma mark Update methods

- (void)updateCurrentVersion:(NSDictionary *)version {
    if (version == nil) {
        app.currentVersion = [self readJSONValueFromFileInApplicationDirectoryWithName:kCurrentVersionFileName];
    }
    else {
        app.currentVersion = version;
    }
}

- (void)updateAlbums:(NSArray *)albums {
    if (albums == nil) {
        app.currentAlbums = [self readJSONValueFromFileInApplicationDirectoryWithName:kAlbumsFileName];
    }
    else {
        app.currentAlbums = albums;
    }
}

- (void)updateUserInfo:(NSArray *)userInfo {
    if (userInfo == nil) {
        app.userInfo = [self readJSONValueFromFileInApplicationDirectoryWithName:kUserInfoFileName];
    }
    else {
        app.userInfo = userInfo;
    }
}

- (void)updateCounters:(NSArray *)counters {
    if (counters == nil) {
        app.counters = [self readJSONValueFromFileInApplicationDirectoryWithName:kCountersFileName];
    }
    else {
        app.counters = counters;
    }
}

- (void)updateFavorites:(NSArray *)favorites {
    if (favorites == nil) {
        app.favorites = [self readJSONValueFromFileInApplicationDirectoryWithName:kFavoritesFileName];
    }
    else {
        app.favorites = favorites;
    }
}


#pragma mark -
#pragma mark Save methods

- (void)saveCurrentVersion:(NSDictionary *)latest {
    if (latest == nil) {
        NSError *error = nil;
        BOOL success = [filemanager copyItemAtPath:[[NSBundle mainBundle] pathForResource:kCurrentVersionFileName ofType:nil]
                                            toPath:[((NSString *)[filemanager applicationSupportDirectory])
                                                    stringByAppendingPathComponent:kCurrentVersionFileName]
                                             error:&error];
        if (!success) {
            NSLog(@"Unable to copy latest version file from bundle:\n%@", error);
        }
    }
    else {
        [self writeJSONRepresentationInApplicationDirectory:latest
                                                   WithName:kCurrentVersionFileName];
    }
}

- (void)saveAlbums:(NSArray *)albums {
    if (albums == nil) {
        NSError *error = nil;
        BOOL success = [filemanager copyItemAtPath:[[NSBundle mainBundle] pathForResource:kAlbumsFileName ofType:nil]
                                            toPath:[((NSString *)[filemanager applicationSupportDirectory])
                                                    stringByAppendingPathComponent:kAlbumsFileName]
                                             error:&error];
        if (!success) {
            NSLog(@"Unable to copy albums file from bundle:\n%@", error);
        }
    }
    else {
        [self writeJSONRepresentationInApplicationDirectory:albums
                                                   WithName:kAlbumsFileName];
    }
}

- (void)saveUserInfo:(NSArray *)userInfo {
    [self writeJSONRepresentationInApplicationDirectory:userInfo != nil ? userInfo : [NSArray new]
                                               WithName:kUserInfoFileName];
}

- (void)saveCounters:(NSArray *)counters {
    if (counters == nil) {
        NSError *error = nil;
        BOOL success = [filemanager copyItemAtPath:[[NSBundle mainBundle] pathForResource:kCountersFileName ofType:nil]
                                            toPath:[((NSString *)[filemanager applicationSupportDirectory])
                                                    stringByAppendingPathComponent:kCountersFileName]
                                             error:&error];
        if (!success) {
            NSLog(@"Unable to copy counters file from bundle:\n%@", error);
        }
    }
    else {
        [self writeJSONRepresentationInApplicationDirectory:counters
                                                   WithName:kCountersFileName];
    }
}

- (void)saveFavorites:(NSArray *)favorites {
    [self writeJSONRepresentationInApplicationDirectory:favorites != nil ? favorites : [NSArray new]
                                               WithName:kFavoritesFileName];
}


#pragma mark -
#pragma mark Other methods

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

- (id)getAlbumArtworkWithSlug:(NSString *)albumSlug AndSize:(NSString *)size {
    
    NSString *filename = [[NSString stringWithFormat:@"%@-%@", albumSlug, size]
                          stringByAppendingPathExtension:kAlbumArtworkFileExtension];
    
    NSData *image = [self getFileByName:filename];
    if (image == nil) {
        filename = [[NSString stringWithFormat:@"default-%@", size]
                    stringByAppendingPathExtension:kAlbumArtworkFileExtension];
        image = [self getFileByName:filename];
    }
    
    return image;
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

@end
