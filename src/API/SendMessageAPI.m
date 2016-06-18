//
//  SendMessageAPI.m
//
// add by wonliao
//

#import "SendMessageAPI.h"

@implementation SendMessageAPI

- (void)sendMessageToUserId:(NSString *)userId message:(NSString *)message {
    [super addGetParameter:@"sid" value:[KKAPI getSID]];
    [super addPostParameter:@"user_id" value:userId];
    [super addPostParameter:@"message" value:message];
    [super connect:@"message/send"];
}

- (int)parse:(NSData *)data {
    return 0;
}

@end
