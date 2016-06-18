//
//  HomeViewController.m
//  myFans
//
//  Created by wonliao on 13/1/16.
//  Copyright (c) 2013年 wonliao. All rights reserved.
//
#import "HomeViewController.h"
#import "AsyncImageView.h"
#import "HomePageData.h"  // 首頁的資料庫互動類別
#import "WpHomepageData.h"  // wordpress的首頁資料格式
#import "RecordSongList.h"  // 可錄歌曲列表的資料庫互動類別
#import "AsyncImageView2.h"
#import "LoginAPI.h"
#import "UserListAPI.h"
#import "UserInfo.h"


#define NUMBER_OF_COLUMNS 3
#define kMosaicDataViewFont @"Helvetica-Bold"

@implementation HomeViewController

@synthesize segment_title;
@synthesize singButton;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 取得應用程式的代理物件參照
    m_coreData = [[CoreData alloc] init];

    m_currentData = [NSMutableArray array];
    m_page1 = [NSMutableArray array];
    m_page2 = [NSMutableArray array];
    m_page3 = [NSMutableArray array];

    // 先使用暫存的首頁資料
    [self useTempHomepageData];

    // 取得 wordpress 上的首頁資料
    [self getHomepageDataFromWordpress];

    // 取得錄歌清單
    [self getRecordSongList];

    [self.slidingViewController setAnchorRightRevealAmount:280.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;

    NSArray *segmentTextContent = [NSArray arrayWithObjects:
                                   @"北區榜",
                                   @"全國榜",
                                   @"新星榜",
                                   nil];
    self.segment_title = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
    //UIFont *font = [UIFont boldSystemFontOfSize:16.0f];
    //NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
    //                                                       forKey:UITextAttributeFont];

    //[self.segment_title setTitleTextAttributes:attributes
    //                                  forState:UIControlStateNormal];
    self.segment_title.selectedSegmentIndex = 0;
    self.segment_title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //self.segment_title.segmentedControlStyle = UISegmentedControlStyleBar;
    self.segment_title.frame = CGRectMake(m_tableView.frame.origin.x, m_tableView.frame.origin.y, m_tableView.frame.size.width, 40);
    [self.segment_title addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.segment_title setAlpha:0.9];
    //[self.segment_title setTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    [self.view addSubview:self.segment_title];

    //k歌button
    UIImage *buttonUpImage3 = [UIImage imageNamed:@"kbar_Icon_57x57.png"];
    UIImage *buttonDownImage3 = [UIImage imageNamed:@"kbar_Icon_57x57.png"];
    singButton = [UIButton buttonWithType:UIButtonTypeCustom];
    singButton.frame = CGRectMake(m_tableView.frame.size.width/2 - buttonUpImage3.size.width/2,
                                  self.view.frame.size.height - buttonUpImage3.size.height - 5,
                                  buttonUpImage3.size.width,
                                  buttonUpImage3.size.height);
    [singButton setBackgroundImage:buttonUpImage3
                          forState:UIControlStateNormal];
    [singButton setBackgroundImage:buttonDownImage3
                          forState:UIControlStateHighlighted];
    [singButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    //[button3 setTitle:@"附近" forState:UIControlStateNormal];
    [singButton addTarget:self action:@selector(singButtonTapped:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:singButton];
    
    LoginAPI *loginAPI = [[LoginAPI alloc] init];
    [loginAPI setSucceededCallback: ^{
        NSLog(@"%@", @"LoginAPI Succeeded!");
        UserListAPI *testAPI = [[UserListAPI alloc] init];
        UserListAPI * __weak blockAPI = testAPI;
        [testAPI setSucceededCallback: ^{
            for (UserInfo* info in [blockAPI userList]) {
                NSLog(@"name: %@", [info nickname]);
            }
            NSLog(@"%@", @"UserListAPI Succeeded!");
        }];
        [testAPI fetchFollowerListByUserId:@"123"];
    }];
    [loginAPI loginWithAccount:@"test" password:@"test"];

}

- (void)segmentAction:(id)sender
{
    switch (self.segment_title.selectedSegmentIndex) {
        case 0:
            [self setCurrentData:m_page1];
            break;
        case 1:
            [self setCurrentData:m_page2];
            break;
        case 2:
            [self setCurrentData:m_page3];
            break;
    }

    [m_tableView reloadData];
    [m_tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.segment_title = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [m_tableView reloadData];

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

    //初始右側下一層View
    if (![self.slidingViewController.underRightViewController isKindOfClass:[UnderRightViewController class]]) {

        self.slidingViewController.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NeighborTop"];
    }

    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

#pragma mark - MosaicViewDelegateProtocol

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)singButtonTapped:(id)sender
{
    NSString *identifier =@"NaviSongMenu";
    UIViewController *singViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];

	singViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

	[self presentModalViewController:singViewController animated:YES];
}

- (IBAction)neighborButtonTapped:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECLeft];
}

// 新增資料庫管理物件準備寫入
- (void) addPlayingData:(NSString *)post_id WithTitle:(NSString *)title AndImageFileName:(NSString *)imageFilename AndFBImageFileName:(NSString *)fbImageFilename AndName:(NSString *)name
{
    NSLog(@"新增資料庫管理物件準備寫入");

    [m_coreData addDataToPlaying:post_id WithTitle:title AndImageFileName:imageFilename AndFBImageFileName:fbImageFilename AndName:name];
}

-(void) getRecordSongList
{
    NSString *query = [NSString stringWithFormat:@"records.php"];
    [m_wordpress queryWordpress:query completion:^(NSArray *parsedElements) {

        if( [parsedElements count] > 0 ) {

            NSMutableArray* returnObjs = [m_coreData loadDataFromRecordSongList];

            for (NSDictionary *aModuleDict in parsedElements) {

                NSString *postTitle = [aModuleDict objectForKey:@"POST_TITLE"];

                BOOL check = NO;
                for( RecordSongList* recordSongList in returnObjs ) {

                    if([recordSongList.name isEqualToString:postTitle]) {

                        check = YES;
                        break;
                    }
                }

                if( check == NO ) {

                    [m_coreData addDataToRecordSongList:postTitle];
                }
            }
        }
    }];
}

// 取得 wordpress 上的首頁資料
-(void) getHomepageDataFromWordpress
{
    // 先清除暫存用的首頁資料，讓之後更新
    [m_coreData clearHomePageData];
    
    // document 目錄路徑
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    // 初始化 wordpress
    m_wordpress = [[wordpress alloc] init];

    // 三個榜單
    for(int i=0; i<=2; i++) {

        NSString *query = [NSString stringWithFormat:@"homepage.php?area=%d", i];
        [m_wordpress queryWordpress:query completion:^(NSArray *parsedElements){

            // 異步下載，等待回傳資料
            if( [parsedElements count] > 0 ) {

                int counter = 0;
                for (NSDictionary *aModuleDict in parsedElements) {

                    WpHomepageData* wpHomepageData = [[WpHomepageData alloc] initWithDictionary:aModuleDict];

                    counter++;

                    NSString *post_id = wpHomepageData.post_id;
                    NSString *imageFilename = @"";
                    NSString *size = @"";
                    NSString *title = wpHomepageData.post_title;
                    NSString *fbImageFilename = wpHomepageData.singer_uid;
                    NSString *name = wpHomepageData.singer_name;
                    NSString *fileName = [NSString stringWithFormat:@"FB_%@.jpg", fbImageFilename];
                    NSString *imgURL = [NSString stringWithFormat:@"http://54.200.150.53/kbar/wp-content/uploads/photos/%@", fileName];
                    NSString *keyName = @"";
                    switch (counter) {
                        case 1:     keyName = [NSString stringWithFormat:@"%d_No1", i];      break;
                        case 2:     keyName = [NSString stringWithFormat:@"%d_No2", i];      break;
                        case 3:     keyName = [NSString stringWithFormat:@"%d_No3", i];      break;
                        default:    keyName = fileName;    break;
                    }

                    [self setData:i
                      WithCounter:counter
                 AndDocumentsPath:documentsPath
                      AndFileName:fileName
                        AndPostId:post_id
               AndFbImageFilename:fbImageFilename
                        AndImgURL:imgURL
                          AndName:name
                       AndKeyName:keyName
                         AndTitle:title
                     //AndSize:size
                 AndImageFilename:imageFilename];
                    
                    // 存入資料庫，當成首頁的暫用資料
                    if( i == 0 ) {

                        [m_coreData addDataToHomePageData:[NSString stringWithFormat:@"%d",i] WithPostId:post_id AndFbImageFilename:fbImageFilename AndImgURL:imgURL AndName:name AndKeyName:keyName AndTitle:title AndSize:size AndImageFilename:imageFilename];
                    }
                }

                // 顯示第一個榜單
                if( i == 0 ) {

                    // 重繪首頁
                    [self setCurrentData:m_page1];
                    [m_tableView reloadData];
                }
            }
        }];
    }
}

-(void)setCurrentData:(NSMutableArray *)_array
{
    [m_currentData removeAllObjects];
    [m_currentData addObjectsFromArray:_array];
    NSLog(@"self.m_currentData count(%d)", [m_currentData count]);
}

-(void) setData:(int)area
    WithCounter:(int)counter
AndDocumentsPath:(NSString *)documentsPath
    AndFileName:(NSString *)fileName
      AndPostId:(NSString *)post_id
AndFbImageFilename:(NSString *)fbImageFilename
      AndImgURL:(NSString *)imgURL
        AndName:(NSString *)name
     AndKeyName:(NSString *)keyName
       AndTitle:(NSString *)title
        //AndSize:(NSString *)size
AndImageFilename:(NSString *)imageFilename
{
    int i = area;

    NSString *size = @"3";
    if( counter == 0 ) size = @"0";
    else if( counter == 1 || counter == 2 ) size = @"1";

    NSMutableArray *temp = [[NSMutableArray alloc] init];
    [temp addObject:fbImageFilename];   // 0
    [temp addObject:imgURL];            // 1
    [temp addObject:name];              // 2
    [temp addObject:keyName];           // 3
    [temp addObject:title];             // 4
    [temp addObject:size];              // 5
    [temp addObject:post_id];           // 6
    [temp addObject:imageFilename];     // 7
    [temp addObject:[NSString stringWithFormat:@"%d",counter]];           // 8

    switch(i) {
    case 0: [m_page1 addObject:temp];  break;
    case 1: [m_page2 addObject:temp];  break;
    case 2: [m_page3 addObject:temp];  break;
    }
}


- (UIFont *)fontWithModuleSize:(NSUInteger)aSize
{    
    UIFont *retVal = nil;
    //顯示的字體大小
    switch (aSize) {
        case 0:
            retVal = [UIFont fontWithName:kMosaicDataViewFont size:18];
            break;
        case 1:
        case 2:
            retVal = [UIFont fontWithName:kMosaicDataViewFont size:15];
            break;
        default:
            retVal = [UIFont fontWithName:kMosaicDataViewFont size:13];
            break;
    }

    return retVal;
}

- (void)useTempHomepageData
{
    int i=0;
    if( [m_coreData checkHomePageData:[NSString stringWithFormat:@"%d",i]] == YES ) {

        // document 目錄路徑
        NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

        int counter = 0;
        NSMutableArray* returnObjs = [m_coreData loadDataFromHomePageData];
        if( [returnObjs count] > 0 ) {

            for( HomePageData* homePageData in returnObjs ) {

                if( [homePageData.area isEqualToString:[NSString stringWithFormat:@"%d", i]] ) {

                    counter++;

                    NSString *fbImageFilename = homePageData.fbImageFilename;
                    NSString *imgURL = homePageData.imgURL;
                    NSString *name = homePageData.name;
                    NSString *keyName = homePageData.keyName;
                    NSString *title = homePageData.title;
                    //NSString *size = homePageData.size;
                    NSString *post_id = homePageData.post_id;
                    NSString *imageFilename = homePageData.imageFilename;
                    NSString *fileName = [NSString stringWithFormat:@"FB_%@.jpg", fbImageFilename];

                    [self setData:i
                      WithCounter:counter
                 AndDocumentsPath:documentsPath
                      AndFileName:fileName
                        AndPostId:post_id
               AndFbImageFilename:fbImageFilename
                        AndImgURL:imgURL
                          AndName:name
                       AndKeyName:keyName
                         AndTitle:title
                     //AndSize:size
                 AndImageFilename:imageFilename];
                }
            }

            // 重繪首頁
            [self setCurrentData:m_page1];
            [m_tableView reloadData];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([m_currentData count] > 0) {
    
        NSInteger _count = floor(([m_currentData count]-3) / 3);
        NSLog(@"table numberOfRowsInSection(%d)(%d)", _count, [m_currentData count]);
        
        return _count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // 清除 cell 所加的東西
    //[[cell subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    float w, h;
    int num = 0;
    if(indexPath.row == 0 ) {

        num = 1;
        w = 320.0f;
        h = 240.0f;
    } else if(indexPath.row == 1) {

        num = 2;
        w = 160.0f;
        h = 120.0f;
    } else {

        num = 3;
        w = 106.0f;
        h = 106.0f;
    }

    // cell 加上 button
    for(int i=0; i<num; i++){

        int index = 0;
        if( num == 1)       index = 0;
        else if( num == 2)  index = i+1;
        else                index = (indexPath.row - 1) * num + i;

        NSString *imageFilename = [m_currentData objectAtIndex:index][1];
        NSURL *imgURL = [NSURL URLWithString:imageFilename];

        NSLog(@"index(%d) = row(%d) num(%d) i(%d) img(%@)", index, indexPath.row,  num, i, imageFilename);
        float x = w * i;
        float y = 0.0f;

        UIButton *_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(x, y, w, h);
        _btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;  // 使圖片符合 frame 大小
        _btn.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;      // 使圖片符合 frame 大小
        _btn.imageView.contentMode = UIViewContentModeScaleAspectFill;              // 設定view置中
        _btn.imageView.layer.borderColor = [[UIColor blackColor] CGColor];          // 設定view框線
        _btn.imageView.layer.borderWidth = 1;                                       // 設定view框線寬度
        _btn.imageView.layer.masksToBounds = YES;
        _btn.imageView.clipsToBounds = YES;
        _btn.imageView.imageURL = imgURL;
        _btn.tag = 1000 + index;
      
        [_btn setBackgroundColor:[UIColor yellowColor]];
        [_btn setImage: [UIImage imageNamed:@"blank.png"] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];    // 點擊
        [cell addSubview:_btn];
        
        
        // 定位用
        NSInteger marginLeft = w / 40;
        UIFont *font = [self fontWithModuleSize:[[m_currentData objectAtIndex:index][5] intValue]];
        float fontH = (font.xHeight * 2);

        // 歌名
        [self setTitleLabel:[m_currentData objectAtIndex:index][4] on:_btn index:index at:CGRectMake(marginLeft, h-(fontH*2)-5, w, fontH)];
        
        //  用戶名
        [self setTitleLabel:[m_currentData objectAtIndex:index][2] on:_btn index:index at:CGRectMake(marginLeft, h-fontH-5, w, fontH)];
        
        /*
        // 歌名
        NSInteger marginLeft = width / 40;
        CGRect titleLabelFrame = CGRectMake(0,
                                            round(height/2),
                                            width,
                                            round(height/2));
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont fontWithName:kMosaicDataViewFont size:15];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.shadowColor = [UIColor blackColor];
        titleLabel.shadowOffset = CGSizeMake(0, 1);
        titleLabel.numberOfLines = 1;
        titleLabel.text = [m_currentData objectAtIndex:index][4];
        titleLabel.font =  [self fontWithModuleSize:[[m_currentData objectAtIndex:index][5] intValue]];
        CGSize newSize = [[m_currentData objectAtIndex:index][4] sizeWithFont:titleLabel.font constrainedToSize:titleLabel.frame.size];
        CGRect newRect = CGRectMake(marginLeft,
                                    height - newSize.height -(titleLabel.font.xHeight)*2,
                                    newSize.width,
                                    newSize.height);
        titleLabel.frame = newRect;
        
        [imageView addSubview:titleLabel];


        //  用戶名
        CGRect usernameLabelFrame = CGRectMake(0,
                                               round(h/2),
                                               w,
                                               round(h/2));
        UILabel *usernameLabel = [[UILabel alloc] initWithFrame:usernameLabelFrame];
        usernameLabel.textAlignment = NSTextAlignmentLeft;
        usernameLabel.backgroundColor = [UIColor clearColor];
        usernameLabel.font = [UIFont fontWithName:kMosaicDataViewFont size:10];
        usernameLabel.textColor = [UIColor whiteColor];
        usernameLabel.shadowColor = [UIColor blackColor];
        usernameLabel.shadowOffset = CGSizeMake(0, 1);
        usernameLabel.numberOfLines = 1;
        usernameLabel.text = [m_currentData objectAtIndex:index][2];
        usernameLabel.font =  [self fontWithModuleSize:[[m_currentData objectAtIndex:index][5] intValue]];
        usernameLabel.adjustsFontSizeToFitWidth=5;
        CGSize newSize2 = [[m_currentData objectAtIndex:index][2] sizeWithFont:usernameLabel.font constrainedToSize:usernameLabel.frame.size];
        CGRect newRect2 = CGRectMake(marginLeft+2,
                                     h - newSize2.height ,
                                     newSize2.width-5,
                                     newSize2.height-5);
        usernameLabel.frame = newRect2;
        [_btn.imageView addSubview:usernameLabel];
        
        //  聽過人數
        CGRect listenedLabelFrame = CGRectMake(0,
                                               round(h/2),
                                               w,
                                               round(h/2));
        UILabel *listenedLabel = [[UILabel alloc] initWithFrame:listenedLabelFrame];
        listenedLabel.textAlignment = NSTextAlignmentRight;
        listenedLabel.backgroundColor = [UIColor clearColor];
        listenedLabel.font = [UIFont fontWithName:kMosaicDataViewFont size:10];
        listenedLabel.textColor = [UIColor whiteColor];
        listenedLabel.shadowColor = [UIColor blackColor];
        listenedLabel.shadowOffset = CGSizeMake(0, 1);
        listenedLabel.numberOfLines = 1;
        listenedLabel.text = @"4499人";
        listenedLabel.font = [UIFont systemFontOfSize:14];
        CGSize newSize3 = [listenedLabel.text sizeWithFont:listenedLabel.font constrainedToSize:listenedLabel.frame.size];
        CGRect newRect3 = CGRectMake(320-newSize3.width-5,
                                     25 ,
                                     newSize3.width,
                                     newSize3.height);
        listenedLabel.frame = newRect3;
        [_btn.imageView addSubview:listenedLabel];
        
        //  花朵數
        CGRect flowersLabelFrame = CGRectMake(0,
                                              round(h/2),
                                              w,
                                              round(h/2));
        UILabel *flowersLabel = [[UILabel alloc] initWithFrame:flowersLabelFrame];
        flowersLabel.textAlignment = NSTextAlignmentRight;
        flowersLabel.backgroundColor = [UIColor clearColor];
        flowersLabel.font = [UIFont fontWithName:kMosaicDataViewFont size:10];
        flowersLabel.textColor = [UIColor whiteColor];
        flowersLabel.shadowColor = [UIColor blackColor];
        flowersLabel.shadowOffset = CGSizeMake(0, 1);
        flowersLabel.numberOfLines = 1;
        flowersLabel.text = @"13388朵";
        flowersLabel.font = [UIFont systemFontOfSize:14];
        CGSize newSize4 = [flowersLabel.text sizeWithFont:flowersLabel.font constrainedToSize:flowersLabel.frame.size];
        CGRect newRect4 = CGRectMake(320-newSize4.width-5,
                                     5 ,
                                     newSize4.width,
                                     newSize4.height);
        flowersLabel.frame = newRect4;
        [_btn.imageView addSubview:flowersLabel];
        
        //鮮花及耳機小icon
        UIImageView *flowersImgView = [[UIImageView alloc] initWithFrame:CGRectMake(320-newSize4.width-21, 6, 15, 15)];
        flowersImgView.image = [UIImage imageNamed:@"bunch_flowers_white.png"];
        [_btn.imageView addSubview:flowersImgView];
        
        UIImageView *headphoneImgView = [[UIImageView alloc] initWithFrame:CGRectMake(320-newSize3.width-23, 26, 14, 14)];
        headphoneImgView.image = [UIImage imageNamed:@"headphones_white.png"];
        [_btn.imageView addSubview:headphoneImgView];
        
        UIImageView *numberOneImgView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 1, 20, 20)];
        numberOneImgView.image = [UIImage imageNamed:@"crown.png"];
        [_btn.imageView addSubview:numberOneImgView];
*/
    }

    return cell;
}

-(void)setTitleLabel:text on:(UIButton *)_btn index:(int)index at:(CGRect)titleLabelFrame
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.numberOfLines = 1;
    titleLabel.text = text;
    titleLabel.font =  [self fontWithModuleSize:[[m_currentData objectAtIndex:index][5] intValue]];
    [_btn.imageView addSubview:titleLabel];
}

- (CGFloat)tableView:(UITableView *)t heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0 ) {

        return 240.0f;
    } else if(indexPath.row == 1) {

        return 120.0f;
    }

    return 106.0f;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    m_scrollEnd = scrollView.contentOffset;
    
    if( m_scrollEnd.y > m_scrollStart.y ) {
        
        [self showFloatUI:NO];
    } else {
        
        [self showFloatUI:YES];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    m_scrollStart = scrollView.contentOffset;
}

- (void)showFloatUI:(BOOL)_show
{
    if( _show == YES ) {
        
        [UIView animateWithDuration:0.3 // sec
                         animations:^{
                             //self.segment_title.alpha = 0.9f;
                             //self.singButton.alpha = 1.0f;

                             self.segment_title.frame = CGRectMake(m_tableView.frame.origin.x,
                                                                   m_tableView.frame.origin.y,
                                                                   m_tableView.frame.size.width,
                                                                   40);
                             self.singButton.frame = CGRectMake(m_tableView.frame.size.width/2 - 57/2,
                                                           self.view.frame.size.height - 57 - 5,
                                                           57,
                                                           57);
                         } completion:^(BOOL finished) {
                             NSLog(@"done");
                         }];
    } else {
        
        [UIView animateWithDuration:0.3 // sec
                         animations:^{
                             //self.segment_title.alpha = 0.0f;
                             //self.singButton.alpha = 0.0f;

                             self.segment_title.frame = CGRectMake(m_tableView.frame.origin.x,
                                                                   m_tableView.frame.origin.y -100,
                                                                   m_tableView.frame.size.width,
                                                                   40);
                             self.singButton.frame = CGRectMake(m_tableView.frame.size.width/2 - 57/2,
                                                                m_tableView.frame.size.height + 100,
                                                                57,
                                                                57);
                         } completion:^(BOOL finished) {
                             NSLog(@"done");
                         }];
    }
}

- (void)btnAction:(id)sender
{
    UIButton* _btn = (UIButton*)sender;
    int index = _btn.tag - 1000;
    NSLog(@"tag(%d) index(%d)", _btn.tag, index);
    
    
    NSString *fbImageFilename = [m_currentData objectAtIndex:index][0];
    //NSString *imgURL = [m_currentData objectAtIndex:index][1];
    NSString *name = [m_currentData objectAtIndex:index][2];
    //NSString *keyName = [m_currentData objectAtIndex:index][3];
    NSString *title = [m_currentData objectAtIndex:index][4];
    //NSString *size = [m_currentData objectAtIndex:index][5];
    NSString *post_id = [m_currentData objectAtIndex:index][6];
    NSString *imageFilename = [m_currentData objectAtIndex:index][7];
    
    NSLog(@"post_id(%@) title(%@) imageFilename(%@) fbImageFilename(%@)", post_id, title, imageFilename, fbImageFilename);
    [self addPlayingData:post_id WithTitle:title AndImageFileName:imageFilename AndFBImageFileName:fbImageFilename AndName:name];
    
    NSString *identifier =@"PlaySong";
    UIViewController *singViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
	singViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentModalViewController:singViewController animated:YES];
}


@end
