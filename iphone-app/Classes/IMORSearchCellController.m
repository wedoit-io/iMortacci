//
//  IMORSearchCellController.m
//  iMortacci
//
//  Created by Ali Servet Donmez on 8.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import "IMORSearchCellController.h"


@implementation IMORSearchCellController

@synthesize titleTextLabel;
@synthesize descriptionTextLabel;
@synthesize playbackCountTextLabel;

- (void)dealloc {
    [titleTextLabel release];
    [descriptionTextLabel release];
    [playbackCountTextLabel release];
    [super dealloc];
}


@end
