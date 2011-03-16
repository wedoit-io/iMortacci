//
//  IMORPlayblackController.m
//  iMortacci
//
//  Created by Ali Servet Donmez on 11.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import "IMORPlayblackController.h"
#import "IMORPlayblackCellController.h"
#import "iMortacciAppDelegate.h"
#import "SHK.h"


@implementation IMORPlayblackController

@synthesize _tableView;
@synthesize item;
@synthesize albumSlug;
@synthesize player;
@synthesize tempCell;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TODO: Cambia il titolo della vista playbackcontroller con il titolo del dialetto
    self.title = @"iMortacci";

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
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
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
    
    cell.imageView.image = [UIImage imageWithData:[((iMortacciAppDelegate *)[[UIApplication sharedApplication] delegate])
                                                   getAlbumArtworkWithSlug:albumSlug]];
    cell.titleTextLabel.text = [item valueForKey:@"title"];
    cell.descriptionTextLabel.text = [item valueForKey:@"description"];
    cell.playbackCountTextLabel.text = [NSString stringWithFormat:@"%d ascolti", [[item valueForKey:@"playback_count"] intValue]];
    cell.likesTextLabel.text = [NSString stringWithFormat:@"%d voti", [[item valueForKey:@"like_count"] intValue]];
    
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
    [albumSlug release];
    [tempCell release];
    [super dealloc];
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
#pragma mark UI actions

- (IBAction)playTrack:(id)sender {
    iMortacciAppDelegate *appDelegate = (iMortacciAppDelegate *)[[UIApplication sharedApplication] delegate];
    player = [[AVAudioPlayer alloc] initWithData:[appDelegate getTrackWithId:[[item valueForKey:@"id"] intValue]]
                                           error:nil];
    [player play];
}

- (IBAction)share:(id)sender {
    // Create the item to share (in this example, a url)
	NSURL *url = [NSURL URLWithString:[item valueForKey:@"site_url"]];
	SHKItem *shareItem = [SHKItem URL:url title:[item valueForKey:@"title"]];
    
	// Get the ShareKit action sheet
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:shareItem];
    
	// Display the action sheet
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
}

@end

