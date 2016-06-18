//
//  HomeViewController.h
//  myFans
//
//  Created by vincent on 13/1/16.
//  Copyright (c) 2013年 vincent. All rights reserved.
//首頁,主要實現照片瀑布

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "ECSlidingViewController.h"
#import "UnderRightViewController.h"
#import "wordpress.h"
#import "CoreData.h"

@interface HomeViewController : UIViewController <UIScrollViewDelegate> {

    int count;

    // CoreData 物件
    CoreData *m_coreData;

    NSMutableArray *homepageData;
    wordpress *m_wordpress;

    NSMutableArray* m_currentData;
    NSMutableArray *m_page1;
    NSMutableArray *m_page2;
    NSMutableArray *m_page3;
        
    int m_oldIndexRow;
        
    IBOutlet UITableView *m_tableView;
    
    CGPoint m_scrollStart, m_scrollEnd;
}

@property (strong,nonatomic) UISegmentedControl * segment_title;
@property (strong,nonatomic) UIButton *singButton;



- (IBAction)revealMenu:(id)sender;
- (IBAction)singButtonTapped:(id)sender;
- (IBAction)neighborButtonTapped:(id)sender;
- (void)showFloatUI:(BOOL)_show;

@end
