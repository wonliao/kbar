//
//  Chat.m
//
// add by wonliao
//

#import "Chat.h"

@implementation Chat

+ (Chat *)initWithDictionary:(NSDictionary *)dict {
    Chat * chat = [[Chat alloc] init];
    [chat fillObjectWithDictionary:dict];
    return chat;
}

- (void)fillObjectWithDictionary:(NSDictionary *)dict {
    _chatId =[dict objectForKey:@"chat_id"];
    _unreadCount = [[dict objectForKey:@"unread_count"] intValue];
    _lastMessage = [dict objectForKey:@"last_message"];
    _lastMessageTimestamp = [[dict objectForKey:@"last_update"] longValue];

}

@end
