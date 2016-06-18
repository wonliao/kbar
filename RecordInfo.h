//
//  RecordInfo.h
//
// add by wonliao
//

#import <Foundation/Foundation.h>

@interface RecordInfo : NSObject
//TODO: rename it to Record

@property NSString *trackId;
@property NSString *trackName;
@property NSString *artistName;
@property NSString *artistId;
@property NSString *recordId;
@property int       type;
@property NSString *myDescription;
@property NSArray  *userList;
@property int       flowerCount;
@property int       favoriteCount;
@property int       listenCount;
@property long      timestamp;
@property int       commentCount;
@property NSArray  *commentList;

+ (RecordInfo *)initWithDictionary:(NSDictionary *)dict;
- (void)fillObjectWithDictionary:(NSDictionary *)dict;

@end
