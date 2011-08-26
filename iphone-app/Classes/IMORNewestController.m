//
//  IMORNewestController.m
//  iMortacci
//
//  Created by Ali Servet Donmez on 1.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import "IMORNewestController.h"
#import "IMORNewestCellController.h"
#import "iMortacci.h"
#import "QuickFunctions.h"
#import "Reachability.h"
#import "JSON+Extensions.h"
#import <unistd.h>
#import "GANTracker.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "NSFileManager+Extensions.h"


@interface IMORNewestController (internal)

- (void)requestFinished:(ASINetworkQueue *)queue;
- (void)queueFinished:(ASINetworkQueue *)queue;

@end

@implementation IMORNewestController (internal)

- (void)requestFinished:(ASINetworkQueue *)queue;
{
    HUD.progress = [self.progressView progress];
    HUD.labelText = [NSString stringWithFormat:@"%d%%", (int)(HUD.progress * 100)];
}

- (void)queueFinished:(ASINetworkQueue *)queue
{
	if ([self.queue requestsCount] == 0) {
		[self setQueue:nil]; 
	}
    
    HUD.progress = 1.0;
    HUD.labelText = [NSString stringWithFormat:@"100%%"];
    self.taskInProgress = NO;
}

@end

@implementation IMORNewestController

@synthesize _tableView;
@synthesize taskInProgress;
@synthesize latestAlbums;
@synthesize downloadedItem;
@synthesize tempCell;
@synthesize alertShowed;
@synthesize internetReachable;
@synthesize hostReachable;
@synthesize queue;
@synthesize progressView;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.progressView = [UIProgressView new];
    
    // $$$ Let's make some money! ;-) $$$
    [self.view addSubview:[AdWhirlView requestAdWhirlViewWithDelegate:self]];
    
    // This is a fake table actually, so we don't want to scroll
    self._tableView.scrollEnabled = NO;
    
    self._tableView.rowHeight = kSingleRowTableRowHeight;
    self._tableView.separatorColor = [UIColor clearColor];

    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkNetworkStatus:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    internetReachable = [[Reachability reachabilityForInternetConnection] retain];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [[Reachability reachabilityWithHostName:kReachabilityHostName] retain];
    [hostReachable startNotifier];
    
    // now patiently wait for the notification...
    
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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // This should (kinda) fix some fast-handed buddies out there who's got there
    // before we can actually refresh screen which results to some inconsistency
    // with what badge counter says
    [self._tableView reloadData];
}

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
    
    BOOL updatesAvailable = [QuickFunctions sharedQuickFunctions].app.newItemsCount > 0;
    cell.updatesUnavailableImage.hidden = updatesAvailable;
    cell.updatesAvailableImage.hidden = !updatesAvailable;
    cell.updateButton.hidden = !updatesAvailable;
    
    self._tableView.backgroundColor = updatesAvailable ? kIMORColorWhite : kIMORColorGray;
    
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
    [internetReachable release];
    [hostReachable release];
    [queue release];
    [progressView release];
    [super dealloc];
}


#pragma mark -
#pragma mark Internal methods

- (void)checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    
    // Alert user about connection status if not done it before
    if ([QuickFunctions sharedQuickFunctions].app.newItemsCount > 0 && !alertShowed) {

        NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
        
        switch (internetStatus)
        {
            case NotReachable:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"Non sei connesso a internet. Collegati per poter aggiornare l'App con gli ultimi mortaccioni."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Chiudi"
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
                alertShowed = YES;
                break;
            }
                
            case ReachableViaWWAN:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"Non sei connesso ad una rete WIFI. Il download potrebbe essere più lento."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Chiudi"
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
                alertShowed = YES;
                break;
            }
                
            default:
                break;
        }
    }
}

- (void)updateTask {
    // update albums in a new thread
    
    // Must always specify a NSAutoreleasePool and release it for each thread you run
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // Indeterminate mode
    [self downloadAlbums];

    if (self.queue) {
        [self.queue cancelAllOperations];
    }
    
    [self setQueue:[ASINetworkQueue queue]];
    [self.queue setDownloadProgressDelegate:self.progressView];
    [self.queue setDelegate:self];
    [self.queue setRequestDidFinishSelector:@selector(requestFinished:)];
    [self.queue setQueueDidFinishSelector:@selector(queueFinished:)];
    [self.queue setShouldCancelAllRequestsOnFailure:NO];

    for (NSDictionary *album in latestAlbums) {
        for (NSDictionary *track in [album valueForKey:@"tracks"]) {
            // If track is not saved locally then we shall download and save it
            if ([[QuickFunctions sharedQuickFunctions] getTrackWithId:[[track valueForKey:@"id"] intValue]] == nil) {

                NSString *urlString = [NSString stringWithFormat:@"%@?consumer_key=%@", [track valueForKey:@"download_url"], kSoundCloudClientId];
                NSURL *url = [NSURL URLWithString:urlString];
                
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
                NSString *filename = [[NSString stringWithFormat:@"%d", [[track valueForKey:@"id"] intValue]] stringByAppendingPathExtension:kTrackFileExtension];
                NSString *destinationPath = [((NSString *)[[NSFileManager defaultManager] applicationSupportDirectory]) stringByAppendingPathComponent:filename];
                [request setDownloadDestinationPath:destinationPath];
                [queue addOperation:request];
            }
        }
    }

    if ([self.queue requestsCount] > 0) {
        // Switch to determinate mode
        HUD.mode = MBProgressHUDModeDeterminate;
        HUD.progress = 0;
        HUD.labelText = [NSString stringWithFormat:@"0%%"];
        HUD.detailsLabelText = [QuickFunctions sharedQuickFunctions].app.newItemsCount > 1
        ? [NSString stringWithFormat:@"%d mortaccioni", [QuickFunctions sharedQuickFunctions].app.newItemsCount]
        : @"Un mortaccione";
        
        self.taskInProgress = YES;
        [self.queue go];
        while (self.taskInProgress) {
            usleep(100000); // 0.1 seconds
        }
    }

    // Back to indeterminate mode
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Aspetta un attimo...";
    HUD.detailsLabelText = @"Installo";

    // save version.json, albums.json files and update app delegate properties accordingly
    
    [[QuickFunctions sharedQuickFunctions] saveCurrentVersion:[QuickFunctions sharedQuickFunctions].app.latestVersion];
    [[QuickFunctions sharedQuickFunctions] saveAlbums:latestAlbums];

    [[QuickFunctions sharedQuickFunctions] updateCurrentVersion:[QuickFunctions sharedQuickFunctions].app.latestVersion];
    [[QuickFunctions sharedQuickFunctions] updateAlbums:latestAlbums];
    
    // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
	HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark.png"]] autorelease];
	HUD.mode = MBProgressHUDModeCustomView;
	HUD.labelText = @"Fine";
    HUD.detailsLabelText = [QuickFunctions sharedQuickFunctions].app.newItemsCount > 1
    ? [NSString stringWithFormat:@"%d nuovissimi mortaccioni", [QuickFunctions sharedQuickFunctions].app.newItemsCount]
    : @"Un nuovissimo mortaccione";
    
    [[[QuickFunctions sharedQuickFunctions].app.tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:nil];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [QuickFunctions sharedQuickFunctions].app.newItemsCount = 0;
    [self._tableView reloadData];
    
    // Hide the HUD
    [HUD hide:YES];
    
    [pool release];
}

- (void)downloadAlbums {
    [[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"/download/%@",
                                               [[QuickFunctions sharedQuickFunctions].app.latestVersion valueForKey:@"hash"]]
                                    withError:nil];
    
    NSString *urlString = [[QuickFunctions sharedQuickFunctions].app.latestVersion valueForKey:@"download_url"];
    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *jsonString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        latestAlbums = [[jsonString JSONValue] retain];
    }
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
	
    // Register for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
	
    HUD.opacity = 0.6;
    HUD.animationType = MBProgressHUDAnimationZoom;
    
    HUD.labelText = @"Aspetta un attimo...";
	
    // Show the HUD
    [HUD show:YES];
    
    [NSThread detachNewThreadSelector:@selector(updateTask) toTarget:self withObject:nil];
}

@end
