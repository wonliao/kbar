//
//  MenuViewController.m
//  myFans
//
//  Created by vincent on 13/1/16.
//  Copyright (c) 2013年 vincent. All rights reserved.
//
#import "MenuViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FBCoreData.h"

#import "StyledTableViewCell.h"

@implementation MenuViewController


@synthesize demoTableViewStyle = _demoTableViewStyle;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.slidingViewController setAnchorRightRevealAmount:280.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;

    // 可變換色彩 TableView
    _demoTableViewStyle = DemoTableViewStyle_GradientHorizontal;
    
    menuTextList = [[NSArray alloc] initWithObjects:
                        [[NSArray alloc] initWithObjects: @"個人檔案",   @"itunes.png",     @"fourthButtonTapped:", nil],
                        [[NSArray alloc] initWithObjects: @"首頁",    @"itunes.png",     @"eigthButtonTapped:", nil],
                        [[NSArray alloc] initWithObjects: @"通知",    @"itunes.png",     @"thirdButtonTapped:", nil],
                        [[NSArray alloc] initWithObjects: @"訊息",    @"itunes.png",     @"sixthButtonTapped:", nil],
                        [[NSArray alloc] initWithObjects: @"加入合唱", @"itunes.png",     @"fifthButtonTapped:", nil],
                        [[NSArray alloc] initWithObjects: @"比賽",    @"itunes.png",     @"seventhButtonTapped:", nil],
                        [[NSArray alloc] initWithObjects: @"匯入朋友", @"itunes.png",     @"firstButtonTapped:", nil],
                        [[NSArray alloc] initWithObjects: @"系統設定", @"itunes.png",     @"settingButtonTapped:", nil],
                        nil];
    
    m_tableView.backgroundView.alpha = 0.7;

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [menuTextList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StyledTableViewCell *cell = nil;
  
    if (_demoTableViewStyle==DemoTableViewStyle_Cyan) {

        static NSString *CellIdentifier = @"CYAN";
        cell = (StyledTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {

            cell = [[StyledTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.textLabel setTextColor:[UIColor blackColor]];
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
            [cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];
            [cell setStyledTableViewCellSelectionStyle:StyledTableViewCellSelectionStyleCyan];
        }

    } else if (_demoTableViewStyle==DemoTableViewStyle_Green) {

        static NSString *CellIdentifier = @"GREEN";
        cell = (StyledTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {

            cell = [[StyledTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.textLabel setTextColor:[UIColor blackColor]];
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
            [cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];
            [cell setStyledTableViewCellSelectionStyle:StyledTableViewCellSelectionStyleGreen];
        }

    } else if (_demoTableViewStyle==DemoTableViewStyle_Purple) {

        static NSString *CellIdentifier = @"PURPLE";
        cell = (StyledTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {

            cell = [[StyledTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.textLabel setTextColor:[UIColor blackColor]];
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
            [cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];
            [cell setStyledTableViewCellSelectionStyle:StyledTableViewCellSelectionStylePurple];
        }

    } else if (_demoTableViewStyle==DemoTableViewStyle_Yellow) {

        static NSString *CellIdentifier = @"YELLOW";
        cell = (StyledTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {

            cell = [[StyledTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.textLabel setTextColor:[UIColor blackColor]];
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
            [cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];
            [cell setStyledTableViewCellSelectionStyle:StyledTableViewCellSelectionStyleYellow];
        }

    } else if (_demoTableViewStyle==DemoTableViewStyle_2Colors) {

        static NSString *CellIdentifier = @"CUSTOM2";
        cell = (StyledTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {

            cell = [[StyledTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.textLabel setTextColor:[UIColor blackColor]];
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
            [cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];
            
            NSMutableArray *colors = [NSMutableArray array];
            [colors addObject:(id)[[UIColor colorWithRed:255/255.0 green:234/255.0 blue:0 alpha:1] CGColor]];
            [colors addObject:(id)[[UIColor colorWithRed:255/255.0 green:174/255.0 blue:0 alpha:1] CGColor]];
            [cell setSelectedBackgroundViewGradientColors:colors];
            
        }

    } else if (_demoTableViewStyle==DemoTableViewStyle_3Colors) {

        static NSString *CellIdentifier = @"CUSTOM3";
        cell = (StyledTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {

            cell = [[StyledTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.textLabel setTextColor:[UIColor blackColor]];
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
            [cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];
            
            NSMutableArray *colors = [NSMutableArray array];
            [colors addObject:(id)[[UIColor colorWithRed:255/255.0 green:174/255.0 blue:0 alpha:1] CGColor]];
            [colors addObject:(id)[[UIColor colorWithRed:255/255.0 green:234/255.0 blue:0 alpha:1] CGColor]];
            [colors addObject:(id)[[UIColor colorWithRed:255/255.0 green:174/255.0 blue:0 alpha:1] CGColor]];
            [cell setSelectedBackgroundViewGradientColors:colors];
        }

    } else if (_demoTableViewStyle==DemoTableViewStyle_DottedLine) {

        static NSString *CellIdentifier = @"DOTTED_LINE";
        cell = (StyledTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {

            cell = [[StyledTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.textLabel setTextColor:[UIColor blackColor]];
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
            [cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];
            [cell setStyledTableViewCellSelectionStyle:StyledTableViewCellSelectionStyleCyan];
            [cell setDashWidth:1 dashGap:3 dashStroke:1];
        }

    } else if (_demoTableViewStyle==DemoTableViewStyle_Dashes) {

        static NSString *CellIdentifier = @"DASH";
        cell = (StyledTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {

            cell = [[StyledTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.textLabel setTextColor:[UIColor blackColor]];
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
            [cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];
            [cell setStyledTableViewCellSelectionStyle:StyledTableViewCellSelectionStyleCyan];
            [cell setDashWidth:5 dashGap:3 dashStroke:1];
        }

    } else if (_demoTableViewStyle==DemoTableViewStyle_GradientVertical) {

        NSMutableArray *colors = [NSMutableArray array];
        [colors addObject:(id)[[UIColor colorWithRed:255/255.0 green:234/255.0 blue:0 alpha:1] CGColor]];
        [colors addObject:(id)[[UIColor colorWithRed:255/255.0 green:174/255.0 blue:0 alpha:1] CGColor]];
        
        static NSString *CellIdentifier = @"VERTICAL";
        cell = (StyledTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {

            cell = [[StyledTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.textLabel setTextColor:[UIColor blackColor]];
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
            [cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];
            [cell setDashWidth:1 dashGap:3 dashStroke:1];
            [cell setSelectedBackgroundViewGradientColors:colors];
            [cell setSelectionGradientDirection:StyledTableViewCellSelectionGradientDirectionVertical];
        }

    } else if (_demoTableViewStyle==DemoTableViewStyle_GradientHorizontal) {

        NSMutableArray *colors = [NSMutableArray array];
        [colors addObject:(id)[[UIColor colorWithRed:255/255.0 green:234/255.0 blue:0 alpha:1] CGColor]];
        [colors addObject:(id)[[UIColor colorWithRed:255/255.0 green:174/255.0 blue:0 alpha:1] CGColor]];
        
        static NSString *CellIdentifier = @"HORIZONTAL";
        cell = (StyledTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {

            cell = [[StyledTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.textLabel setTextColor:[UIColor blackColor]];
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
            [cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];
            [cell setDashWidth:1 dashGap:3 dashStroke:1];
            [cell setSelectedBackgroundViewGradientColors:colors];
            [cell setSelectionGradientDirection:StyledTableViewCellSelectionGradientDirectionHorizontal];
        }

    } else if (_demoTableViewStyle==DemoTableViewStyle_GradientDiagonalTopLeftToBottomRight) {

        NSMutableArray *colors = [NSMutableArray array];
        [colors addObject:(id)[[UIColor colorWithRed:255/255.0 green:234/255.0 blue:0 alpha:1] CGColor]];
        [colors addObject:(id)[[UIColor colorWithRed:255/255.0 green:174/255.0 blue:0 alpha:1] CGColor]];
        
        static NSString *CellIdentifier = @"DIAGONAL1";
        cell = (StyledTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {

            cell = [[StyledTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.textLabel setTextColor:[UIColor blackColor]];
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
            [cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];
            [cell setDashWidth:1 dashGap:3 dashStroke:1];
            [cell setSelectedBackgroundViewGradientColors:colors];
            [cell setSelectionGradientDirection:StyledTableViewCellSelectionGradientDirectionDiagonalTopLeftToBottomRight];
        }

    } else if (_demoTableViewStyle==DemoTableViewStyle_GradientDiagonalBottomLeftToTopRight) {

        NSMutableArray *colors = [NSMutableArray array];
        [colors addObject:(id)[[UIColor colorWithRed:255/255.0 green:234/255.0 blue:0 alpha:1] CGColor]];
        [colors addObject:(id)[[UIColor colorWithRed:255/255.0 green:174/255.0 blue:0 alpha:1] CGColor]];
        
        static NSString *CellIdentifier = @"DIAGONAL2";
        cell = (StyledTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {

            cell = [[StyledTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.textLabel setTextColor:[UIColor blackColor]];
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
            [cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];
            [cell setDashWidth:1 dashGap:3 dashStroke:1];
            [cell setSelectedBackgroundViewGradientColors:colors];
            [cell setSelectionGradientDirection:StyledTableViewCellSelectionGradientDirectionDiagonalBottomLeftToTopRight];
        }
    }
    
    NSArray *itemArray = [menuTextList objectAtIndex:indexPath.row];
    [cell.textLabel setText:[itemArray objectAtIndex:0]];
    [cell.imageView setImage:[UIImage imageNamed:[itemArray objectAtIndex:1]]];

    cell.backgroundView.alpha = 0.5;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *itemArray = [menuTextList objectAtIndex:indexPath.row];
    if( itemArray ) {

        NSString *methodName = [itemArray objectAtIndex:2];
        NSLog(@"call %@", methodName);
        [self performSelector:NSSelectorFromString(methodName)
                   withObject:nil
                   afterDelay:0];
    }
}

- (IBAction)firstButtonTapped:(id)sender
{
    
    NSString *identifier =@"FirstTop";
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];

}

- (IBAction)secondButtonTapped:(id)sender
{
    NSString *identifier =@"SecondTop";
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

- (IBAction)thirdButtonTapped:(id)sender
{
    NSString *identifier =@"ThirdTop";
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

- (IBAction)fourthButtonTapped:(id)sender
{
    // 取得 facebook 資料
    FBCoreData *fbCoreData = [[FBCoreData alloc] init];
    [fbCoreData load];

    if( [fbCoreData.fbUID isEqual:@""] ) {

        NSLog(@"未登錄facebook!!");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"先登錄" message:@"您需要先登錄k吧才能完成操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登錄",nil];
        [alert show];
    } else {

        NSLog(@"已登錄facebook!!");
        NSString *identifier =@"FourthTop";
        UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];

        [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
            CGRect frame = self.slidingViewController.topViewController.view.frame;
            self.slidingViewController.topViewController = newTopViewController;
            self.slidingViewController.topViewController.view.frame = frame;
            [self.slidingViewController resetTopView];
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"取消");
    }
    if (buttonIndex == 1)
    {
        NSLog(@"登錄");
        
        NSString *identifier =@"LoginTop";
        UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];

        [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
            CGRect frame = self.slidingViewController.topViewController.view.frame;
            self.slidingViewController.topViewController = newTopViewController;
            self.slidingViewController.topViewController.view.frame = frame;
            [self.slidingViewController resetTopView];
        }];
    }
}

- (IBAction)fifthButtonTapped:(id)sender
{
    NSString *identifier =@"FifthTop";
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];

    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

- (IBAction)sixthButtonTapped:(id)sender
{
    NSString *identifier =@"SixthTop";
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

- (IBAction)seventhButtonTapped:(id)sender
{
    NSString *identifier =@"SeventhTop";
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

- (IBAction)eigthButtonTapped:(id)sender
{
    NSString *identifier =@"NavTop";
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

- (IBAction)settingButtonTapped:(id)sender
{
    NSString *identifier =@"SettingTop";
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

- (IBAction)singButtonTapped:(id)sender
{
    NSString *identifier =@"NaviSongMenu";
    UIViewController *singViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
	singViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
	[self presentModalViewController:singViewController animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    // Do the search...
}
@end
