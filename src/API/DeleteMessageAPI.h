//
//  DeleteMessageAPI.h
//
// add by wonliao
//

#import "KKAPI.h"

@interface DeleteMessageAPI : KKAPI

- (void)deleteMessageById:(NSString *)messageId;
- (int)parse:(NSData *)data;

@end
