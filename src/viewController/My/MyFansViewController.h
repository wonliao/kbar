//
//  MyFansViewController.h
//  kBar
//
//  Created by wonliao on 13/2/19.
//
//

#import <UIKit/UIKit.h>

@interface MyFansViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    
	NSMutableArray *dataArray;
    UIImageView *characterImageView;
}

@property (nonatomic, retain) UIImageView *characterImageView;
- (IBAction)backButtonTapped:(id)sender;

@end
