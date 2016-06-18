//
//  MenuViewController.h
//  ECSlidingViewController
//
//  myFans
//
//  Created by wonliao on 13/1/16.
//  Copyright (c) 2013年 wonliao. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"

typedef enum
{
    DemoTableViewStyle_Cyan = 0,
    DemoTableViewStyle_Green = 1,
    DemoTableViewStyle_Purple = 2,
    DemoTableViewStyle_Yellow = 3,
    DemoTableViewStyle_2Colors = 4,
    DemoTableViewStyle_3Colors = 5,
    DemoTableViewStyle_DottedLine = 6,
    DemoTableViewStyle_Dashes = 7,
    DemoTableViewStyle_GradientVertical = 8,
    DemoTableViewStyle_GradientHorizontal = 9,
    DemoTableViewStyle_GradientDiagonalTopLeftToBottomRight = 10,
    DemoTableViewStyle_GradientDiagonalBottomLeftToTopRight = 11,
} DemoTableViewStyle;

@interface MenuViewController : UIViewController <UIAlertViewDelegate>
{
    NSArray* menuTextList;
    IBOutlet UITableView *m_tableView;
}


@property (assign, nonatomic) DemoTableViewStyle demoTableViewStyle;

- (IBAction)firstButtonTapped:(id)sender;
- (IBAction)secondButtonTapped:(id)sender;
- (IBAction)thirdButtonTapped:(id)sender;
- (IBAction)fourthButtonTapped:(id)sender;
- (IBAction)fifthButtonTapped:(id)sender;
- (IBAction)sixthButtonTapped:(id)sender;
- (IBAction)seventhButtonTapped:(id)sender;
- (IBAction)eigthButtonTapped:(id)sender;
- (IBAction)settingButtonTapped:(id)sender;
- (IBAction)singButtonTapped:(id)sender;


@end
