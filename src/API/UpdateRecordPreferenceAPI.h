//
//  UpdateRecordPreferenceAPI.h
//
// add by wonliao
//

#import "KKAPI.h"

@interface UpdateRecordPreferenceAPI : KKAPI

- (void)update:(BOOL)isFavorite recordId:(NSString *)recordId;

@end
