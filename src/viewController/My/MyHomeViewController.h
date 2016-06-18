//
//  MyHomeViewController.h
//  kBar
//
//  Created by vincent on 13/2/19.
//
//

#import <UIKit/UIKit.h>
#import "MDCParallaxView.h"

@interface MyHomeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    MDCParallaxView * parallaxView;
    UITextView *textView;
    UITableView *tableView;
    UIView *detailView;
}
- (IBAction)button1Tapped:(id)sender;
- (IBAction)button2Tapped:(id)sender;
- (IBAction)button3Tapped:(id)sender;
@property (nonatomic, strong) NSArray *sampleItems;
//@property (nonatomic, strong) NSArray *sampleItems2;
//@property (nonatomic, strong) NSArray *sampleItems3;


//- (IBAction)backButtonTapped:(id)sender;
- (IBAction)backButtonTapped:(id)sender;
- (IBAction)settingTapped:(id)sender;



@end
