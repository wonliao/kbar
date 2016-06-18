//
//  WpSongData.h
//  kBar
//  
//  Created by wonliao on 13/3/31.
//
//

#import <Foundation/Foundation.h>

// wordpress的歌曲資料格式
@interface WpSongData : NSObject

-(id)initWithDictionary:(NSDictionary *)aDict;

@property (nonatomic,retain) NSString *post_id;         // 歌曲編號
@property (nonatomic,retain) NSString *post_title;      // 歌曲名稱
@property (nonatomic,retain) NSString *mp3_url;         // 文章的網址
@property (nonatomic,retain) NSString *post_content;    // 歌詞

@end
