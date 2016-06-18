//
//  NotifyViewController.m
//  myFans
//
//  Created by vincent on 13/1/16.
//  Copyright (c) 2013年 vincent. All rights reserved.
//


#import "NotifyViewController.h"

@implementation NotifyViewController

- (void)awakeFromNib
{
  [[NSNotificationCenter defaultCenter] addObserver:self 
                                           selector:@selector(underLeftWillAppear:)
                                               name:ECSlidingViewUnderLeftWillAppear 
                                             object:self.slidingViewController];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(topDidAnchorRight:) 
                                               name:ECSlidingViewTopDidAnchorRight 
                                             object:self.slidingViewController];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(underRightWillAppear:) 
                                               name:ECSlidingViewUnderRightWillAppear 
                                             object:self.slidingViewController];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(topDidAnchorLeft:) 
                                               name:ECSlidingViewTopDidAnchorLeft 
                                             object:self.slidingViewController];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(topDidReset:) 
                                               name:ECSlidingViewTopDidReset 
                                             object:self.slidingViewController];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
    // shadowPath, shadowOffset, and rotation is handled by ECSlidingViewController.
    // You just need to set the opacity, radius, and color.
    // 上層View的陰影
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;

    //初始左側下一層View
  if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
    self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
  }
    //初始右側下一層View
  if (![self.slidingViewController.underRightViewController isKindOfClass:[UnderRightViewController class]]) {
    self.slidingViewController.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UnderRight"];
  }
  
  [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (IBAction)revealMenu:(id)sender
{
  [self.slidingViewController anchorTopViewTo:ECRight];
}

// slidingViewController notification
- (void)underLeftWillAppear:(NSNotification *)notification
{
  //NSLog(@"under left will appear");
}

- (void)topDidAnchorRight:(NSNotification *)notification
{
  //NSLog(@"top did anchor right");
}

- (void)underRightWillAppear:(NSNotification *)notification
{
  //NSLog(@"under right will appear");
}

- (void)topDidAnchorLeft:(NSNotification *)notification
{
  //NSLog(@"top did anchor left");
}

- (void)topDidReset:(NSNotification *)notification
{
 // NSLog(@"top did reset");
}

@end
