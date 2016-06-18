//
//  RegisterAPI.m
//
// add by wonliao
//

#import "RegisterAPI.h"
#import "StringUtils.h"

@implementation RegisterAPI

- (void)registerWithAccount:(NSString *)account password:(NSString *)password nickname:(NSString *)nickname {
    NSString* passwordEncrypted = [StringUtils md5:[NSString stringWithFormat:@"%@%@", @"K8aPp_Pa55W0rD_5Alt_", password]];
    [super addPostParameter:@"email" value:account];
    [super addPostParameter:@"nickname" value:nickname];
    [super addPostParameter:@"password" value:passwordEncrypted];
    [super addPostParameter:@"type" value:@"direct"];
    [super connect:@"register"];
}

- (void)registerWithFacebookToken:(NSString *)account facebookId:(NSString *)facebookId facebookToken:(NSString *)token nickname:(NSString *)nickname {
    [super addPostParameter:@"email" value:account];
    [super addPostParameter:@"nickname" value:nickname];
    [super addPostParameter:@"fb_at" value:token];
    [super addPostParameter:@"fb_uid" value:facebookId];
    [super addPostParameter:@"type" value:@"direct"];
    [super connect:@"register"];
}

@end
