//
//  OthersHomeViewController.h
//  kBar
//
//  Created by wonliao on 13/2/19.
//
//

#import <UIKit/UIKit.h>

@interface OthersHomeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    
	NSMutableArray *dataArray;
    UIImageView *characterImageView;
}

@property (nonatomic, retain) UIImageView *characterImageView;

- (IBAction)backButtonTapped:(id)sender;
- (IBAction)followBottonTapped:(id)sender;
- (IBAction)blockListBottonTapped:(id)sender;

@end
