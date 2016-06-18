//
//  WpChorusData.m
//  kBar
//
//  Created by wonliao on 13/4/20.
//
//

#import "WpChorusData.h"

@implementation WpChorusData

-(id)initWithDictionary:(NSDictionary *)aDict
{
    self = [self init];
    if (self){

        self.post_id = [aDict objectForKey:@"ID"];
        self.title = [aDict objectForKey:@"TITLE"];
        self.singer_id = [aDict objectForKey:@"SINGER_ID"];

        self.imageURLString = [NSString stringWithFormat:@"http://54.200.150.53/kbar/wp-content/uploads/photos/%@.jpg", self.singer_id];

        self.singer_name = [aDict objectForKey:@"SINGER_NAME"];
        self.note = [aDict objectForKey:@"NOTE"];
        self.reference_count = [aDict objectForKey:@"REFERENCE_COUNT"];
    }
    return self;
}

@end
