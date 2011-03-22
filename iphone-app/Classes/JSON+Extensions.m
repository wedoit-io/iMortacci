//
//  SBJSON+Extensions.m
//  iMortacci
//
//  Created by Ali Servet Donmez on 22.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import "JSON+Extensions.h"


@implementation NSObject (JSON_Extensions)

+ (id)readJSONValueFromFile:(NSString *)filename {
    NSError *error = nil;
    id jsonValue = [[[NSString stringWithContentsOfFile:filename
                                               encoding:NSUTF8StringEncoding
                                                  error:&error]
                     JSONValue] retain];
    if (error != nil) {
        NSLog(@"Error reading json value from file: %@", error);
    }
    return jsonValue;
}

- (void)writeJSONRepresentationToFile:(NSString *)filename {
    NSError *error = nil;
    BOOL success = [[self JSONRepresentation] writeToFile:filename
                                               atomically:YES
                                                 encoding:NSUTF8StringEncoding
                                                    error:&error];
    if (!success) {
        NSLog(@"Unable to write json to file:\n%@", error);
    }
}

@end
