//
//  MySongListViewController.h
//  kBar
//
//  Created by wonliao on 2016/6/23.
//
//

#import <UIKit/UIKit.h>
#import "CoreData.h"

@interface MySongListViewController :UIViewController<UITableViewDelegate, UITableViewDataSource>{
    
    // CoreData 物件
    CoreData *m_coreData;
    
    NSMutableArray *m_recordData;
}

- (IBAction)buttonTapped:(id)sender;

@property (nonatomic, strong) NSMutableArray *m_recordData;
@end
