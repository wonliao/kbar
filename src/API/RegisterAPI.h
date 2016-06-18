//
//  RegisterAPI.h
//
// add by wonliao
//

#import "KKAPI.h"

@interface RegisterAPI : KKAPI

- (void)registerWithAccount:(NSString *)account password:(NSString *)password nickname:(NSString *)nickname;
- (void)registerWithFacebookToken:(NSString *)account facebookId:(NSString *)facebookId facebookToken:(NSString *)token nickname:(NSString *)nickname;

@end
