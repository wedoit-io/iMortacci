//
//  IMORFavoritesController.m
//  iMortacci
//
//  Created by Ali Servet Donmez on 1.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import "IMORFavoritesController.h"
#import "iMortacci.h"
#import "QuickFunctions.h"
#import "IMORFavoritesCellController.h"
#import "IMORPlayblackController.h"

@implementation IMORFavoritesController

@synthesize _tableView;
@synthesize emptyView;
@synthesize noFavoritesLabel;
@synthesize items;
@synthesize filteredItems;
@synthesize savedSearchTerm;
@synthesize savedScopeButtonIndex;
@synthesize searchWasActive;
@synthesize tempCell;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Initiate items array with current number of favorites
    items = [NSMutableArray new];
    
    // $$$ Let's make some money! ;-) $$$
    [self.view addSubview:[AdWhirlView requestAdWhirlViewWithDelegate:self]];
    
    self._tableView.rowHeight = kSearchTableRowHeight;
    self._tableView.backgroundColor = kIMORColorWhite;
    self._tableView.separatorColor = [UIColor whiteColor];
    
    self.view.backgroundColor = kIMORColorWhite;
    self.emptyView.backgroundColor = kIMORColorWhite;
    self.noFavoritesLabel.backgroundColor = kIMORColorWhite;
    
    self.searchDisplayController.searchResultsTableView.rowHeight = kSearchTableRowHeight;
    
	// create a filtered list that will contain products for the search results table.
	self.filteredItems = [NSMutableArray arrayWithCapacity:[self.items count]];
	
	// restore search settings if they were saved in didReceiveMemoryWarning.
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    [self setEditing:NO animated:NO];
    
    [self populateItems];

    [self._tableView deselectRowAtIndexPath:[self._tableView indexPathForSelectedRow] animated:YES];
    
    // We set some search results tableview's properties here, instead of in 'viewDidLoad', because
    // after first time search view will popup row height will be set to default and
    // we don't definitely want that
    self.searchDisplayController.searchResultsTableView.rowHeight = kSearchTableRowHeight;
    self.searchDisplayController.searchResultsTableView.backgroundColor = kIMORColorWhite;
    self.searchDisplayController.searchResultsTableView.separatorColor = [UIColor whiteColor];

    [self._tableView reloadData];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // save the state of the search UI so that it can be restored if the view is re-created
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
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
//    return <#number of sections#>;
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tableView == self._tableView) {
        return [items count];
    }
    else {
        return [filteredItems count];
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = (tableView == self._tableView)
    ? [items objectAtIndex:indexPath.row]
    : [filteredItems objectAtIndex:indexPath.row];

    static NSString *CellIdentifier = @"IMORFavoritesCellController";
    
    IMORFavoritesCellController *cell = (IMORFavoritesCellController *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"IMORFavoritesCellController" owner:self options:nil];
        cell = tempCell;
        self.tempCell = nil;
    }
    
    // Configure the cell...
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %@", [dict valueForKey:@"album_id"]];
    NSArray *filtered = [[QuickFunctions sharedQuickFunctions].app.currentAlbums filteredArrayUsingPredicate:pred];
    if ([filtered count] > 0) {
        cell.imageView.image = [[QuickFunctions sharedQuickFunctions] getAlbumArtworkWithSlug:[[filtered objectAtIndex:0] valueForKey:@"slug"]
                                                                                      AndSize:@"small"];
    }
    else {
        cell.imageView.image = [[QuickFunctions sharedQuickFunctions] getAlbumArtworkWithSlug:@"default"
                                                                                      AndSize:@"small"];
    }
    
    cell.titleTextLabel.text = [dict valueForKey:@"title"];
    // This is how you check for null string values in JSON string "<null>"
    // Ref.: http://stackoverflow.com/questions/4839355/checking-a-null-value-in-objective-c-that-has-been-returned-from-a-json-string
    if ([dict valueForKey:@"description"] != [NSNull null]) {
        cell.descriptionTextLabel.text = [dict valueForKey:@"description"];
    }
    
    int playbackCount = 0;
    int likeCount = 0;

    NSPredicate *predCounters = [NSPredicate predicateWithFormat:@"id = %@", [dict valueForKey:@"id"]];
    NSArray *filteredCounters = [[QuickFunctions sharedQuickFunctions].app.counters filteredArrayUsingPredicate:predCounters];
    if ([filteredCounters count] > 0) {
        playbackCount += [(NSNumber *)[[filteredCounters objectAtIndex:0] valueForKey:@"playback_count"] intValue];
        likeCount += [(NSNumber *)[[filteredCounters objectAtIndex:0] valueForKey:@"like_count"] intValue];
    }

    NSPredicate *predLocalUserInfo = [NSPredicate predicateWithFormat:@"id = %@", [dict valueForKey:@"id"]];
    NSArray *filteredLocalUserInfo = [[QuickFunctions sharedQuickFunctions].app.localUserInfo filteredArrayUsingPredicate:predLocalUserInfo];
    if ([filteredLocalUserInfo count] > 0) {
        playbackCount += [(NSNumber *)[[filteredLocalUserInfo objectAtIndex:0] valueForKey:@"user_playback_count"] intValue];
        likeCount += [(NSNumber *)[[filteredLocalUserInfo objectAtIndex:0] valueForKey:@"like_status"] intValue] > 0 ? 1 : 0;
    }
    
    cell.playbackCountTextLabel.text = [NSString stringWithFormat:@"%d ascolti", playbackCount];
    cell.likesTextLabel.text = [NSString stringWithFormat:@"%d voti", likeCount];
    
    return cell;
}


// Go in and out into editing mode when edit or done button is tapped accordingly
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    if ([items count] > 0) {
        [super setEditing:editing animated:YES];
        [self._tableView setEditing:editing animated:animated];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %@", [[items objectAtIndex:indexPath.row] valueForKey:@"id"]];
        [[QuickFunctions sharedQuickFunctions].app.favorites removeObjectsInArray:
         [[QuickFunctions sharedQuickFunctions].app.favorites filteredArrayUsingPredicate:pred]];
        [self populateItems];

        [self._tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
}


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

    IMORPlayblackController *detailViewController = [[IMORPlayblackController alloc]
                                                     initWithNibName:@"IMORPlayblackController" bundle:nil];
    
    if (tableView == self._tableView) {
        detailViewController.item = [items objectAtIndex:indexPath.row];
    }
    else {
        detailViewController.item = [filteredItems objectAtIndex:indexPath.row];
    }
    
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [self setNoFavoritesLabel:nil];
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	self.filteredItems = nil;
}


- (void)dealloc {
    [_tableView release];
    [items release];
    [filteredItems release];
    [emptyView release];
    [noFavoritesLabel release];
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
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Update the filtered array based on the search text and scope.
    
	[self.filteredItems removeAllObjects]; // First clear the filtered array.
	
	/* Search the main list for items whose name matches searchText;
     * add items that match to the filtered array.
	 */
    
    searchString = [NSString stringWithFormat:@"*%@*", searchString];
    NSPredicate *pred = [NSPredicate predicateWithFormat:
                         @"(title LIKE[cd] %@) OR (description LIKE[cd] %@) OR (alternate_desc LIKE[cd] %@)",
                         searchString, searchString, searchString];
    
    [self.filteredItems addObjectsFromArray:[items filteredArrayUsingPredicate:pred]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


#pragma mark -
#pragma mark Internal methods

- (void)populateItems {
    [items removeAllObjects];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"id IN %@",
                         [[QuickFunctions sharedQuickFunctions].app.favorites valueForKeyPath:@"id"]];
    
    for (NSMutableDictionary *item in [QuickFunctions sharedQuickFunctions].app.currentAlbums) {
        NSArray *filtered = [[item valueForKey:@"tracks"] filteredArrayUsingPredicate:pred];
        [items addObjectsFromArray:filtered];
    }
    
    BOOL hasItems = [items count] > 0;

    self.emptyView.hidden = hasItems;
    self._tableView.hidden = !hasItems;
    if (!hasItems) {
        [self setEditing:NO animated:NO];
        self.navigationItem.leftBarButtonItem = nil;
    }
}

@end

