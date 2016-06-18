//
//  UIMenuBar.h
//  TesdXcodeUserGuideDemo
//
//  Created by xd.su on 13-2-19.
//  Copyright (c) 2013年 su xinde. All rights reserved.
//

// UITabBar
// UIToolbar
// UINavigationBar

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIMenuBarItem.h"

@class UIMenuBar;

@protocol UIMenuBarDelegate <NSObject>
@optional
- (void)menuBar:(UIMenuBar *)menuBar didSelectAtIndex:(int)index;

@end

@interface UIMenuBar : UIView <UIScrollViewDelegate>//,UIAppearance>
{
@private
    id<UIMenuBarDelegate>  _delegate;
    NSMutableArray        *_items;
    UIMenuBarItem         *_selectedItem;
    UIColor               *_tintColor;
    
    NSInteger              _pages;                  
    UIScrollView          *_containerView;          
    UIPageControl         *_pageControl;            
    NSMutableArray        *_containerScrollViews;
    CGSize                 _originalSize;
    CGSize                 _halfOriginalSize;
}

@property (nonatomic, assign) id<UIMenuBarDelegate> delegate;     // weak reference. default is nil
@property (nonatomic, copy)   NSMutableArray       *items;
@property (nonatomic, assign) UIMenuBarItem        *selectedItem; // will show feedback based on mode. default is nil
@property (nonatomic, retain) UIColor              *tintColor;    // Default is black.

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items;
- (void)setItems:(NSMutableArray *)items;
- (void)show;  
- (void)dismiss; 

@end
