//
//  IMORPlayblackCellController.m
//  iMortacci
//
//  Created by Ali Servet Donmez on 8.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import "IMORPlayblackCellController.h"

@implementation IMORPlayblackCellController

@synthesize headerView;
@synthesize imageView;
@synthesize titleTextLabel;
@synthesize descriptionTextLabel;
@synthesize playbackCountTextLabel;
@synthesize likesTextLabel;
@synthesize likesButton;

- (void)dealloc {
    [headerView release];
    [imageView release];
    [titleTextLabel release];
    [descriptionTextLabel release];
    [playbackCountTextLabel release];
    [likesTextLabel release];
    [likesButton release];
    [super dealloc];
}


@end
