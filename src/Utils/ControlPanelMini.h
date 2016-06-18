//
//  ControlPanelMini.h
//  mySingPage
//
//  Created by wonliao on 13/1/22.
//  Copyright (c) 2013年 wonliao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ControlPanelMini : UIView{
    UIImageView *_iconView;
    UILabel *_titleLabel;
    UILabel *_detailLabel;
    
    UIColor *_color;
    
    CGGradientRef _gradient;
    
    UIButton *button;
}

@property (nonatomic, assign) UIImage *icon;
@property (nonatomic, assign) NSString *title;
@property (nonatomic, assign) NSString *detail;
@property (nonatomic, assign) UIColor *color;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) UIButton *button;


- (id)initWithWidth:(CGFloat)width;
- (id)initWithTitle:(NSString *)title detail:(NSString *)detail icon:(UIImage *)icon;
- (UIColor *)lightenColor:(UIColor *)oldColor value:(float)value;

- (IBAction)playButtonTapped:(id)sender;
- (IBAction)pauseButtonTapped:(id)sender;

@end
