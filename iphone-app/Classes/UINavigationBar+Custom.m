//
//  UINavigationBar+Custom.m
//  iMortacci
//
//  Created by Ali Servet Donmez on 9.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import "UINavigationBar+Custom.h"
#import "iMortacci.h"


@implementation UINavigationBar (Custom)

- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed: @"NavBarBackground.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self setTintColor:kIMORColorGreen];
}

@end
