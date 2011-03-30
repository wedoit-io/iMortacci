//
//  IMORTopChartCellController.m
//  iMortacci
//
//  Created by Ali Servet Donmez on 8.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import "IMORTopChartCellController.h"
#import "iMortacci.h"


@implementation IMORTopChartCellController

@synthesize imageView;
@synthesize titleTextLabel;
@synthesize descriptionTextLabel;
@synthesize playbackCountTextLabel;
@synthesize likesTextLabel;
@synthesize rankView;
@synthesize rankTextLabel;

- (void)dealloc {
    [imageView release];
    [titleTextLabel release];
    [descriptionTextLabel release];
    [playbackCountTextLabel release];
    [likesTextLabel release];
    [rankView release];
    [rankTextLabel release];
    [super dealloc];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	[super setHighlighted:highlighted animated:animated];

    self.titleTextLabel.shadowColor = highlighted ? [UIColor darkGrayColor] : [UIColor whiteColor];
    self.descriptionTextLabel.shadowColor = highlighted ? [UIColor darkGrayColor] : [UIColor whiteColor];
    self.playbackCountTextLabel.shadowColor = highlighted ? [UIColor darkGrayColor] : [UIColor whiteColor];
    self.likesTextLabel.shadowColor = highlighted ? [UIColor darkGrayColor] : [UIColor whiteColor];
    
    self.titleTextLabel.shadowOffset = highlighted ? CGSizeMake(0, -1) : CGSizeMake(0, 1);
    self.descriptionTextLabel.shadowOffset = highlighted ? CGSizeMake(0, -1) : CGSizeMake(0, 1);
    self.playbackCountTextLabel.shadowOffset = highlighted ? CGSizeMake(0, -1) : CGSizeMake(0, 1);
    self.likesTextLabel.shadowOffset = highlighted ? CGSizeMake(0, -1) : CGSizeMake(0, 1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
    
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:kIMORColorGreen];
    self.selectedBackgroundView = bgColorView;
    [bgColorView release];
    
    self.titleTextLabel.shadowColor = selected ? [UIColor darkGrayColor] : [UIColor whiteColor];
    self.descriptionTextLabel.shadowColor = selected ? [UIColor darkGrayColor] : [UIColor whiteColor];
    self.playbackCountTextLabel.shadowColor = selected ? [UIColor darkGrayColor] : [UIColor whiteColor];
    self.likesTextLabel.shadowColor = selected ? [UIColor darkGrayColor] : [UIColor whiteColor];
    
    self.titleTextLabel.shadowOffset = selected ? CGSizeMake(0, -1) : CGSizeMake(0, 1);
    self.descriptionTextLabel.shadowOffset = selected ? CGSizeMake(0, -1) : CGSizeMake(0, 1);
    self.playbackCountTextLabel.shadowOffset = selected ? CGSizeMake(0, -1) : CGSizeMake(0, 1);
    self.likesTextLabel.shadowOffset = selected ? CGSizeMake(0, -1) : CGSizeMake(0, 1);
}

@end
