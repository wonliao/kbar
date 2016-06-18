//
//  WpCommentData.h
//  kBar
//
//  Created by wonliao on 13/4/11.
//
//

#import <Foundation/Foundation.h>

@interface WpCommentData : NSObject

-(id)initWithDictionary:(NSDictionary *)aDict;

@property (nonatomic, retain) NSString* author;         // 發表者名稱
@property (nonatomic, retain) NSString* uid;            // 發表者uid
@property (nonatomic, retain) NSString* imageURLString; // 發表者圖片
@property (nonatomic, retain) NSString* content;        // 內容
@property (nonatomic, retain) NSString* date;           // 日期



@end
