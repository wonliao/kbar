//
//  GuideViewController.h
//  kBar
//
//  Created by wonliao on 13/3/20.
//
//

#import <UIKit/UIKit.h>
#import "SliderPageControl.h"
#import <QuartzCore/CoreAnimation.h>
@class CAEmitterLayer;

@interface GuideViewController : UIViewController<SliderPageControlDelegate, UIScrollViewDelegate>{
	UIScrollView *scrollView;
	NSMutableArray *demoContent;
	SliderPageControl *sliderPageControl;
	BOOL pageControlUsed;
}

@property (nonatomic, retain) SliderPageControl *sliderPageControl;
@property (nonatomic, retain) NSMutableArray *demoContent;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIButton *gotoMainViewBtn;
@property (strong) CAEmitterLayer *ringEmitter;


- (IBAction)gotoMainView:(id)sender;
- (void)slideToCurrentPage:(bool)animated;
- (void)changeToPage:(int)page animated:(BOOL)animated;
//- (void) touchAtPosition:(CGPoint)position;

@end
