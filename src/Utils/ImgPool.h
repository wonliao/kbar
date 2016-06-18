//
//  ImgPool.h
//  kBar
//
//  Created by wonliao on 13/3/11.
//
//

#import <Foundation/Foundation.h>

@interface ImgPool : NSObject {

    NSMutableDictionary *m_imgPool;
}

@property (strong) NSMutableDictionary *m_imgPool;

+ (id)sharedInstance;

@end
