//
//  LRCParser.h
//  EasyChinese
//
//  Created by wcrane on 11-7-21.
//  Copyright 2011 SGP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRCLineObject : NSObject
{
	NSString	*lrc;               // 歌詞
    
	NSInteger	startTime;          // 開始時間
    NSInteger   endTime;            // 結束時間
    NSMutableArray  *lyricsTime;    // 逐字時間
}
@property (nonatomic, retain) NSString	*lrc;


@property (nonatomic, assign) NSInteger startTime;
@property (nonatomic, assign) NSInteger endTime;
@property (nonatomic, strong) NSMutableArray *lyricsTime;


- (NSComparisonResult)timeSort:(LRCLineObject*)lineObject;
@end


@interface LRCParser : NSObject{
	NSString	*author;
	NSString 	*title;
	NSString 	*album;
	NSString 	*byWorker;
	NSInteger 	offset;
	NSMutableArray *lrcArray;
	NSInteger	currentLine;
	NSInteger	totalLine;
    
    float    diff_time;
}
@property (nonatomic, retain) NSString	*author;
@property (nonatomic, retain) NSString	*title;
@property (nonatomic, retain) NSString 	*album;
@property (nonatomic, retain) NSString 	*byWorker;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, retain) NSMutableArray *lrcArray;
@property (nonatomic, assign) NSInteger	currentLine;
@property (nonatomic, assign) NSInteger	totalLine;
@property (nonatomic,assign) NSInteger endTime;
@property (nonatomic,assign) float diff_time;

- (void)parseLRC:(NSString*)lrcContent;
@end
