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
@class Reachability;
@class ASINetworkQueue;


@interface IMORNewestController : UIViewController <AdWhirlDelegate, MBProgressHUDDelegate> {
    UITableView *_tableView;
    
	MBProgressHUD *HUD;
    BOOL taskInProgress;
    NSArray *latestAlbums;
    NSData *downloadedItem;

    // UI elements
    IMORNewestCellController *tempCell;
    
    BOOL alertShowed;
    Reachability *internetReachable;
    Reachability *hostReachable;
    
    ASINetworkQueue *queue;
    UIProgressView *progressView;
}

@property (nonatomic, retain) IBOutlet UITableView *_tableView;
@property (nonatomic, assign) BOOL taskInProgress;
@property (nonatomic, retain) NSArray *latestAlbums;
@property (nonatomic, retain) NSData *downloadedItem;
@property (nonatomic, assign) IBOutlet IMORNewestCellController *tempCell;
@property (nonatomic, assign) BOOL alertShowed;
@property (nonatomic, retain) Reachability *internetReachable;
@property (nonatomic, retain) Reachability *hostReachable;
@property (retain) ASINetworkQueue *queue;
@property (nonatomic, retain) UIProgressView *progressView;

- (void)checkNetworkStatus:(NSNotification *)notice;
- (void)updateTask;
- (void)downloadAlbums;

- (IBAction)update:(id)sender;

@end
