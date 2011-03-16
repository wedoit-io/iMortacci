//
//  IMORNewestCellController.m
//  iMortacci
//
//  Created by Ali Servet Donmez on 14.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import "IMORNewestCellController.h"


@implementation IMORNewestCellController

@synthesize updateButton;
@synthesize noUpdatesLabel;

- (void)dealloc {
    [updateButton release];
    [noUpdatesLabel release];
    [super dealloc];
}


@end
