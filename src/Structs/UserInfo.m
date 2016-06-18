//
//  UserInfo.m
//
// add by wonliao
//


#import "UserInfo.h"

@implementation UserInfo

+ (UserInfo *)initWithDictionary:(NSDictionary *)dict {
    UserInfo * userInfo = [[UserInfo alloc] init];
    [userInfo fillObjectWithDictionary:dict];
    return userInfo;
}

- (void)fillObjectWithDictionary:(NSDictionary *)dict {
    _nickname = [dict objectForKey:@"nickname"];
    _uid = [dict objectForKey:@"user_id"];
    _headImage:[dict objectForKey:@"headpic"];
    _followerCount = [[dict objectForKey:@"follower_count"] intValue];
    _followingCount = [[dict objectForKey:@"following_count"] intValue];
    _recordCount = [[dict objectForKey:@"record_count"] intValue];
    _chorusCount = [[dict objectForKey:@"chorus_count"] intValue];
}

@end
