//
//  IMORPlayblackController.h
//  iMortacci
//
//  Created by Ali Servet Donmez on 8.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>;


@interface IMORPlayblackController : UIViewController {
    NSDictionary *item;
    
    // UI elements
    UILabel *titleTextLabel;
    UILabel *descriptionTextLabel;
    
    // Audio playback
    AVAudioPlayer *player;
}

@property (nonatomic, retain) NSDictionary *item;
@property (nonatomic, retain) IBOutlet UILabel *titleTextLabel;
@property (nonatomic, retain) IBOutlet UILabel *descriptionTextLabel;
@property (nonatomic, assign) AVAudioPlayer *player;

- (IBAction)playTrack;
- (IBAction)share;

@end
