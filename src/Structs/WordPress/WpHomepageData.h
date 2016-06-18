//
//  WpHomepageData.h
//  kBar
//
//  Created by wonliao on 13/3/31.
//
//

#import <Foundation/Foundation.h>

// wordpress的首頁資料格式
@interface WpHomepageData : NSObject

-(id)initWithDictionary:(NSDictionary *)aDict;

@property (nonatomic,retain) NSString *post_id;         // 歌曲編號
@property (nonatomic,retain) NSString *post_title;      // 歌曲名稱
@property (nonatomic,retain) NSString *singer_name;     // 歌手名
@property (nonatomic,retain) NSString *singer_uid;      // 歌手的 fb_id
@property (nonatomic,retain) NSString *img_url;         // 圖片

@end
