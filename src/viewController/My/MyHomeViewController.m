//
//  MyHomeViewController.m
//  kBar
//
//  Created by vincent on 13/2/19.
//
//

#import "MyHomeViewController.h"
#import "MDCParallaxView.h"
#import "CustomUIToolBar.h"
@interface MyHomeViewController ()<UIScrollViewDelegate>

@end

@implementation MyHomeViewController
@synthesize sampleItems;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.sampleItems = [NSArray arrayWithObjects:
                        @"演唱已下載歌曲",
                        @"今天你要嫁給我",
                        @"寧夏",
                        @"挪威的森林",
                        @"一千個傷心的理由",
                        @"日不落",
                        @"寶貝對不起",
                        @"失戀陣線聯盟",
                        @"記事本",
                        @"大海",
                        @"很愛很愛你",
                        @"世界第一等",
                        @"笨小孩",
                        @"用生命所愛的人",
                        @"再會啦心愛的無緣的人",
                        @"你愛誰",
                        @"原來你什麼都不要",
                        @"小鎮姑娘",
                        @"菊花台",
                        @"寂寞沙洲冷",
                        @"你不愛我",
                        @"十年",
                        @"星語心願",
                        @"一路上有你",
                        @"小城故事",
                        @"天高地厚",
                        @"死了都要愛",
                        @"忠孝東路走九遍",
                        @"除了愛你還能愛誰",
                        nil];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"Photo_L_2.png"];
    CGRect backgroundRect = CGRectMake(0, 0, self.view.frame.size.width, backgroundImage.size.height);
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:backgroundRect];
    backgroundImageView.image = backgroundImage;
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    
    UIImage *midImage = [UIImage imageNamed:@"bottomBar.png"];
    CGRect midRect = CGRectMake(0, 0, self.view.frame.size.width, 50);
    UIImageView *midImageView = [[UIImageView alloc] initWithFrame:midRect];
    midImageView.image = midImage;
    midImageView.contentMode = UIViewContentModeScaleAspectFill;
    midImageView.userInteractionEnabled = YES;
    
    
    UIImage *buttonUpImage = [UIImage imageNamed:@"gray_btn.png"];
    UIImage *buttonDownImage = [UIImage imageNamed:@"button_down.png"];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(10.0, 5.0, 95,39);
    [button1 setBackgroundImage:buttonUpImage
                       forState:UIControlStateNormal];
    [button1 setBackgroundImage:buttonDownImage
                       forState:UIControlStateHighlighted];
    [button1.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [button1 setTitle:@"5個作品" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(button1Tapped:)
      forControlEvents:UIControlEventTouchUpInside];
    [midImageView addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(113.0, 5.0, 95,39);
    [button2 setBackgroundImage:buttonUpImage
                       forState:UIControlStateNormal];
    [button2 setBackgroundImage:buttonDownImage
                       forState:UIControlStateHighlighted];
    [button2.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [button2 setTitle:@"發起的合唱" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(button2Tapped:)
      forControlEvents:UIControlEventTouchUpInside];
    [midImageView addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame = CGRectMake(216.0, 5.0, 95,39);
    [button3 setBackgroundImage:buttonUpImage
                       forState:UIControlStateNormal];
    [button3 setBackgroundImage:buttonDownImage
                       forState:UIControlStateHighlighted];
    [button3.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [button3 setTitle:@"詳細資料" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(button3Tapped:)
      forControlEvents:UIControlEventTouchUpInside];
    [midImageView addSubview:button3];
    
    
    
    CGRect detailRect = CGRectMake(0, 0, self.view.frame.size.width, 464.0f);
    detailView = [[UIView alloc] initWithFrame:detailRect];
    
    UIImage *buttonUpImage2 = [UIImage imageNamed:@"song_order.png"];
    UIImage *buttonDownImage2 = [UIImage imageNamed:@"button_down.png"];
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    button4.frame = CGRectMake(3.0, 8.0, 155.0,66.0);
    [button4 setBackgroundImage:buttonUpImage2
                       forState:UIControlStateNormal];
    [button4 setBackgroundImage:buttonDownImage2
                       forState:UIControlStateHighlighted];
    [button4.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [button4 setTitle:@"我的關注" forState:UIControlStateNormal];
    //[button4 addTarget:self action:@selector(button4Tapped:) forControlEvents:UIControlEventTouchUpInside];
    [detailView addSubview:button4];
    
    UIButton *button5 = [UIButton buttonWithType:UIButtonTypeCustom];
    button5.frame = CGRectMake(162.0, 8.0, 155.0,66.0);
    [button5 setBackgroundImage:buttonUpImage2
                       forState:UIControlStateNormal];
    [button5 setBackgroundImage:buttonDownImage2
                       forState:UIControlStateHighlighted];
    [button5.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [button5 setTitle:@"我的粉絲" forState:UIControlStateNormal];
    //[button5 addTarget:self action:@selector(button5Tapped:) forControlEvents:UIControlEventTouchUpInside];
    [detailView addSubview:button5];
    
    
    CGRect textRect = CGRectMake(0, 0, self.view.frame.size.width, 600.0f);
    textView = [[UITextView alloc] initWithFrame:textRect];
    textView.text = NSLocalizedString(@"Permission is hereby granted, free of charge, to any person obtaining "
                                      @"a copy of this software and associated documentation files (the "
                                      @"\"Software\"), to deal in the Software without restriction, including "
                                      @"without limitation the rights to use, copy, modify, merge, publish, "
                                      @"distribute, sublicense, and/or sell copies of the Software, and to "
                                      @"permit persons to whom the Software is furnished to do so, subject to "
                                      @"the following conditions...\"", nil);
    textView.textAlignment = NSTextAlignmentCenter;
    textView.font = [UIFont systemFontOfSize:14.0f];
    textView.textColor = [UIColor darkTextColor];
    textView.editable = NO;
    
    //TableViewController1 *myTableController = [[TableViewController1 alloc] initWithStyle:UITableViewStylePlain]; // initWithStyle:UITableViewStylePlain
    
    
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,800) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    //tableView.userInteractionEnabled = NO;
    tableView.scrollEnabled = NO;
    //tableView.showsVerticalScrollIndicator = NO;
    
    
    //背景image  前景text
    parallaxView = [[MDCParallaxView alloc] initWithBackgroundView:backgroundImageView midgroundView:midImageView
                                                    foregroundView:tableView];
    parallaxView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    parallaxView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //背景視窗的高度
    parallaxView.backgroundHeight = 290.0f;
    parallaxView.scrollViewDelegate = self;
    [self.view addSubview:parallaxView];
    
    
    
    UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, 320, 44)];
    UIImage *image = [UIImage imageNamed:@"bottomBar.png"];
    myToolbar.tintColor = [UIColor colorWithRed:57.0 / 255.0 green:54.0 / 255.0 blue:49.0 / 255.0 alpha:1.0];
    //myToolbar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"kTabBar.png"]];

    [myToolbar setBackgroundImage:image forToolbarPosition:0 barMetrics:0];
/*
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(backButtonTapped:)];
    
    [myToolbar setItems:[NSArray arrayWithObjects:infoButton,nil]];
*/    
    [self.view addSubview:myToolbar];
    //抽屜button
    UIImage *revealButtonUpImage = [UIImage imageNamed:@"menu_icon_3.png"];
    UIImage *revealButtonDownImage = [UIImage imageNamed:@"menu_icon_3_d.png"];
    UIButton *revealButton = [UIButton buttonWithType:UIButtonTypeCustom];
    revealButton.frame = CGRectMake(10.0, self.view.frame.size.height-48, revealButtonUpImage.size.width,revealButtonUpImage.size.height);
    [revealButton setBackgroundImage:revealButtonUpImage
                            forState:UIControlStateNormal];
    [revealButton setBackgroundImage:revealButtonDownImage
                            forState:UIControlStateHighlighted];
    [revealButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [revealButton setTitle:@"返回" forState:UIControlStateNormal];
    [revealButton addTarget:self action:@selector(backButtonTapped:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:revealButton];

    
    //帳號設定屜button
    UIImage *accountButtonUpImage = [UIImage imageNamed:@"menu_icon_3.png"];
    UIImage *accountButtonDownImage = [UIImage imageNamed:@"menu_icon_3_d.png"];
    UIButton *accountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    accountButton.frame = CGRectMake(250.0, self.view.frame.size.height-48, accountButtonUpImage.size.width,
                                     accountButtonUpImage.size.height);
    [accountButton setBackgroundImage:accountButtonUpImage
                             forState:UIControlStateNormal];
    [accountButton setBackgroundImage:accountButtonDownImage
                             forState:UIControlStateHighlighted];
    [accountButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [accountButton setTitle:@"設定" forState:UIControlStateNormal];
    //[accountButton addTarget:self action:@selector(settingButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:accountButton];

    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.sampleItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NSString *cellIdentifier = @"SampleCell";
        UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //第一行留白
        cell.textLabel.text = NULL;
        //cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        return cell;
    }
    
    NSString *cellIdentifier = @"SampleCell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    
    cell.textLabel.text = [self.sampleItems objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     if (indexPath.row == 0) {
     
     NSString *identifier =@"SongList";
     UIViewController *singViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
     
     [self.navigationController pushViewController:singViewController animated:YES];
     }else{
     
     NSString *identifier =@"OthersSong";
     UIViewController *singViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
     
     [self.navigationController pushViewController:singViewController animated:YES];
     }
     
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button1Tapped:(id)sender
{
    [parallaxView setforegroundView:tableView];
    /*
     UIAlertView *alert = [[UIAlertView alloc]
     initWithTitle:@"系統"
     message:@"點擊了按鈕"
     delegate:nil
     cancelButtonTitle:@"知道了"
     otherButtonTitles:nil];
     [alert show];
     */
    
}

- (IBAction)button2Tapped:(id)sender
{
    [parallaxView setforegroundView:tableView];
    /*
     UIAlertView *alert = [[UIAlertView alloc]
     initWithTitle:@"系統"
     message:@"點擊了按鈕"
     delegate:nil
     cancelButtonTitle:@"知道了"
     otherButtonTitles:nil];
     [alert show];
     */
    
}

- (IBAction)button3Tapped:(id)sender
{
    [parallaxView setforegroundView:detailView];
    /*
     UIAlertView *alert = [[UIAlertView alloc]
     initWithTitle:@"系統"
     message:@"點擊了按鈕"
     delegate:nil
     cancelButtonTitle:@"知道了"
     otherButtonTitles:nil];
     [alert show];
     */
    
}

- (IBAction)backButtonTapped:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)settingTapped:(id)sender {
    
    NSString *identifier =@"MyInfomation";
    UIViewController *infoViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
	infoViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
	[self presentModalViewController:infoViewController animated:YES];;
}

@end
