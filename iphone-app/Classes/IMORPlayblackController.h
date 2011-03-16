//
//  IMORPlayblackController.h
//  iMortacci
//
//  Created by Ali Servet Donmez on 11.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>;
#import "AdWhirlView.h"

@class IMORPlayblackCellController;


@interface IMORPlayblackController : UIViewController <AdWhirlDelegate> {
    UITableView *_tableView;
    
    NSDictionary *item;
    NSString *albumSlug;
    
    // Audio playback
    AVAudioPlayer *player;
    
    // UI elements
    IMORPlayblackCellController *tempCell;
}

@property (nonatomic, retain) IBOutlet UITableView *_tableView;
@property (nonatomic, retain) NSDictionary *item;
@property (nonatomic, retain) NSString *albumSlug;
@property (nonatomic, assign) AVAudioPlayer *player;
@property (nonatomic, assign) IBOutlet IMORPlayblackCellController *tempCell;

- (IBAction)playTrack:(id)sender;
- (IBAction)share:(id)sender;

@end
