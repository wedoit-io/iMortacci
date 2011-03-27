//
//  IMORFavoritesCellController.m
//  iMortacci
//
//  Created by Ali Servet Donmez on 8.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import "IMORFavoritesCellController.h"


@implementation IMORFavoritesCellController

@synthesize imageView;
@synthesize titleTextLabel;
@synthesize descriptionTextLabel;
@synthesize playbackCountTextLabel;
@synthesize likesTextLabel;

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[self setNeedsLayout];
}

- (void)layoutSubviews
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
    
	[super layoutSubviews];
    
	if (((UITableView *)self.superview).isEditing)
	{
		CGRect contentFrame = self.contentView.frame;
		contentFrame.origin.x = 39.0;
		self.contentView.frame = contentFrame;
        self.accessoryType = UITableViewCellAccessoryNone;
	}
	else
	{
		CGRect contentFrame = self.contentView.frame;
		contentFrame.origin.x = 0;
		self.contentView.frame = contentFrame;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    
	[UIView commitAnimations];
}

- (void)dealloc {
    [imageView release];
    [titleTextLabel release];
    [descriptionTextLabel release];
    [playbackCountTextLabel release];
    [likesTextLabel release];
    [super dealloc];
}


#pragma mark -
#pragma mark UI actions

- (IBAction)deleteFavorite:(id)sender {
    NSLog(@"Delete");
}

@end
