//
//  ImgPool.m
//  kBar
//
//  Created by wonliao on 13/3/11.
//
//

#import "ImgPool.h"

@implementation ImgPool

@synthesize m_imgPool;

static ImgPool *sharedInstance = nil;

+ (ImgPool *)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if (self) {

    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(void)setImgPool:(NSMutableDictionary *)newImgPool
{
    m_imgPool = newImgPool;
}

-(NSMutableDictionary *)imgPool
{
    return m_imgPool;
}


@end
