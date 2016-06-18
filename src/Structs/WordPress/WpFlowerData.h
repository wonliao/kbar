//
//  WpFlowerData.h
//  kBar
//
//  Created by wonliao on 13/4/1.
//
//

#import <Foundation/Foundation.h>

// wordpress的歌曲送花資料格式
@interface WpFlowerData : NSObject

-(id)initWithDictionary:(NSDictionary *)aDict;


@property (nonatomic,retain) NSString *flower_count;      // 花朵數


@end
