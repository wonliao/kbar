//
//  fbCoreData.h
//  kBar
//
//  Created by wonliao on 13/2/22.
//
//

#import <Foundation/Foundation.h>
#import "CoreData.h"

@interface FBCoreData : NSObject {

    // CoreData 物件
    CoreData *m_coreData;

    NSString *fbUID;    // fbuid
    NSString *fbName;   // 名稱
    NSString *fbPlace;  // 位置
    NSString *fbLink;   // fb 個人網頁連結
}

@property (nonatomic, retain) NSString *fbUID;
@property (nonatomic, retain) NSString *fbName;
@property (nonatomic, retain) NSString *fbPlace;
@property (nonatomic, retain) NSString *fbLink;

- (void) save;
- (void) load;
- (void) clear;
- (void) updateWordpress;

@end
