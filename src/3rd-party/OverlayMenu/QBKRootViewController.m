//
//  QBKRootViewController.m
//  QBKOverlayMenuView
//
//  Created by Sendoa Portuondo on 11/05/12.
//  Copyright (c) 2012 Qbikode Solutions, S.L. All rights reserved.
//

#import "QBKRootViewController.h"
#import "QBKOverlayMenuView.h"


@interface QBKRootViewController ()

@end

@implementation QBKRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    QBKOverlayMenuViewOffset offset;
    offset.bottomOffset = 44;
    
    _qbkOverlayMenu = [[QBKOverlayMenuView alloc] initWithDelegate:self position:kQBKOverlayMenuViewPositionBottom offset:offset];
    [_qbkOverlayMenu setParentView:[self view]];

    //建立陣列並設定其內容來當作選項
    NSArray *itemArray =[NSArray arrayWithObjects:@"原聲", @"KTV", @"小劇場", @"演唱會", nil];

    //使用陣列來建立UISegmentedControl
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];

    //設定外觀大小與初始選項
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.frame = CGRectMake(4.0, 4.0, 260.0, 35.0);
    segmentedControl.selectedSegmentIndex = 0;

    //設定所觸發的事件條件與對應事件
    [segmentedControl addTarget:self action:@selector(chooseOne:) forControlEvents:UIControlEventValueChanged];

    //加入畫面中並釋放記憶體
    [_qbkOverlayMenu.contentView addSubview:segmentedControl];
}

- (void)chooseOne:(id)sender {
    
    NSLog(@"%@", [sender titleForSegmentAtIndex:[sender selectedSegmentIndex]]);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
