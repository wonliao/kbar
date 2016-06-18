//
//  ArtistCategory.m
//
// add by wonliao
//

#import "ArtistCategory.h"

@implementation ArtistCategory

+ (ArtistCategory *)initWithDictionary:(NSDictionary *)dict {
    ArtistCategory * artistCategory = [[ArtistCategory alloc] init];
    [artistCategory fillObjectWithDictionary:dict];
    return artistCategory;
}

- (void)fillObjectWithDictionary:(NSDictionary *)dict {
    _artistCategoryId = [dict objectForKey:@"artist_id"];
    _name = [dict objectForKey:@"artist_name"];
    _parentId = [dict objectForKey:@"parent_category"];
}

@end
