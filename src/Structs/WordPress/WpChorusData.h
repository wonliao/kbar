//
//  WpChorusData.h
//  kBar
//
//  Created by wonliao on 13/4/20.
//
//

#import <Foundation/Foundation.h>

@interface WpChorusData : NSObject

-(id)initWithDictionary:(NSDictionary *)aDict;

@property (nonatomic,retain) NSString *post_id;         // 歌曲 ID
@property (nonatomic,retain) NSString *title;           // 歌名
@property (nonatomic,retain) NSString *singer_id;       // 歌手 ID
@property (nonatomic,retain) NSString *singer_name;     // 歌手名
@property (nonatomic,retain) NSString* imageURLString;  // 歌手圖片
@property (nonatomic,retain) NSString *note;            // 作者備註
@property (nonatomic,retain) NSString *reference_count; // 一起合唱人數


@end
