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
@class iMortacciAppDelegate;


@interface IMORNewestController : UIViewController <AdWhirlDelegate, MBProgressHUDDelegate> {
    UITableView *_tableView;
    
    iMortacciAppDelegate *appDelegate;
	MBProgressHUD *HUD;
    BOOL taskInProgress;
    NSString *albumsRemoteString;
    NSArray *albumsRemote;
    NSData *downloadedItem;

    // UI elements
    IMORNewestCellController *tempCell;
}

@property (nonatomic, retain) IBOutlet UITableView *_tableView;
@property (nonatomic, retain) iMortacciAppDelegate *appDelegate;
@property (nonatomic, assign) BOOL taskInProgress;
@property (nonatomic, retain) NSString *albumsRemoteString;
@property (nonatomic, retain) NSArray *albumsRemote;
@property (nonatomic, retain) NSData *downloadedItem;
@property (nonatomic, assign) IBOutlet IMORNewestCellController *tempCell;

- (IBAction)update:(id)sender;

- (void)updateTask;
- (void)downloadAlbums;

@end
