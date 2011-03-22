//
//  NSFileManager+Extensions.h
//  iMortacci
//
//  Created by Ali Servet Donmez on 22.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSFileManager+DirectoryLocations.h"


@interface NSFileManager (NSFileManager_Extensions)

+ (BOOL)fileExistsInApplicationSupportDirectory:(NSString *)filename;

@end
