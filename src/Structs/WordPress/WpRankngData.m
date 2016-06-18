//
//  WpRankngData.m
//  kBar
//
//  Created by wonliao on 13/4/17.
//
//

#import "WpRankngData.h"

@implementation WpRankngData

-(id)initWithDictionary:(NSDictionary *)aDict
{
    self = [self init];
    if (self){
        
        self.post_id = [aDict objectForKey:@"ID"];
        self.author = [aDict objectForKey:@"AUTHOR"];
        
        self.uid = [aDict objectForKey:@"UID"];
        self.imageURLString = [NSString stringWithFormat:@"http://54.200.150.53/kbar/wp-content/uploads/photos/%@.jpg", self.uid];

        self.date = [aDict objectForKey:@"DATE"];
        self.title = [aDict objectForKey:@"TITLE"];
        self.flower = [aDict objectForKey:@"FLOWER"];
    }
    return self;
}

@end
