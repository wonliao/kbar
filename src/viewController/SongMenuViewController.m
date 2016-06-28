//
//  SongMenuViewController.m
//  myFans
//
//  Created by wonliao on 13/1/16.
//  Copyright (c) 2013年 wonliao. All rights reserved.
//

#import "SongMenuViewController.h"
//#import "PushTestViewController.h"
#import "CustomNavigationBar.h"
#import "OrderByArtistViewController.h"
#import "RecordingViewController.h"
#import "Record.h"      // 錄音的資料庫互動類別
#import "Recording.h"   // 目前要錄音的資料庫互動類別
#import "FBCoreData.h"  // fbUserInfo的資料庫互動類別
#import "RecordSongList.h"  // 可錄歌曲列表的資料庫互動類別
#import "WpSongData.h"  // wordpress的歌曲資料格式

@interface SongMenuViewController()
@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation SongMenuViewController
@synthesize m_recordData, sampleItems, downloadBars, m_wordpress;

- (void)awakeFromNib
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.m_wordpress = [[wordpress alloc] init];

    // 取得應用程式的代理物件參照
    m_coreData = [[CoreData alloc] init];

    m_recordData = [self loadRecordData];

    // 下載吧
    self.downloadBars = [[NSMutableArray alloc] init];

    NSArray *segmentTextContent = [NSArray arrayWithObjects:
                                   @"點歌台",
                                   @"已點歌曲",
                                   @"我的錄音",
                                   nil];
    self.segment_title = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
    UIFont *font = [UIFont boldSystemFontOfSize:16.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:UITextAttributeFont];
    [self.segment_title setTitleTextAttributes:attributes
                                      forState:UIControlStateNormal];
    self.segment_title.selectedSegmentIndex = 0;
    self.segment_title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.segment_title.segmentedControlStyle = UISegmentedControlStyleBar;
    self.segment_title.frame = CGRectMake(0, 0, 300, 30);
    //[self.segment_title addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    //self.navigationItem.titleView = self.segment_title;

    self.sampleItems = [[NSMutableArray alloc] init];
    [self.sampleItems addObject:@"演唱已下載歌曲"];

    NSMutableArray* returnObjs = [m_coreData loadDataFromRecordSongList];
    if( [returnObjs count] > 0 ) {

        for( RecordSongList* recordSongList in returnObjs ) {

            [self.sampleItems addObject:recordSongList.name];
        }
    }
}
/*
- (void)segmentAction:(id)sender
{
    switch (self.segment_title.selectedSegmentIndex) {

        case 0:
            //NSLog(@"case0");
            break;
        case 1:
            //NSLog(@"case1");
            break;
        case 2:
            //NSLog(@"case2");
            break;
    }
}
*/

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear");

    // 檢查 facebook 登入
    [self checkFacebook];
}

// 檢查 facebook 登入
- (void)checkFacebook
{
    // 取得 facebook 資料
    FBCoreData *fbCoreData = [[FBCoreData alloc] init];
    [fbCoreData load];

    if( [fbCoreData.fbUID isEqual:@""] ) {

        NSLog(@"未登錄facebook!!");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"先登錄" message:@"您需要先登錄k吧才能完成操作" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"登錄",nil];
        [alert show];
    } else {

        NSLog(@"已登錄facebook!!");
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {

        NSLog(@"返回");
        [self dismissModalViewControllerAnimated:YES];
    } else if (buttonIndex == 1) {

        NSLog(@"登錄");
        NSString *identifier =@"LoginTop2";
        UIViewController *singViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        singViewController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
        [self presentModalViewController:singViewController animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.sampleItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NSString *cellIdentifier = @"SampleCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [self.sampleItems objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        
        cell.accessoryView = nil;
        return cell;
    }

    NSString *cellIdentifier = @"SampleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    //演唱button
    UIImage *buttonUpImage = [UIImage imageNamed:@"button_up.png"];
    UIImage *buttonDownImage = [UIImage imageNamed:@"button_down.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, buttonUpImage.size.width,
                              buttonUpImage.size.height);
    [button setBackgroundImage:buttonUpImage
                      forState:UIControlStateNormal];
    [button setBackgroundImage:buttonDownImage
                      forState:UIControlStateHighlighted];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [button setTitle:@"下載" forState:UIControlStateNormal];
    [button setTag:[indexPath row]];
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = button;

    cell.textLabel.text = [self.sampleItems objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
/*
    // 檢查是否已下載
    for( Record* currentRecord in m_recordData ) {

        if( [currentRecord.row isEqualToString:[NSString stringWithFormat:@"%d", indexPath.row] ] ) {

            if( [currentRecord.downloaded isEqualToString:@"YES"] ) {

                [button setTitle:@"演唱" forState:UIControlStateNormal];
                [button setEnabled:YES];
            }

            break;
        }
    }
*/
    // 清除 cell 的下載進度吧
    for (UITableViewCell *view in [cell subviews]) {

        if ([view isKindOfClass:[UIDownloadBar class]] ) {

            [view removeFromSuperview];
        }
    }

    // 將進度吧 重新加入 TableView 的 cell 中
    NSDictionary *dict = [self getBarForRow:indexPath.row];
    if (dict) {

        UIDownloadBar *bar = [dict objectForKey:@"bar"];
        [cell addSubview:bar];

        float percent = bar.percentComplete;
        if( percent < 100.0 ) {

            [button setTitle:@"下載中" forState:UIControlStateNormal];
            [button setEnabled:NO];
        } else {

            [button setTitle:@"演唱" forState:UIControlStateNormal];
            [button setEnabled:YES];
        }
    }

    return cell;
}
/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {

        NSString *identifier =@"SongList";
        UIViewController *singViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];

        [self.navigationController pushViewController:singViewController animated:YES];
    }else{

        NSString *identifier =@"OthersSong";
        UIViewController *singViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];

        [self.navigationController pushViewController:singViewController animated:YES];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)orderByArtist:(id)sender
{
}

- (IBAction)orderByCatagory:(id)sender
{
}

- (IBAction)buttonTapped:(id)sender
{
/*
    UIButton *button = (UIButton *)sender;
    NSString* text = button.titleLabel.text;
    NSString* row = [NSString stringWithFormat:@"%d", button.tag];
    NSLog( @"button(%@) row(%d)", text, row.intValue );

    // 下載
    if( [text isEqualToString: @"下載"] ) {

        NSString* title = [self.sampleItems objectAtIndex:row.intValue];
        NSLog(@"title(%@) row(%d)", title, row.intValue);

        // 從 wordpress 取得下載資料
        NSString* downloadFile = [self getSongFromWordpress:row WithTitle:title AndRow:row];

        // 下載進度吧
        UIDownloadBar *bar = [[UIDownloadBar alloc] initWithURL:[NSURL URLWithString: downloadFile]
                                               progressBarFrame:CGRectMake( 210, 18, 50, 20)
                                                        timeout:15
                                                       delegate:self];

        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:bar forKey:@"bar"];
        [dict setObject:[NSNumber numberWithInt:button.tag] forKey:@"row"]; 
        [self.downloadBars addObject:dict];

        // 將進度吧 加入 TableView 的 cell 中
        [button.superview addSubview:bar];

        // 按鈕文字改為下載中
        [button setTitle:@"下載中" forState:UIControlStateNormal];
        NSLog( @"button(%@)", button.titleLabel.text );
        [button setEnabled:NO];

    // 下載中
    } else if( [text isEqualToString: @"下載中"] ) {

        // 不做任何事

    // 演唱
    } else if( [text isEqualToString: @"演唱"] ) {

        NSArray* array = [self loadRecordDataByRow: row];
        if( [array count] > 0 ) {

            NSString* index = [array objectAtIndex:0];
            NSString* title = [array objectAtIndex:1];
            //NSString* file_name = [array objectAtIndex:2];
            NSString* file = [array objectAtIndex:3];
            NSString* content = [array objectAtIndex:4];

            // 存入 Recording 資料庫
            [self addRecordingData:index WithTitle:title AndFile:file AndContent:content];
        }

        // 切換到 RecordingSong 頁面
        [self gotoRecordingSong];
    }
*/
}

// 取得　bar 資訊 by row
- (NSDictionary*)getBarForRow:(int)row
{
    for (NSDictionary *dict in self.downloadBars) {
        if ([[dict objectForKey:@"row"] intValue] == row) {
            return dict;
        }
    }
    return nil;
}

// 切換到 RecordingSong 頁面
- (void) gotoRecordingSong
{
    NSString *identifier = @"RecordingSong";
    UIViewController *singViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];

    singViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

    [self presentModalViewController:singViewController animated:YES];
}

// 下載 MP3 完成
- (void)downloadBar:(UIDownloadBar *)downloadBar didFinishWithData:(NSData *)fileData suggestedFilename:(NSString *)filename
{
    int row = [self loadRecordData:filename];
    NSLog(@"downloa file done!!! row(%d) filename(%@)", row, filename);

    // 將檔案存至 tmp 目錄下
    NSURL *tmpDirURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSString* fileToSaveTo = [[tmpDirURL path] stringByAppendingString:@"/"];
    fileToSaveTo = [fileToSaveTo stringByAppendingString:filename];
    [fileData writeToFile:[NSString stringWithFormat:@"%@",fileToSaveTo] atomically:YES];

    // 按鈕文字改為演唱
    UIButton *button = (UIButton *)[self.view viewWithTag:row];
    [button setTitle:@"演唱" forState:UIControlStateNormal];
    NSLog( @"button(%@)", button.titleLabel.text );
    [button setEnabled:YES];

    // 更新資料庫中的資料
    [self updateRecordDataByRow:[NSString stringWithFormat:@"%d", row]];
}

// 下載 MP3 失敗
- (void)downloadBar:(UIDownloadBar *)downloadBar didFailWithError:(NSError *)error
{
	NSLog(@"Error:%@", error);
}

// 下載 MP3 中
- (void)downloadBarUpdated:(UIDownloadBar *)downloadBar
{
}

- (IBAction)backButtonTapped:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

// 從資料庫中讀取資料
- (NSMutableArray *) loadRecordData
{
    NSMutableArray* returnObjs = [m_coreData loadDataFromRecord];
    return returnObjs;
}

// 從資料庫中讀取資料
- (int) loadRecordData:(NSString *)fileName
{
/*
    NSMutableArray* returnObjs = [m_coreData loadDataFromRecord];
    for( Record* currentRecord in returnObjs ) {

        if( [currentRecord.file_name isEqualToString: fileName] ) {

            NSLog(@"row(%d) index(%@) title(%@) file(%@)", currentRecord.row.intValue, currentRecord.index, currentRecord.title, currentRecord.file);
            return currentRecord.row.intValue;
        }
    }
*/
    return nil;
}

// 從資料庫中讀取資料 by Row
- (NSArray *) loadRecordDataByRow:(NSString *)row
{
/*
    NSMutableArray* returnObjs = [m_coreData loadDataFromRecord];
    for( Record* currentRecord in returnObjs ) {

        if( [currentRecord.row isEqualToString: row] ) {

            NSLog(@"row(%d) index(%d) title(%@) file(%@)", currentRecord.row.intValue, currentRecord.index.intValue, currentRecord.title, currentRecord.file);
            return [NSArray arrayWithObjects:currentRecord.index, currentRecord.title, currentRecord.file_name, currentRecord.file, currentRecord.content, nil];
        }
    }
*/
    return nil;
}
/*
// 新增資料庫管理物件準備寫入
- (void) addRecordData:(NSString *)index WithTitle:(NSString *)title AndFileName:(NSString *)name AndFile:(NSString *)file AndRow:(NSString *)row AndContent:(NSString *)content
{
    NSLog(@"新增資料庫管理物件準備寫入");

    [m_coreData addDataToRecord:index WithTitle:title AndFileName:name AndFile:file AndRow:row AndContent:content];
}
*/

// 更新資料庫中的資料
- (void) updateRecordDataByRow:(NSString *)row
{
/*
    // 設定從Core Data框架中取出Beverage的Entity
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Record" inManagedObjectContext:[m_coreData managedObjectContext]];
    [request setEntity:entity];

    NSError* error = nil;
    // 執行存取的指令並且將資料載入returnObjs
    NSMutableArray* returnObjs = [[[m_coreData managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];

    for( Record* currentRecord in returnObjs ) {

        if( [currentRecord.row isEqualToString: row] ) {

            currentRecord.downloaded = @"YES";

            if( ![[m_coreData managedObjectContext] save:&error] ) {

                NSLog(@"物件更新失敗");
            }
        }
    }
*/
}

// 新增資料庫管理物件準備寫入
- (void) addRecordingData:(NSString *)index WithTitle:(NSString *)title AndFile:(NSString *)file AndContent:(NSString *)content
{
    NSLog(@"新增資料庫管理物件準備寫入");

    [m_coreData addDataToRecording:index WithTitle:title AndFile:file AndContent:content];
}
/*
// 從 wordpress 取得下載資料
- (NSString*) getSongFromWordpress:(NSString *)index WithTitle:(NSString *)title AndRow:(NSString *)row
{
    NSString *query = [NSString stringWithFormat:@"song.php?song_title=%@", title];
    NSArray *parsedElements = [self.m_wordpress queryWordpress:query];
    if( [parsedElements count] > 0 ) {

        NSDictionary *aModuleDict = [parsedElements objectAtIndex:0];
        WpSongData *wpSongData = [[WpSongData alloc] initWithDictionary:aModuleDict];

        NSString *fileName;
        // 2個資料來源
        NSRange searchString1 = [wpSongData.mp3_url rangeOfString:@"cobrand.kkbox.com.tw"];
        if( searchString1.length > 0 ) {

            fileName = [wpSongData.mp3_url stringByReplacingOccurrencesOfString:@"http://cobrand.kkbox.com.tw/efun/songs/" withString:@""];
            fileName = [fileName substringFromIndex:3];
        } else {

            fileName = [wpSongData.mp3_url stringByReplacingOccurrencesOfString:@"http://54.200.150.53/kbar/wp-content/uploads/" withString:@""];
            fileName = [fileName substringFromIndex:8];
        }

        // 存放至 tmp 目錄下
        NSURL *tmpDirURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
        NSString* fileToSaveTo = [[tmpDirURL path] stringByAppendingString:@"/"];
        NSString* file = [fileToSaveTo stringByAppendingString:fileName];
        NSLog(@"file(%@)", file);

        // 存入資料庫
        [self addRecordData:wpSongData.post_id WithTitle:wpSongData.post_title AndFileName:fileName AndFile:file AndRow:row AndContent:wpSongData.post_content ];

        return wpSongData.mp3_url;
    }

    return @"";
}
*/
// 點歌台
- (IBAction)orderSong:(id)sender
{
}

// 已點歌曲
- (IBAction)myOrderedList:(id)sender
{
}

// 我的錄音
- (IBAction)myRecordedList:(id)sender
{
}

@end
