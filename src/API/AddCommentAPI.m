//
//  AddCommentAPI.m
//
// add by wonliao
//

#import "AddCommentAPI.h"

@implementation AddCommentAPI

- (void)addByRecordId:(NSString *)recordId comment:(NSString *)comment {
    [super addGetParameter:@"sid" value:[KKAPI getSID]];
    [super addPostParameter:@"record_id" value:recordId];
    [super addPostParameter:@"comment" value:comment];
    [super connect:@"comment/add"];
}

- (int)parse:(NSData *)data {
    return 0;
}

@end
