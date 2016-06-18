//
//  RecordInfo.m
//
// add by wonliao
//

#import "RecordInfo.h"

@implementation RecordInfo

+ (RecordInfo *)initWithDictionary:(NSDictionary *)dict {
    RecordInfo * record = [[RecordInfo alloc] init];
    [record fillObjectWithDictionary:dict];
    return record;
}

- (void)fillObjectWithDictionary:(NSDictionary *)dict {
    _trackId =[dict objectForKey:@"song_id"];
    _trackName = [dict objectForKey:@"song_name"];
    _artistId = [dict objectForKey:@"artist_id"];
    _artistName = [dict objectForKey:@"artist_name"];
    _recordId = [dict objectForKey:@"record_id"];
    _myDescription = [dict objectForKey:@"description"];
    _type = [[dict objectForKey:@"record_type"] intValue];
    _flowerCount = [[dict objectForKey:@"flower_count"] intValue];
    _favoriteCount = [[dict objectForKey:@"favorite_count"] intValue];
    _listenCount = [[dict objectForKey:@"listen_count"] intValue];
    _timestamp = [[dict objectForKey:@"timestamp"] longValue];
    _commentCount = [[dict objectForKey:@"comment_count"] intValue];
    
    //_userList
    //_commentList
}

@end
