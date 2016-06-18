//
//  CommonViewController.h
//  kBar
//
//  Created by wonliao on 13/4/20.
//
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "ASIHTTPRequest.h"
#import "wordpress.h"
#import "FBCoreData.h"  // fbUserInfo的資料庫互動類別
#import "CoreData.h"





@interface CommonViewController : UIViewController {
@public

    // CoreData 物件
    CoreData *m_coreData;
    
    FBCoreData *m_FbCoreData;
    wordpress *m_wordpress;
}

@end
