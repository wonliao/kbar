//
//  SendMessageAPI.h
//
// add by wonliao
//

#import "KKAPI.h"

@interface SendMessageAPI : KKAPI

- (void)sendMessageToUserId:(NSString *)userId message:(NSString *)message;
- (int)parse:(NSData *)data;

@end
