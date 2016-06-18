//
//  WpFavoriteData.m
//  kBar
//
//  Created by wonliao on 13/4/1.
//
//

#import "WpFavoriteData.h"

@implementation WpFavoriteData

@synthesize follow_state, follow_count;

-(id)initWithDictionary:(NSDictionary *)aDict
{
    self = [self init];
    if (self){
        
        self.follow_state = [aDict objectForKey:@"FOLLOW_STATE"];       // 關注狀態
        self.follow_count = [aDict objectForKey:@"FOLLOW_COUNT"];       // 關注數
        self.activity_id = [aDict objectForKey:@"ACTIVITY_ID"];         // activity id
        self.user_id = [aDict objectForKey:@"USER_ID"];                 // 使用者id
    }
    return self;
}

@end
