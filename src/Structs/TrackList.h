//
//  TrackList.h
//
// add by wonliao
//

#import <Foundation/Foundation.h>

@interface TrackList : NSObject

@property NSString *listId;
@property NSString *title;
@property NSString *myDescription;
@property NSArray  *bannerResource;
@property NSArray  *trackList;

+ (TrackList *)initWithDictionary:(NSDictionary *)dict;
- (void)fillObjectWithDictionary:(NSDictionary *)dict;

@end
