//
//  WpPlayingData.h
//  kBar
//
//  Created by wonliao on 13/3/29.
//
//

#import <Foundation/Foundation.h>

// wordpress的播放歌曲資料格式
@interface WpPlayingData : NSObject

-(id)initWithDictionary:(NSDictionary *)aDict;

@property (nonatomic,retain) NSString *post_id;         // 歌曲編號
@property (nonatomic,retain) NSString *post_title;      // 歌曲名稱
@property (nonatomic,retain) NSString *mp3_url;         // 文章的網址
@property (nonatomic,retain) NSString *flower;          // 花朵數
@property (nonatomic,retain) NSString *post_content;    // 歌詞
@property (nonatomic,retain) NSString *followed;        // 是否已關注
@property (nonatomic,retain) NSString *follow_count;    // 關注數
@property (nonatomic,retain) NSString *singer_name;     // 歌手名
@property (nonatomic,retain) NSString *singer_lv;       // 歌手等級
@property (nonatomic,retain) NSString *singer_uid;      // 歌手fb uid
@property (nonatomic,retain) NSString *singer_img;      // 歌手上傳圖片

@end