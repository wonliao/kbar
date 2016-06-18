//
//  WpHomepageData.m
//  kBar
//
//  Created by wonliao on 13/3/31.
//
//

#import "WpHomepageData.h"

@implementation WpHomepageData

@synthesize post_id, post_title, singer_name, img_url;

-(id)initWithDictionary:(NSDictionary *)aDict
{
    self = [self init];
    if (self){

        self.post_id = [aDict objectForKey:@"POST_ID"];             // 歌曲編號
        self.post_title = [aDict objectForKey:@"POST_TITLE"];       // 歌曲名稱
        self.singer_name = [aDict objectForKey:@"SINGER_NAME"];     // 歌手名
        self.singer_uid = [aDict objectForKey:@"SINGER_UID"];       // 歌手的 fb_id
        self.img_url = [aDict objectForKey:@"IMG_URL"];             // 圖片
    }
    return self;
}

@end
