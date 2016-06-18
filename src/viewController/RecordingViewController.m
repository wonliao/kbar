//
//  RecordingViewController.m
//  myFans
//
//  Created by wonliao on 13/1/25.
//
//
#import "RecordingViewController.h"
#import "Recording.h"   // 目前要錄音的資料庫互動類別
#import "ASIFormDataRequest.h"
#import "CaptureSessionController.h"
#import "FBCoreData.h"



// Private stuff
@interface RecordingViewController ()
- (void)uploadFailed:(ASIHTTPRequest *)theRequest;
- (void)uploadFinished:(ASIHTTPRequest *)theRequest;
@property (nonatomic ,strong) IBOutlet CaptureSessionController *captureSessionController;
@end

@implementation RecordingViewController

@synthesize timer, request, m_postId, m_songTitle, m_mp3, m_content, HUD, tmpParser, myView;

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
    
    //m_wordpress = [[wordpress alloc] init];

    //[self checkFacebook];

    // 設定錄音session
    [self setupAudioSession];

    // 取得應用程式的代理物件參照
    m_coreData = [[CoreData alloc] init];

    // 載入目前要錄音的資料庫互動類別
    //[self loadRecordingData];

    // // 載入本地端mp3和動態歌詞
    [self loadSong];
    
    // 載入動態歌詞
    //[self loadKscContent];

    audioIO_ = [[AudioIO alloc] initWithSamplingRate:44100.0];
    //[audioIO_ open];
/*
    // 開始錄音
    [self.captureSessionController startRecording];
*/
    // 建立 recordAudio
    m_recordAudio = [[RecordAudio alloc] init];
/*
    // 播放音樂
    [m_recordAudio playMusic: m_mp3];

    // 準備長條圖
    [self initBarChart];
    
    // 粒子特效1
    effectView1 = [UIEffectDesignerView effectWithFile:@"pitch.ped"];
    effectView1.layer.zPosition = 201;
    [self.view addSubview:effectView1];
    
    // 粒子特效2
    effectView2 = [UIEffectDesignerView effectWithFile:@"pitch2.ped"];
    effectView2.layer.zPosition = 200;
    [self.view addSubview:effectView2];
*/
    // OverlayMenu
    [self initOverlayView];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

// 設定錄音session
- (void)setupAudioSession
{
    //初始錄音session
    if ([self.captureSessionController setupCaptureSession]) {

        NSLog(@"Initializing CaptureSessionController");
    } else {

        NSLog(@"Initializing CaptureSessionController failed just BAIL!");
    }

    static BOOL audioSessionSetup = NO;

    if (audioSessionSetup)  return;

    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
    UInt32 doSetProperty = 1;

    AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(doSetProperty), &doSetProperty);

    [[AVAudioSession sharedInstance] setActive: YES error: nil];

    audioSessionSetup = YES;
}

//錄音完成或取消
- (IBAction)endButtonTapped:(id)sender
{
    [audioIO_ stop];

    // 合成錄音及音樂
    [self mergeRecord];
}

// 合成錄音及音樂
- (void)mergeRecord
{
    [self stopUpdate];

    // 錄影
    [self stopVideoRecord];

    // 停止錄音
    [self.captureSessionController stopRecording];
    //[self.captureSessionController stopCaptureSession];

    // 錄音檔位置
    NSURL *url = (NSURL *)self.captureSessionController.outputFile;
    NSString *record_file_path = [url path];
    NSLog(@"record_file_path(%@)", record_file_path);

    // 開始合成
    [m_recordAudio merge2wav:m_mp3 withRecord:record_file_path];
    
    // 播放 合成中的進度吧
    [self showProgress];

    [button3 setEnabled:YES];
    [button4 setEnabled:YES];
}

- (IBAction)playButtonTapped:(id)sender
{
    // 播放合成之後的歌曲
    [m_recordAudio playSong];

    // 重新播放 動態歌詞
    [lecLayer reset:tmpParser.lrcArray];
    [self loadKscContent];
    
    
    // 設定 播放鈕
    [button2 setTitle:@"停止"];
    [button2 setAction:@selector(stopSongButtonTapped:)];
    
    // 錄影
    [self playVideo];
}

- (IBAction)stopSongButtonTapped:(id)sender
{
    // 停止播歌
    [m_recordAudio stopSong];
    
    // 設定 播放鈕
    [button2 setTitle:@"播放"];
    [button2 setAction:@selector(playButtonTapped:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)reRecordTapped:(id)sender
{
    [self reRecord];
}

- (void)reRecord
{
    [self.captureSessionController resetCaptureSession];
    
    // 設定錄音session
    [self setupAudioSession];
    
    [audioIO_ open];
    [audioIO_ start];
    
    // 開始錄音
    [self.captureSessionController startRecording];
    
    // 播放音樂
    [m_recordAudio playMusic: m_mp3];
    
    [button3 setEnabled:NO];
    [button4 setEnabled:NO];
    [button1 setEnabled:YES];
    [button1 setTitle:@"完成"];
    [button1 setAction:@selector(endButtonTapped:)];
    [button2 setTitle:@"播放"];
    [button2 setEnabled:NO];
    [button2 setAction:@selector(playButtonTapped:)];
}

// 發起合唱
- (IBAction)chorusTapped:(id)sender
{
    NSLog(@"upload chorus");
    
    [button3 setEnabled:NO];
    
    [self uploadSong:YES withChrous:YES];
}

// 上傳錄音檔至 wordpress
- (IBAction)uploadButtonTapped:(id)sender
{
    NSLog(@"uploadSong");

    [self uploadSong:YES withChrous:NO];
}

- (void)uploadSong:(BOOL)flag withChrous:(BOOL)chorusFlag
{
    NSLog(@"已登錄facebook!!");
    
    // 播放 合成中的進度吧
    [self showUploadProgress];

    [request cancel];
 
    NSString *urlString = [NSString stringWithFormat:@"http://54.200.150.53/kbar/import/upload.php?uid=%@&pid=%@&title=%@&user_name=%@", m_FbCoreData.fbUID, m_postId, m_songTitle, m_FbCoreData.fbName];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8)];
    
    [self setRequest:[ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]]];
    [request setTimeOutSeconds:60];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    [request setShouldContinueWhenAppEntersBackground:YES];
#endif
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(uploadFailed:)];
    
    if( chorusFlag == NO ) {

        [request setDidFinishSelector:@selector(uploadFinished:)];
    } else {

        [request setDidFinishSelector:@selector(uploadFinished2:)];
    }
    
    // 上傳 m4a
    NSURL *tmpDirURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSURL *m4aOutputFileURL = [[tmpDirURL URLByAppendingPathComponent:@"output"] URLByAppendingPathExtension:@"m4a"];
    NSString* m4aPath = [m4aOutputFileURL path];
    [request setFile:m4aPath forKey:[NSString stringWithFormat:@"m4a"]];
    
    // 上傳 mov
    if( fileUrl ) {

        NSURL *movOutputFileURL = [[tmpDirURL URLByAppendingPathComponent:@"output"] URLByAppendingPathExtension:@"mov"];
        NSString* movPath = [movOutputFileURL path];
        [request setFile:movPath forKey:[NSString stringWithFormat:@"mov"]];
    }

    [request startAsynchronous];
    NSLog(@"Uploading data...");
}

// 上傳錄音檔至 wordpress 失敗
- (void)uploadFailed:(ASIHTTPRequest *)theRequest
{
    NSLog(@"Request failed:\r\n%@",[[theRequest error] localizedDescription]);
    
    NSString *message = [[NSString alloc] initWithFormat:
                         @"上傳失敗:\r\n%@",[[theRequest error] localizedDescription]];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"系統"
                          message:message
                          delegate:nil
                          cancelButtonTitle:@"知道了"
                          otherButtonTitles:nil];
    [alert show];
}

// 上傳錄音檔至 wordpress 成功
- (void)uploadFinished:(ASIHTTPRequest *)theRequest
{
    NSLog(@"Finished uploading %llu bytes of data",[theRequest postLength]);
}

// 上傳錄音檔至 wordpress 成功
- (void)uploadFinished2:(ASIHTTPRequest *)theRequest
{
    NSLog(@"Finished uploading %llu bytes of data",[theRequest postLength]);
    NSLog(@"responseString(%@)", [theRequest responseString]);
/*
    int attachId = [[theRequest responseString] intValue];

    NSString *query = [NSString stringWithFormat:@"add_chorus.php?post_id=%d&post_name=%@&uid=FB_%@&name=%@&note=%@", attachId, m_songTitle, m_FbCoreData.fbUID, m_FbCoreData.fbName, @"test"];
    [m_wordpress queryWordpress:query completion:^(NSArray *parsedElements){

        if( [parsedElements count] > 0 ) {

            NSString *result = [[parsedElements objectAtIndex:0] objectForKey:@"RESULT"];
            NSLog(@"result(%@)", result);
            if( [result isEqualToString:@"OK"] ) {

                [button3 setEnabled:NO];
                UIAlertView* alertView = [[UIAlertView alloc]
                                          initWithTitle:@"提示"
                                          message:@"新增合唱成功"
                                          delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
            }
        }
    }];
*/
}


// 載入本地端mp3和動態歌詞
-(void)loadSong
{
   
    m_postId = @"1";
    m_songTitle = @"寂寞沙洲冷";
    m_mp3 = [[NSBundle mainBundle] pathForResource: @"44524" ofType: @"mp3"];
    
    
    m_content = @"diffTime:4;karaoke.add('00:32.110', '00:35.430', '自你走後心憔悴', '560,570,430,570,500,430,260');karaoke.add('00:35.730', '00:38.980', '白色油桐風中紛飛', '310,260,310,370,250,440,310,1000');karaoke.add('00:40.210', '00:45.650', '落花似人有情這個季節', '440,440,250,370,440,570,370,440,620,1500');karaoke.add('00:48.090', '00:51.520', '河畔的風放肆拼命的吹', '440,430,380,370,320,310,310,380,240,250');karaoke.add('00:51.780', '00:55.340', '無端撥弄離人的眼淚', '250,240,380,380,310,380,310,310,1000');karaoke.add('00:55.750', '00:59.370', '那樣濃烈的愛再也無法給', '250,320,300,380,250,370,380,310,310,440,310');karaoke.add('01:00.060', '01:03.750', '傷感一夜一夜', '500,560,440,440,370,1380');karaoke.add('01:07.820', '01:10.130', '當記憶的線纏繞過往', '430,320,310,190,240,250,260,180,130');karaoke.add('01:10.380', '01:11.440', '支離破碎', '190,250,240,380');karaoke.add('01:11.820', '01:15.130', '是慌亂占據了心扉', '370,310,250,250,320,370,440,1000');karaoke.add('01:15.690', '01:17.820', '有花兒伴著蝴碟', '500,320,240,320,250,250,250');karaoke.add('01:18.060', '01:19.880', '孤雁可以雙飛', '440,320,250,250,250,310');karaoke.add('01:20.190', '01:22.750', '夜深人靜獨徘徊', '310,250,260,240,320,500,680');karaoke.add('01:23.630', '01:26.190', '當幸福戀人寄來紅色', '560,310,320,250,310,190,250,180,190');karaoke.add('01:26.380', '01:27.380', '分享喜悅', '190,310,190,310');karaoke.add('01:27.750', '01:31.250', '閉上雙眼難過頭也不敢回', '320,250,250,250,250,250,370,250,250,190,870');karaoke.add('01:31.690', '01:34.320', '仍然撿盡寒枝不肯安歇', '310,250,250,320,250,250,250,310,250,190');karaoke.add('01:34.500', '01:35.690', '微帶著後悔', '190,190,250,250,310');karaoke.add('01:36.070', '01:39.320', '寂寞沙洲我該思念誰', '430,320,250,250,310,250,250,370,820');karaoke.add('01:48.150', '01:51.460', '自你走後心憔悴', '560,500,440,490,510,430,380');karaoke.add('01:51.680', '01:55.060', '白色油桐風中紛飛', '320,310,310,380,310,430,380,940');karaoke.add('01:56.120', '02:01.740', '落花似人有情這個季節', '370,510,310,440,310,620,380,440,560,1680');karaoke.add('02:04.120', '02:07.500', '河畔的風放肆拼命的吹', '440,440,310,370,320,310,310,380,310,190');karaoke.add('02:07.750', '02:11.370', '無端撥弄離人的眼淚', '310,250,310,380,310,370,440,310,940');karaoke.add('02:11.810', '02:15.680', '那樣濃烈的愛再也無法給', '250,310,250,250,440,440,310,310,310,380,620');karaoke.add('02:16.180', '02:20.250', '傷感一夜一夜', '440,560,500,380,440,1750');karaoke.add('02:23.710', '02:26.210', '當記憶的線纏繞過往', '500,380,250,250,250,250,250,190,180');karaoke.add('02:26.400', '02:27.400', '支離破碎', '190,310,190,310');karaoke.add('02:27.770', '02:30.900', '是慌亂占據了心扉', '440,310,260,250,250,370,440,810');karaoke.add('02:31.710', '02:33.840', '有花兒伴著蝴碟', '440,310,320,250,310,250,250');karaoke.add('02:34.150', '02:35.840', '孤雁可以雙飛', '380,310,180,320,250,250');karaoke.add('02:36.210', '02:38.770', '夜深人靜獨徘徊', '310,260,240,260,310,500,680');karaoke.add('02:39.720', '02:41.710', '當幸福戀人寄來', '490,310,260,310,250,190,180');karaoke.add('02:41.900', '02:43.400', '紅色分享喜悅', '190,250,250,250,250,310');karaoke.add('02:43.770', '02:47.150', '閉上雙眼難過頭也不敢回', '260,240,250,250,260,310,380,240,190,250,750');karaoke.add('02:47.720', '02:50.210', '仍然撿盡寒枝不肯安歇', '300,320,250,190,250,310,250,250,190,180');karaoke.add('02:50.400', '02:51.650', '微帶著後悔', '250,190,250,250,310');karaoke.add('02:52.210', '02:55.400', '寂寞沙洲我該思念誰', '320,250,310,250,250,250,250,430,880');karaoke.add('03:23.770', '03:26.140', '當記憶的線纏繞過往', '500,310,250,250,250,250,190,250,120');karaoke.add('03:26.330', '03:27.390', '支離破碎', '250,250,250,310');karaoke.add('03:27.770', '03:31.210', '是慌亂占據了心扉', '430,250,320,250,250,250,500,1190');karaoke.add('03:31.950', '03:33.830', '有花兒伴著蝴碟', '320,250,250,250,250,250,310');karaoke.add('03:34.080', '03:35.830', '孤雁可以雙飛', '440,250,250,310,250,250');karaoke.add('03:36.210', '03:38.770', '夜深人靜獨徘徊', '310,250,250,250,250,560,690');karaoke.add('03:39.640', '03:41.700', '當幸福戀人寄來', '560,320,250,250,250,190,240');karaoke.add('03:41.890', '03:43.330', '紅色分享喜悅', '190,250,250,190,310,250');karaoke.add('03:43.710', '03:47.210', '閉上雙眼難過頭也不敢回', '310,250,250,250,250,250,310,250,250,250,880');karaoke.add('03:47.640', '03:50.210', '仍然撿盡寒枝不肯安歇', '380,250,250,250,250,250,250,250,250,190');karaoke.add('03:50.390', '03:51.770', '微帶著後悔', '190,250,250,250,440');karaoke.add('03:52.200', '03:55.270', '寂寞沙洲我該思念誰', '250,320,250,250,250,310,190,370,880');karaoke.add('03:55.770', '03:58.080', '仍然撿盡寒枝不肯安歇', '310,250,250,190,250,250,250,190,180,190');karaoke.add('03:58.330', '03:59.770', '微帶著後悔', '190,250,250,310,440');karaoke.add('04:00.210', '04:03.330', '寂寞沙洲我該思念誰', '310,250,250,310,250,250,250,370,880');";

    [self loadKscContent];
/*
    // 解析 KSC 檔
    tmpParser = [[LRCParser alloc] init];
    [tmpParser parseLRC:m_content];
    
    // Layer 處理
    lecLayer = [[LRCView alloc] initWithFrame:CGRectMake(0, 20, 320, 250)];
    [lecLayer setLineLayers:tmpParser.lrcArray];
    
    [self.view.layer addSublayer:lecLayer];
    
    [self playKscContent];
*/
}

// 從資料庫中讀取資料
- (void)loadRecordingData
{
    Recording* currentRecording = [m_coreData loadDataFromRecording];
    if( currentRecording ) {

        m_postId = currentRecording.index;
        m_songTitle = currentRecording.title;
        m_mp3 = currentRecording.file;
        m_content = currentRecording.content;
    }
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

    [self playKscContent];
}

// 播放動態歌詞
- (void)playKscContent
{
    lecLayer.currentLine = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateTT:) userInfo:nil repeats:YES];
}

// 取得音樂播放時間及更新動態歌詞
- (void)updateTT:(NSTimer*)TimeRecord
{
    // 取得音樂播放時間
    double cTime;
    double cEndTime;
    [m_recordAudio getCurrentTime:&cTime getEndTime:&cEndTime];

    // 取得 mic 輸入的音量與頻率
    //float avg = [self.captureSessionController getAveragePowerLevel];
    //float frequency = self.captureSessionController->m_frequency;

    // 更新動態歌詞
    m_currentTime = (int)(cTime * 1000);
    

    //int score = [lecLayer updateLRCLineLayer:m_currentTime AndAvg:avg AndFrequency:frequency];
    [lecLayer updateLRCLineLayer:m_currentTime];
/*
    if( score >= 0 ) {

        m_scoreCount++;
        m_totalScore += score;
        int currentScore = ceil( m_totalScore / m_scoreCount );

        text2.text = [NSString stringWithFormat:@"%d / 單字得分：%d", currentScore, score];
    }
*/
/*
    // 更新長條圖
    if( m_currentTime > 0 ) {

        [barChart update:m_currentTime];
    }

 
    // 更新長條圖特效
    if( avg > -25 ) {
    
        effectView1.center = CGPointMake(50, barChart->m_effectHeight + barChart.frame.origin.y);
        effectView2.center = CGPointMake(50, barChart->m_effectHeight + barChart.frame.origin.y);
    } else {
        
        effectView1.center = CGPointMake(-50, -50);
        effectView2.center = CGPointMake(-50, -50);
    }
*/
/*
    // 音樂播放完畢時
    if( [m_recordAudio.m_pLongMusicPlayer isPlaying] == NO ) {

        if( self.captureSessionController.isRecording ) {

            // 合成錄音及音樂
            [self mergeRecord];
        } else {

            [self stopUpdate];
            
        }
    }

 

    if( [audioIO_ isHeadsetPluggedIn] == YES && self.captureSessionController.isRecording ) {

        [audioIO_ start];
    } else {

        [audioIO_ stop];
    }
*/
}

- (void)stopUpdate
{
    // 停止動態歌詞
    [self.timer invalidate];
    self.timer = nil;
    
    // 停止音樂
    [m_recordAudio stopMusic];
    
    // 停止播放影片
    [m_videoPlayer pause];
}

// 播放 合成中的進度吧
- (void)showProgress
{
    // 設定按鈕狀態
    [button1 setTitle:@"處理中"];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.dimBackground = YES;

    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    HUD.labelText = @"處理中";

    // Show the HUD while the provided method executes in a new thread
    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

// 檢查是否合成完成
- (void)myTask {

	while(1) {

        // 等待合成中
        if( m_recordAudio.m_mergeDone == NO ) {

            sleep(1);

            // 合成完成
        } else {

            // 按鈕換成上傳
            [button1 setTitle:@"上傳"];
            [button1 setAction:@selector(uploadButtonTapped:)];

            // 開啟播放鈕
            [button2 setEnabled:YES];

            break;
        }
    }
}

// 播放 上傳中的進度吧
- (void) showUploadProgress
{
    // 設定按鈕狀態
    [button1 setTitle:@"上傳中"];

    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];

    // Set determinate mode
	HUD.mode = MBProgressHUDModeAnnularDeterminate;
    HUD.dimBackground = YES;

    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    HUD.labelText = @"上傳中";

    // Show the HUD while the provided method executes in a new thread
    [HUD showWhileExecuting:@selector(myTask2) onTarget:self withObject:nil animated:YES];
}

// 檢查是否上傳完成
- (void)myTask2
{
    unsigned long long totalBytesSent = 0.0f;
    float progress = 0.0f;
	while( progress < 1.0f || totalBytesSent == 0.0f ) { // 等待上傳中

        // 上傳進度
        totalBytesSent = request.totalBytesSent;
        unsigned long long postLength = request.postLength;
        progress =  (float) totalBytesSent / postLength;
        NSLog(@"progress(%f) = totalBytesSent(%llu) / postLength(%llu) ", progress, totalBytesSent, postLength);
        HUD.progress = progress;

        sleep(1);
    }

    // 按鈕換成上傳
    [button1 setTitle:@"上傳完成"];
    [button1 setEnabled:NO];
}

// 檢查 facebook 登入
- (void)checkFacebook
{
    // 取得 facebook 資料
    m_FbCoreData = [[FBCoreData alloc] init];
    [m_FbCoreData load];

    if( [m_FbCoreData.fbUID isEqual:@""] ) {

        NSLog(@"未登錄facebook!!");
    } else {

        NSLog(@"已登錄facebook!!");
    }
}

// 準備長條圖
- (void) initBarChart
{
    NSMutableArray *timeArray = [[NSMutableArray alloc] init];

    int startTime = 0;
    int endTime = 0;
    for( int i= 0; i<[lecLayer.lineLayers count]; i++ ) {

        LRCLineLayer *lrcLineLayer = (LRCLineLayer*)[lecLayer.lineLayers objectAtIndex:i];
        startTime = lrcLineLayer.startTime;
        endTime = lrcLineLayer.endTime;

        NSNumber *bTime = [NSNumber numberWithInt:startTime];
        NSNumber *eTime = [NSNumber numberWithInt:startTime];

        // 逐字時間
        for( int j=0; j<[lrcLineLayer->lyricsTime count]; j++ ) {
            
            NSNumber *time = [lrcLineLayer->lyricsTime objectAtIndex:j];

            eTime = time;
            NSArray *tempArray = [ [ NSArray alloc ] initWithObjects:bTime,eTime,nil];
            bTime = eTime;
            
            [timeArray addObject: tempArray ];
        }
    }
    
    // 長條圖陣列
    NSMutableDictionary *values = [[NSMutableDictionary alloc]init];
    
    NSLog(@"timeArray count(%d)", [timeArray count]);
    int current = 0;
    int randNum = 20;
    for( int i=0; i<endTime; i+=10) {

        NSArray *tempArray = [timeArray objectAtIndex:current];
        int bTime = [[tempArray objectAtIndex:0] intValue];
        int eTime = [[tempArray objectAtIndex:1] intValue];
        int value = 0;

        if( i >= bTime ) {

            value = randNum;
        }

        if( i >= eTime ) {

            current++;
            value = randNum;
            randNum+=20;
            if( randNum >= 100) randNum = 20;
        }

        [values setValue:[NSString stringWithFormat:@"%d", value] forKey:[NSString stringWithFormat:@"%d", i]];
    }
    
    barChart = [[BarChart alloc] initWithFrame:
                CGRectMake(0, myView.frame.origin.y+myView.frame.size.height, 320, 100)
                values:values];

    barChart.barColor  = [UIColor colorWithRed:176.0/255.0
                                         green:212.0/255.0
                                          blue:131.0/255.0
                                         alpha:1];

    barChart.layer.zPosition = 100;
    [self.view addSubview:barChart];
}

- (IBAction)pauseTapped:(id)sender
{
    [m_recordAudio pause];
    [m_videoPlayer pause];
}

// 錄影
-(void)setCaptureConfig
{
    captureSession = [[AVCaptureSession alloc] init];

    // 設定影片品質
    /*
    Preset                          3G      3GS     4 back      4 front
    AVCaptureSessionPresetHigh      400x304	640x480	1280x720    640x480
    AVCaptureSessionPresetMedium	400x304	480x360	480x360     480x360
    AVCaptureSessionPresetLow       400x306	192x144	192x144     192x144
    AVCaptureSessionPreset640x480	NA      640x480	640x480     640x480
    AVCaptureSessionPreset1280x720	NA      NA      1280x720	NA
    AVCaptureSessionPresetPhoto     NA      NA      NA          NA
    */
    [captureSession setSessionPreset:AVCaptureSessionPresetMedium];

    [self checkDevice];
    [self setPreview];
}

// 設定影片輸出檔
-(void)outputFile
{
	captureOutput = [[AVCaptureMovieFileOutput alloc] init];
	if (! fileUrl) {

        NSURL *tmpDirURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
        fileUrl = [[tmpDirURL URLByAppendingPathComponent:@"output"] URLByAppendingPathExtension:@"mov"];
        filePath = [fileUrl path];

        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {

            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
	}
    NSLog(@"recording to %@",fileUrl);

	[captureSession addOutput:captureOutput];
}

-(void)checkDevice
{
    NSError *error = nil;
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
    if (videoDevice) {

        // 取得前後鏡頭名
        NSArray *devices = [AVCaptureDevice devices];
        AVCaptureDevice *frontCamera;
        AVCaptureDevice *backCamera;

        for (AVCaptureDevice *device in devices) {

            NSLog(@"Device name: %@", [device localizedName]);

            if ([device hasMediaType:AVMediaTypeVideo]) {
                
                if ([device position] == AVCaptureDevicePositionBack) {

                    NSLog(@"Device position : back");
                    backCamera = device;
                }
                else {

                    NSLog(@"Device position : front");
                    frontCamera = device;
                }
            }
        }

        // 設置前置鏡頭
        AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];

        if (videoInput) {

            [captureSession addInput: videoInput];
        }
    }
}

-(void)setPreview
{
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
	previewLayer.frame = myView.layer.bounds;
	previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
	[myView.layer addSublayer:previewLayer];
    myView.clipsToBounds = YES;
}

-(void)starVideoRecord
{
    NSLog(@"starVideoRecord");
    [captureSession startRunning];
    [captureOutput startRecordingToOutputFileURL:fileUrl
                               recordingDelegate:self];
}

-(void)stopVideoRecord
{
    NSLog(@"stopVideoRecord");
    [captureSession stopRunning];
    [captureOutput stopRecording];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
didStartRecordingToOutputFileAtURL:(NSURL *)fileURL
      fromConnections:(NSArray *)connections
{
	NSLog (@"開始寫入影片至 %@", fileURL);
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
      fromConnections:(NSArray *)connections error:(NSError *)error
{
	if (error) {

		NSLog (@"錄影失敗: %@", error);
	} else {

		NSLog (@"錄製影片至 %@", outputFileURL);
	}
}

-(void)playVideo
{
    AVURLAsset *movieAsset	= [AVURLAsset URLAssetWithURL:fileUrl options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    m_videoPlayer = [AVPlayer playerWithPlayerItem:playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:m_videoPlayer];
    playerLayer.frame = myView.layer.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [myView.layer addSublayer:playerLayer];

    [m_videoPlayer play];
}

- (IBAction)mvTapped:(id)sender
{
    //[self reRecord];

    if( myView.hidden == YES ) {

        // 錄影
        [self setCaptureConfig];
        [self outputFile];
        [self starVideoRecord];

        myView.hidden = NO;
        [button5 setTitle:@"普通模式" forState:UIControlStateNormal];

    } else {

        [self stopVideoRecord];
        fileUrl = nil;
        myView.hidden = YES;
        [button5 setTitle:@"MV模式" forState:UIControlStateNormal];
    }
}

- (void)initOverlayView
{
    QBKOverlayMenuViewOffset offset;
    offset.bottomOffset = 130;

    _qbkOverlayMenu = [[QBKOverlayMenuView alloc] initWithDelegate:self position:kQBKOverlayMenuViewPositionBottom offset:offset];
    [_qbkOverlayMenu setParentView:[self view]];

    //建立陣列並設定其內容來當作選項
    NSArray *itemArray =[NSArray arrayWithObjects:@"原聲", @"KTV", @"小劇場", @"演唱會", nil];

    //使用陣列來建立UISegmentedControl
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];

    //設定外觀大小與初始選項
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.frame = CGRectMake(4.0, 4.0, 260.0, 35.0);
    segmentedControl.selectedSegmentIndex = 1;

    //設定所觸發的事件條件與對應事件
    [segmentedControl addTarget:self action:@selector(chooseOne:) forControlEvents:UIControlEventValueChanged];

    //加入畫面中
    [_qbkOverlayMenu.contentView addSubview:segmentedControl];
}


- (void)chooseOne:(id)sender {
    
    int selectIndex = [sender selectedSegmentIndex];
    NSLog(@"%@", [sender titleForSegmentAtIndex:selectIndex]);
    
    [audioIO_ setReverbArea:selectIndex];
    [self.captureSessionController setReverbArea:selectIndex];
}

@end
