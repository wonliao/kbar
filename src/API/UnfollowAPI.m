//
//  UnfollowAPI.m
//
// add by wonliao
//

#import "UnfollowAPI.h"

@implementation UnfollowAPI

- (void)unfollow:(NSString *)uid {
    [super addGetParameter:@"sid" value:[KKAPI getSID]];
    [super addPostParameter:@"user_id" value:uid];
    [super connect:@"me/unfollow"];
}

@end