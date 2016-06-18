//
//  CustomNavigationBar.m
//  myFans
//
//  Created by vincent on 13/1/16.
//  Copyright (c) 2013年 vincent. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CustomNavigationBar.h"

@implementation CustomNavigationBar

- (void)awakeFromNib {
    [super awakeFromNib];
    _image = [UIImage imageNamed:@"naviBar.png"];
    self.tintColor = [UIColor colorWithRed:31.0 / 255.0 green:134.0 / 255.0 blue:164.0 / 255.0 alpha:1.0];
    
    // draw shadow
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 0.6;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

- (void)drawRect:(CGRect)rect
{
    [_image drawInRect:rect];
}

@end
