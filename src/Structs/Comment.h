//
//  Comment.h
//
// add by wonliao
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property NSString *commentId;
@property NSString *userId;
@property NSString *nickname;
@property NSString *headpic;
@property NSString *content;
@property long     timestamp;
@property NSString *parentCommentId;
@property NSString *parentRecordId;

+ (Comment *)initWithDictionary:(NSDictionary *)dict;
- (void)fillObjectWithDictionary:(NSDictionary *)dict;

@end
