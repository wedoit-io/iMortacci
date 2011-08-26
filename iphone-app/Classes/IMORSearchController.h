//
//  IMORSearchController.h
//  iMortacci
//
//  Created by Ali Servet Donmez on 1.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdWhirlView.h"

@class IMORSearchCellController;


@interface IMORSearchController : UIViewController <AdWhirlDelegate> {
    
    UITableView *_tableView;
    
    BOOL tracksOnly;

    NSArray *items;
	NSMutableArray	*filteredItems; // The content filtered as a result of a search.
	
	// The saved state of the search UI if a memory warning removed the view.
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
    
    // UI elements
    IMORSearchCellController *tempCell;
    
    UIImage *albumImage;
}

@property (nonatomic, retain) IBOutlet UITableView *_tableView;
@property (nonatomic, assign) BOOL tracksOnly;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) NSMutableArray *filteredItems;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;
@property (nonatomic, assign) IBOutlet IMORSearchCellController *tempCell;
@property (nonatomic, retain) UIImage *albumImage;

@end
