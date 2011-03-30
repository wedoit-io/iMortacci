//
//  IMORPlayblackController.h
//  iMortacci
//
//  Created by Ali Servet Donmez on 11.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AdWhirlView.h"
#import "MBProgressHUD.h"

@class IMORPlayblackCellController;


@interface IMORPlayblackController : UIViewController <AdWhirlDelegate, MBProgressHUDDelegate, AVAudioPlayerDelegate> {
    UITableView *_tableView;
    
	MBProgressHUD *HUD;
    NSDictionary *item;
    
    // Audio playback
    AVAudioPlayer *player;
    
    // UI elements
    IMORPlayblackCellController *tempCell;
    UIView *rightButtonView;
}

@property (nonatomic, retain) IBOutlet UIView *rightButtonView;
@property (nonatomic, retain) IBOutlet UITableView *_tableView;
@property (nonatomic, retain) NSDictionary *item;
@property (nonatomic, assign) AVAudioPlayer *player;
@property (nonatomic, assign) IBOutlet IMORPlayblackCellController *tempCell;

- (IBAction)playTrack:(id)sender;
- (IBAction)share:(id)sender;
- (IBAction)addToFavorites:(id)sender;
- (IBAction)likeIt:(id)sender;
- (IBAction)iCanDoBetter:(id)sender;

@end
