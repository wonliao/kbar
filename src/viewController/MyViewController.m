//
//  MyViewController.h.m
//  myFans
//
//  Created by wonliao on 13/1/16.
//  Copyright (c) 2013年 wonliao. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

#import "MyViewController.h"
#import "AppDelegate.h" // 為了取得應用程式的代理物件參照
#import "FBCoreData.h"

#import <QuartzCore/QuartzCore.h>

@implementation MyViewController

@synthesize labelFirstName = _labelFirstName;
@synthesize operationQueue;
@synthesize fbUID;
@synthesize snapshotStackView = m_snapshotStackView;

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
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    self.slidingViewController.underRightViewController = nil;
    self.slidingViewController.anchorLeftPeekAmount     = 0;
    self.slidingViewController.anchorLeftRevealAmount   = 0;
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    // 取得應用程式的代理物件參照
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FBLoginView *loginview = [appDelegate getLoginview];
    //loginview.frame = (CGRect){ { 80, 55 }, loginview.frame.size};
    loginview.delegate = self;
    //[self.view addSubview:loginview];
    //[loginview sizeToFit];
    
    //下方toolBar button
    //抽屜button
    UIImage *revealButtonUpImage = [UIImage imageNamed:@"menu_icon_2.png"];
    UIImage *revealButtonDownImage = [UIImage imageNamed:@"menu_icon_2_d.png"];
    UIButton *revealButton = [UIButton buttonWithType:UIButtonTypeCustom];
    revealButton.frame = CGRectMake(10.0, self.view.frame.size.height-48, revealButtonUpImage.size.width,
                                    revealButtonUpImage.size.height);
    [revealButton setBackgroundImage:revealButtonUpImage
                            forState:UIControlStateNormal];
    [revealButton setBackgroundImage:revealButtonDownImage
                            forState:UIControlStateHighlighted];
    [revealButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    //[button setTitle:@"演唱" forState:UIControlStateNormal];
    [revealButton addTarget:self action:@selector(revealMenu:)
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
    [accountButton setTitle:@"帳號" forState:UIControlStateNormal];
    [accountButton addTarget:self action:@selector(accountButtonTapped:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:accountButton];

    
    //k歌button
    UIImage *buttonUpImage3 = [UIImage imageNamed:@"kButton.png"];
    UIImage *buttonDownImage3 = [UIImage imageNamed:@"kButton_d.png"];
    UIButton *singButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //singButton.frame = CGRectMake(130.0, 364.0, buttonUpImage3.size.width,buttonUpImage3.size.height);
    singButton.frame = CGRectMake(130.0, self.view.frame.size.height-52, buttonUpImage3.size.width/2,buttonUpImage3.size.height/2);

    [singButton setBackgroundImage:buttonUpImage3
                          forState:UIControlStateNormal];
    [singButton setBackgroundImage:buttonDownImage3
                          forState:UIControlStateHighlighted];
    [singButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    //[button3 setTitle:@"附近" forState:UIControlStateNormal];
    [singButton addTarget:self action:@selector(singButtonTapped:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:singButton];
}

- (void)viewDidUnload {
    self.labelFirstName = nil;
    //self.profilePic = nil;
    [super viewDidUnload];
}

#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    // first get the buttons set for login mode
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    // here we use helper properties of FBGraphUser to dot-through to first_name and
    // id properties of the json response from the server; alternatively we could use
    // NSDictionary methods such as objectForKey to get values from the my json object
    self.labelFirstName.text = [NSString stringWithFormat:@"%@", user.first_name];
    // setting the profileID property of the FBProfilePictureView instance
    // causes the control to fetch and display the profile picture for the user
    //self.profilePic.profileID = user.id;
    
    
    // 取得 facebook 資料
    NSLog(@"myViewfbUID(%@)", user.id);               // fbuid
    NSLog(@"myViewfbName(%@)", user.name);            // 名稱
    NSLog(@"myViewfbPlace(%@)", user.location.name);  // 位置
    NSLog(@"myViewfbLink(%@)", user.link);            // fb 個人網頁連結
    
    FBCoreData *fbCoreData = [[FBCoreData alloc] init];
    fbCoreData.fbUID = user.id;                 // fbuid
    fbCoreData.fbName = user.name;              // 名稱
    fbCoreData.fbPlace = user.location.name;    // 位置
    fbCoreData.fbLink = user.link;              // fb 個人網頁連結
    [fbCoreData save];

    fbUID = user.id;

    //Document
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"FB_%@.jpg", fbUID];
    
    // 檢查圖檔是否已暫存
    NSString* imgFile = [documentsPath stringByAppendingPathComponent:fileName];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:imgFile];
    if( fileExists == YES ) {

        // 將已存在的 document 中圖檔寫入 UIImage
        //imageView.image = [UIImage imageWithContentsOfFile:imgFile];
        m_snapshotStackView.image = [UIImage imageWithContentsOfFile:imgFile];
        NSLog(@"檔案已存在");
    } else {

        // UIImage 先使用預設檔案
        //imageView.image = [UIImage imageNamed:@"people.png"];
        m_snapshotStackView.image =[UIImage imageNamed:@"people.png"];

        // 加入 loading 圖示
        //UIImageView* animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.frame.size.width/2-16, imageView.frame.size.height/2-16, 32, 32)];
        UIImageView* animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(m_snapshotStackView.frame.size.width/2-16, m_snapshotStackView.frame.size.height/2-16, 32, 32)];
        
        animatedImageView.animationImages = [[NSArray alloc] initWithObjects:
                                             [UIImage imageNamed:@"loading1.png"],
                                             [UIImage imageNamed:@"loading2.png"],
                                             [UIImage imageNamed:@"loading3.png"],
                                             [UIImage imageNamed:@"loading4.png"],
                                             [UIImage imageNamed:@"loading5.png"],
                                             [UIImage imageNamed:@"loading6.png"],
                                             [UIImage imageNamed:@"loading7.png"],
                                             [UIImage imageNamed:@"loading8.png"],
                                             [UIImage imageNamed:@"loading9.png"],
                                             [UIImage imageNamed:@"loading10.png"],
                                             [UIImage imageNamed:@"loading11.png"],
                                             [UIImage imageNamed:@"loading12.png"],
                                             nil];
        animatedImageView.animationDuration = 2.0f;
        animatedImageView.animationRepeatCount = 0;
        [animatedImageView startAnimating];
        //[imageView addSubview: animatedImageView];
        [m_snapshotStackView addSubview: animatedImageView];

        // 從 wordpress 下載圖檔
        NSString *imgURL = [NSString stringWithFormat:@"http://54.200.150.53/kbar/wp-content/uploads/photos/%@", fileName];
        UIImageFromURL2( [NSURL URLWithString:imgURL], ^( UIImage * image )
                       {
                           // 清除圖像下載 loading 圖
                           NSArray* subviews = [[NSArray alloc] initWithArray: m_snapshotStackView.subviews];
                           for (UIView* view in subviews) {
                               if ([view isKindOfClass:[UIImageView class]]) {
                                   [view removeFromSuperview];
                               }
                           }
                           
                           // UIImage 使用下載的圖檔
                           //imageView.image = image;
                           m_snapshotStackView.image = image;
                           
                           //將圖片存到 documents 目錄中
                           NSString *uniquePath=[documentsPath stringByAppendingPathComponent:fileName];
                           [UIImagePNGRepresentation(image)writeToFile:uniquePath atomically:YES];
                       }, ^(void){
                           
                           NSLog(@"UIImageFromURL2 error!");
                       });
        //NSLog(@"檔案不存在");
    }
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    //self.profilePic.profileID = nil;
    self.labelFirstName.text = nil;
}

// 取得相簿
- (IBAction)getImagefromLibrary:(id)sender
{
    UIMenuBarItem *menuItem1 = [[UIMenuBarItem alloc] initWithTitle:@"上傳照片" target:self image:[UIImage imageNamed:@"5_content_copy.png"]  action:@selector(openImageAlbum:)];
    UIMenuBarItem *menuItem2 = [[UIMenuBarItem alloc] initWithTitle:@"編輯照片" target:self image:[UIImage imageNamed:@"5_content_save.png"]  action:@selector(clickAction:)];
    UIMenuBarItem *menuItem3 = [[UIMenuBarItem alloc] initWithTitle:@"取消" target:self image:[UIImage imageNamed:@"5_content_discard.png"]  action:@selector(clickAction:)];

    NSMutableArray *items = [NSMutableArray arrayWithObjects:menuItem1, menuItem2, menuItem3,nil];
 
    menuBar = [[UIMenuBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 240.0f) items:items];
    //menuBar.layer.borderWidth = 1.f;
    //menuBar.layer.borderColor = [[UIColor orangeColor] CGColor];
    //menuBar.tintColor = [UIColor orangeColor];
    menuBar.delegate = self;

    menuBar.items = [NSMutableArray arrayWithObjects:menuItem1, menuItem2, menuItem3,nil];

    [menuBar show];
}

- (void)openImageAlbum:(id)sender
{
    [menuBar dismiss];
}

- (void)clickAction:(id)sender
{
    [menuBar dismiss];
}

// 圖片異步下載
void UIImageFromURL2( NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) )
{
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                   {
                       NSData * data = [[NSData alloc] initWithContentsOfURL:URL];
                       UIImage * image = [[UIImage alloc] initWithData:data];
                       dispatch_async( dispatch_get_main_queue(), ^(void){
                           if( image != nil )
                           {
                               imageBlock( image );
                           } else {
                               errorBlock();
                           }
                       });
                   });
}

- (IBAction)singButtonTapped:(id)sender
{
    NSString *identifier =@"NaviSongMenu";
    UIViewController *NaviSongMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
	NaviSongMenuViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
	[self presentModalViewController:NaviSongMenuViewController animated:YES];
}
- (IBAction)accountButtonTapped:(id)sender
{
    NSString *identifier =@"LoginTop2";
    UIViewController *accountViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
	accountViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
	[self presentModalViewController:accountViewController animated:YES];
}



@end
