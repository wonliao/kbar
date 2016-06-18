//
//  DeleteMessageAPI.m
//
// add by wonliao
//

#import "DeleteMessageAPI.h"

@implementation DeleteMessageAPI

- (void)deleteMessageById:(NSString *)messageId {
    [super addGetParameter:@"sid" value:[KKAPI getSID]];
    [super addPostParameter:@"message_id" value:messageId];
    [super connect:@"message/delete"];
}

- (int)parse:(NSData *)data {
    return 0;
}

@end
