//
//  IMORSearchCellController.m
//  iMortacci
//
//  Created by Ali Servet Donmez on 8.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import "IMORSearchCellController.h"


@implementation IMORSearchCellController

@synthesize imageView;
@synthesize titleTextLabel;
@synthesize descriptionTextLabel;
@synthesize playbackCountTextLabel;
@synthesize likesTextLabel;

- (void)dealloc {
    [imageView release];
    [titleTextLabel release];
    [descriptionTextLabel release];
    [playbackCountTextLabel release];
    [likesTextLabel release];
    [super dealloc];
}


@end
