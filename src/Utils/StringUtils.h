//
//  StringUtils.h
//  kBar
//
//  Created by Peter Zhou on 6/14/13.
//
//

#import <Foundation/Foundation.h>

@interface StringUtils : NSObject

+ (NSString *)md5:(NSString *)input;

+ (NSString *)urlEncode:(NSString *)input;

@end
