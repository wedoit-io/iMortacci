//
//  IMORTopChartController.m
//  iMortacci
//
//  Created by Ali Servet Donmez on 1.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import "IMORTopChartController.h"
#import "iMortacci.h"
#import "QuickFunctions.h"
#import "IMORTopChartCellController.h"
#import "IMORPlayblackController.h"


@implementation IMORTopChartController

@synthesize _tableView;
@synthesize items;
@synthesize tempCell;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Sort counter array
    NSArray *sortedCounters = [[QuickFunctions sharedQuickFunctions].app.counters sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return (NSComparisonResult)[(NSNumber *)[obj1 valueForKey:@"like_count"] compare:
                (NSNumber *)[obj2 valueForKey:@"like_count"]] * -1;
    }];
    
    // Take top 25
    if ([sortedCounters count] > 25) {
        sortedCounters = [sortedCounters subarrayWithRange:NSMakeRange(0, 25)];
    }
    
    NSMutableArray *allItems = [NSMutableArray new];
    for (NSDictionary *album in [QuickFunctions sharedQuickFunctions].app.currentAlbums) {
        [allItems addObjectsFromArray:[album valueForKey:@"tracks"]];
    }

    items = [NSMutableArray new];
    for (NSDictionary *counter in sortedCounters) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"id = %@", [counter valueForKeyPath:@"id"]];
        NSArray *filtered = [allItems filteredArrayUsingPredicate:pred];
        if ([filtered count] > 0) {
            [items addObject:[filtered objectAtIndex:0]];
        }
    }

//    [items sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"id = %@", [obj1 valueForKey:@"id"]];
//        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"id = %@", [obj2 valueForKey:@"id"]];
//        NSDictionary *count1 = [[[QuickFunctions sharedQuickFunctions].app.counters filteredArrayUsingPredicate:pred1] objectAtIndex:0];
//        NSDictionary *count2 = [[[QuickFunctions sharedQuickFunctions].app.counters filteredArrayUsingPredicate:pred2] objectAtIndex:0];
//        return [(NSNumber *)[count1 valueForKey:@"like_count"] compare:
//                (NSNumber *)[count2 valueForKey:@"like_count"]];
//    }];
    
    // $$$ Let's make some money! ;-) $$$
    [self.view addSubview:[AdWhirlView requestAdWhirlViewWithDelegate:self]];
    
    self._tableView.rowHeight = kSearchTableRowHeight;
    self._tableView.backgroundColor = kIMORColorWhite;
    self._tableView.separatorColor = [UIColor whiteColor];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self._tableView deselectRowAtIndexPath:[self._tableView indexPathForSelectedRow] animated:YES];
}

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
    return [items count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"IMORTopChartCellController";
    
    IMORTopChartCellController *cell = (IMORTopChartCellController *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"IMORTopChartCellController" owner:self options:nil];
        cell = tempCell;
        self.tempCell = nil;
    }
    
    // Configure the cell...
    
    NSDictionary *dict = [items objectAtIndex:indexPath.row];
    
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
    
    cell.rankView.layer.cornerRadius = 4.0;
    cell.rankTextLabel.text = [NSString stringWithFormat:@"%02d", indexPath.row +1];
    
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
    
    IMORPlayblackController *detailViewController = [[IMORPlayblackController alloc]
                                                     initWithNibName:@"IMORPlayblackController" bundle:nil];
    
    detailViewController.item = [items objectAtIndex:indexPath.row];
    
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
    [self set_tableView:nil];
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [_tableView release];
    [items release];
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

@end

