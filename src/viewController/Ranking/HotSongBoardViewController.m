//
//  HotSongBoardViewController.m
//  kBar
//
//  Created by wonliao on 13/4/18.
//
//

#import "HotSongBoardViewController.h"

@interface HotSongBoardViewController ()

@end

@implementation HotSongBoardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    m_rankType = 4;

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
