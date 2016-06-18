//
//  WpFavoriteData.h
//  kBar
//
//  Created by wonliao on 13/4/1.
//
//

#import <Foundation/Foundation.h>

// wordpress的歌曲關注資料格式
@interface WpFavoriteData : NSObject

-(id)initWithDictionary:(NSDictionary *)aDict;

@property (nonatomic,retain) NSString *follow_state;      // 關注狀態
@property (nonatomic,retain) NSString *follow_count;      // 關注數
@property (nonatomic,retain) NSString *activity_id;       // activity id
@property (nonatomic,retain) NSString *user_id;             // 使用者id


@end
