//
//  IMORFavoritesController.h
//  iMortacci
//
//  Created by Ali Servet Donmez on 1.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdWhirlView.h"

@class IMORFavoritesCellController;


@interface IMORFavoritesController : UIViewController <AdWhirlDelegate> {

    UITableView *_tableView;
    UIView *emptyView;
    UILabel *noFavoritesLabel;

    NSMutableArray *items;
	NSMutableArray	*filteredItems; // The content filtered as a result of a search.

	// The saved state of the search UI if a memory warning removed the view.
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
    
    // UI elements
    IMORFavoritesCellController *tempCell;
}

@property (nonatomic, retain) IBOutlet UITableView *_tableView;
@property (nonatomic, retain) IBOutlet UIView *emptyView;
@property (nonatomic, retain) IBOutlet UILabel *noFavoritesLabel;
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) NSMutableArray *filteredItems;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;
@property (nonatomic, assign) IBOutlet IMORFavoritesCellController *tempCell;

- (void)populateItems;

@end
