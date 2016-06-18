//
//  Artist.m
//
// add by wonliao
//

#import "Artist.h"

@implementation Artist

+ (Artist *)initWithDictionary:(NSDictionary *)dict {
    Artist * artist = [[Artist alloc] init];
    [artist fillObjectWithDictionary:dict];
    return artist;
}

- (void)fillObjectWithDictionary:(NSDictionary *)dict {
    _artistId = [dict objectForKey:@"artist_id"];
    _name = [dict objectForKey:@"artist_name"];
    _indexKey = [dict objectForKey:@"index_key"];
}

@end
