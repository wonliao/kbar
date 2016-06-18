//
//  RecordListAPI.h
//
// add by wonliao
//

#import "KKAPI.h"

@interface RecordListAPI : KKAPI

@property NSMutableArray *recordList;

- (void)fetchListById:(NSString *)listId;
- (void)fetchFavoriteListByUserId:(NSString *)userId;
- (void)fetchListByUserId:(NSString *)userId;

- (int)parse:(NSData *)data;

@end
