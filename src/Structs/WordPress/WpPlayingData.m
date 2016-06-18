//
//  WpPlayingData.m
//  kBar
//
//  Created by wonliao on 13/3/29.
//
//

#import "WpPlayingData.h"

@implementation WpPlayingData

@synthesize post_id, post_title, mp3_url, flower, post_content, followed, follow_count, singer_name, singer_lv, singer_uid, singer_img;

-(id)initWithDictionary:(NSDictionary *)aDict
{
    self = [self init];
    if (self){
        
        self.post_id = [aDict objectForKey:@"POST_ID"];             // 歌曲編號
        self.post_title = [aDict objectForKey:@"POST_TITLE"];       // 歌曲名稱
        self.mp3_url = [aDict objectForKey:@"MP3_URL"];             // 文章的網址
        self.flower = [aDict objectForKey:@"FLOWER"];               // 花朵數
        self.post_content = [aDict objectForKey:@"POST_CONTENT"];   // 歌詞
        self.followed = [aDict objectForKey:@"FOLLOWED"];           // 是否已關注
        self.follow_count = [aDict objectForKey:@"FOLLOW_COUNT"];   // 關注數
        self.singer_name = [aDict objectForKey:@"SINGER_NAME"];     // 歌手名
        self.singer_lv = [aDict objectForKey:@"SINGER_LV"];         // 歌手等級
        self.singer_uid = [aDict objectForKey:@"SINGER_UID"];       // 歌手fb uid
        self.singer_img = [aDict objectForKey:@"SINGER_IMG"];       // 歌手上傳圖片
    }
    return self;
}

@end
