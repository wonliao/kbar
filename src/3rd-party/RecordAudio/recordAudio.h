//
//  record_audio_testViewController.h
//  record_audio_test
//
//  Created by jinhu zhang on 11-1-5.
//  Copyright 2011 no. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface RecordAudio:  NSObject <AVAudioRecorderDelegate> {
    
    NSString *outputFileName;
    
	//Variables setup for access in the class:
	NSURL * recordedTmpFile;
	AVAudioRecorder * recorder;
	NSError * error;

	AVAudioPlayer *m_pLongMusicPlayer;

    NSMutableArray* audioMixParams;

    NSMutableArray* roomTypeOrder;
    NSMutableDictionary* roomTypeNames;
    int roomIndex;
    
    CFTimeInterval startTime;
    float duration;
    
    BOOL m_mergeDone;   // 檢查是否合成完成
}

@property (nonatomic,retain) AVAudioPlayer *m_pLongMusicPlayer;
@property (readwrite) BOOL m_mergeDone;
@property (readwrite) CFTimeInterval startTime;
@property (readwrite) float duration;
@property (nonatomic, retain) AVURLAsset* videoAsset;
@property (nonatomic, retain) AVURLAsset* audioAsset;

- (void)playMusic:(NSString*)mp3;                                   // 播放音樂
- (void)stopMusic;                                                  // 停止音樂
- (NSString*)merge2wav:(NSString*)music withRecord:(NSString *)path1;    // 開始合成
- (void)playSong;                                                   // 播放合成之後的歌曲
- (void)stopSong;                                                   // 停止播放合成之後的歌曲
- (void)getCurrentTime:(double*) currentTime getEndTime:(double*)cEndTime;   // 取得目前播放時間
- (void)pause;
- (void)exportDidFinish:(AVAssetExportSession*)session;

@end
