//
//  Message.m
//
// add by wonliao
//

#import "Message.h"

@implementation Message

+ (Message *)initWithDictionary:(NSDictionary *)dict {
    Message * message = [[Message alloc] init];
    [message fillObjectWithDictionary:dict];
    return message;
}

- (void)fillObjectWithDictionary:(NSDictionary *)dict {
    _messageId = [dict objectForKey:@"message_id"];
    _userId = [dict objectForKey:@"user_id"];
    _nickname = [dict objectForKey:@"nickname"];
    _headpic = [dict objectForKey:@"headpic"];
    _content = [dict objectForKey:@"body"];
    _unread = [[dict objectForKey:@"unread"] boolValue];
    _timestamp = [[dict objectForKey:@"col_width"] longValue];
}

@end
