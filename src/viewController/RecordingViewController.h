//
//  RecordingViewController.h
//  myFans
//
//  Created by vincent on 13/1/25.
//
//

#import <UIKit/UIKit.h>
#import "RecordAudio.h"
#import "LRCLayer.h"
#import "MBProgressHUD.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioIO.h"
#import "CoreData.h"
#import "QBKOverlayMenuView.h"
#import "AppDelegate.h"
#import "SocialVideoHelper.h"

@class ASIFormDataRequest;
@class CaptureSessionController;


@interface RecordingViewController : UIViewController <MBProgressHUDDelegate, AVAudioPlayerDelegate, AVCaptureFileOutputRecordingDelegate, QBKOverlayMenuViewDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>
{
    IBOutlet UIBarButtonItem *button1;
    IBOutlet UIBarButtonItem *button2;
    IBOutlet UIBarButtonItem *button3;
    IBOutlet UIBarButtonItem *button4;
    IBOutlet UIButton *button5;
    IBOutlet UILabel *text2;

    // 播放音樂
    RecordAudio *m_recordAudio;

    // CoreData 物件
    CoreData *m_coreData;
    
    NSString *m_songId;
    NSString *m_songTitle;
    NSString *m_playFlag;
    NSString *m_mp3;
    NSString *m_content;
    NSString *m_fileName;
    NSString *m_file;
    NSString *m_isVideo;

    // 動態歌詞
    NSTimer *timer;
    LRCView *lecLayer;
    NSInteger m_currentTime;
    ASIFormDataRequest *request;
    LRCParser *tmpParser;

    // 合成時間吧
    MBProgressHUD *HUD;

    AudioIO *audioIO_;

    // 錄影
    IBOutlet UIView *myView;
    NSString *filePath;
    NSURL *fileUrl;
    AVCaptureSession *captureSession;
    AVCaptureMovieFileOutput *captureOutput;
    AVCaptureVideoPreviewLayer *previewLayer;
    
    // OverlayMenu
    QBKOverlayMenuView *_qbkOverlayMenu;
    
    UIImageView *imagev;
    KKMediaPlayer *moviePlayer;
    
    NSString *outputFileName;
    NSURL *outputFileUrl;
}


@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) NSString* m_songId;
@property (nonatomic, retain) NSString* m_songTitle;
@property (nonatomic, retain) NSString* m_playFlag;
@property (nonatomic, retain) NSString* m_mp3;
@property (nonatomic, retain) NSString* m_content;
@property (nonatomic, retain) NSString* m_fileName;
@property (nonatomic, retain) NSString* m_file;
@property (nonatomic, retain) NSString* m_isVideo;

@property (nonatomic, retain) LRCParser *tmpParser;
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (retain, nonatomic) ASIFormDataRequest *request;


- (IBAction)endButtonTapped:(id)sender;
- (IBAction)playButtonTapped:(id)sender;
- (IBAction)cancelButtonTapped:(id)sender;
- (IBAction)stopSongButtonTapped:(id)sender;
- (IBAction)reRecordTapped:(id)sender;
- (IBAction)mvTapped:(id)sender;


// 錄影
@property (nonatomic,retain)IBOutlet UIView *myView;
@end
