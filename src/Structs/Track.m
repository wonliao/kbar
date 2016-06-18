//
//  Track.m
//
// add by wonliao
//

#import "Track.h"

@implementation Track

+ (Track *)initWithDictionary:(NSDictionary *)dict {
    Track * track = [[Track alloc] init];
    [track fillObjectWithDictionary:dict];
    return track;
}

- (void)fillObjectWithDictionary:(NSDictionary *)dict {
    _trackId =[dict objectForKey:@"song_id"];
    _trackName = [dict objectForKey:@"song_name"];
    _recordCount = [[dict objectForKey:@"record_count"] intValue];
    _chorusCount = [[dict objectForKey:@"chorus_count"] intValue];
    _artistId = [dict objectForKey:@"artist_id"];
    _artistName = [dict objectForKey:@"artist_name"];
    _albumCover = [dict objectForKey:@"album_cover"];
    
    _lyricsUrl = [dict objectForKey:@"lyrics_file"];
    _pitchInfoUrl = [dict objectForKey:@"pitch_file"];
    _streamingUrl = [dict objectForKey:@"song_path"];
}

@end
