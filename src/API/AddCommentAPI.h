//
//  AddCommentAPI.h
//
// add by wonliao
//

#import "KKAPI.h"

@interface AddCommentAPI : KKAPI

- (void)addByRecordId:(NSString *)recordId comment:(NSString *)comment;
- (int)parse:(NSData *)data;

@end
