//
//  DuetViewController.h
//  myFans
//
//  Created by vincent on 13/1/16.
//  Copyright (c) 2013年 vincent. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "ECSlidingViewController.h"
#import "CommonViewController.h"
#import "MHLazyTableImages.h"
#import "MHImageCache.h"
#import "UIDownloadBar.h"
#import "MBProgressHUD.h"

@interface DuetViewController : CommonViewController <FBLoginViewDelegate, MHLazyTableImagesDelegate, UITableViewDataSource, UITableViewDelegate, UIDownloadBarDelegate, MBProgressHUDDelegate>
{
    IBOutlet UITableView *m_tableView;
    MHLazyTableImages* lazyImages;

    float m_percentComplete;
    
    // 合成時間吧
    MBProgressHUD *m_HUD;
}

@property (strong,nonatomic) UISegmentedControl * segment_title;
@property (nonatomic, retain) NSArray* entries;
@property (strong, nonatomic) MBProgressHUD *m_HUD;


- (IBAction)revealMenu:(id)sender;


@end
