//
//  IMORNewestCellController.m
//  iMortacci
//
//  Created by Ali Servet Donmez on 14.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import "IMORNewestCellController.h"


@implementation IMORNewestCellController

@synthesize updatesAvailableImage;
@synthesize updatesUnavailableImage;
@synthesize updateButton;

- (void)dealloc {
    [updateButton release];
    [updatesAvailableImage release];
    [updatesUnavailableImage release];
    [super dealloc];
}

@end
