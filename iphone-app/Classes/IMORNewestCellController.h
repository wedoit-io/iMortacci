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
    UILabel *noUpdatesLabel;
}

@property (nonatomic, retain) IBOutlet UIButton *updateButton;
@property (nonatomic, retain) IBOutlet UILabel *noUpdatesLabel;

@end
