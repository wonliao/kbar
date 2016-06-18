//
//  CustomUIToolBar2.m
//  kBar
//
//  Created by wonliao on 13/2/19.
//
//

#import "CustomUIToolBar2.h"

@implementation CustomUIToolBar2

- (void)awakeFromNib {
    [super awakeFromNib];
    _image = [UIImage imageNamed:@"naviBar.png"];
    self.tintColor = [UIColor colorWithRed:31.0 / 255.0 green:134.0 / 255.0 blue:164.0 / 255.0 alpha:1.0];
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
