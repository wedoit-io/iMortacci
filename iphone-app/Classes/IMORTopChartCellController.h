//
//  IMORTopChartCellController.h
//  iMortacci
//
//  Created by Ali Servet Donmez on 8.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IMORTopChartCellController : UITableViewCell {
    UIImageView *imageView;
    UILabel *titleTextLabel;
    UILabel *descriptionTextLabel;
    UILabel *playbackCountTextLabel;
    UILabel *likesTextLabel;
    UIView *rankView;
    UILabel *rankTextLabel;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UILabel *titleTextLabel;
@property (nonatomic, retain) IBOutlet UILabel *descriptionTextLabel;
@property (nonatomic, retain) IBOutlet UILabel *playbackCountTextLabel;
@property (nonatomic, retain) IBOutlet UILabel *likesTextLabel;
@property (nonatomic, retain) IBOutlet UIView *rankView;
@property (nonatomic, retain) IBOutlet UILabel *rankTextLabel;

@end
