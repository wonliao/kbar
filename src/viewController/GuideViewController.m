//
//  GuideViewController.m
//  kBar
//
//  Created by wonliao on 13/3/20.
//
//

#import "GuideViewController.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

@synthesize scrollView;
@synthesize demoContent;
@synthesize sliderPageControl;
@synthesize ringEmitter;
@synthesize  gotoMainViewBtn;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //判斷是否第一次進入app
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    
    /*
     
     if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
     ViewController *appStartController = [[ViewController alloc] init];
     self.window.rootViewController = appStartController;
     [appStartController release];
     }else {
     NextViewController *mainViewController = [[NextViewController alloc] init];
     self.window.rootViewController=mainViewController;
     [mainViewController release];
     
     }
     */
    
    
    
    
    
    
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    self.demoContent = [NSMutableArray new];
    NSMutableDictionary *page1 = [NSMutableDictionary dictionary];
    [page1 setObject:@"用心" forKey:@"title"];
    [page1 setObject:@"g1.png" forKey:@"image"];
    [self.demoContent addObject:page1];
    NSMutableDictionary *page2 = [NSMutableDictionary dictionary];
    [page2 setObject:@"真實" forKey:@"title"];
    [page2 setObject:@"g2.png" forKey:@"image"];
    [self.demoContent addObject:page2];
    NSMutableDictionary *page3 = [NSMutableDictionary dictionary];
    [page3 setObject:@"自己" forKey:@"title"];
    [page3 setObject:@"g3.png" forKey:@"image"];
    [self.demoContent addObject:page3];
    NSMutableDictionary *page4 = [NSMutableDictionary dictionary];
    [page4 setObject:@"唱歌" forKey:@"title"];
    [page4 setObject:@"g4.png" forKey:@"image"];
    [self.demoContent addObject:page4];
    NSMutableDictionary *page5 = [NSMutableDictionary dictionary];
    [page5 setObject:@"開始" forKey:@"title"];
    [page5 setObject:@"g5.png" forKey:@"image"];
    [self.demoContent addObject:page5];


    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,[self.view bounds].size.width,[self.view bounds].size.height)];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake([self.demoContent count]*self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setDelegate:self];
    [self.view addSubview:self.scrollView];
    //[self.scrollView release];
    
    self.sliderPageControl = [[SliderPageControl  alloc] initWithFrame:CGRectMake(0,[self.view bounds].size.height-20,[self.view bounds].size.width,20)];
    [self.sliderPageControl addTarget:self action:@selector(onPageChanged:) forControlEvents:UIControlEventValueChanged];
    [self.sliderPageControl setDelegate:self];
    [self.sliderPageControl setShowsHint:YES];
    [self.view addSubview:self.sliderPageControl];
    //[self.sliderPageControl release];
    [self.sliderPageControl setNumberOfPages:[self.demoContent count]];
    [self.sliderPageControl setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    
    
    
    
    for (int i=0; i<[self.demoContent count]; i++)
    {
        //UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i*self.scrollView.frame.size.width,0,self.scrollView.frame.size.width,self.scrollView.frame.size.height)];
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.scrollView.frame.size.width,0,self.scrollView.frame.size.width,self.scrollView.frame.size.height)];
        //[cell.contentView addSubview:characterImageView];
        //[view setBackgroundColor:[[self.demoContent objectAtIndex:i] objectForKey:@"color"]];
        //UIImage *scrollImage = UIImage imageNamed:[self.demoContent objectForKey:@"image"];
        UIImage *scrollImage = [UIImage imageNamed:[[self.demoContent objectAtIndex:i] objectForKey:@"image"]];
        //NSLog(@"self.scrollView.frame.size.height= %f", (self.scrollView.frame.size.height));
        view.image = scrollImage;
        //characterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 40.0, 40.0)];
        //[cell.contentView addSubview:characterImageView];
        // UIImage *Image1 = [UIImage imageNamed:[item objectForKey:@"image"]];
        
        
        
        
        UIImage *buttonUpImage = [UIImage imageNamed:@"guidebutton.png"];
        //UIImage *buttonDownImage = [UIImage imageNamed:@"menu_icon_2_d.png"];
        self.gotoMainViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.gotoMainViewBtn.frame = CGRectMake(110.0, 300.0, 100,
                                                40);
        [self.gotoMainViewBtn setBackgroundImage:buttonUpImage
        forState:UIControlStateNormal];
        //[button setBackgroundImage:buttonDownImage
        //forState:UIControlStateHighlighted];
        [self.gotoMainViewBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [self.gotoMainViewBtn setTitle:@"開始k吧" forState:UIControlStateNormal];
        [self.gotoMainViewBtn addTarget:self action:@selector(gotoMainView:)
                       forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.gotoMainViewBtn];
        [self.gotoMainViewBtn setHidden:YES];
        
        
        
        
        
        
        
        [self.scrollView addSubview:view];
        //[view release];
        
        //particle
        CGRect viewBounds = self.view.layer.bounds;
        
        // Create the emitter layer
        self.ringEmitter = [CAEmitterLayer layer];
        
        // Cells spawn in a 50pt circle around the position
        self.ringEmitter.emitterPosition = CGPointMake(viewBounds.size.width/2.0, viewBounds.size.height/2.0);
        self.ringEmitter.emitterSize	= CGSizeMake(50, 0);
        self.ringEmitter.emitterMode	= kCAEmitterLayerOutline;
        self.ringEmitter.emitterShape	= kCAEmitterLayerCircle;
        self.ringEmitter.renderMode		= kCAEmitterLayerBackToFront;
        
        // Create the fire emitter cell
        CAEmitterCell* ring = [CAEmitterCell emitterCell];
        [ring setName:@"ring"];
        
        ring.birthRate			= 0;
        ring.velocity			= 250;
        ring.scale				= 1.2;
        ring.scaleSpeed			=-0.2;
        ring.greenSpeed			=-0.2;	// shifting to green
        ring.redSpeed			=-0.5;
        ring.blueSpeed			=-0.5;
        ring.lifetime			= 2;
        
        ring.color = [[UIColor whiteColor] CGColor];
        ring.contents = (id) [[UIImage imageNamed:@"DazTriangle"] CGImage];
        
        
        CAEmitterCell* circle = [CAEmitterCell emitterCell];
        [circle setName:@"circle"];
        
        circle.birthRate		= 10;			// every triangle creates 20
        circle.emissionLongitude = M_PI * 0.5;	// sideways to triangle vector
        circle.velocity			= 50;
        circle.scale			= 0.3;
        circle.scaleSpeed		=-0.2;
        circle.greenSpeed		=-0.1;	// shifting to blue
        circle.redSpeed			=-0.2;
        circle.blueSpeed		= 0.1;
        circle.alphaSpeed		=-0.2;
        circle.lifetime			= 4;
        
        circle.color = [[UIColor whiteColor] CGColor];
        circle.contents = (id) [[UIImage imageNamed:@"DazRing"] CGImage];
        
        
        CAEmitterCell* star = [CAEmitterCell emitterCell];
        [star setName:@"star"];
        
        star.birthRate		= 10;	// every triangle creates 20
        star.velocity		= 100;
        star.zAcceleration  = -1;
        star.emissionLongitude = -M_PI;	// back from triangle vector
        star.scale			= 0.5;
        star.scaleSpeed		=-0.2;
        star.greenSpeed		=-0.1;
        star.redSpeed		= 0.4;	// shifting to red
        star.blueSpeed		=-0.1;
        star.alphaSpeed		=-0.2;
        star.lifetime		= 2;
        
        star.color = [[UIColor whiteColor] CGColor];
        star.contents = (id) [[UIImage imageNamed:@"DazStarOutline"] CGImage];
        
        // First traigles are emitted, which then spawn circles and star along their path
        self.ringEmitter.emitterCells = [NSArray arrayWithObject:ring];
        ring.emitterCells = [NSArray arrayWithObjects:circle, star, nil];
        //	circle.emitterCells = [NSArray arrayWithObject:star];	// this is SLOW!
        [self.view.layer addSublayer:self.ringEmitter];
    }
    
    //[self changeToPage:0 animated:NO];
    
}






- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



#pragma mark scrollview delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView_
{
	pageControlUsed = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView_
{
    if (pageControlUsed)
	{
        return;
    }
	
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	[sliderPageControl setCurrentPage:page animated:YES];
    if (page == [self.demoContent count]-1) {
        [self.gotoMainViewBtn setHidden:NO];
    }
    else{
        [self.gotoMainViewBtn setHidden:YES];
        
        
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView_
{
	pageControlUsed = NO;
}

#pragma mark sliderPageControlDelegate

- (NSString *)sliderPageController:(id)controller hintTitleForPage:(NSInteger)page
{
	NSString *hintTitle = [[self.demoContent objectAtIndex:page] objectForKey:@"title"];
	return hintTitle;
}

- (void)onPageChanged:(id)sender
{
	pageControlUsed = YES;
	[self slideToCurrentPage:YES];
	
}

- (void)slideToCurrentPage:(bool)animated
{
	int page = sliderPageControl.currentPage;
	
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:animated];
    if (page == [self.demoContent count]-1) {
        [self.gotoMainViewBtn setHidden:NO];
    }
    else{
        [self.gotoMainViewBtn setHidden:YES];
        
        
    }
}

- (void)changeToPage:(int)page animated:(BOOL)animated
{
	[sliderPageControl setCurrentPage:page animated:YES];
    
	[self slideToCurrentPage:animated];
    
}
- (IBAction)gotoMainView:(id)sender{
    
    //particles
    // Bling bling..
	CABasicAnimation *burst = [CABasicAnimation animationWithKeyPath:@"emitterCells.ring.birthRate"];
	burst.fromValue			= [NSNumber numberWithFloat: 125.0];	// short but intense burst
	burst.toValue			= [NSNumber numberWithFloat: 0.0];		// each birth creates 20 aditional cells!
	burst.duration			= 0.5;
	burst.timingFunction	= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	
	[self.ringEmitter addAnimation:burst forKey:@"burst"];
    
	// Move to touch point
	[CATransaction begin];
	[CATransaction setDisableActions: YES];
	//self.ringEmitter.emitterPosition	= position;
	[CATransaction commit];

    
    
    NSString *identifier =@"InitDrawer";
    UIViewController *singViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
	
	singViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
	[self presentModalViewController:singViewController animated:YES];
    
    
}

@end
