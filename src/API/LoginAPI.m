//
//  LoginAPI.m
//
// add by wonliao
//

#import "LoginAPI.h"
#import "AppDelegate.h"
#import "StringUtils.h"

@implementation LoginAPI

- (void)loginWithAccount:(NSString *)account passwordEncrypted:(NSString *)passwordEncrypted {
    [super addPostParameter:@"email" value:account];
    [super addPostParameter:@"password" value:passwordEncrypted];
    [super addPostParameter:@"type" value:@"direct"];
    [super connect:@"login"];
}

- (void)loginWithAccount:(NSString *)account password:(NSString *)password {
    NSString* passwordEncrypted = [StringUtils md5:[NSString stringWithFormat:@"K8aPp_Pa55W0rD_5Alt_%@", password]];
    [self loginWithAccount:account passwordEncrypted:passwordEncrypted];
}

- (void)loginWithFacebookToken:(NSString *)account facebookToken:(NSString *)token {
    [super addPostParameter:@"email" value:account];
    [super addPostParameter:@"fb_at" value:token];
    [super addPostParameter:@"type" value:@"direct"];
    [super connect:@"login"];
}

- (int)parse:(NSData *)data {
    int status = [super parse:data];
    if (status > 0) {
        KKUser* user = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user];
        [user fillObjectWithDictionary:[jsonData objectForKey:@"user_info"]];
        [KKAPI updateSID:[jsonData objectForKey:@"sid"]];
    }
    return status;
}

@end
