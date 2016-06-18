//
//  AddCommentViewController.m
//  kBar
//
//  Created by wonliao on 13/4/11.
//
//

#import "AddCommentViewController.h"
#import "Playing.h"     // 目前播放歌的資料庫互動類別

@implementation AddCommentViewController

@synthesize myTextView;

- (void)viewDidLoad
{
	[super viewDidLoad];

    // 取得應用程式的代理物件參照
    m_coreData = [[CoreData alloc] init];

    m_wordpress = [[wordpress alloc] init];

    [self checkFacebook];
    [self loadRecordData];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
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

// 從資料庫中讀取資料
- (void) loadRecordData
{
    Playing *currentPlaying = [m_coreData loadDataFromPlaying];
    if( currentPlaying ) {

        m_post_id = currentPlaying.post_id;
    }
}

- (IBAction)buttonTapped:(id)sender
{    
    NSString *inputString = myTextView.text;
    NSLog(@"inputString(%@)", inputString);

    if( [inputString length] > 140 ) {

        UIAlertView* alertView = [[UIAlertView alloc]
                                  initWithTitle:@"提示"
                                  message:@"最多輸入140個中文字"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    } else if( [inputString length] <= 0 ) {

        UIAlertView* alertView = [[UIAlertView alloc]
                                  initWithTitle:@"提示"
                                  message:@"請輸入文字"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    } else {

        NSString *query = [NSString stringWithFormat:@"comment.php?song_id=%@&uid=FB_%@&add_comment=%@", m_post_id, m_FbCoreData.fbUID, inputString];
        [m_wordpress queryWordpress:query completion:^(NSArray *parsedElements){

            if( [parsedElements count] > 0 ) {
 
                NSString *result = [[parsedElements objectAtIndex:0] objectForKey:@"RESULT"];
                NSLog(@"result(%@)", result);
                if( [result isEqualToString:@"OK"] ) {

                    UIAlertView* alertView = [[UIAlertView alloc]
                                              initWithTitle:@"提示"
                                              message:@"新增評論成功"
                                              delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];

                    [self dismissModalViewControllerAnimated:YES];
                }
            }
        }];
    }
}

- (IBAction)backButtonTapped:(id)sender
{    
    [self dismissModalViewControllerAnimated:YES];
}

@end
