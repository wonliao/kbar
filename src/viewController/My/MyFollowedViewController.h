//
//  MyFollowedViewController.h
//  kBar
//
//  Created by vincent on 13/2/19.
//
//

#import <UIKit/UIKit.h>

@interface MyFollowedViewController :  UIViewController
<UITableViewDelegate, UITableViewDataSource>
{
    
	NSMutableArray *dataArray;
    UIImageView *characterImageView;
}

@property (nonatomic, retain) UIImageView *characterImageView;

- (IBAction)backButtonTapped:(id)sender;

@end
