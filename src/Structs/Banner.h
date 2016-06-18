//
//  Banner.h
//
// add by wonliao
//

#import <Foundation/Foundation.h>

@interface Banner : NSObject

@property NSString *bannerId;
@property int       type;
@property NSString *title;
@property NSString *myDescription;
@property int       columnWidth;
@property NSArray  *resourceList;

+ (Banner *)initWithDictionary:(NSDictionary *)dict;
- (void)fillObjectWithDictionary:(NSDictionary *)dict;

@end
