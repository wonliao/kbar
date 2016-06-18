//
//  ArtistCategory.h
//
// add by wonliao
//

#import <Foundation/Foundation.h>

@interface ArtistCategory : NSObject

@property NSString *artistCategoryId;
@property NSString *name;
@property NSString *parentId;

+ (ArtistCategory *)initWithDictionary:(NSDictionary *)dict;
- (void)fillObjectWithDictionary:(NSDictionary *)dict;

@end
