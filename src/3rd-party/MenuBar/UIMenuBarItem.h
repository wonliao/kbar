//
//  UIMenuItem.h
//  TesdXcodeUserGuideDemo
//
//  Created by xd.su on 13-2-19.
//  Copyright (c) 2013年 su xinde. All rights reserved.
//

#import <Foundation/Foundation.h>

// UIBarButtonItem
// UITabBarItem

@interface UIMenuBarItem : NSObject
{
    NSString    *_title;
    UIImage     *_image;
    id           _target;
    SEL          _action;
    UIControl   *_containView;
    UIImageView *_imageView;
    UILabel     *_titleLabel;
    CGFloat     *width;
    CGFloat     *height;
}

@property (nonatomic) SEL action;
@property (nonatomic, retain, readonly) NSString *title;
@property (nonatomic, retain, readonly) UIImage *image;
@property (nonatomic, retain) UIControl *containView;
@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;

- (id)initWithTitle:(NSString *)title
             target:(id)target
              image:(UIImage *)image
             action:(SEL)action;

@end
