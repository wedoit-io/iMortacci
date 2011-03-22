//
//  NSFileManager+Extensions.m
//  iMortacci
//
//  Created by Ali Servet Donmez on 22.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import "NSFileManager+Extensions.h"


@implementation NSFileManager (NSFileManager_Extensions)

+ (BOOL)fileExistsInApplicationSupportDirectory:(NSString *)filename {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // This will look like: /User/Applications/<APP_UUID>/Library/Application Support/<APP_NAME>/<FILENAME>
    NSString *filePath = [((NSString *)[fileManager applicationSupportDirectory])
                          stringByAppendingPathComponent:filename];
    return [fileManager fileExistsAtPath:filePath];
}

@end
