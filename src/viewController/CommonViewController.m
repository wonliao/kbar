//
//  CommonViewController.m
//  kBar
//
//  Created by wonliao on 13/4/20.
//
//

#import "CommonViewController.h"

@interface CommonViewController ()

@end

@implementation CommonViewController

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
  
    // 取得應用程式的代理物件參照
    m_coreData = [[CoreData alloc] init];
    
    m_wordpress = [[wordpress alloc] init];
    
    [self checkFacebook];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 檢查 facebook 登入
- (void)checkFacebook
{
    // 取得 facebook 資料
    m_FbCoreData = [[FBCoreData alloc] init];
    [m_FbCoreData load];
    
    if( [m_FbCoreData.fbUID isEqual:@""] ) {
        
        NSLog(@"未登錄facebook!!");
    } else {
        
        NSLog(@"已登錄facebook!!");
    }
}

@end
