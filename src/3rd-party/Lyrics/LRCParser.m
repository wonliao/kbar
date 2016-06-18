//
//  LRCParser.m
//  EasyChinese
//
//  Created by wcrane on 11-7-21.
//  Copyright 2011 SGP. All rights reserved.
//

#import "LRCParser.h"

@implementation LRCLineObject

@synthesize lrc, startTime, endTime, lyricsTime;

- (id)init
{
	if (self = [super init]) {
		self.lrc = nil;
		self.startTime = 0;
        self.endTime = 0;
        self.lyricsTime = [[NSMutableArray alloc] init];
	}

	return self;
}

- (void)dealloc{

}

- (NSComparisonResult)timeSort:(LRCLineObject*)lineObject
{
	if (self.startTime > lineObject.startTime) {
		return NSOrderedDescending;
	}else if (self.startTime == lineObject.startTime) {
		return NSOrderedSame;
	}else {
		return NSOrderedAscending;
	}
}

@end


@implementation LRCParser
@synthesize author;
@synthesize title;
@synthesize album;
@synthesize byWorker;
@synthesize offset;
@synthesize lrcArray;
@synthesize currentLine;
@synthesize totalLine;
@synthesize endTime;
@synthesize diff_time;


- (id)init
{
	if (self = [super init]) {
		self.author = nil;
		self.title = nil;
		self.album = nil;
		self.byWorker = nil;
		self.offset = 0;
		self.lrcArray = nil;
		self.currentLine = 0;
		self.totalLine = 0;
        self.endTime = 0;
        self.diff_time = 0.0f;
	}
	
	return self;
}

- (void)dealloc
{
}

- (void)parserLRCLine:(NSArray*)lrcLines
{
    // for 倒數321
    //int lastEndTime = 0;

	for(NSString *lrcLine in lrcLines){

		if ([lrcLine length] != 0) {

            LRCLineObject *lineObject = [[LRCLineObject alloc] init];

            NSString *timeString = [[NSString alloc] initWithString:lrcLine];

            NSRange range = [timeString rangeOfString:@"diffTime:"];
            if( range.length > 0 ) {

                diff_time = [[timeString substringFromIndex:range.length] floatValue] * 1000;
            } else {

                timeString = [timeString stringByReplacingOccurrencesOfString:@"karaoke.add(" withString:@""];
                timeString = [timeString stringByReplacingOccurrencesOfString:@"(男:)" withString:@""];
                timeString = [timeString stringByReplacingOccurrencesOfString:@"(女:)" withString:@""];
                timeString = [timeString stringByReplacingOccurrencesOfString:@"(合:)" withString:@""];
                timeString = [timeString stringByReplacingOccurrencesOfString:@"'" withString:@""];
                timeString = [timeString stringByReplacingOccurrencesOfString:@" " withString:@""];
                timeString = [timeString stringByReplacingOccurrencesOfString:@"[" withString:@""];
                timeString = [timeString stringByReplacingOccurrencesOfString:@"]" withString:@""];
                timeString = [timeString stringByReplacingOccurrencesOfString:@")" withString:@""];
                NSLog(@"%@",timeString);

                NSInteger _LastTime = 0;
                NSArray *temp = [timeString componentsSeparatedByString:@","];
                for( int j=0; j<[temp count]; j++ ) {

                    NSString *str = [temp objectAtIndex:j];

                    // begin time
                    if( j == 0 ) {

                        lineObject.startTime = [[str substringWithRange:NSMakeRange(0,2)] intValue];
                        lineObject.startTime = lineObject.startTime*60+[[str substringWithRange:NSMakeRange(3,2)] intValue];
                        lineObject.startTime = lineObject.startTime*1000+[[str substringWithRange:NSMakeRange(6,3)] intValue];
                        lineObject.startTime = lineObject.startTime - diff_time;

                        _LastTime = lineObject.startTime;

                        // for 倒數321
                        /*
                        if( (lineObject.startTime - lastEndTime) >= 5*1000 ) {

                            lineObject.startTime -= 3*1000;
                            _LastTime = lineObject.startTime;

                            for(int i=0; i<3; i++) {

                                NSInteger num1 = 1000;
                                _LastTime += num1;
                                [lineObject.lyricsTime addObject: [NSNumber numberWithInt:_LastTime] ];
                            }

                            lineObject.lrc = @"321";    // 倒數321
                        } else {

                            _LastTime = lineObject.startTime;
                            lineObject.lrc = @"";
                        }
                        */
                    // end time
                    } else if( j == 1 ) {

                        lineObject.endTime = [[str substringWithRange:NSMakeRange(0,2)] intValue];
                        lineObject.endTime = lineObject.endTime*60+[[str substringWithRange:NSMakeRange(3,2)] intValue];
                        lineObject.endTime = lineObject.endTime*1000+[[str substringWithRange:NSMakeRange(6,3)] intValue];
                        lineObject.endTime = lineObject.endTime - diff_time;

                        // for 倒數321
                        //lastEndTime = lineObject.endTime;
                    // 歌詞
                    } else if( j == 2 ) {

                        lineObject.lrc = str;

                        // for 倒數321
                        //lineObject.lrc = [lineObject.lrc stringByAppendingString:str];
                    // 歌詞逐字時間
                    } else {

                        NSInteger num1 = [str intValue];
                        _LastTime += num1;
                        [lineObject.lyricsTime addObject: [NSNumber numberWithInt:_LastTime] ];
                    }
                }

                if (self.lrcArray == nil) {

                    NSMutableArray *lrcTmpArray = [[NSMutableArray alloc] init];
                    self.lrcArray = lrcTmpArray;
                }

                [self.lrcArray addObject:lineObject];
            }
        }
	}

	[self.lrcArray sortUsingSelector:@selector(timeSort:)];

	self.totalLine = [self.lrcArray count];

    self.endTime = ((LRCLineObject*)[self.lrcArray lastObject]).startTime;
}

//split lrc into a array
- (void)parseLRC:(NSString*)lrcContent
{
	NSArray *retArray = [lrcContent componentsSeparatedByString:@";"];
	[self parserLRCLine:retArray];
}

@end
