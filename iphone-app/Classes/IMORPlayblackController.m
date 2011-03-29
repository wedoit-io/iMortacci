//
//  IMORPlayblackController.m
//  iMortacci
//
//  Created by Ali Servet Donmez on 11.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import "IMORPlayblackController.h"
#import "IMORPlayblackCellController.h"
#import "iMortacci.h"
#import "QuickFunctions.h"
#import "SHK.h"
#import <QuartzCore/QuartzCore.h>

@implementation IMORPlayblackController

@synthesize _tableView;
@synthesize item;
@synthesize player;
@synthesize tempCell;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // $$$ Let's make some money! ;-) $$$
    [self.view addSubview:[AdWhirlView requestAdWhirlViewWithDelegate:self]];
    
    // This is a fake table actually, so we don't want to scroll
    self._tableView.scrollEnabled = NO;
    
    self._tableView.rowHeight = kSingleRowTableRowHeight;
    self._tableView.backgroundColor = kIMORColorGreen;
    self._tableView.separatorColor = [UIColor clearColor];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Become first responder to handle shake motion
    // Ref.: https://devforums.apple.com/message/49571#49571
    [self becomeFirstResponder];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // This will slowly fade out volume (duration: 1.2 seconds)
    if (player != nil && player.playing) {
        while (player.volume > 0) {
            player.volume -= 0.01;
            usleep(12000); // this is equal to 0.012 seconds
        }
        [player stop];
    }
}

/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    // Return the number of sections.
//    return number of sections;
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
     static NSString *CellIdentifier = @"IMORSearchCellController";
     
     IMORSearchCellController *cell = (IMORSearchCellController *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
     [[NSBundle mainBundle] loadNibNamed:@"IMORSearchCellController" owner:self options:nil];
     cell = tempCell;
     self.tempCell = nil;
     }
     */
    
    static NSString *CellIdentifier = @"IMORPlayblackCellController";
    
    IMORPlayblackCellController *cell = (IMORPlayblackCellController *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"IMORPlayblackCellController" owner:self options:nil];
        cell = tempCell;
        self.tempCell = nil;
    }
    
    // Configure the cell...
    
    /* It's important to remember to pass CG structs like floats and CGColors */
    [[cell.headerView layer] setShadowOffset:CGSizeMake(0, 5)];
    [[cell.headerView layer] setShadowColor:[kIMORColorShadow CGColor]];
    [[cell.headerView layer] setShadowRadius:3.0];
    [[cell.headerView layer] setShadowOpacity:0.8];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %@", [item valueForKey:@"album_id"]];
    NSArray *filtered = [[QuickFunctions sharedQuickFunctions].app.currentAlbums filteredArrayUsingPredicate:pred];
    if ([filtered count] > 0) {
        cell.imageView.image = [UIImage imageWithData:[[QuickFunctions sharedQuickFunctions] getAlbumArtworkWithSlug:[[filtered objectAtIndex:0] valueForKey:@"slug"]
                                                                                                             AndSize:@"small"]];
    }
    else {
        cell.imageView.image = [UIImage imageWithData:[[QuickFunctions sharedQuickFunctions] getAlbumArtworkWithSlug:@"default"
                                                                                                             AndSize:@"small"]];
    }

    cell.titleTextLabel.text = [item valueForKey:@"title"];
    if ([item valueForKey:@"description"] != [NSNull null]) {
        cell.descriptionTextLabel.text = [item valueForKey:@"description"];
    }

    int playbackCount = 0;
    int likeCount = 0;
    
    NSPredicate *predCounters = [NSPredicate predicateWithFormat:@"id = %@", [item valueForKey:@"id"]];
    NSArray *filteredCounters = [[QuickFunctions sharedQuickFunctions].app.counters filteredArrayUsingPredicate:predCounters];
    if ([filteredCounters count] > 0) {
        playbackCount += [(NSNumber *)[[filteredCounters objectAtIndex:0] valueForKey:@"playback_count"] intValue];
        likeCount += [(NSNumber *)[[filteredCounters objectAtIndex:0] valueForKey:@"like_count"] intValue];
    }
    
    NSPredicate *predLocalUserInfo = [NSPredicate predicateWithFormat:@"id = %@", [item valueForKey:@"id"]];
    NSArray *filteredLocalUserInfo = [[QuickFunctions sharedQuickFunctions].app.localUserInfo filteredArrayUsingPredicate:predLocalUserInfo];
    if ([filteredLocalUserInfo count] > 0) {
        playbackCount += [(NSNumber *)[[filteredLocalUserInfo objectAtIndex:0] valueForKey:@"user_playback_count"] intValue];
        likeCount += [(NSNumber *)[[filteredLocalUserInfo objectAtIndex:0] valueForKey:@"like_status"] intValue] > 0 ? 1 : 0;
    }
    
    cell.playbackCountTextLabel.text = [NSString stringWithFormat:@"%d ascolti", playbackCount];
    cell.likesTextLabel.text = [NSString stringWithFormat:@"%d", likeCount];
    
    NSPredicate *predLikeStatus = [NSPredicate predicateWithFormat:@"id = %@ AND like_status > 0", [item valueForKey:@"id"]];
    NSArray *filteredLikeStatus = [[QuickFunctions sharedQuickFunctions].app.localUserInfo filteredArrayUsingPredicate:predLikeStatus];
    if ([filteredLikeStatus count] > 0) {
        [cell.likesButton setBackgroundImage:[UIImage imageNamed:@"YouLikeItButton.png"] forState:UIControlStateNormal];
        [cell.likesButton setBackgroundImage:[UIImage imageNamed:@"YouLikeItButton.png"] forState:UIControlStateHighlighted];
    }
    
    // This is a fake table actually, so we don't want to show selected cells
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [_tableView release];
    [item release];
    [tempCell release];
    [super dealloc];
}


#pragma mark -
#pragma mark UIResponder delegate

//-(BOOL)canBecomeFirstResponder {
//    return YES;
//}


#pragma mark -
#pragma mark Responding to Motion Events

/*
 Custom views should implement all motion-event handlers, even if it's a null implementation, and not call super.
 */

//- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
//    
//}
//
//- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
//	if (motion == UIEventSubtypeMotionShake) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.google.com"]];
//	}
//}
//
//- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
//    
//}


#pragma mark -
#pragma mark Internal methods

- (void)likeItTask {
    // mark as liked in a new thread
    
    // Must always specify a NSAutoreleasePool and release it for each thread you run
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    sleep(3);
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %@", [item valueForKey:@"id"]];
    NSArray *filtered = [[QuickFunctions sharedQuickFunctions].app.localUserInfo filteredArrayUsingPredicate:pred];
    if ([filtered count] > 0) {
        NSDictionary *itemInfo = [[QuickFunctions sharedQuickFunctions].app.localUserInfo firstObjectCommonWithArray:filtered];
        if ([(NSNumber *)[itemInfo valueForKey:@"like_status"] intValue] == 0) {
            [[QuickFunctions sharedQuickFunctions].app.localUserInfo replaceObjectAtIndex:[[QuickFunctions sharedQuickFunctions].app.localUserInfo indexOfObject:itemInfo]
                                                                          withObject:
             [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
                                                  [itemInfo valueForKey:@"id"],
                                                  [NSNumber numberWithInt:1],
                                                  [itemInfo valueForKey:@"user_playback_count"],
                                                  nil]
                                         forKeys:[NSArray arrayWithObjects:
                                                  @"id",
                                                  @"like_status",
                                                  @"user_playback_count",
                                                  nil]]];
            
            // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
            HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Favorite.png"]] autorelease];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.labelText = @"Grazie";
            
            sleep(2);
        }
        else {
            
            // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
            HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Error.png"]] autorelease];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.labelText = @"Già votato";
            
            sleep(3);
        }
    }
    
    // Hide the HUD
    [HUD hide:YES];
    
    [self._tableView reloadData];
    
    [pool release];
}

- (void)addToFavoritesTask {
    // add to favorites in a new thread
    
    // Must always specify a NSAutoreleasePool and release it for each thread you run
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %@", [item valueForKey:@"id"]];
    NSArray *filtered = [[QuickFunctions sharedQuickFunctions].app.favorites filteredArrayUsingPredicate:pred];
    if ([filtered count] == 0) {
        [[QuickFunctions sharedQuickFunctions].app.favorites addObject:
         [NSDictionary dictionaryWithObject:[item valueForKey:@"id"] forKey:@"id"]];

        // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark.png"]] autorelease];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"Preferito";
        
        sleep(1);
    }
    else {
        
        // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Error.png"]] autorelease];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"Già preferito";
        
        sleep(1);
    }

    // Hide the HUD
    [HUD hide:YES];
    
    [self._tableView reloadData];
    
    [pool release];
}


#pragma mark -
#pragma mark AdWhirl delegate methods

- (NSString *)adWhirlApplicationKey {
    return kAdWhirlApplicationKey;
}

- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

- (void)adWhirlDidReceiveAd:(AdWhirlView *)adWhirlView {
    CGSize adSize = [adWhirlView actualAdSize];
    CGRect newAdFrame = adWhirlView.frame;
    CGRect newTableFrame = self._tableView.frame;
    
    newAdFrame.size = adSize;
    newTableFrame.size.height = self.view.frame.size.height - adSize.height;
    
    newAdFrame.origin.x = (self.view.bounds.size.width - adSize.width) / 2;
    newAdFrame.origin.y = newTableFrame.size.height;
    
    adWhirlView.frame = newAdFrame;
    self._tableView.frame = newTableFrame;
}

- (void)adWhirlDidFailToReceiveAd:(AdWhirlView *)adWhirlView usingBackup:(BOOL)yesOrNo {
    if (!yesOrNo) {
        _tableView.frame = self.view.frame;
        adWhirlView.frame = CGRectZero;
    }
}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
}


#pragma mark -
#pragma mark AVAudioPlayerDelegate methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    if ([QuickFunctions sharedQuickFunctions].app.firstPlay) {
        [QuickFunctions sharedQuickFunctions].app.firstPlay = NO;
        
        // Hide the HUD
        [HUD hide:YES];
    }
}


#pragma mark -
#pragma mark UI actions

- (IBAction)playTrack:(id)sender {
    if (!player.playing) {
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %@", [item valueForKey:@"id"]];
        NSArray *filtered = [[QuickFunctions sharedQuickFunctions].app.localUserInfo filteredArrayUsingPredicate:pred];
        if ([filtered count] == 0) {
            [[QuickFunctions sharedQuickFunctions].app.localUserInfo addObject:
             [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
                                                  [item valueForKey:@"id"],
                                                  [NSNumber numberWithInt:0],
                                                  [NSNumber numberWithInt:1],
                                                  nil]
                                         forKeys:[NSArray arrayWithObjects:
                                                  @"id",
                                                  @"like_status",
                                                  @"user_playback_count",
                                                  nil]]];
        }
        else {
            NSDictionary *itemInfo = [[QuickFunctions sharedQuickFunctions].app.localUserInfo firstObjectCommonWithArray:filtered];
            [[QuickFunctions sharedQuickFunctions].app.localUserInfo replaceObjectAtIndex:[[QuickFunctions sharedQuickFunctions].app.localUserInfo indexOfObject:itemInfo]
                                                                               withObject:
             [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
                                                  [itemInfo valueForKey:@"id"],
                                                  [itemInfo valueForKey:@"like_status"],
                                                  [NSNumber numberWithInt:[(NSNumber *)[itemInfo valueForKey:@"user_playback_count"] intValue] + 1],
                                                  nil]
                                         forKeys:[NSArray arrayWithObjects:
                                                  @"id",
                                                  @"like_status",
                                                  @"user_playback_count",
                                                  nil]]];
        }
        
        [self._tableView reloadData];

        if ([QuickFunctions sharedQuickFunctions].app.firstPlay) {
            // The hud will dispable all input on the view
            HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            
            // Add HUD to screen
            [self.navigationController.view addSubview:HUD];
            
            // Register for HUD callbacks so we can remove it from the window at the right time
            HUD.delegate = self;
            
            HUD.minShowTime = 3.0;
            HUD.opacity = 0.6;
            HUD.animationType = MBProgressHUDAnimationZoom;
            
            HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Playback.png"]] autorelease];
            HUD.labelText = @"Alza il volume";
            HUD.detailsLabelText = @"Se non senti la voce...";
            HUD.mode = MBProgressHUDModeCustomView;
            
            // Show the HUD
            [HUD show:YES];
        }
        
        player = [[AVAudioPlayer alloc] initWithData:[[QuickFunctions sharedQuickFunctions]
                                                      getTrackWithId:[[item valueForKey:@"id"] intValue]]
                                               error:nil];
        player.delegate = self;
        [player play];
    }
}

- (IBAction)share:(id)sender {
    // Create the item to share (in this example, a url)
//	NSURL *url = [NSURL URLWithString:[item valueForKey:@"site_url"]];
//	SHKItem *shareItem = [SHKItem URL:url title:[item valueForKey:@"title"]];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kPlayerURL, [item valueForKey:@"id"]]];
	SHKItem *shareItem = [SHKItem URL:url title:[NSString stringWithFormat:@"Ascolta subito: \"%@\"", [item valueForKey:@"title"]]];
    shareItem.text = [NSString stringWithFormat:@"%@", [item valueForKey:@"description"]];
    [shareItem setCustomValue:@"Ali Servet stà utilizzando iMortacci, l'app GRATUITA per iPhone/iPad che ti permette di ascoltare e inviare agli amici le più belle espressioni, imprecazioni e modi di dire dei dialetti italiani." forKey:@"description"];
    [shareItem setCustomValue:@"http://i1.sndcdn.com/artworks-000005393668-9wdjqg-large.jpg" forKey:@"image"];
    
	// Get the ShareKit action sheet
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:shareItem];
    
	// Display the action sheet
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (IBAction)addToFavorites:(id)sender {
    
	// The hud will dispable all input on the view
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	
    // Add HUD to screen
    [self.navigationController.view addSubview:HUD];
	
    // Register for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    
    HUD.opacity = 0.6;
    HUD.animationType = MBProgressHUDAnimationZoom;

    // Show the HUD
    [HUD show:YES];

    [NSThread detachNewThreadSelector:@selector(addToFavoritesTask) toTarget:self withObject:nil];
}

- (IBAction)likeIt:(id)sender {
    
	// The hud will dispable all input on the view
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	
    // Add HUD to screen
    [self.navigationController.view addSubview:HUD];
	
    // Register for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    
    HUD.opacity = 0.6;
    HUD.animationType = MBProgressHUDAnimationZoom;
    
    HUD.labelText = @"Attendere";
	
    // Show the HUD
    [HUD show:YES];
    
    [NSThread detachNewThreadSelector:@selector(likeItTask) toTarget:self withObject:nil];
}

@end

