//
//  WpFlowerData.m
//  kBar
//
//  Created by wonliao on 13/4/1.
//
//

#import "WpFlowerData.h"

@implementation WpFlowerData

-(id)initWithDictionary:(NSDictionary *)aDict
{
    self = [self init];
    if (self){

        self.flower_count = [aDict objectForKey:@"FLOWER_COUNT"];       // 花朵數
    }
    return self;
}

@end
