//
//  TrackListAPI.m
//
// add by wonliao
//

#import "TrackListAPI.h"
#import "Track.h"

@implementation TrackListAPI

- (void)fetchListById:(NSString *)listId {

}

- (int)parse:(NSData *)data {
    int status = [super parse:data];
    if (status > 0) {
        NSArray * trackListObjects = (NSArray *)[jsonData objectForKey:@"song_list"];
        _trackList = [NSMutableArray arrayWithCapacity:[trackListObjects count]];
        for (NSDictionary * dict in trackListObjects) {
            [_trackList addObject:[Track initWithDictionary:dict]];
        }
    }
    return status;
}

@end
