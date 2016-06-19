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
#import "ASScreenRecorder.h"


// Private stuff
@interface RecordingViewController ()
//- (void)uploadFailed:(ASIHTTPRequest *)theRequest;
//- (void)uploadFinished:(ASIHTTPRequest *)theRequest;
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
    
    imagev = [[UIImageView alloc] init];
    imagev.frame = myView.layer.bounds;// CGRectMake(0, 0, 320, 320);
    imagev.backgroundColor=[UIColor orangeColor];
    [myView addSubview:imagev];

    // 設定錄音session
    [self setupAudioSession];

    // 取得應用程式的代理物件參照
    m_coreData = [[CoreData alloc] init];

    // // 載入本地端mp3和動態歌詞
    [self loadSong];

    audioIO_ = [[AudioIO alloc] initWithSamplingRate:44100.0];

    // 建立 recordAudio
    m_recordAudio = [[RecordAudio alloc] init];

    // 音場設定選單
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

    // 錄影錄影
    //[self stopVideoRecord];
    
    // 停止螢幕錄影
    ASScreenRecorder *recorder = [ASScreenRecorder sharedInstance];
    [recorder stopRecordingWithCompletion:^{
        NSLog(@"Finished recording");
    }];

    // 停止錄音
    [self.captureSessionController stopRecording];

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

    // 重置動態歌詞
    [lecLayer reset:tmpParser.lrcArray];
    
    // 檢查是否在MV模式?
    if(myView.hidden == NO) {

        // 播放錄影
        [self playVideo];
    } else {
        
        // 播放動態歌詞
        [self loadKscContent];
    }
    
    // 設定 播放鈕
    [button2 setTitle:@"停止"];
    [button2 setAction:@selector(stopSongButtonTapped:)];
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
    // 檢查是否在MV模式?
    if(myView.hidden == NO) {
        
        // 開始錄影
        //[captureOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
        
        // 螢幕錄影
        ASScreenRecorder *recorder = [ASScreenRecorder sharedInstance];
        [recorder startRecording];
    }

    // 錄音
    [self reRecord];
}

// 錄音
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

/*
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
}
*/

// 載入本地端mp3和動態歌詞
-(void)loadSong
{
    m_postId = [NSString stringWithFormat:@"%d", [[NSUserDefaults standardUserDefaults] integerForKey:@"songId"]];
    m_songTitle = [[NSUserDefaults standardUserDefaults] objectForKey:@"songTitle"];
    m_mp3 = [[NSBundle mainBundle] pathForResource: m_songTitle ofType: @"mp3"];
    m_content = [[NSUserDefaults standardUserDefaults] objectForKey:@"songKsc"];

    [self loadKscContent];
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
/*
            // 按鈕換成上傳
            [button1 setTitle:@"上傳"];
            [button1 setAction:@selector(uploadButtonTapped:)];

            // 開啟播放鈕
            [button2 setEnabled:YES];
*/
            
            
            //[self performSelector:@selector(mergeAndSave) withObject:nil afterDelay:.6];
            
            //[self mergeAndSave];
            
            break;
        }
    }
}
/*
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
    // Preset                          3G      3GS     4 back      4 front
    // AVCaptureSessionPresetHigh      400x304	640x480	1280x720    640x480
    // AVCaptureSessionPresetMedium	400x304	480x360	480x360     480x360
    // AVCaptureSessionPresetLow       400x306	192x144	192x144     192x144
    // AVCaptureSessionPreset640x480	NA      640x480	640x480     640x480
    // AVCaptureSessionPreset1280x720	NA      NA      1280x720	NA
    // AVCaptureSessionPresetPhoto     NA      NA      NA          NA
 
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
    //[captureOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
}

-(void)stopVideoRecord
{
    NSLog(@"stopVideoRecord");
    [captureSession stopRunning];
    //[captureOutput stopRecording];
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
*/
-(void)playVideo
{
    AVURLAsset *movieAsset	= [AVURLAsset URLAssetWithURL:fileUrl options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    m_videoPlayer = [AVPlayer playerWithPlayerItem:playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:m_videoPlayer];
    playerLayer.frame = myView.layer.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [myView.layer addSublayer:playerLayer];
/*
    // 影片因不明原因慢了一秒，暫用快轉一秒的方式解
    CMTime newTime = CMTimeMakeWithSeconds(0, 1);
    newTime.value += 1.5;
    [m_videoPlayer seekToTime: newTime];
*/
    
    [m_videoPlayer play];
}

- (IBAction)mvTapped:(id)sender
{
    //[self reRecord];

    if( myView.hidden == YES ) {

        // 錄影
        //[self setCaptureConfig];
        //[self outputFile];
        //[self starVideoRecord];
        [self setupCaptureSession];

        myView.hidden = NO;
        [button5 setTitle:@"普通模式" forState:UIControlStateNormal];
    } else {

        //[self stopVideoRecord];
        fileUrl = nil;
        myView.hidden = YES;
        [button5 setTitle:@"MV模式" forState:UIControlStateNormal];
    }
}

// 音場效果選單
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

// 選擇音場效果
- (void)chooseOne:(id)sender {
    
    int selectIndex = [sender selectedSegmentIndex];
    NSLog(@"%@", [sender titleForSegmentAtIndex:selectIndex]);
    
    [audioIO_ setReverbArea:selectIndex];
    [self.captureSessionController setReverbArea:selectIndex];
}

// 捕获到视频的回调函数
// 將camera視頻轉為image, 讓螢幕擷取 work
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    // Create a UIImage from the sample buffer data
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    NSData *mData = UIImageJPEGRepresentation(image, 0.5);//这里的mData是NSData对象，后面的0.5代表生成的图片质量
    //在主线程中执行才会把图片显示出来
    dispatch_async(dispatch_get_main_queue(), ^{
       [imagev setImage:[UIImage imageWithData:mData]];
    });
    //[myView addSubview:imagev];
    //NSLog(@"output,mdata:%@",image);
}

// 把buffer流生成图片
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    //UIImage *image = [UIImage imageWithCGImage:quartzImage];
    UIImage *image = [UIImage imageWithCGImage:quartzImage scale:1.0f orientation:UIImageOrientationRight];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}

// Create and configure a capture session and start it running
//开启摄像头
- (void)setupCaptureSession
{
    NSError *error = nil;
    
    // Create the session
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    // Configure the session to produce lower resolution video frames, if your
    // processing algorithm can cope. We'll specify medium quality for the
    // chosen device.
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    // Find a suitable AVCaptureDevice
    //AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];//这里默认是使用后置摄像头，你可以改成前置摄像头
    AVCaptureDevice *device;
    for(AVCaptureDevice *dev in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo])
    {
        //这里修改AVCaptureDevicePositionFront成AVCaptureDevicePositionBack可获取后端摄像头
        if([dev position]==AVCaptureDevicePositionFront)
        {
            device=dev;
            break;
        }
    }
    // Create a device input with the device and add it to the session.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device
                                                                        error:&error];
    if (!input) {
        // Handling the error appropriately.
    }
    [session addInput:input];
    
    // Create a VideoDataOutput and add it to the session
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [session addOutput:output];
    
    // Configure your output.
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    [output setSampleBufferDelegate:self queue:queue];
    //dispatch_release(queue);
    
    // Specify the pixel format 设置输出的参数
   	output.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithInt:kCVPixelFormatType_32BGRA], kCVPixelBufferPixelFormatTypeKey,
                            [NSNumber numberWithInt: 640], (id)kCVPixelBufferWidthKey,
                            [NSNumber numberWithInt: 480], (id)kCVPixelBufferHeightKey,
                            nil];
    
    AVCaptureVideoPreviewLayer* preLayer = [AVCaptureVideoPreviewLayer layerWithSession: session];
    //preLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    preLayer.frame = CGRectMake(0, 0, 640, 480);
    preLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [myView.layer addSublayer:preLayer];
    // If you wish to cap the frame rate to a known value, such as 15 fps, set
    // minFrameDuration.
    output.minFrameDuration = CMTimeMake(1, 15);
    
    // Start the session running to start the flow of data
    [session startRunning];
    
    // Assign session to an ivar.
    //[self setSession:session];
}


/*
// 合成聲音及影像，並存入相簿
-(void)mergeAndSave
{
    //Create AVMutableComposition Object which will hold our multiple AVMutableCompositionTrack or we can say it will hold our video and audio files.
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    //Now first load your audio file using AVURLAsset. Make sure you give the correct path of your videos.
    //NSURL *audio_url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"output" ofType:@"m4a"]];
    NSString *urlString = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/output.m4a"];
    NSURL *audio_url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    audioAsset = [[AVURLAsset alloc]initWithURL:audio_url options:nil];
    CMTimeRange audio_timeRange = CMTimeRangeMake(kCMTimeZero, audioAsset.duration);
    
    //Now we are creating the first AVMutableCompositionTrack containing our audio and add it to our AVMutableComposition object.
    AVMutableCompositionTrack *b_compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [b_compositionAudioTrack insertTimeRange:audio_timeRange ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    //Now we will load video file.
    //NSURL *video_url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"screenCapture" ofType:@"mp4"]];
    NSString *urlString2 = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/screenCapture.mp4"];
    NSURL *video_url = [NSURL URLWithString:[urlString2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    videoAsset = [[AVURLAsset alloc]initWithURL:video_url options:nil];
    CMTimeRange video_timeRange = CMTimeRangeMake(kCMTimeZero,audioAsset.duration);
    
    //Now we are creating the second AVMutableCompositionTrack containing our video and add it to our AVMutableComposition object.
    AVMutableCompositionTrack *a_compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [a_compositionVideoTrack insertTimeRange:video_timeRange ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    //decide the path where you want to store the final video created with audio and video merge.
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *outputFilePath = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"FinalVideo.mov"]];
    NSURL *outputFileUrl = [NSURL fileURLWithPath:outputFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:outputFilePath])
        [[NSFileManager defaultManager] removeItemAtPath:outputFilePath error:nil];
    
    //Now create an AVAssetExportSession object that will save your final video at specified path.
    AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    _assetExport.outputFileType = @"com.apple.quicktime-movie";
    _assetExport.outputURL = outputFileUrl;
    
    [_assetExport exportAsynchronouslyWithCompletionHandler:
     ^(void ) {
         dispatch_async(dispatch_get_main_queue(), ^{
             [self exportDidFinish:_assetExport];
         });
     }
     ];
}

- (void)exportDidFinish:(AVAssetExportSession*)session
{
    if(session.status == AVAssetExportSessionStatusCompleted){
        NSURL *outputURL = session.outputURL;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
            [library writeVideoAtPathToSavedPhotosAlbum:outputURL
                                        completionBlock:^(NSURL *assetURL, NSError *error){
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                if (error) {
                                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
                                                    [alert show];
                                                }else{
                                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                                                    [alert show];
                                                    //[self loadMoviePlayer:outputURL];
                                                }
                                            });
                                        }];
        }
    }
    audioAsset = nil;
    videoAsset = nil;
    //[activityView stopAnimating];
    //[activityView setHidden:YES];
}
*/

@end
