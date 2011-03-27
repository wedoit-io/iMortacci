//
//  IMORNewestCellController.h
//  iMortacci
//
//  Created by Ali Servet Donmez on 14.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IMORNewestCellController : UITableViewCell {
    UIButton *updateButton;
    UIImageView *updatesAvailableImage;
    UIImageView *updatesUnavailableImage;
}

@property (nonatomic, retain) IBOutlet UIImageView *updatesAvailableImage;
@property (nonatomic, retain) IBOutlet UIImageView *updatesUnavailableImage;
@property (nonatomic, retain) IBOutlet UIButton *updateButton;

@end
