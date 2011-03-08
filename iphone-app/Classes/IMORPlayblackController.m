//
//  IMORPlayblackController.m
//  iMortacci
//
//  Created by Ali Servet Donmez on 8.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import "IMORPlayblackController.h"
#import "iMortacciAppDelegate.h"
#import "SHK.h"

@implementation IMORPlayblackController

@synthesize item;
@synthesize titleTextLabel;
@synthesize descriptionTextLabel;
@synthesize player;

/*
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    titleTextLabel.text = [item valueForKey:@"title"];
    descriptionTextLabel.text = [item valueForKey:@"description"];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [item release];
    [titleTextLabel release];
    [descriptionTextLabel release];
    [super dealloc];
}


#pragma mark -
#pragma mark UI actions

- (IBAction)playTrack {
    iMortacciAppDelegate *appDelegate = (iMortacciAppDelegate *)[[UIApplication sharedApplication] delegate];
    player = [[AVAudioPlayer alloc] initWithData:[appDelegate getTrackWithId:[[item valueForKey:@"id"] intValue]]
                                           error:nil];
    [player play];
}

- (IBAction)share {
    // Create the item to share (in this example, a url)
	NSURL *url = [NSURL URLWithString:@"http://getsharekit.com"];
	SHKItem *shareItem = [SHKItem URL:url title:@"ShareKit is Awesome!"];
    
	// Get the ShareKit action sheet
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:shareItem];
    
	// Display the action sheet
	[actionSheet showFromToolbar:self.navigationController.toolbar];
}


@end
