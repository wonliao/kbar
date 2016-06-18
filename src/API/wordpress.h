//
//  wordpress.h
//  kBar
//
//  Created by wonliao on 13/3/6.
//
//

#import <Foundation/Foundation.h>

@interface wordpress : NSObject

// 查詢 wordpress 資料
-(NSArray *) queryWordpress:(NSString *) query;

// 異步查詢 wordpress 資料
-(void) queryWordpress:(NSString *) query completion:(void (^)(NSArray *))completionBlock;

// 取得指定角色圖片
-(void) getUserImage:(NSString *)uid completion:(void (^)(UIImage *))completionBlock;

@end
