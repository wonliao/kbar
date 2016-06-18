//
//  FollowAPI.m
//
// add by wonliao
//

#import "FollowAPI.h"

@implementation FollowAPI

- (void)follow:(NSString *)uid {
    [super addGetParameter:@"sid" value:[KKAPI getSID]];
    [super addPostParameter:@"user_id" value:uid];
    [super connect:@"me/follow"];
}

@end
