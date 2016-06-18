//
//  CustomUIToolBar.m
//  myFans
//
//  Created by vincent on 13/1/16.
//  Copyright (c) 2013年 vincent. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CustomUIToolBar.h"

@implementation CustomUIToolBar

- (void)awakeFromNib {
    [super awakeFromNib];
    //_image = [UIImage imageNamed:@"kTabBar.png"];
    //self.tintColor = [UIColor colorWithRed:57.0 / 255.0 green:54.0 / 255.0 blue:49.0 / 255.0 alpha:1.0];
    
    // draw shadow
    //self.layer.masksToBounds = NO;
    //self.layer.shadowOffset = CGSizeMake(0, 3);
    //self.layer.shadowOpacity = 0.6;
    //self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

- (void)drawRect:(CGRect)rect
{
    [_image drawInRect:rect];
}

@end
