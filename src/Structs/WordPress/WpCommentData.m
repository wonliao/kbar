//
//  WpCommentData.m
//  kBar
//
//  Created by wonliao on 13/4/11.
//
//

#import "WpCommentData.h"

@implementation WpCommentData

-(id)initWithDictionary:(NSDictionary *)aDict
{
    self = [self init];
    if (self){
        
        self.author = [aDict objectForKey:@"AUTHOR"];

        self.uid = [aDict objectForKey:@"UID"];
        self.imageURLString = [NSString stringWithFormat:@"http://54.200.150.53/kbar/wp-content/uploads/photos/%@.jpg", self.uid];

        self.content = [aDict objectForKey:@"CONTENT"];
        self.date = [aDict objectForKey:@"DATE"];
    }
    return self;
}

@end
