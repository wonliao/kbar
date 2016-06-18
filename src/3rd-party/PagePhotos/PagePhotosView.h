//
//  PagePhotosView.h
//  PagePhotosDemo
//
//  Created by junmin liu on 10-8-23.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "PagePhotosDataSource.h"
#import "wordpress.h"
#import "FBCoreData.h"

// 與 PlaySongViewController 協定
@protocol subViewDelegate
-(void)openLoginTop2:(id)sender;
-(void)openComment:(id)sender;
@end


@interface PagePhotosView : UIView<UIScrollViewDelegate, UIAlertViewDelegate, FBLoginViewDelegate> {

    // 與 PlaySongViewController 協定
    id<subViewDelegate> delegate;

	UIScrollView *scrollView;
	UIPageControl *pageControl;

    //UIImageView *imageView1;

    //id < PagePhotosViewDelegate > delegate;

	//id<PagePhotosDataSource> dataSource;
	NSMutableArray *imageViews;

	// To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;

    // 花朵數
    UILabel *flowerLabel;
    int m_flowerCount;

    // 關注數
    UILabel *followLabel;
    BOOL m_followState;
    int m_followCount;

    NSString *m_postID;
    
    NSString *m_songName;
    NSString *m_playerName;
    NSString *m_mp3;
    
 
    wordpress *m_wordpress;

    FBCoreData *m_fbCoreData;
}


// 與 PlaySongViewController 協定
@property (nonatomic, assign) id<subViewDelegate> delegate;

@property (nonatomic, assign) id<PagePhotosDataSource> dataSource;
@property (nonatomic, retain) NSMutableArray *imageViews;
@property (strong) id <PagePhotosDataSource> datasource;

// 花朵數
@property (readwrite) UILabel *flowerLabel;
@property (readwrite) int m_flowerCount;

// 關注數
@property (readwrite) UILabel *followLabel;
@property (readwrite) BOOL m_followState;
@property (readwrite) int m_followCount;

@property (nonatomic, retain) NSString *m_postID;



@property (nonatomic, retain) wordpress *m_wordpress;



- (IBAction)changePage:(id)sender;
- (IBAction)commentButtonTapped:(id)sender;
- (IBAction)toSingButtonTapped:(id)sender;
- (IBAction)flowerButtonTapped:(id)sender;
- (IBAction)listenButtonTapped:(id)sender;
- (IBAction)shareButtonTapped:(id)sender;
- (IBAction)followButtonTapped:(id)sender;


- (id)initWithFrame:(CGRect)frame withDataSource:(id<PagePhotosDataSource>)_dataSource andPostID:(NSString *)postID;

// 設定花朵數
-(void)setFlower:(int)flower;

// 設定關注狀態文字
-(void)setFollowLabel:(BOOL)state AndCount:(int)count;

-(void)setSongData:(NSString *)songName with:(NSString *)playerName andMp3:(NSString *)mp3;

@end
