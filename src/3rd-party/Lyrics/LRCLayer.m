//
//  LRCView.m
//  AudioTest
//
//  Created by hv on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LRCLayer.h"
#import <CoreText/CoreText.h>
#import "sys/utsname.h"

#define kShadowOffsetY (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 1.0f : 1.0f)
#define kShadowBlur (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 1.0f : 1.0f)
#define kStrokeSize (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 1.0f : 1.0f)

@implementation LRCLineLayer
@synthesize startTime, endTime, nextTime, currentTime, TT;

- (id)init
{
    self = [super init];
    if (self) {

        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

        self.font = @"Verdana";
        self.fontSize = FONT_SIZE;
        self.backgroundColor = [UIColor clearColor].CGColor;
        self.shadowColor = [UIColor clearColor].CGColor;
        self.shadowOffset = CGSizeMake(1, 1);
        self.shadowOpacity = 1.0;
        self.alignmentMode = kCAAlignmentCenter;
        self.shadowRadius =10.0;
        self.foregroundColor = [UIColor darkGrayColor].CGColor;
        self.startTime = 0;
        self.string = NULL;

        m_wordPitchArrayList = [[NSMutableArray alloc] init];

        // 漸層字
        {
            lbl = [[THLabel alloc] initWithFrame:CGRectMake(0 , 0, 320, 25)];
            // 置中
            lbl.textAlignment = NSTextAlignmentCenter;
            // 藍字
            [lbl setGradientStartColor:[UIColor colorWithRed:27.0f / 255.0f green:11.0f / 255.0f blue:152.0f / 255.0f alpha:1.0f]];
            // 白底
            [lbl setGradientEndColor:[UIColor colorWithRed:255.0f / 255.0f green:255.0f / 255.0f blue:255.0f / 255.0f alpha:1.0f]];

            // iPod4 不做陰影及描邊
            NSRange search = [deviceString rangeOfString:@"iPod4"];
            if( search.length <= 0 ) {

                // 陰影
                [lbl setShadowColor:[UIColor colorWithWhite:0.0f alpha:0.75f]];
                [lbl setShadowOffset:CGSizeMake(0.0f, kShadowOffsetY)];
                [lbl setShadowBlur:kShadowBlur];
/*
                // 描邊
                [lbl setStrokePosition:THLabelStrokePositionOutside];
                [lbl setStrokeColor:[UIColor colorWithRed:255.0f / 255.0f green:255.0f / 255.0f blue:255.0f / 255.0f alpha:1.0f]];
                [lbl setStrokeSize:kStrokeSize];
*/
            }

            [lbl setFont:[UIFont systemFontOfSize:FONT_SIZE+2]];
            [self addSublayer:lbl.layer];
        }
    }

    return self;
}

- (void)setContentString:(NSString *)text WithLyricsTime:(NSMutableArray*)times
{
    tempString = [[NSString alloc] initWithString:text];
    self.string = tempString;

    lyricsTime = [[NSMutableArray alloc]init];
    for(NSNumber *lrcLine in times) {

        [lyricsTime addObject: lrcLine ];
    }
}

- (void)checkLyricTime:(NSInteger)time
{
    [self hilightcolortimer:time];
}

- (void)hilightcolortimer:(NSInteger)time
{
    currentTime = time;

    if( currentTime >= nextTime && TT < [lyricsTime count] ) {

        if( TT == [lyricsTime count]-1 ) {

            nextTime = endTime;
        } else {

            NSNumber* number = [lyricsTime objectAtIndex:TT+1];
            nextTime = [ number integerValue];
        }

        TT++;
    }
}

- (void)clearColor
{
    self.shadowColor = [UIColor clearColor].CGColor;
    self.string = tempString;
    self.foregroundColor = [UIColor grayColor].CGColor;

    [lbl removeFromSuperview];
}

- (void)changeCurrentWord
{
    self.string = NULL;
    lbl.text = tempString;
    [lbl setGradientStartPoint:CGPointMake(0.0f, 1.0f)];
    [lbl setGradientEndPoint:CGPointMake(0.01f, 1.0f)];
    //NSLog( @"lbl.text(%@)", lbl.text);
}

- (void)updateWordPercent
{
    // 漸層字
    float diff = nextTime - currentTime;
    if( diff > 0 ) {

        float oneWordPercent = 1.0f / [lyricsTime count];

        float number1 = 0.0f;
        if( TT == 0 ) {

            number1 = startTime;
        } else {

            number1 = [[lyricsTime objectAtIndex:TT-1] floatValue];
        }

        float number2 = 0.0f;
        if( TT == [lyricsTime count]-1 ) {

            number2 = endTime;
        } else {

            number2 = [[lyricsTime objectAtIndex:TT] floatValue];
        }

        float totalTime = number2 - number1;
        float percet = (totalTime - diff) / totalTime;
        float currentPercent = (TT * oneWordPercent) + ( percet * oneWordPercent);
        //NSLog(@"currentPercent(%f)", currentPercent);

        if( currentPercent > 0 ) {

            // 漸層
            [lbl setGradientStartPoint:CGPointMake(currentPercent, 1.0f)];
            [lbl setGradientEndPoint:CGPointMake(currentPercent+0.01f, 1.0f)];

            [lbl setNeedsDisplay];
        }
    }
}

@end

@implementation LRCView
@synthesize lineLayers;
@synthesize currentLine;
@synthesize totalLine;
@synthesize hilightcolor;
@synthesize endTime;

- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {

        // Initialization code
        self.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.position = CGPointMake(frame.origin.x+frame.size.width/2, frame.origin.y+frame.size.height/2);
        self.backgroundColor = [UIColor clearColor].CGColor;
        lineLayers = [[NSMutableArray alloc] initWithCapacity:0];
        totalLine = 0;
        currentLine = 0;
        margin = self.frame.origin.y;
    }

    return self;
}

- (void)setLineLayers:(NSMutableArray *)lineLayers_
{
    totalLine = lineLayers_.count;
    for (int i =0; i<lineLayers_.count; i++) {

        LRCLineObject *lineObject = (LRCLineObject*)[lineLayers_ objectAtIndex:i];
        LRCLineLayer *lineLayer = [[LRCLineLayer alloc] init];

        [lineLayer setContentString:lineObject.lrc WithLyricsTime:lineObject.lyricsTime];
        lineLayer.startTime = lineObject.startTime;
        lineLayer.endTime = lineObject.endTime;
        lineLayer.nextTime = [[lineObject.lyricsTime objectAtIndex:0] intValue]; //lineObject.startTime;
        lineLayer.TT = 0;

        lineLayer.bounds = CGRectMake(0, 0, self.bounds.size.width, FONT_SIZE+6);
        lineLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height*8/10+FONT_SIZE*i);
        [self addSublayer:lineLayer];
        [lineLayers addObject:lineLayer];

        [lineLayer release];
    }
    
    endTime = ((LRCLineObject*)[lineLayers_ lastObject]).startTime;
}

//显示更新
- (void)updateLRCLineLayer:(NSInteger)TimeRecord
{
    //int score = -1;
    
    LRCLineLayer *next = (LRCLineLayer*)[lineLayers objectAtIndex:currentLine];
    LRCLineLayer *last = nil;
    

    if (currentLine>0) {
        
        last = (LRCLineLayer*)[lineLayers objectAtIndex:currentLine-1];

        // 逐字歌詞
        [last checkLyricTime:TimeRecord];

        // 漸層字
        [last updateWordPercent];
    }

    // 逐句歌詞
    if (TimeRecord>=next.startTime) {

        // 往上捲動
        [self scrollRectToVisible:CGRectMake(self.frame.origin.x, margin+FONT_SIZE*currentLine, self.frame.size.width, self.frame.size.height+10)];

        // 漸層字
        [next changeCurrentWord];

        // 把之前的文字變色
        [last clearColor];

        currentLine++;
    }

    // 全部播放完畢
    if (TimeRecord>=endTime){

        [self scrollRectToVisible:CGRectMake(self.frame.origin.x, margin, self.frame.size.width, self.frame.size.height+10)];
        [next clearColor];

        currentLine = 0;
    }
}

- (void)dealloc{

	[lineLayers release];
    [super dealloc];
}

- (void)reset:(NSMutableArray *)lineLayers_
{
    totalLine = 0;
    currentLine = 0;
    margin = self.frame.origin.y;

    totalLine = lineLayers_.count;
    for (int i =0; i<lineLayers_.count; i++) {

        LRCLineObject *lineObject = (LRCLineObject*)[lineLayers_ objectAtIndex:i];
        LRCLineLayer *lineLayer = [lineLayers objectAtIndex: i];
        
        [lineLayer removeFromSuperlayer];
    }
    
    endTime = ((LRCLineObject*)[lineLayers_ lastObject]).startTime;
}

@end
