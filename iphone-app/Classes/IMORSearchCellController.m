//
//  IMORSearchCellController.m
//  iMortacci
//
//  Created by Ali Servet Donmez on 8.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import "IMORSearchCellController.h"
#import "TDBadgedCell.h"


@implementation IMORSearchCellController

@synthesize imageView;
@synthesize titleTextLabel;
@synthesize descriptionTextLabel;
@synthesize playbackCountTextLabel;
@synthesize likesTextLabel;
@synthesize badgeString;
@synthesize badge;
@synthesize badgeColor;
@synthesize badgeColorHighlighted;

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
    badge = [[TDBadgeView alloc] initWithFrame:CGRectZero];
    badge.parent = self;
    
    //redraw cells in accordance to accessory
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (version <= 3.0)
        [self addSubview:self.badge];
    else 
        [self.contentView addSubview:self.badge];
    
    [self.badge setNeedsDisplay];
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	
	if(self.badgeString)
	{
		//force badges to hide on edit.
		if(self.editing)
			[self.badge setHidden:YES];
		else
			[self.badge setHidden:NO];
		
		
		CGSize badgeSize = [self.badgeString sizeWithFont:[UIFont boldSystemFontOfSize: 14]];
		
		float version = [[[UIDevice currentDevice] systemVersion] floatValue];
		
		CGRect badgeframe;
		
		if (version <= 3.0)
		{
			badgeframe = CGRectMake(self.contentView.frame.size.width - (badgeSize.width+16), round((self.contentView.frame.size.height - 18) / 2), badgeSize.width+16, 18);
		}
		else
		{
			badgeframe = CGRectMake(self.contentView.frame.size.width - (badgeSize.width+16) - 10, round((self.contentView.frame.size.height - 18) / 2), badgeSize.width+16, 18);
		}
		
		[self.badge setFrame:badgeframe];
		[badge setBadgeString:self.badgeString];
		[badge setParent:self];
		
		if ((self.titleTextLabel.frame.origin.x + self.titleTextLabel.frame.size.width) >= badgeframe.origin.x)
		{
			CGFloat badgeWidth = self.titleTextLabel.frame.size.width - badgeframe.size.width - 10.0;
			
			self.titleTextLabel.frame = CGRectMake(self.titleTextLabel.frame.origin.x, self.titleTextLabel.frame.origin.y, badgeWidth, self.titleTextLabel.frame.size.height);
		}
		
		if ((self.descriptionTextLabel.frame.origin.x + self.descriptionTextLabel.frame.size.width) >= badgeframe.origin.x)
		{
			CGFloat badgeWidth = self.descriptionTextLabel.frame.size.width - badgeframe.size.width - 10.0;
			
			self.descriptionTextLabel.frame = CGRectMake(self.descriptionTextLabel.frame.origin.x, self.descriptionTextLabel.frame.origin.y, badgeWidth, self.descriptionTextLabel.frame.size.height);
		}
        
		//set badge highlighted colours or use defaults
		if(self.badgeColorHighlighted)
			badge.badgeColorHighlighted = self.badgeColorHighlighted;
		else 
			badge.badgeColorHighlighted = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.000];
		
		//set badge colours or impose defaults
		if(self.badgeColor)
			badge.badgeColor = self.badgeColor;
		else
			badge.badgeColor = [UIColor colorWithRed:0.530 green:0.600 blue:0.738 alpha:1.000];
	}
	else
	{
		[self.badge setHidden:YES];
	}
	
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
	[super setHighlighted:highlighted animated:animated];
	[badge setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
	[badge setNeedsDisplay];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:animated];
	
	if (editing) {
		badge.hidden = YES;
		[badge setNeedsDisplay];
		[self setNeedsDisplay];
	}
	else 
	{
		badge.hidden = NO;
		[badge setNeedsDisplay];
		[self setNeedsDisplay];
	}
}

- (void)dealloc {
    [imageView release];
    [titleTextLabel release];
    [descriptionTextLabel release];
    [playbackCountTextLabel release];
    [likesTextLabel release];
	[badge release];
	[badgeColor release];
	[badgeString release];
	[badgeColorHighlighted release];
    [super dealloc];
}


@end
