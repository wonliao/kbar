//
//  UserListAPI.m
//
// add by wonliao
//

#import "UserListAPI.h"
#import "UserInfo.h"

@implementation UserListAPI

- (void)fetchListById:(NSString *)listId {
    [super addGetParameter:@"sid" value:[KKAPI getSID]];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"users" forKey:@"table"];
    [dict setValue:[[NSArray alloc] initWithObjects:@"user_id", @"nickname", @"headpic", @"cover_imgs", @"follower_count", @"following_count", @"record_count", @"chorus_count", @"favorite_count", @"account_balance", nil] forKey:@"fields"];
    
    [dict setValue:[[NSDictionary alloc] initWithObjectsAndKeys:@"random", @"list_id", @"1", @"count", [[NSDictionary alloc] initWithObjectsAndKeys:listId, @"user_id", nil], @"cond", nil] forKey:@"param"];
    NSArray* queryObjects = [[NSArray alloc] initWithObjects:dict, nil];
    NSData* data = [NSJSONSerialization dataWithJSONObject:queryObjects options:NSJSONWritingPrettyPrinted error:nil];
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    [super addPostParameter:@"query" value:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    [super connect:@"datalist/query"];
}

- (void)fetchFollowerListByUserId:(NSString *)userId {
    [super addGetParameter:@"sid" value:[KKAPI getSID]];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"users" forKey:@"table"];
    [dict setValue:[[NSArray alloc] initWithObjects:@"user_id", @"nickname", @"headpic", @"cover_imgs", @"follower_count", @"following_count", @"record_count", @"chorus_count", @"favorite_count", @"account_balance", nil] forKey:@"fields"];
    
    [dict setValue:[[NSDictionary alloc] initWithObjectsAndKeys:@"follower", @"list_id", @"1", @"count", [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"user_id", nil], @"cond", nil] forKey:@"param"];
    NSArray* queryObjects = [[NSArray alloc] initWithObjects:dict, nil];
    NSData* data = [NSJSONSerialization dataWithJSONObject:queryObjects options:NSJSONWritingPrettyPrinted error:nil];
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    [super addPostParameter:@"query" value:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    [super connect:@"datalist/query"];
}

- (void)fetchFollowingListByUserId:(NSString *)userId {
    [super addGetParameter:@"sid" value:[KKAPI getSID]];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"users" forKey:@"table"];
    [dict setValue:[[NSArray alloc] initWithObjects:@"user_id", @"nickname", @"headpic", @"cover_imgs", @"follower_count", @"following_count", @"record_count", @"chorus_count", @"favorite_count", @"account_balance", nil] forKey:@"fields"];
    
    [dict setValue:[[NSDictionary alloc] initWithObjectsAndKeys:@"following", @"list_id", @"1", @"count", [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"user_id", nil], @"cond", nil] forKey:@"param"];
    NSArray* queryObjects = [[NSArray alloc] initWithObjects:dict, nil];
    NSData* data = [NSJSONSerialization dataWithJSONObject:queryObjects options:NSJSONWritingPrettyPrinted error:nil];
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    [super addPostParameter:@"query" value:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    [super connect:@"datalist/query"];
}

- (int)parse:(NSData *)data {
    int status = [super parse:data];
    if (status > 0) {
        NSArray * queryObjects = (NSArray *)[jsonData objectForKey:@"datalist"];
        NSArray * userListObjects = (NSArray *)[queryObjects objectAtIndex:0];
        _userList = [NSMutableArray arrayWithCapacity:[userListObjects count]];
        for (NSDictionary * dict in userListObjects) {
            [_userList addObject:[UserInfo initWithDictionary:dict]];
        }
    }
    return status;
}

@end
