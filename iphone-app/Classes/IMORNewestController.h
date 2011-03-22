//
//  IMORNewestController.h
//  iMortacci
//
//  Created by Ali Servet Donmez on 1.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdWhirlView.h"
#import "MBProgressHUD.h"

@class IMORNewestCellController;


@interface IMORNewestController : UIViewController <AdWhirlDelegate, MBProgressHUDDelegate> {
    UITableView *_tableView;
    
	MBProgressHUD *HUD;
    BOOL taskInProgress;
    NSArray *latestAlbums;
    NSData *downloadedItem;

    // UI elements
    IMORNewestCellController *tempCell;
}

@property (nonatomic, retain) IBOutlet UITableView *_tableView;
@property (nonatomic, assign) BOOL taskInProgress;
@property (nonatomic, retain) NSArray *latestAlbums;
@property (nonatomic, retain) NSData *downloadedItem;
@property (nonatomic, assign) IBOutlet IMORNewestCellController *tempCell;

- (IBAction)update:(id)sender;

- (void)updateTask;
- (void)downloadAlbums;

@end
