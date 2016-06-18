//
//  UserListAPI.h
//
// add by wonliao
//

#import "KKAPI.h"

@interface UserListAPI : KKAPI

@property NSMutableArray *userList;

- (void)fetchListById:(NSString *)listId;

- (void)fetchFollowerListByUserId:(NSString *)userId;

- (void)fetchFollowingListByUserId:(NSString *)userId;

- (int)parse:(NSData *)data;

@end
