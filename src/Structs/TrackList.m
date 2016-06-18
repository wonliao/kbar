//
//  TrackList.m
//
// add by wonliao
//

#import "TrackList.h"

@implementation TrackList

+ (TrackList *)initWithDictionary:(NSDictionary *)dict {
    TrackList * trackList = [[TrackList alloc] init];
    [trackList fillObjectWithDictionary:dict];
    return trackList;
}

- (void)fillObjectWithDictionary:(NSDictionary *)dict {
    _listId = [dict objectForKey:@"song_list_id"];
    _title = [dict objectForKey:@"title"];
    _myDescription = [dict objectForKey:@"description"];
}

@end
