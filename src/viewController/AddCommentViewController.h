//
//  AddCommentViewController.h
//  kBar
//
//  Created by wonliao on 13/4/11.
//
//
#import <UIKit/UIKit.h>
#import "wordpress.h"
#import "FBCoreData.h"  // fbUserInfo的資料庫互動類別
#import "CoreData.h"

@interface AddCommentViewController : UIViewController {

    // CoreData 物件
    CoreData *m_coreData;

    FBCoreData *m_FbCoreData;
    NSString *m_post_id;
    wordpress *m_wordpress;
}

@property (nonatomic, retain) IBOutlet UITextView *myTextView;

- (IBAction)buttonTapped:(id)sender;
- (IBAction)backButtonTapped:(id)sender;


@end
