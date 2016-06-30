//
//  PlayRecordingViewController.m
//  myFans
//
//  Created by wonliao on 13/1/25.
//
//
#import "PlayRecordingViewController.h"
#import "Recording.h"   // 目前要錄音的資料庫互動類別
#import "ASIFormDataRequest.h"
#import "CaptureSessionController.h"
#import "ASScreenRecorder.h"
#import <FBSDKShareKit/FBSDKShareKit.h>

// Private stuff
@interface PlayRecordingViewController ()
@property (nonatomic ,strong) IBOutlet CaptureSessionController *captureSessionController;
@end

@implementation PlayRecordingViewController

@synthesize timer, request, m_songId, m_songTitle, m_playFlag, m_mp3, m_content, m_fileName, m_file, m_isVideo, HUD, tmpParser, myView;

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

    // // 載入本地端mp3和動態歌詞
    [self loadSong];

    // 建立 recordAudio
    m_recordAudio = [[RecordAudio alloc] init];

    // 回放
    [self play];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [moviePlayer stop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)play
{
    // 檢查是否在MV模式?
    if([m_isVideo isEqualToString:@"YES"]) {

        NSString *urlString = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov", m_fileName]];
        outputFileUrl = [NSURL fileURLWithPath:urlString];

        // 播放錄影
        [self playVideo];
    } else {

        // 播放合成之後的歌曲
        [m_recordAudio playSongWithFile:m_fileName];
        
        // 重置動態歌詞
        [lecLayer reset:tmpParser.lrcArray];
        
        // 播放動態歌詞
        [self loadKscContent];
    }
    
    // 設定 播放鈕
    [button2 setTitle:@"停止"];
    [button2 setEnabled:YES];
    [button2 setAction:@selector(stopSongButtonTapped:)];
}

//退出本頁
- (IBAction)cancelButtonTapped:(id)sender
{
    // 停止取得音樂播放時間及更新動態歌詞
    [self.timer invalidate];
    self.timer = nil;
    
    [audioIO_ stop];
    
    [self dismissModalViewControllerAnimated:YES];
}

// 載入本地端mp3和動態歌詞
-(void)loadSong
{
    m_playFlag = [[NSUserDefaults standardUserDefaults] stringForKey:@"playFlag"];
    m_songId = [NSString stringWithFormat:@"%d", [[NSUserDefaults standardUserDefaults] integerForKey:@"songId"]];
    m_songTitle = [[NSUserDefaults standardUserDefaults] objectForKey:@"songTitle"];
    m_content = [[NSUserDefaults standardUserDefaults] objectForKey:@"songKsc"];
    m_fileName = [[NSUserDefaults standardUserDefaults] objectForKey:@"fileName"];
    m_file = [[NSUserDefaults standardUserDefaults] objectForKey:@"file"];
    m_isVideo = [[NSUserDefaults standardUserDefaults] objectForKey:@"isVideo"];

    m_mp3 = [[NSBundle mainBundle] pathForResource: m_songTitle ofType: @"mp3"];
}

// 載入動態歌詞
- (void)loadKscContent
{
    // 解析 KSC 檔
    tmpParser = [[LRCParser alloc] init];
    [tmpParser parseLRC:m_content];

    // Layer 處理
    lecLayer = [[LRCView alloc] initWithFrame:CGRectMake(0, 20, 320, 250)];
    [lecLayer setLineLayers:tmpParser.lrcArray];

    [self.view.layer addSublayer:lecLayer];

    // 播放字幕
    [self playKscContent];
}

// 播放動態歌詞
- (void)playKscContent
{
    lecLayer.currentLine = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateTT:) userInfo:nil repeats:YES];
}

// 取得音樂播放時間及更新動態歌詞
- (void)updateTT:(NSTimer*)TimeRecord
{
    // 取得音樂播放時間
    double cTime;
    double cEndTime;
    [m_recordAudio getCurrentTime:&cTime getEndTime:&cEndTime];

    // 更新動態歌詞
    m_currentTime = (int)(cTime * 1000);

    [lecLayer updateLRCLineLayer:m_currentTime];

    // 音樂播放完畢時
    if( [m_recordAudio.m_pLongMusicPlayer isPlaying] == NO && cEndTime != 0 ) {

        [self performSelectorOnMainThread:@selector(stopUpdate) withObject:nil waitUntilDone:NO];
    }
}

- (void)stopUpdate
{
    // 停止動態歌詞
    [timer invalidate];
    timer = nil;

    // 停止音樂
    [m_recordAudio stopMusic];
}

-(void)playVideo
{
    if(moviePlayer) [moviePlayer stop];
    
    moviePlayer = [[(AppDelegate *)[[UIApplication sharedApplication] delegate] player] initWithContentURL:outputFileUrl];
    moviePlayer.view.tag = 99;
    moviePlayer.view.hidden = NO;
    moviePlayer.view.frame= CGRectMake(0, 0, myView.frame.size.width, myView.frame.size.height);
    moviePlayer.view.backgroundColor = [UIColor clearColor];
    moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    moviePlayer.fullscreen = YES;
    moviePlayer.shouldAutoplay = YES;
    [moviePlayer setRepeatMode:MPMovieRepeatModeNone];
    [moviePlayer prepareToPlay];
    [moviePlayer readyForDisplay];
    [moviePlayer setControlStyle:MPMovieControlStyleDefault];

    [myView addSubview:moviePlayer.view];
    [myView setHidden:NO];
}

@end
