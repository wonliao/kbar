//
//  SongListViewController.h
//  myFans
//
//  Created by vincent on 13/1/17.
//
//

#import <UIKit/UIKit.h>
#import "CoreData.h"


@interface SongListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    
    // CoreData 物件
    CoreData *m_coreData;

    NSMutableArray *m_recordData;
}

- (IBAction)buttonTapped:(id)sender;

@property (nonatomic, strong) NSMutableArray *m_recordData;
@end
