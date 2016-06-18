//
//  FindFriendViewController.h
//  ECSlidingViewController
//
//  myFans
//
//  Created by vincent on 13/1/16.
//  Copyright (c) 2013年 vincent. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MHLazyTableImages.h"
#import "wordpress.h"
#import "FBCoreData.h"  // fbUserInfo的資料庫互動類別
#import "CoreData.h"


@class MHLazyTableImages;


@interface CommentViewController : UIViewController <FBLoginViewDelegate, MHLazyTableImagesDelegate> {

    IBOutlet UITableView *m_tableView;

    // CoreData 物件
    CoreData *m_coreData;

    FBCoreData *m_FbCoreData;
    NSString *m_post_id;
    wordpress *m_wordpress;

    MHLazyTableImages* lazyImages;
}

@property (nonatomic, retain) NSArray* entries;


- (IBAction)backButtonTapped:(id)sender;

@end
