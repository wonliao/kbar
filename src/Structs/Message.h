//
//  Message.h
//
// add by wonliao
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property NSString *messageId;
@property NSString *userId;
@property NSString *nickname;
@property NSString *headpic;
@property NSString *content;
@property bool      unread;
@property long      timestamp;

+ (Message *)initWithDictionary:(NSDictionary *)dict;
- (void)fillObjectWithDictionary:(NSDictionary *)dict;

@end
