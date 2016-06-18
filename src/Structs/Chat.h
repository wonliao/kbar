//
//  Chat.h
//
// add by wonliao
//

#import <Foundation/Foundation.h>

@interface Chat : NSObject

@property NSString *chatId;
@property NSArray  *userList;
@property int       unreadCount;
@property NSString *lastMessage;
@property long      lastMessageTimestamp;


+ (Chat *)initWithDictionary:(NSDictionary *)dict;
- (void)fillObjectWithDictionary:(NSDictionary *)dict;

@end
