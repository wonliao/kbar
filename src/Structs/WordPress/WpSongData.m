//
//  WpSongData.m
//  kBar
//
//  Created by wonliao on 13/3/31.
//
//

#import "WpSongData.h"

@implementation WpSongData

@synthesize post_id, post_title, mp3_url, post_content;

-(id)initWithDictionary:(NSDictionary *)aDict
{
    self = [self init];
    if (self){

        self.post_id = [aDict objectForKey:@"POST_ID"];             // 歌曲編號
        self.post_title = [aDict objectForKey:@"POST_TITLE"];       // 歌曲名稱
        self.mp3_url = [aDict objectForKey:@"MP3_URL"];             // 文章的網址
        self.post_content = [aDict objectForKey:@"POST_CONTENT"];   // 歌詞
    }
    return self;
}

@end
