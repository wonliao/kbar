//
//  Banner.m
//
// add by wonliao
//

#import "Banner.h"

@implementation Banner

+ (Banner *)initWithDictionary:(NSDictionary *)dict {
    Banner * banner = [[Banner alloc] init];
    [banner fillObjectWithDictionary:dict];
    return banner;
}

- (void)fillObjectWithDictionary:(NSDictionary *)dict {
    _bannerId = [dict objectForKey:@"banner_id"];
    _type = [[dict objectForKey:@"banner_type"] intValue];
    _title = [dict objectForKey:@"title"];
    _myDescription = [dict objectForKey:@"description"];
    _columnWidth = [[dict objectForKey:@"col_width"] intValue];
}

@end
