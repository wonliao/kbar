//
//  RankingViewController.h
//  myFans
//
//  Created by wonliao on 13/1/16.
//  Copyright (c) 2013年 wonliao. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@interface RankingViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
- (IBAction)revealMenu:(id)sender;
@end
