//
//  WpFollowData.h
//  kBar
//
//  Created by WonLiao on 13/5/9.
//
//

#import <Foundation/Foundation.h>

@interface WpFollowData : NSObject

-(id)initWithDictionary:(NSDictionary *)aDict;

@property (nonatomic,retain) NSString *post_id;         // 歌的 post id
@property (nonatomic,retain) NSString *post_title;      // 歌名
@property (nonatomic,retain) NSString *uid;             // 歌手uid
@property (nonatomic,retain) NSString *user_name;		// 歌手名
@property (nonatomic,retain) NSString *imageURLString;  // 發表者圖片
@property (nonatomic,retain) NSString *post_date;		// 發佈日期
@property (nonatomic,retain) NSString *comment_count;	// 評論數
@property (nonatomic,retain) NSString *flower;			// 獲得花朵數

@end