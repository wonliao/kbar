//
//  WpRankngData.h
//  kBar
//
//  Created by wonliao on 13/4/17.
//
//

#import <Foundation/Foundation.h>

@interface WpRankngData : NSObject

-(id)initWithDictionary:(NSDictionary *)aDict;

@property (nonatomic, retain) NSString* post_id;        // 歌的 post_id
@property (nonatomic, retain) NSString* author;         // 發表者名稱
@property (nonatomic, retain) NSString* uid;            // 發表者uid
@property (nonatomic, retain) NSString* imageURLString; // 發表者圖片
@property (nonatomic, retain) NSString* date;           // 日期
@property (nonatomic, retain) NSString* title;          // 歌名
@property (nonatomic, retain) NSString* flower;         // 花朵數

@end
