//
//  TrackListAPI.h
//
// add by wonliao
//

#import "KKAPI.h"

@interface TrackListAPI : KKAPI

@property NSMutableArray *trackList;

- (void)fetchListById:(NSString *)listId;
- (int)parse:(NSData *)data;

@end
