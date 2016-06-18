//
//  PlaySongViewController.h
//  myFans
//
//  Created by wonliao on 13/1/22.
//播放歌曲頁面,包含照片展示,播放控制及下方圓形按鈕
//

#import <UIKit/UIKit.h>
#import "ControlPanelMini.h"
#import "ControlPanel.h"
#import "PagePhotosDataSource.h"
#import "PagePhotosView.h"
#import "LRCLayer.h"
#import "wordpress.h"
#import "FBCoreData.h"  // fbUserInfo的資料庫互動類別
#import "WpPlayingData.h"
#import "CoreData.h"
#import "KKMediaPlayer.h"



@interface PlaySongViewController : UIViewController< PagePhotosDataSource, subViewDelegate>{
    
    IBOutlet UIImageView *imageView1;
    IBOutlet UIImageView *imageView2;

    // CoreData 物件
    CoreData *m_coreData;

    // wordpress 物件
    wordpress *m_wordpress;
    WpPlayingData *m_wpPlayingData;

    //頁面上方浮動透明控制面板
    ControlPanelMini *nv;
    ControlPanel *controlPanel;
    UISlider *timeSlider;
    int state;

    //控制照片輪播
    NSTimer *timer;
    int imagenumber;

    NSString *m_post_id;

    // 歌詞
    LRCView *lecLayer;
    NSInteger m_currentTime;

    KKMediaPlayer *player;

    FBCoreData *m_FbCoreData;
    
    PagePhotosView *pagePhotosView;
    
    NSTimer *timer2;
    int m_count;
    NSMutableArray *m_UserImages;
    
    // 錄影
    IBOutlet UIView *myView;
    AVPlayer *m_videoPlayer;
    float m_videoCurrentTime;
}

@property (nonatomic,retain) IBOutlet UIImageView *imageView1;
@property (nonatomic,retain) IBOutlet UIImageView *imageView2;
@property (nonatomic, retain) NSString* m_post_id;
@property (nonatomic,retain) KKMediaPlayer *player;
@property (nonatomic, retain) wordpress *m_wordpress;

// 錄影
@property (nonatomic,retain)IBOutlet UIView *myView;


- (IBAction)touchScreen:(id)sender;
- (IBAction)closeButtonTapped:(id)sender;
- (void)tapToControlPanel;
- (void)selectorTests;
- (void)openLoginTop2:(id)sender;
- (void)openComment:(id)sender;
@end
