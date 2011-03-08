//
//  IMORSearchCellController.h
//  iMortacci
//
//  Created by Ali Servet Donmez on 8.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IMORSearchCellController : UITableViewCell {
    UILabel *titleTextLabel;
    UILabel *descriptionTextLabel;
    UILabel *playbackCountTextLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *titleTextLabel;
@property (nonatomic, retain) IBOutlet UILabel *descriptionTextLabel;
@property (nonatomic, retain) IBOutlet UILabel *playbackCountTextLabel;

@end
