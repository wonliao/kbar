//
//  Artist.h
//
// add by wonliao
//

#import <Foundation/Foundation.h>

@interface Artist : NSObject

@property NSString *artistId;
@property NSString *name;
@property NSString *indexKey;

+ (Artist *)initWithDictionary:(NSDictionary *)dict;
- (void)fillObjectWithDictionary:(NSDictionary *)dict;

@end
