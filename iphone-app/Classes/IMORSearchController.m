//
//  IMORSearchController.m
//  iMortacci
//
//  Created by Ali Servet Donmez on 1.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import "IMORSearchController.h"
#import "iMortacci.h"
#import "QuickFunctions.h"
#import "IMORSearchCellController.h"
#import "IMORPlayblackController.h"


@implementation IMORSearchController

@synthesize _tableView;
@synthesize tracksOnly;
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
    
    // $$$ Let's make some money! ;-) $$$
    [self.view addSubview:[AdWhirlView requestAdWhirlViewWithDelegate:self]];
    
    self._tableView.rowHeight = kSearchTableRowHeight;
    self._tableView.backgroundColor = kIMORColorWhite;
    self._tableView.separatorColor = [UIColor whiteColor];
    
    self.searchDisplayController.searchResultsTableView.rowHeight = kSearchTableRowHeight;
    
    if (tracksOnly) {
        self.searchDisplayController.searchBar.placeholder = [NSString stringWithFormat:@"Cerca in %@", self.title];
    }
    else {
        self.searchDisplayController.searchBar.placeholder = @"Cerca in tutti i dialetti";
    }

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
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!tracksOnly) {
        items = [QuickFunctions sharedQuickFunctions].app.currentAlbums;
    }

    [self._tableView deselectRowAtIndexPath:[self._tableView indexPathForSelectedRow] animated:YES];

    // We set some search results tableview's properties here, instead of in 'viewDidLoad', because
    // after first time search view will popup row height will be set to default and
    // we don't definitely want that
    self.searchDisplayController.searchResultsTableView.rowHeight = kSearchTableRowHeight;
    self.searchDisplayController.searchResultsTableView.backgroundColor = kIMORColorWhite;
    self.searchDisplayController.searchResultsTableView.separatorColor = [UIColor whiteColor];
    
    [self._tableView reloadData];
}

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (tracksOnly) {
        return 1;
    }
    else {
        if (tableView == self._tableView) {
            return 1;
        }
        else {
            return [filteredItems count];
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tracksOnly) {
        if (tableView == self._tableView) {
            return [items count];
        }
        else {
            return [filteredItems count];
        }
    } else {
        if (tableView == self._tableView) {
            return [items count];
        }
        else {
            return [[[filteredItems objectAtIndex:section] valueForKey:@"tracks"] count];
        }
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // Return header title for each section
    if (!tracksOnly && tableView == self.searchDisplayController.searchResultsTableView) {
        return [[filteredItems objectAtIndex:section] valueForKey:@"title"];
    }
    else {
        return nil;
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict;
    if (tracksOnly) {
        dict = (tableView == self._tableView)
        ? [items objectAtIndex:indexPath.row]
        : [filteredItems objectAtIndex:indexPath.row];
    }
    else {
        dict = (tableView == self._tableView)
        ? [items objectAtIndex:indexPath.row]
        : [[[filteredItems objectAtIndex:indexPath.section] valueForKey:@"tracks"] objectAtIndex:indexPath.row];
    }
    
    if (!tracksOnly && tableView == self._tableView) {
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        }

        // Configure the cell...
        
        cell.imageView.image = [UIImage imageWithData:[[QuickFunctions sharedQuickFunctions] getAlbumArtworkWithSlug:[dict valueForKey:@"slug"]
                                                                                                             AndSize:@"small"]];
        cell.textLabel.text = [dict valueForKey:@"title"];
        // This is how you check for null string values in JSON string "<null>"
        // Ref.: http://stackoverflow.com/questions/4839355/checking-a-null-value-in-objective-c-that-has-been-returned-from-a-json-string
        if ([dict valueForKey:@"description"] != [NSNull null]) {
            cell.detailTextLabel.text = [dict valueForKey:@"description"];
        }
        
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"IMORSearchCellController";
        
        IMORSearchCellController *cell = (IMORSearchCellController *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"IMORSearchCellController" owner:self options:nil];
            cell = tempCell;
            self.tempCell = nil;
        }

        // Configure the cell...
        
        if (tracksOnly) {
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %@", [dict valueForKey:@"album_id"]];
            NSArray *filtered = [[QuickFunctions sharedQuickFunctions].app.currentAlbums filteredArrayUsingPredicate:pred];
            if ([filtered count] > 0) {
                cell.imageView.image = [UIImage imageWithData:[[QuickFunctions sharedQuickFunctions] getAlbumArtworkWithSlug:[[filtered objectAtIndex:0] valueForKey:@"slug"]
                                                                                                                     AndSize:@"small"]];
            }
            else {
                cell.imageView.image = [UIImage imageWithData:[[QuickFunctions sharedQuickFunctions] getAlbumArtworkWithSlug:@"default"
                                                                                                                     AndSize:@"small"]];
            }
        }
        else {
            cell.imageView.image = [UIImage imageWithData:[[QuickFunctions sharedQuickFunctions]
                                                           getAlbumArtworkWithSlug:[[filteredItems
                                                                                     objectAtIndex:indexPath.section]
                                                                                    valueForKey:@"slug"]
                                                           AndSize:@"small"]];
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
        
        if ([filteredLocalUserInfo count] == 0) {
            cell.badgeString = @"nuovo";
            cell.badgeColor = kIMORColorGreen;
        }
        
        return cell;
    }
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

    if (!tracksOnly && tableView == self._tableView) {
        IMORSearchController *detailViewController = [[IMORSearchController alloc]
                                                      initWithNibName:@"IMORSearchController" bundle:nil];
        NSDictionary *item = [items objectAtIndex:indexPath.row];
        detailViewController.tracksOnly = YES;
        detailViewController.title = [item valueForKey:@"title"];
        detailViewController.items = [item valueForKey:@"tracks"];
        
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    }
    else {
        IMORPlayblackController *detailViewController = [[IMORPlayblackController alloc]
                                                         initWithNibName:@"IMORPlayblackController" bundle:nil];
        
        if (tracksOnly) {
            if (tableView == self._tableView) {
                detailViewController.item = [items objectAtIndex:indexPath.row];
            }
            else {
                detailViewController.item = [filteredItems objectAtIndex:indexPath.row];
            }
        }
        else {
            detailViewController.item = [[[filteredItems objectAtIndex:indexPath.section]
                                          valueForKey:@"tracks"] objectAtIndex:indexPath.row];
        }

        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    }
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
	self.filteredItems = nil;
}


- (void)dealloc {
    [_tableView release];
    [items release];
    [filteredItems release];
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

    if (tracksOnly) {
        [self.filteredItems addObjectsFromArray:[items filteredArrayUsingPredicate:pred]];
    }
    else {
        [items enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
            NSMutableDictionary *item = [NSMutableDictionary dictionaryWithDictionary:obj];
            NSArray *filtered = [[item valueForKey:@"tracks"] filteredArrayUsingPredicate:pred];
            if ([filtered count] > 0) {
                [item setObject:filtered forKey:@"tracks"];
                [self.filteredItems addObject:item];
            }
        }];
    }
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

@end

