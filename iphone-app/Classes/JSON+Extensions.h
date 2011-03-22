//
//  SBJSON+Extensions.h
//  iMortacci
//
//  Created by Ali Servet Donmez on 22.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"


@interface NSObject (JSON_Extensions)

+ (id)readJSONValueFromFile:(NSString *)filename;
- (void)writeJSONRepresentationToFile:(NSString *)filename;

@end
