//
//  IMORNavigationBar.m
//  iMortacci
//
//  Created by Ali Servet Donmez on 29.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import "IMORNavigationBar.h"
#import "iMortacci.h"


@implementation IMORNavigationBar

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Custom Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed: @"IMORNavBarBackground.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self setTintColor:kIMORColorGreen];
}

- (void)dealloc {
    [super dealloc];
}

@end
