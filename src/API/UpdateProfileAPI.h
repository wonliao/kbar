//
//  UpdateProfileAPI.h
//
// add by wonliao
//

#import "KKAPI.h"

@interface UpdateProfileAPI : KKAPI

- (void)update:(NSString *)nickname;
- (int)parse:(NSData *)data;

@end
