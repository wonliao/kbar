//
//  RecordListAPI.m
//
// add by wonliao
//

#import "RecordListAPI.h"
#import "RecordInfo.h"

@implementation RecordListAPI

- (void)fetchListById:(NSString *)listId {

}

- (void)fetchFavoriteListByUserId:(NSString *)userId {

}

- (void)fetchListByUserId:(NSString *)userId {

}

- (int)parse:(NSData *)data {
    int status = [super parse:data];
    if (status > 0) {
        NSArray * recordListObjects = (NSArray *)[jsonData objectForKey:@"record_list"];
        _recordList = [NSMutableArray arrayWithCapacity:[recordListObjects count]];
        for (NSDictionary * dict in recordListObjects) {
            [_recordList addObject:[RecordInfo initWithDictionary:dict]];
        }
    }
    return status;
}

@end
