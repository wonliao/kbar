//
//  WpFollowData.m
//  kBar
//
//  Created by WonLiao on 13/5/9.
//
//

#import "WpFollowData.h"

@implementation WpFollowData

@synthesize post_id, post_title, uid, user_name, imageURLString, post_date, comment_count, flower;

-(id)initWithDictionary:(NSDictionary *)aDict
{
    self = [self init];
    if (self){
        
        self.post_id = [aDict objectForKey:@"ID"];                      // 歌的 post id
        self.post_title = [aDict objectForKey:@"POST_TITLE"];           // 歌名
        
        self.uid = [aDict objectForKey:@"UID"];                         // 歌手uid
        self.imageURLString = [NSString stringWithFormat:@"http://54.200.150.53/kbar/wp-content/uploads/photos/%@.jpg", self.uid];

        self.user_name = [aDict objectForKey:@"USER_NAME"];             // 歌手名
        self.post_date = [aDict objectForKey:@"POST_DATE"];             // 發佈日期
        self.comment_count = [aDict objectForKey:@"COMMENT_COUNT"];     // 評論數
        self.flower = [aDict objectForKey:@"FLOWER"];                   // 獲得花朵數
    }
    return self;
}

@end
