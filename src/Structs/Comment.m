//
//  Comment.m
//
// add by wonliao
//

#import "Comment.h"

@implementation Comment

+ (Comment *)initWithDictionary:(NSDictionary *)dict {
    Comment * comment = [[Comment alloc] init];
    [comment fillObjectWithDictionary:dict];
    return comment;
}

- (void)fillObjectWithDictionary:(NSDictionary *)dict {
    _commentId =[dict objectForKey:@"comment_id"];
    _userId = [dict objectForKey:@"user_id"];
    _nickname = [dict objectForKey:@"nickname"];
    _content = [dict objectForKey:@"comment"];
    _timestamp = [[dict objectForKey:@"timestamp"] longValue];
    _parentCommentId = [dict objectForKey:@"parent_id"];
    _parentRecordId = [dict objectForKey:@"record_id"];
}

@end
