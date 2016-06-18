//
//  UserInfo.h
//
// add by wonliao
//


#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property NSString *nickname;
@property NSString *uid;
@property NSString *headImage;

@property int followerCount;
@property int followingCount;
@property int recordCount;
@property int chorusCount;

+ (UserInfo *)initWithDictionary:(NSDictionary *)dict;
- (void)fillObjectWithDictionary:(NSDictionary *)dict;

@end