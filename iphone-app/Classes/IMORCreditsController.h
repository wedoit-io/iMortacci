//
//  IMORCreditsController.h
//  iMortacci
//
//  Created by Ali Servet Donmez on 1.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdWhirlView.h"

@class IMORCreditsCellController;


@interface IMORCreditsController : UIViewController <AdWhirlDelegate> {

    UITableView *_tableView;

    // UI elements
    IMORCreditsCellController *tempCell;
}

@property (nonatomic, retain) IBOutlet UITableView *_tableView;
@property (nonatomic, assign) IBOutlet IMORCreditsCellController *tempCell;

- (IBAction)info:(id)sender;
- (IBAction)goto2mlab:(id)sender;
- (IBAction)gotoApexNet:(id)sender;

@end
