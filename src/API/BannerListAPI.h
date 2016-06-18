//
//  BannerListAPI.h
//
// add by wonliao
//

#import "KKAPI.h"

@interface BannerListAPI : KKAPI

@property NSMutableArray *bannerList;

- (void)fetchRecommendList;
- (void)fetchOrderSingleList;
- (void)fetchOrderChorusList;
- (int)parse:(NSData *)data;

@end
