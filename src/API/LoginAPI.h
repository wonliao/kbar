//
//  LoginAPI.h
//
// add by wonliao
//

#import <Foundation/Foundation.h>
#import "KKAPI.h"

@interface LoginAPI : KKAPI

- (void)loginWithAccount:(NSString *)account passwordEncrypted:(NSString *)passwordEncrypted;
- (void)loginWithAccount:(NSString *)account password:(NSString *)password;
- (void)loginWithFacebookToken:(NSString *)account facebookToken:(NSString *)token;
- (int)parse:(NSData *)data;

@end
