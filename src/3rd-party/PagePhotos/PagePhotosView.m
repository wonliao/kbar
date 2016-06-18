//
//  PagePhotosView.m
//  PagePhotosDemo
//
//  Created by junmin liu on 10-8-23.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "PagePhotosView.h"
#import "WpFavoriteData.h"  // wordpress的歌曲關注資料格式
#import "WpFlowerData.h"    // wordpress的歌曲送花資料格式
#import <FacebookSDK/FacebookSDK.h>

#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0];

@interface PagePhotosView (PrivateMethods)

- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;

@end

@implementation PagePhotosView
@synthesize delegate = _delegate;
@synthesize dataSource;
@synthesize imageViews;
@synthesize flowerLabel;
@synthesize m_flowerCount;
@synthesize m_postID;
@synthesize m_followState;
@synthesize followLabel;
@synthesize m_followCount;
@synthesize m_wordpress;


- (id)initWithFrame:(CGRect)frame withDataSource:(id<PagePhotosDataSource>)_dataSource andPostID:(NSString *)postID
{
    if ((self = [super initWithFrame:frame])) {

        self.m_wordpress = [[wordpress alloc] init];

		self.dataSource = _dataSource;
        self.m_postID = postID;

        // Initialization UIScrollView
        //視窗高度
		int pageControlHeight = 20;
		scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height )];

        //控件初始
		pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height - pageControlHeight, frame.size.width, pageControlHeight)];
        pageControl.userInteractionEnabled = NO;

		[self addSubview:scrollView ];
		[self addSubview:pageControl];

		int kNumberOfPages = [_dataSource numberOfPages];

		// in the meantime, load the array with placeholders which will be replaced on demand
		NSMutableArray *views = [[NSMutableArray alloc] init];
		for (unsigned i = 0; i < kNumberOfPages; i++) {

			[views addObject:[NSNull null]];
		}
		self.imageViews = views;

		// a page is the width of the scroll view
		scrollView.pagingEnabled = YES;
		scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
		scrollView.showsHorizontalScrollIndicator = NO;
		scrollView.showsVerticalScrollIndicator = NO;
		scrollView.scrollsToTop = NO;
		scrollView.delegate = self;

		pageControl.numberOfPages = kNumberOfPages;
		pageControl.currentPage = 0;
		pageControl.backgroundColor = [UIColor clearColor];
        pageControl.alpha = 0.6;
        pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        pageControl.pageIndicatorTintColor = [UIColor whiteColor];;

		// pages are created on demand
		// load the visible page
		// load the page on either side to avoid flashes when the user starts scrolling
		[self loadScrollViewWithPage:0];
		[self loadScrollViewWithPage:1];

        //下方圓形按鈕
        UIImage *buttonUpImage = [UIImage imageNamed:@"comment_btn.png"];
        UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        commentButton.frame = CGRectMake(165.0, 2.0, buttonUpImage.size.width+20.0, buttonUpImage.size.height+20.0);
        [commentButton setImage:buttonUpImage forState:UIControlStateNormal];

        [commentButton addTarget:self action:@selector(commentButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:commentButton];

        UIImage *buttonUpImage2 = [UIImage imageNamed:@"tosing_btn.png"];        
        UIButton *toSingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        toSingButton.frame = CGRectMake(380.0, 16.0, buttonUpImage.size.width+20.0, buttonUpImage.size.height+20.0);
        [toSingButton setImage:buttonUpImage2 forState:UIControlStateNormal];

        [toSingButton addTarget:self action:@selector(toSingButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:toSingButton];

        UIImage *buttonUpImage3 = [UIImage imageNamed:@"flower_btn.png"];
        UIButton *flowerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        flowerButton.frame = CGRectMake(84.0, 2.0, buttonUpImage.size.width+20.0, buttonUpImage.size.height+20.0);
        [flowerButton setImage:buttonUpImage3 forState:UIControlStateNormal];

        [flowerButton addTarget:self action:@selector(flowerButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:flowerButton];

        // 花朵數
        m_flowerCount = 0;
        flowerLabel = [[UILabel alloc] initWithFrame: CGRectMake(105.0, 85.0, 100.0, 20.0)];
        flowerLabel.adjustsFontSizeToFitWidth = NO;
        flowerLabel.opaque = NO;
        flowerLabel.backgroundColor = [UIColor clearColor];
        flowerLabel.textColor = HEXCOLOR(0xcca899ff);
        flowerLabel.text = [NSString stringWithFormat:@"%d", m_flowerCount];
        flowerLabel.font = [UIFont systemFontOfSize:15];
        flowerLabel.tag = 1000;
        [scrollView addSubview:flowerLabel];

        UIImage *buttonUpImage4 = [UIImage imageNamed:@"listen_btn.png"];
        UIButton *listenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        listenButton.frame = CGRectMake(503.0, 16.0, buttonUpImage.size.width+20.0,
                                        buttonUpImage.size.height+20.0);
        [listenButton setImage:buttonUpImage4
                                forState:UIControlStateNormal];

        [listenButton addTarget:self action:@selector(listenButtonTapped:)
               forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:listenButton];

        UIImage *buttonUpImage5 = [UIImage imageNamed:@"share_btn.png"];
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        shareButton.frame = CGRectMake(241.0, 29.0, buttonUpImage.size.width+20.0,
                                       buttonUpImage.size.height+20.0);
        [shareButton setImage:buttonUpImage5
                                forState:UIControlStateNormal];

        [shareButton addTarget:self action:@selector(shareButtonTapped:)
               forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:shareButton];

        // 關注
        UIImage *buttonUpImage6 = [UIImage imageNamed:@"follow_btn.png"];
        UIButton *followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        followButton.frame = CGRectMake(6.0, 29.0, buttonUpImage.size.width+20.0,
                                        buttonUpImage.size.height+20.0);
        [followButton setImage:buttonUpImage6
                                forState:UIControlStateNormal];

        [followButton addTarget:self action:@selector(followButtonTapped:)
               forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:followButton];

        // 關注數
        followLabel = [[UILabel alloc] initWithFrame: CGRectMake(20.0, 95.0, 50.0, 40.0)];
        followLabel.adjustsFontSizeToFitWidth = NO;
        followLabel.opaque = NO;
        followLabel.backgroundColor = [UIColor clearColor];
        followLabel.textColor = HEXCOLOR(0xcca899ff);
        followLabel.lineBreakMode = UILineBreakModeWordWrap;
        followLabel.numberOfLines = 0;
        followLabel.textAlignment = UITextAlignmentCenter; //置中
        followLabel.numberOfLines = 0; // 置頂
        followLabel.font = [UIFont systemFontOfSize:15];
        followLabel.tag = 1000;
        [scrollView addSubview:followLabel];

        // 取得 facebook 資料
        m_fbCoreData = [[FBCoreData alloc] init];
        [m_fbCoreData load];
        if( [m_fbCoreData.fbUID isEqual:@""] ) {

            NSLog(@"未登錄facebook!!");
        }

        // 取得關注歌曲狀態
        [self getFavorite];
    }

    return self;
}

// 發表評論
- (IBAction)commentButtonTapped:(id)sender
{
    NSLog(@"commentButtonTapped");

    [self.delegate openComment:self];
}

// 檢查 facebook 登入
- (void)checkFacebook
{
    // 取得 facebook 資料
    //FBCoreData *fbCoreData = [[FBCoreData alloc] init];
    [m_fbCoreData load];

    if( [m_fbCoreData.fbUID isEqual:@""] ) {

        NSLog(@"未登錄facebook!!");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"先登錄" message:@"您需要先登錄k吧才能完成操作" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"登錄",nil];
        [alert show];
    } else {

        NSLog(@"已登錄facebook!!");
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {

        NSLog(@"返回");
    } else if (buttonIndex == 1) {

        NSLog(@"登錄");

        // 呼叫 PlaySongViewController 的 openLoginTop2 函式
        [self.delegate openLoginTop2:self];
    }
}

- (UIViewController*)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {

        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {

            return (UIViewController*)nextResponder;
        }
    }

    return nil;
}

- (IBAction)toSingButtonTapped:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"控制"
                          message:[NSString stringWithFormat:@"我也要唱"]
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)flowerButtonTapped:(id)sender
{
    [m_fbCoreData load];

    if( [m_fbCoreData.fbUID isEqual:@""] ) {

        NSLog(@"未登錄facebook!!");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"先登錄" message:@"您需要先登錄k吧才能完成操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登錄",nil];
        [alert show];
    } else {

        // disable 送花按鈕
        UIButton *buttonThatWasPressed = (UIButton *)sender;
        buttonThatWasPressed.enabled = NO;

        NSString *query = [NSString stringWithFormat:@"flower.php?song_id=%@&uid=FB_%@&method=add", m_postID, m_fbCoreData.fbUID];
        [m_wordpress queryWordpress:query completion:^(NSArray *parsedElements){

            if( [parsedElements count] > 0 ) {

                NSDictionary *aModuleDict = [parsedElements objectAtIndex:0];
                WpFlowerData *wpFlowerData = [[WpFlowerData alloc] initWithDictionary:aModuleDict];

                // 設定花朵數
                self.m_flowerCount = [wpFlowerData.flower_count intValue];
            }
        }];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"Update" object:self];
 
        // 增加花朵數
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(sendFlowerEffect:) userInfo:sender repeats:NO];
    }
}

// 設定花朵數
-(void)setFlower:(int)flower
{
    m_flowerCount = flower;
    [flowerLabel setText:[NSString stringWithFormat:@"%d", m_flowerCount]];
}

// 增加花朵數
- (void) sendFlowerEffect:(NSTimer *)theTimer
{
    // enable 送花按鈕
    UIButton *buttonThatWasPressed = (UIButton *)[theTimer userInfo];
    buttonThatWasPressed.enabled = YES;

    [flowerLabel setText:[NSString stringWithFormat:@"%d", m_flowerCount]];
}

- (IBAction)listenButtonTapped:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"控制"
                          message:[NSString stringWithFormat:@"聽別人唱"]
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)shareButtonTapped:(id)sender
{
    [self postImageToFacebook];
}

-(void) postMessageToFacebook
{
    NSString *name = m_fbCoreData.fbName;
    NSString *message = [NSString stringWithFormat:@"Updating status for %@ at %@",
                         name != nil ? name : @"me" , [NSDate date]];

    [self performPublishAction:^{
        // otherwise fall back on a request for permissions and a direct post
        [FBRequestConnection startForPostStatusUpdate:message
                                    completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                        [self showAlert:message result:result error:error];
                                    }];
    }];
}
 
-(void) postImageToFacebook
{
    // Just use the icon image from the application itself.  A real app would have a more
    // useful way to get an image.
    UIImage *img = [UIImage imageNamed:@"kBar_icon_114x114.png"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://54.200.150.53/kbar/archives/%@", m_postID]];
    NSString *message = [NSString stringWithFormat:@"來聽聽%@唱的《%@》，真是太棒了，試聽網址>>>", m_playerName, m_songName];

    // if it is available to us, we will post using the native dialog
    BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:[self viewController]
                                                                    initialText:message
                                                                          image:img
                                                                            url:url
                                                                        handler:nil];

    if (!displayedNativeDialog) {

        [self performPublishAction:^{

            [FBRequestConnection startForUploadPhoto:img
                                   completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                       [self showAlert:@"Photo Post" result:result error:error];
                                   }];
        }];
    }


}

// UIAlertView helper for post buttons
- (void)showAlert:(NSString *)message result:(id)result error:(NSError *)error
{
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        
        alertMsg = error.localizedDescription;
        alertTitle = @"Error";
    } else {
        
        NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.\nPost ID: %@",
                    message, [resultDict valueForKey:@"id"]];
        alertTitle = @"Success";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (IBAction)followButtonTapped:(id)sender
{
    [m_fbCoreData load];

    if( [m_fbCoreData.fbUID isEqual:@""] ) {
        
        NSLog(@"未登錄facebook!!");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"先登錄" message:@"您需要先登錄k吧才能完成操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登錄",nil];
        [alert show];
    } else {

        // disable 關注按鈕
        UIButton *buttonThatWasPressed = (UIButton *)sender;
        buttonThatWasPressed.enabled = NO;

        [self setFavorite:sender WithPostId:self.m_postID for:m_followState];
    }
}

- (void)loadScrollViewWithPage:(int)page
{
	int kNumberOfPages = [dataSource numberOfPages];
    if (page < 0) return;
    if (page >= kNumberOfPages) return;

    // replace the placeholder if necessary
    UIImageView *view = [imageViews objectAtIndex:page];
    if ((NSNull *)view == [NSNull null]) {

		UIImage *image = [dataSource imageAtIndex:page];
        view = [[UIImageView alloc] initWithImage:image];
        [imageViews replaceObjectAtIndex:page withObject:view];
    }

    // add the controller's view to the scroll view
    if (nil == view.superview) {

        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        view.frame = frame;
        [scrollView addSubview:view];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }

    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;

    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender
{
    int page = pageControl.currentPage;

    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];

	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];

	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}

// 取得關注歌曲狀態
-(BOOL) getFavorite
{
    if( self.m_followState == YES ) {

        NSLog(@"已關注");
        followLabel.text = [NSString stringWithFormat:@"已關注\n%d", self.m_followCount];
    } else {

        NSLog(@"尚未關注");
        followLabel.text = [NSString stringWithFormat:@"關注\n%d", self.m_followCount];
    }

    return self.m_followState ;
}

// 關注/取消關注歌曲
-(void)setFavorite:(id)sender WithPostId:(NSString *)post_id for:(BOOL)flag
{
    NSString *query = nil;
    NSString *method = @"";

    if( flag == false ) method = @"add";        // 關注
    else                method = @"remove";     // 取消關注

    query = [NSString stringWithFormat:@"favorite.php?song_id=%@&uid=FB_%@&method=%@", post_id, m_fbCoreData.fbUID, method];
    NSLog(@"query(%@)", query);
    [m_wordpress queryWordpress:query completion:^(NSArray *parsedElements){

        if( [parsedElements count] > 0 ) {

            NSDictionary *aModuleDict = [parsedElements objectAtIndex:0];
            WpFavoriteData *wpFavoriteData = [[WpFavoriteData alloc] initWithDictionary:aModuleDict];

            NSLog(@"follow_state(%@) follow_count(%@) activity_id(%@) user_id(%@)", wpFavoriteData.follow_state, wpFavoriteData.follow_count, wpFavoriteData.activity_id, wpFavoriteData.user_id);

            // 設定關注狀態文字
            [self setFollowLabel:[wpFavoriteData.follow_state boolValue] AndCount:[wpFavoriteData.follow_count intValue]];

            // enable 關注按鈕
            UIButton *buttonThatWasPressed = (UIButton *)sender;
            buttonThatWasPressed.enabled = YES;
        }
    }];
}

// 設定關注狀態文字
-(void)setFollowLabel:(BOOL)state AndCount:(int)count
{
    self.m_followState = state;
    self.m_followCount = count;

    if( state == YES ) {

        followLabel.text = [NSString stringWithFormat:@"已關注\n%d", count];
    } else {

        followLabel.text = [NSString stringWithFormat:@"關注\n%d", count];
    }
}

#pragma mark -

// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action
{
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                                   defaultAudience:FBSessionDefaultAudienceFriends
                                                 completionHandler:^(FBSession *session, NSError *error) {
                                                     if (!error) {
                                                         action();
                                                     }
                                                     //For this example, ignore errors (such as if user cancels).
                                                 }];
    } else {

        action();
    }
}

-(void)setSongData:(NSString *)songName with:(NSString *)playerName andMp3:(NSString *)mp3
{
    m_songName = songName;
    m_playerName = playerName;
    m_mp3 = mp3;
}

@end

