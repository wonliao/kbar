//
//  DeleteCommentAPI.m
//
// add by wonliao
//

#import "DeleteCommentAPI.h"

@implementation DeleteCommentAPI

- (void)deleteById:(NSString *)commentId {
    [super addGetParameter:@"sid" value:[KKAPI getSID]];
    [super addPostParameter:@"comment_id" value:commentId];
    [super connect:@"comment/delete"];
}

- (int)parse:(NSData *)data {
    return 0;
}

@end
