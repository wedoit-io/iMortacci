//
//  IMORTopChartController.h
//  iMortacci
//
//  Created by Ali Servet Donmez on 1.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdWhirlView.h"


@class IMORTopChartCellController;



@interface IMORTopChartController : UIViewController <AdWhirlDelegate> {

    UITableView *_tableView;

    NSMutableArray *items;
    
    // UI elements
    IMORTopChartCellController *tempCell;
}

@property (nonatomic, retain) IBOutlet UITableView *_tableView;
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, assign) IBOutlet IMORTopChartCellController *tempCell;

@end
