//
//  Track.h
//
// add by wonliao
//

#import <Foundation/Foundation.h>

@interface Track : NSObject

@property NSString *trackId;
@property NSString *trackName;
@property NSString *artistName;
@property NSString *artistId;
@property NSString *albumCover;
@property int recordCount;
@property int chorusCount;

@property NSString* lyricsUrl;
@property NSString* pitchInfoUrl;
@property NSString* streamingUrl;

+ (Track *)initWithDictionary:(NSDictionary *)dict;
- (void)fillObjectWithDictionary:(NSDictionary *)dict;

@end
