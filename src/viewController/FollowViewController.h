//
//  FollowViewController.h
//  myFans
//
//  Created by wonliao on 13/1/16.
//  Copyright (c) 2013年 wonliao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "ASIHTTPRequest.h"
#import "MHLazyTableImages.h"
#import "MHImageCache.h"
#import "wordpress.h"
#import "FBCoreData.h"  // fbUserInfo的資料庫互動類別
#import "CoreData.h"
#import "WpFollowData.h"
#import "Playing.h"     // 目前播放歌的資料庫互動類別
#import "ECSlidingViewController.h"


@class MHLazyTableImages;

@interface FollowViewController : UIViewController <FBLoginViewDelegate, MHLazyTableImagesDelegate, UITableViewDataSource, UITableViewDelegate> {
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


- (IBAction)revealMenu:(id)sender;

@end