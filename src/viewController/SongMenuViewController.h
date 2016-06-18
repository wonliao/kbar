//
//  SongMenuViewController.h
//  myFans
//
//  Created by wonliao on 13/1/16.
//  Copyright (c) 2013年 wonliao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDownloadBar.h"
#import "wordpress.h"
#import "CoreData.h"

@interface SongMenuViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource, UIDownloadBarDelegate, UIAlertViewDelegate> {

    // CoreData 物件
    CoreData *m_coreData;
    
    NSMutableArray *m_recordData;
    
    // 下載進度吧
    //UIDownloadBar *bar;
    NSMutableArray *downloadBars;
    
    wordpress *m_wordpress;
    NSMutableArray *sampleItems;
}


- (IBAction)orderByArtist:(id)sender;
- (IBAction)orderByCatagory:(id)sender;
- (IBAction)backButtonTapped:(id)sender;
- (IBAction)buttonTapped:(id)sender;

- (IBAction)orderSong:(id)sender;
- (IBAction)myOrderedList:(id)sender;
- (IBAction)myRecordedList:(id)sender;



@property (nonatomic, strong) NSMutableArray *m_recordData;
@property (nonatomic, strong) NSMutableArray *sampleItems;
@property (nonatomic, strong) NSMutableArray *downloadBars;

@property (nonatomic, retain) wordpress *m_wordpress;

@property (strong,nonatomic) UISegmentedControl * segment_title;

@end
