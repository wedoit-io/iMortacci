//
//  IMORSearchCellController.h
//  iMortacci
//
//  Created by Ali Servet Donmez on 8.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TDBadgeView;


@interface IMORSearchCellController : UITableViewCell {
    UIImageView *imageView;
    UILabel *titleTextLabel;
    UILabel *descriptionTextLabel;
    UILabel *playbackCountTextLabel;
    UILabel *likesTextLabel;

	NSString *badgeString;
	TDBadgeView *badge;
	
	UIColor *badgeColor;
	UIColor *badgeColorHighlighted;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UILabel *titleTextLabel;
@property (nonatomic, retain) IBOutlet UILabel *descriptionTextLabel;
@property (nonatomic, retain) IBOutlet UILabel *playbackCountTextLabel;
@property (nonatomic, retain) IBOutlet UILabel *likesTextLabel;
@property (nonatomic, retain) NSString *badgeString;
@property (readonly, retain) TDBadgeView *badge;
@property (nonatomic, retain) UIColor *badgeColor;
@property (nonatomic, retain) UIColor *badgeColorHighlighted;

@end
