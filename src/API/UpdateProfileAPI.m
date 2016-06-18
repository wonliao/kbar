//
//  UpdateProfileAPI.m
//
// add by wonliao
//

#import "UpdateProfileAPI.h"
#import "AppDelegate.h"

@implementation UpdateProfileAPI

- (void)update:(NSString *)nickname {
    [super addGetParameter:@"sid" value:[KKAPI getSID]];
    [super addPostParameter:@"nickname" value:nickname];
    [super connect:@"me/update"];
}

- (int)parse:(NSData *)data {
    int status = [super parse:data];
    if (status > 0) {
        KKUser* user = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user];
        NSDictionary* userInfo = [jsonData objectForKey:@"user_info"];
        [user setNickname:[userInfo objectForKey:@"nickname"]];
    }
    return status;
}

@end
