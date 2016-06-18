//
//  UpdateRecordPreferenceAPI.m
//
// add by wonliao
//

#import "UpdateRecordPreferenceAPI.h"

@implementation UpdateRecordPreferenceAPI

- (void)update:(BOOL)isFavorite recordId:(NSString *)recordId {
    [super addGetParameter:@"sid" value:[KKAPI getSID]];
    if (isFavorite) {
        [super addPostParameter:@"favorite" value:@"1"];
    } else {
        [super addPostParameter:@"favorite" value:@"0"];
    }
    [super addPostParameter:@"record_id" value:recordId];
    [super connect:@"record/set_favorite"];
}

@end
