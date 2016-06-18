#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "LRCParser.h"
#import "THLabel.h"

#define FONT_SIZE  19


@interface LRCLineLayer:CATextLayer
{
@public
    NSInteger startTime;
    NSInteger endTime;

    CFNumberRef cfNum;
    CGColorRef hilightcolor;
    NSInteger TT;

    NSString *tempString;           // 歌詞
    NSMutableArray  *lyricsTime;    // 逐字時間

    // for pitch
    NSInteger currentTime;
    NSInteger nextTime;
    NSMutableArray *m_wordPitchArrayList;

    // 卡拉OK字幕
    THLabel *lbl;
}

@property(nonatomic,assign)NSInteger startTime;
@property(nonatomic,assign)NSInteger endTime;
@property(nonatomic,assign)NSInteger nextTime;
@property(nonatomic,assign)NSInteger currentTime;
@property(nonatomic,assign)NSInteger TT;

- (id)init;
- (void)clearColor;
- (void)setContentString:(NSString *)text WithLyricsTime:(NSMutableArray*)times;
- (void)checkLyricTime:(NSInteger)time;
- (void)changeCurrentWord;
- (void)updateWordPercent;
@end



@interface LRCView : CAScrollLayer
{
    NSMutableArray *lineLayers;
    NSInteger totalLine;
    NSInteger currentLine;
    float  margin;

}

- (id)initWithFrame:(CGRect)frame;
- (void)setLineLayers:(NSMutableArray *)lineLayers_;
- (void)updateLRCLineLayer:(NSInteger)TimeRecord;
- (void)reset:(NSMutableArray *)lineLayers_;


@property (nonatomic,retain) NSMutableArray *lineLayers;
@property (nonatomic,assign) NSInteger endTime;
@property (nonatomic,assign) NSInteger	currentLine;
@property (nonatomic,assign) NSInteger	totalLine;
@property (nonatomic,assign) CGColorRef hilightcolor;
@end
