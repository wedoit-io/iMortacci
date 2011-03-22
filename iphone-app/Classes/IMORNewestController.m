//
//  IMORNewestController.m
//  iMortacci
//
//  Created by Ali Servet Donmez on 1.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import "IMORNewestController.h"
#import "IMORNewestCellController.h"
#import "QuickFunctions.h"
#import "Reachability.h"
#import "GTMHTTPFetcher.h"
#import "JSON+Extensions.h"
#import <unistd.h>


@implementation IMORNewestController

@synthesize _tableView;
@synthesize taskInProgress;
@synthesize latestAlbums;
@synthesize downloadedItem;
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
//    return <#number of sections#>;
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"IMORNewestCellController";
    
    IMORNewestCellController *cell = (IMORNewestCellController *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"IMORNewestCellController" owner:self options:nil];
        cell = tempCell;
        self.tempCell = nil;
    }
    
    // Configure the cell...
    
    cell.noUpdatesLabel.hidden = [QuickFunctions sharedQuickFunctions].app.newItemsCount > 0;
    cell.updateButton.hidden = !([QuickFunctions sharedQuickFunctions].app.newItemsCount > 0);
    
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
    [latestAlbums release];
    [downloadedItem release];
    [tempCell release];
    [super dealloc];
}


#pragma mark -
#pragma mark Internal methods

- (void)updateTask {
    // update albums in a new thread
    
    // Must always specify a NSAutoreleasePool and release it for each thread you run
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    uint sleepTime = (uint)arc4random() % 4;
    sleepTime = sleepTime < 2 ? 2 : sleepTime;
    
    // Indeterminate mode
    taskInProgress = YES;
    [self performSelectorOnMainThread:@selector(downloadAlbums) withObject:nil waitUntilDone:NO];
    while (taskInProgress) {
        sleep(0.1);
    }

    sleep(sleepTime);
    
    // Switch to determinate mode
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.progress = 0.0f;
    HUD.detailsLabelText = [QuickFunctions sharedQuickFunctions].app.newItemsCount > 1
    ? [NSString stringWithFormat:@"Scarico %d nuovi mortaccioni", [QuickFunctions sharedQuickFunctions].app.newItemsCount]
    : @"Scarico un nuovo mortaccione";

    float progressStep = 1.0f / [QuickFunctions sharedQuickFunctions].app.newItemsCount;
    
    uint sleepMicroSeconds;
    for (NSDictionary *album in latestAlbums) {
        for (NSDictionary *track in [album valueForKey:@"tracks"]) {
            // If track is not saved locally then we shall download and save it
            if ([[QuickFunctions sharedQuickFunctions] getTrackWithId:[[track valueForKey:@"id"] intValue]] == nil) {
                
                taskInProgress = YES;
                [self performSelectorOnMainThread:@selector(downloadItem:) withObject:track waitUntilDone:NO];
                while (taskInProgress) {
                    sleep(0.1);
                }
                
                [[QuickFunctions sharedQuickFunctions] saveTrack:downloadedItem WithId:[[track valueForKey:@"id"] intValue]];

                sleepMicroSeconds = (uint)arc4random() % 1000000;
                sleepMicroSeconds = sleepMicroSeconds < 500000 ? 500000 : sleepMicroSeconds;
                
                // suspend thread execution for an interval measured in microsec-onds microseconds
                // 1 second = 1.000.000 microseconds
                usleep(sleepMicroSeconds);
                
                HUD.progress += progressStep;
                HUD.labelText = [NSString stringWithFormat:@"%d%%", (int)(HUD.progress * 100)];
            }
//            else {
//                sleepMicroSeconds = (uint)arc4random() % 500000;
//                sleepMicroSeconds = sleepMicroSeconds < 250000 ? 250000 : sleepMicroSeconds;
//            }
        }
    }
    HUD.labelText = @"100%";
    HUD.detailsLabelText = [NSString stringWithFormat:@"Finito di scaricare", [QuickFunctions sharedQuickFunctions].app.newItemsCount];
    sleep(sleepTime);

    // Back to indeterminate mode
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Attendere";
    HUD.detailsLabelText = @"Installo gli aggiornamenti";

    // save version.json, albums.json files and update app delegate properties accordingly
    
    [[QuickFunctions sharedQuickFunctions] saveCurrentVersion:[QuickFunctions sharedQuickFunctions].app.latestVersion];
    [[QuickFunctions sharedQuickFunctions] saveAlbums:latestAlbums];

    [[QuickFunctions sharedQuickFunctions] updateCurrentVersion:[QuickFunctions sharedQuickFunctions].app.latestVersion];
    [[QuickFunctions sharedQuickFunctions] updateAlbums:latestAlbums];
    
    sleep(sleepTime*3);
	
    // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
	HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark.png"]] autorelease];
	HUD.mode = MBProgressHUDModeCustomView;
	HUD.labelText = @"Fatto";
    HUD.detailsLabelText = @"Vai con i mortaccioni!";
    
    [[[QuickFunctions sharedQuickFunctions].app.tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:nil];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [QuickFunctions sharedQuickFunctions].app.newItemsCount = 0;
    [self._tableView reloadData];
    
	sleep(2);

    // Hide the HUD
    [HUD hide:YES];
    
    [pool release];
}

- (void)downloadAlbums {
    NSString *urlString = [[QuickFunctions sharedQuickFunctions].app.latestVersion valueForKey:@"download_url"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    GTMHTTPFetcher* itemsFetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    [itemsFetcher beginFetchWithDelegate:self didFinishSelector:@selector(downloadAlbumsFetcher:finishedWithData:error:)];
}

- (void)downloadItem:(NSDictionary *)item {
    NSString *urlString = [NSString stringWithFormat:@"%@?consumer_key=%@", [item valueForKey:@"download_url"], kSoundCloudClientId];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    GTMHTTPFetcher* itemsFetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    [itemsFetcher beginFetchWithDelegate:self didFinishSelector:@selector(downloadItemFetcher:finishedWithData:error:)];
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
#pragma mark UI actions

- (IBAction)update:(id)sender {
	// The hud will dispable all input on the view
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	
    // Add HUD to screen
    [self.navigationController.view addSubview:HUD];
	
    // Regisete for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
	
    HUD.labelText = @"Attendere";
    HUD.detailsLabelText = @"Cerco gli aggiornamenti";
	
    // Show the HUD
    [HUD show:YES];
    
    [NSThread detachNewThreadSelector:@selector(updateTask) toTarget:self withObject:nil];
}


#pragma mark -
#pragma mark GTMHTTPFetcher callback

- (void)downloadAlbumsFetcher:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)retrievedData error:(NSError *)error {
    
    if (error == nil) {
        // fetch succeeded
        
        NSString *jsonString = [[NSString alloc] initWithData:retrievedData encoding:NSUTF8StringEncoding];
        latestAlbums = [[jsonString JSONValue] retain];
    }
    
    taskInProgress = NO;
}

- (void)downloadItemFetcher:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)retrievedData error:(NSError *)error {
    
    if (error == nil) {
        // fetch succeeded
        
        downloadedItem = [retrievedData copy];
    }
    
    taskInProgress = NO;
}


@end

