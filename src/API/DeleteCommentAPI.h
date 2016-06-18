//
//  DeleteCommentAPI.h
//
// add by wonliao
//

#import "KKAPI.h"

@interface DeleteCommentAPI : KKAPI

- (void)deleteById:(NSString *)commentId;
- (int)parse:(NSData *)data;

@end
