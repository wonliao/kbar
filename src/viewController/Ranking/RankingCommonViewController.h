//
//  RankingCommonViewController.h
//  kBar
//
//  Created by wonliao on 13/4/17.
//
//


#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "ASIHTTPRequest.h"
#import "MHLazyTableImages.h"
#import "MHImageCache.h"
#import "wordpress.h"
#import "FBCoreData.h"  // fbUserInfo的資料庫互動類別
#import "CoreData.h"
#import "WpRankngData.h"
#import "Playing.h"     // 目前播放歌的資料庫互動類別



@class MHLazyTableImages;


@interface RankingCommonViewController : UIViewController <FBLoginViewDelegate, MHLazyTableImagesDelegate, UITableViewDataSource, UITableViewDelegate> {
@public
    IBOutlet UITableView *m_tableView;

    // CoreData 物件
    CoreData *m_coreData;

    FBCoreData *m_FbCoreData;
    NSString *m_post_id;
    wordpress *m_wordpress;

    MHLazyTableImages* lazyImages;

    int m_rankType;
}

@property (nonatomic, retain) NSArray* entries;

@end