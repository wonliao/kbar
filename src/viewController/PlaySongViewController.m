//
//  PlaySongViewController.m
//  myFans
//
//  Created by wonliao on 13/1/22.
//
//
#import <MediaPlayer/MediaPlayer.h>
#import "PlaySongViewController.h"
#import "AIAnimationQueue.h"
#import "Playing.h"     // 目前播放歌的資料庫互動類別




#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0];


@interface PlaySongViewController ()


- (CGFloat) viewWidth;
@property (weak, nonatomic) IBOutlet UIImageView *photo1;
@property (weak, nonatomic) IBOutlet UIImageView *photo2;
@property (weak, nonatomic) IBOutlet UIImageView *photo3;
@property (weak, nonatomic) IBOutlet UIImageView *photo4;
@property (weak, nonatomic) IBOutlet UIImageView *photo5;

@end

@implementation PlaySongViewController

@synthesize imageView1, imageView2, m_wordpress, player, m_post_id, myView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }

    return self;
}

-(void)perpareSongData
{
    // 從 wordpress 取得 歌曲資料
    //[self getDataFromWordpress];

    // 設定歌手頭像輪播
    //[self animationImage];

    // 設定子視窗資料
    //[self setChildView];

    // 設定花朵數
    //[pagePhotosView setFlower:[m_wpPlayingData.flower intValue]];

    // 設定關注狀態文字
    //[pagePhotosView setFollowLabel:[m_wpPlayingData.followed boolValue] AndCount:[m_wpPlayingData.follow_count intValue]];

    [pagePhotosView setSongData:m_wpPlayingData.post_title with:m_wpPlayingData.singer_name andMp3:m_wpPlayingData.mp3_url];
    
    // Thread 結束後回呼 loadComplete 函式
    [self performSelectorOnMainThread:@selector(loadComplete) withObject:nil waitUntilDone:NO];
}

- (void)loadComplete
{
    // 載入歌詞
    [self loadKscContent];

    player = [[KKMediaPlayer alloc] initWithContentURL:[NSURL URLWithString:m_wpPlayingData.mp3_url]];

    // 檢查是否有影片
    [self checkPlayVideo];

    [player play];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self checkFacebook];

    self.m_wordpress = [[wordpress alloc] init];

    m_coreData = [[CoreData alloc] init];

    // 取得目前播放歌的資料庫
    [self loadRecordData];

    // 從 wordpress 取得 歌曲資料
    [self getDataFromWordpress];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"Update"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"PauseSong"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"PlaySong"
                                               object:nil];

    pagePhotosView = [[PagePhotosView alloc] initWithFrame: CGRectMake(0, 320, 320, 140) withDataSource: self andPostID:m_post_id];
	[self.view addSubview:pagePhotosView];
    pagePhotosView.delegate = self;

    state = 0;
    imagenumber = 0;

    UITapGestureRecognizer *singleTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapToControlPanel)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:singleTap];

    ControlPanel *nvView2 = [[ControlPanel alloc] initWithWidth:325];
    controlPanel = nvView2;
    [controlPanel setTitle:@"控制板"];
    [controlPanel setIcon:[UIImage imageNamed:@"photo_s"]];
    CGRect f2 = controlPanel.frame;
    f2.origin.x = [self viewWidth] - f2.size.width +2;
    f2.origin.y = -f2.size.height+320+70;
    controlPanel.frame = f2;
    controlPanel.alpha = 0.0;
    [self.view addSubview:controlPanel];

    CGRect frame = CGRectMake(10.0, 304.0, 300.0, 10.0);
    timeSlider = [[UISlider alloc] initWithFrame:frame];
    [timeSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [timeSlider setBackgroundColor:[UIColor clearColor]];
    timeSlider.minimumValue = 0.0;
    timeSlider.maximumValue = 1.0;
    timeSlider.continuous = YES;
    timeSlider.value = 0.0;
    timeSlider.alpha = 0.0;
    [self.view addSubview:timeSlider];

    UIImage *image = [UIImage imageNamed:@"rose.png"];
    CGRect frame2 = CGRectMake(110, 354, 20, 20);
    imageView1.opaque = NO; // 設定為透明背景
    imageView1.frame = frame2;
    imageView1.image = image;
}

-(IBAction)sliderValueChanged:(UISlider *)sender
{
    NSTimeInterval currentTime = player.duration * (double)(sender.value / sender.maximumValue);
    NSLog(@"slider value = %f", currentTime);

    // seek and play
    if (player.playbackState == MPMoviePlaybackStatePlaying) {

        [player pause];
    }

    [player setCurrentPlaybackTime:currentTime];
    [player play];

    // 動態歌詞返回一開頭
    lecLayer.currentLine = 0;
}

// 送花效果
- (void)selectorTests
{
    [self.view addSubview:imageView1];
	AIAnimationQueue *animationQueue = [AIAnimationQueue sharedInstance];

	// Animations with Selectors (iOS 3.2 and lower)
	[animationQueue addAnimation:@selector(moveDown) target:self];
	//[animationQueue addAnimation:@selector(moveRight) target:self];
	[animationQueue addAnimation:@selector(moveUp) target:self];
	[animationQueue addAnimation:@selector(moveLeft) target:self];
    [animationQueue addAnimation:@selector(moveRight) target:self];
	[animationQueue addAnimation:@selector(samePlace) target:self];
}

// 按下 送花 鈕
- (void)receiveNotification:(NSNotification*)notification
{
    if( [notification.name isEqual: @"Update"] ) {
    
        [NSThread detachNewThreadSelector:@selector(selectorTests) toTarget:self withObject:nil];
    } else if( [notification.name isEqual: @"PauseSong"] ) {
        
        [player pause];
    } else if( [notification.name isEqual: @"PlaySong"] ) {
        
        [player play];
    }
}

//#endif

- (void)moveTo:(NSValue *)rect
{
	[UIView setAnimationDuration:2.0];
    imageView1.frame = [rect CGRectValue];
}

- (void)moveDown
{
	[UIView setAnimationDuration:0.3];
    imageView1.frame = CGRectMake(112, 359, 20, 20);
}

- (void)downContinuation {
}

- (void)moveRight
{
	[UIView setAnimationDuration:0.0];
    imageView1.frame = CGRectMake(116, 358, 0, 0);
}

- (void)rightContinuation
{
}

- (void)moveUp
{
	[UIView setAnimationDuration:1.2];
    imageView1.frame = CGRectMake(100, 120, 150, 150);
}

- (void)upContinuation
{
}

- (void)moveLeft
{
	[UIView setAnimationDuration:0.6];
    imageView1.frame = CGRectMake(30, 300, 0, 0);
}

- (void)leftContinuation
{
}

- (void)samePlace
{
	[UIView setAnimationDuration:2.0];
    imageView1.frame = imageView1.frame;
}

- (void)samePlaceContinuation
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (CGFloat) viewWidth
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGFloat width = self.view.frame.size.width;

    if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft) {
        width = self.view.frame.size.height;
    }

    return width;
}

- (IBAction)touchScreen:(id)sender
{
    if (state == 0) {

        [UIView animateWithDuration:0.4 animations:^{nv.frame = CGRectOffset(nv.frame, 0.0, nv.frame.size.height); }
                         completion:^(BOOL finished) {
                         }];

        [UIView animateWithDuration:0.4
                         animations:^{nv.alpha = 0.0;}
                         completion:^(BOOL finished){ [nv removeFromSuperview]; }];

        [UIView animateWithDuration:0.3 animations:^{controlPanel.frame = CGRectOffset(controlPanel.frame, 0.0, controlPanel.frame.size.height-70.0); }
                         completion:^(BOOL finished) {
                         }];

        [UIView animateWithDuration:0.3
                         animations:^{controlPanel.alpha = 1;}
                         completion:^(BOOL finished){ [self.view addSubview:controlPanel]; }];

        [UIView animateWithDuration:0.4 animations:^{timeSlider.frame = CGRectOffset(timeSlider.frame, 0.0, 0.0); }
                         completion:^(BOOL finished) {
                         }];

        [UIView animateWithDuration:0.4
                         animations:^{timeSlider.alpha = 1;}
                         completion:^(BOOL finished){ [self.view addSubview:timeSlider]; }];

        state = 1;
    } else {

        [UIView animateWithDuration:0.4 animations:^{nv.frame = CGRectOffset(nv.frame, 0.0, -nv.frame.size.height); }
                         completion:^(BOOL finished) {
                         }];

        [UIView animateWithDuration:0.4
                         animations:^{nv.alpha = 1;}
                         completion:^(BOOL finished){ [self.view addSubview:nv]; }];

        [UIView animateWithDuration:0.4 animations:^{controlPanel.frame = CGRectOffset(controlPanel.frame, 0.0, -controlPanel.frame.size.height+70); }
                         completion:^(BOOL finished) {
                         }];

        [UIView animateWithDuration:0.4
                         animations:^{controlPanel.alpha = 0.0;}
                         completion:^(BOOL finished){ [controlPanel removeFromSuperview]; }];

        [UIView animateWithDuration:0.4 animations:^{timeSlider.frame = CGRectOffset(timeSlider.frame, 0.0, 0.0); }
                         completion:^(BOOL finished) {
                         }];

        [UIView animateWithDuration:0.4
                         animations:^{timeSlider.alpha = 0.0;}
                         completion:^(BOOL finished){ [timeSlider removeFromSuperview]; }];
        state = 0;
    }
}

- (void)tapToControlPanel
{
    [self performSelector:@selector(touchScreen:)
               withObject:nil afterDelay:0.0f];
}

- (IBAction)closeButtonTapped:(id)sender
{
    [player stop];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)performTransition:(UIViewAnimationOptions)options
{
    UIView *fromView, *toView;
    //NSLog(@"#perform imagenumber= %d", imagenumber);

    switch (imagenumber) {
        case 0:
            fromView = self.photo1;
            toView = self.photo2;
            break;
        case 1:
            fromView = self.photo2;
            toView = self.photo3;
            break;
        case 2:
            fromView = self.photo3;
            toView = self.photo4;
            break;
        case 3:
            fromView = self.photo4;
            toView = self.photo5;
            break;
        case 4:
            fromView = self.photo5;
            toView = self.photo1;
            break;
        default:
            break;
    }

    [UIView transitionFromView:fromView
                        toView:toView
                      duration:1.0
                       options:options
                    completion:^(BOOL finished) {
                        // animation completed
                    }];
}

- (int)numberOfPages
{
	return 2;
}

// 每页的图片
- (UIImage *)imageAtIndex:(int)index
{
	NSString *imageName = [NSString stringWithFormat:@"function_%d.png", index + 1];
	return [UIImage imageNamed:imageName];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [timer invalidate];
}

- (void)viewDidUnload
{
    [self setPhoto1:nil];
    [self setPhoto2:nil];
    [self setPhoto3:nil];
    [self setPhoto4:nil];
    [self setPhoto5:nil];

    [timer invalidate];

    [self setImageView1:nil];
    [super viewDidUnload];
}

// 從資料庫中讀取資料
- (void) loadRecordData
{
    Playing *currentPlaying = [m_coreData loadDataFromPlaying];
    if( currentPlaying ) {

        m_post_id = currentPlaying.post_id;
    }
}

// 從 wordpress 取得 歌曲資料
-(void)getDataFromWordpress
{
    NSString *query = [NSString stringWithFormat:@"playing.php?song_id=%@&uid=%@", m_post_id, m_FbCoreData.fbUID];
    [m_wordpress queryWordpress:query completion:^(NSArray *parsedElements){

        if( [parsedElements count] > 0 ) {

            NSDictionary *aModuleDict = [parsedElements objectAtIndex:0];
            m_wpPlayingData = [[WpPlayingData alloc] initWithDictionary:aModuleDict];

            [self perpareSongData];
        }
    }];
}

// 設定子視窗資料
- (void) setChildView
{
    // 子視窗
    ControlPanelMini *nvView = [[ControlPanelMini alloc] initWithWidth:325];
    nv = nvView;
    [nv setTitle: m_wpPlayingData.post_title];
    [nv setDetail:[NSString stringWithFormat:@"%@ Lv:3 走唱歌手", m_wpPlayingData.singer_name ]]; // this will update the nv height

    // 設定歌手頭像
    [m_wordpress getUserImage:m_wpPlayingData.singer_uid completion:^(UIImage *image){
        
        [nv setIcon:image];
    }];

    CGRect f = nv.frame;
    f.origin.x = [self viewWidth] - f.size.width +2;
    f.origin.y = -f.size.height+320;
    nv.frame = f;
    [self.view addSubview:nv];
}

// 圖片異步下載
void UIImageFromURL4( NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) )
{
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void) {
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

// 設定歌手頭像輪播
- (void) animationImage
{
    NSArray *listItems = [m_wpPlayingData.singer_img componentsSeparatedByString:@","];
    int singerImgCount = [listItems count];//[m_wpPlayingData.singer_img_count intValue];
    if( singerImgCount <= 0 ) {

        m_UserImages = [NSMutableArray arrayWithObjects:
                            [UIImage imageNamed:@"singCanvas1.png"],
                            [UIImage imageNamed:@"singCanvas2.png"],
                            [UIImage imageNamed:@"singCanvas3.png"],
                            [UIImage imageNamed:@"singCanvas4.png"],
                            nil];

        //imageView的动画图片是数组images
        imageView2.animationImages = m_UserImages;

        //按照原始比例缩放图片，保持纵横比
        imageView2.contentMode = UIViewContentModeRedraw;

        // 全部跑完的時間
        imageView2.animationDuration = 16.0;

        //动画的重复次数，想让它无限循环就赋成0
        imageView2.animationRepeatCount = 0;

        //开始动画
        [imageView2 startAnimating];
    } else {

        NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

        //定义数组，存放所有图片对象
        m_UserImages = [[NSMutableArray alloc] init];

        m_count = 0;
        for(int i=0; i<singerImgCount; i++ ) {

            NSString *index = listItems[i];
            NSString *fileName = [NSString stringWithFormat:@"FB_%@_%@.jpg", m_wpPlayingData.singer_uid, index];

            // 檢查圖檔是否已暫存
            NSString* imgFileUrl = [documentsPath stringByAppendingPathComponent:fileName];
            BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:imgFileUrl];
            if( fileExists == NO ) {

                NSString *imgURL = [NSString stringWithFormat:@"http://54.200.150.53/kbar/wp-content/uploads/photos/%@", fileName];

                // 從 wordpress 下載圖檔
                UIImageFromURL4( [NSURL URLWithString:imgURL], ^( UIImage * image ) {

                    //將圖片存到 documents 目錄中
                    NSString *uniquePath=[documentsPath stringByAppendingPathComponent:fileName];
                    [UIImagePNGRepresentation(image)writeToFile:uniquePath atomically:YES];

                    [m_UserImages addObject:image];

                    m_count++;
                }, ^(void){

                    NSLog(@"UIImageFromURL4 error!");
                });
            } else {

                UIImage* image = [UIImage imageWithContentsOfFile:imgFileUrl];
                [m_UserImages addObject:image];
                m_count++;
            }
        }

        timer2 = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(waitUserImage:) userInfo:nil repeats:YES];
    }
}

-(void)waitUserImage:(NSTimer*)TimeRecord
{
    NSArray *listItems = [m_wpPlayingData.singer_img componentsSeparatedByString:@","];
    int singerImgCount = [listItems count];
    //int singerImgCount = [m_wpPlayingData.singer_img_count intValue];
    if (m_count >= singerImgCount ) {

        //imageView的动画图片是数组images
        imageView2.animationImages = m_UserImages;

        //按照原始比例缩放图片，保持纵横比
        imageView2.contentMode = UIViewContentModeRedraw;

        // 全部跑完的時間
        imageView2.animationDuration = 16.0;

        //动画的重复次数，想让它无限循环就赋成0
        imageView2.animationRepeatCount = 0;
        
        //开始动画
        [imageView2 startAnimating];

        [timer2 invalidate];
    }
}

//  動態背景圖 fadeIn/fadeOut 效果
-(void)onTimer
{
    [UIView animateWithDuration:3.0 animations:^{
        imageView2.alpha = 0.0;
    }];

    [UIView animateWithDuration:1.0 animations:^{
        imageView2.alpha = 1.0;
    }];
}

// 準備歌曲資料
- (void) loadKscContent
{
    // 解析 KSC 檔
    LRCParser *tmpParser = [[LRCParser alloc] init];
    [tmpParser parseLRC:m_wpPlayingData.post_content];

    // Layer 處理
    lecLayer = [[LRCView alloc] initWithFrame:CGRectMake(0, 20, 320, 218)];
    [lecLayer setLineLayers:tmpParser.lrcArray];

    [self.view.layer addSublayer:lecLayer];
    [self startTimer];
}

// 取得音樂播放時間及更新動態歌詞
- (void)updateTT:(NSTimer*)TimeRecord
{
    // 取得音樂播放時間
    double cTime;
    double avg = -50.0f;
    cTime = [player currentPlaybackTime];

    // 更新動態歌詞
    m_currentTime = (int)(cTime * 1000);
    //[lecLayer updateLRCLineLayer:m_currentTime AndAvg:avg AndFrequency:0];
    [lecLayer updateLRCLineLayer:m_currentTime];
    timeSlider.value = cTime / player.duration;

    // 音樂播放完畢時
    if(player.playbackState == MPMoviePlaybackStatePlaying && cTime > 0 && [m_videoPlayer rate] == 0.0) {

        CMTime newTime =CMTimeMake(cTime * 44100, 44100);
        [m_videoPlayer seekToTime:newTime];
        [m_videoPlayer play];
    } else if(player.playbackState == MPMoviePlaybackStatePlaying ) {

        if( fabsf(cTime - m_videoCurrentTime) > 1.0 ) {

            //CMTime test = [m_videoPlayer currentTime];
            CMTime newTime =CMTimeMake(cTime * 44100, 44100);
            [m_videoPlayer seekToTime:newTime];
        }
    } else if(player.playbackState == MPMoviePlaybackStateStopped ||
              player.playbackState == MPMoviePlaybackStatePaused) {

        [m_videoPlayer pause];
    }

    m_videoCurrentTime = cTime;
}

- (void)startTimer
{
    lecLayer.currentLine = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateTT:) userInfo:nil repeats:YES];
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

// 開啟fb登入頁面
- (void)openLoginTop2:(id)sender
{
    NSString *identifier = @"LoginTop2";
    UIViewController *singViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    singViewController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:singViewController animated:YES];
}

// 開啟評論頁
- (void)openComment:(id)sender
{
    NSString *identifier = @"PlaySongComment";
    UIViewController *singViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    singViewController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:singViewController animated:YES];
}

// 錄影
- (void)playVideo
{
    NSString *mp3Url = m_wpPlayingData.mp3_url;
    NSString *movUrl = [mp3Url stringByReplacingOccurrencesOfString:@".m4a" withString:@".mov"];
    NSLog(@"movUrl(%@)", movUrl);

    if( m_videoPlayer == nil ) {

        m_videoPlayer = [AVPlayer playerWithURL:[NSURL URLWithString:movUrl]];
    }
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:movUrl] options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    m_videoPlayer = [AVPlayer playerWithPlayerItem:playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:m_videoPlayer];
    playerLayer.frame = myView.layer.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [myView.layer addSublayer:playerLayer];

    //[m_videoPlayer play];
}

- (void)checkPlayVideo
{
    NSString *mp3Url = m_wpPlayingData.mp3_url;
    NSString *movUrl = [mp3Url stringByReplacingOccurrencesOfString:@".m4a" withString:@".mov"];
    NSLog(@"movUrl(%@)", movUrl);
    
    [self queryResponseForURL:[NSURL URLWithString:movUrl]];
}

- (void)queryResponseForURL:(NSURL *)inURL
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:inURL];
    
    [request setHTTPMethod:@"HEAD"];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
    // connection starts automatically
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // url exists
    if ( [(NSHTTPURLResponse  *)response statusCode] == 200 ) {

        // 播放影片
        [self playVideo];

        myView.hidden = NO;
    }
}


@end