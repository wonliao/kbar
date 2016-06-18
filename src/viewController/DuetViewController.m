//
//  DuetViewController.m
//  myFans
//
//  Created by wonliao on 13/1/16.
//  Copyright (c) 2013年 wonliao. All rights reserved.
//


#import "DuetViewController.h"
#import "WpChorusData.h"
#import "WpSongData.h"

#define kCustomRowHeight  60.0
#define kCustomRowCount   7
#define kAppIconHeight    48

@implementation DuetViewController

@synthesize segment_title;
@synthesize entries;
@synthesize m_HUD;

- (void)viewDidLoad
{
    [super viewDidLoad];

    lazyImages = [[MHLazyTableImages alloc] init];
    lazyImages.placeholderImage = [UIImage imageNamed:@"Placeholder"];
    lazyImages.delegate = self;
    
    lazyImages.tableView = m_tableView;
	m_tableView.rowHeight = kCustomRowHeight;
    
    m_percentComplete = 0.0f;

    [self getList];
}

- (void)segmentAction:(id)sender
{
    switch (self.segment_title.selectedSegmentIndex) {
        case 0:
            //m_currentData = self.m_page1;
            break;
        case 1:
            //m_currentData = self.m_page2;
            break;
        case 2:
            //m_currentData = self.m_page3;
            break;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.segment_title = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSArray *segmentTextContent = [NSArray arrayWithObjects:
                                   @"熱門的",
                                   @"我關注的",
                                   @"我發起的",
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
    self.segment_title.frame = CGRectMake(0, 0, 306, 30);
    [self.segment_title addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segment_title;
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView*)theTableView numberOfRowsInSection:(NSInteger)section
{
	int count = [entries count];
    if (count == 0) {
        
        return kCustomRowCount;  // enough rows to fill the screen
	} else {
        
		return count;
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	int nodeCount = [self.entries count];
    
	if (nodeCount == 0 && indexPath.row == 0) {
        
		static NSString* PlaceholderCellIdentifier = @"PlaceholderCell";
        
		UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
		if (cell == nil) {
            
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PlaceholderCellIdentifier];
			cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
        
		cell.detailTextLabel.text = @"載入中…";
		return cell;
	} else {
        
		static NSString* CellIdentifier = @"LazyTableCell";
        
		UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
            
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
        
		if (nodeCount > 0) {
            
			WpChorusData *wpChorusData = [self.entries objectAtIndex:indexPath.row];
			cell.textLabel.text = wpChorusData.singer_name;
			cell.detailTextLabel.text = wpChorusData.title;
			[lazyImages addLazyImageForCell:cell withIndexPath:indexPath];
		}
        
		return cell;
	}
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate
{
	[lazyImages scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
	[lazyImages scrollViewDidEndDecelerating:scrollView];
}

#pragma mark -
#pragma mark MHLazyTableImagesDelegate

- (NSURL*)lazyImageURLForIndexPath:(NSIndexPath*)indexPath
{
	WpChorusData* wpChorusData = [self.entries objectAtIndex:indexPath.row];
	return [NSURL URLWithString:wpChorusData.imageURLString];
}

- (UIImage*)postProcessLazyImage:(UIImage*)image forIndexPath:(NSIndexPath*)indexPath
{
    if (image.size.width != kAppIconHeight && image.size.height != kAppIconHeight) {
        
        CGSize itemSize = CGSizeMake(kAppIconHeight, kAppIconHeight);
		UIGraphicsBeginImageContextWithOptions(itemSize, YES, 0);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		return newImage;
    } else {
        
        return image;
    }
}

- (void)handleError:(NSError*)error
{
	UIAlertView* alertView = [[UIAlertView alloc]
                              initWithTitle:@"Cannot Connet Server"
                              message:[error localizedDescription]
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
	[alertView show];
}

- (void)getList
{
    NSString *query = [NSString stringWithFormat:@"chorus.php?chorus_type=%d", 0];
    [m_wordpress queryWordpress:query completion:^(NSArray *parsedElements){

        if( [parsedElements count] > 0 ) {

            NSMutableArray *workingArray = [[NSMutableArray alloc] init];
            for (NSDictionary *aModuleDict in parsedElements) {

                WpChorusData* wpChorusData = [[WpChorusData alloc] initWithDictionary:aModuleDict];
                [workingArray addObject:wpChorusData];
            }

            self.entries = workingArray;
            [m_tableView reloadData];
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showUploadProgress];
    
    // 新增資料庫管理物件準備寫入
    WpChorusData* wpChorusData = [self.entries objectAtIndex:indexPath.row];

    // 從 wordpress 取得下載資料
    [self getSongFromWordpress:wpChorusData.post_id withTitle:wpChorusData.title];
}

// 從 wordpress 取得下載資料
- (void) getSongFromWordpress:(NSString *)postId withTitle:(NSString *)postTitle
{
    NSString *query = [NSString stringWithFormat:@"song.php?song_title=%@&song_id=%@", postTitle, postId];
    [m_wordpress queryWordpress:query completion:^(NSArray *parsedElements){
        
        if( [parsedElements count] > 0 ) {
            
            NSDictionary *aModuleDict = [parsedElements objectAtIndex:0];
            WpSongData *wpSongData = [[WpSongData alloc] initWithDictionary:aModuleDict];
            
            NSString *fileName = [wpSongData.mp3_url stringByReplacingOccurrencesOfString:@"wp-content/uploads/records/" withString:@""];
            fileName = [fileName substringFromIndex:3];
            
            NSURL *tmpDirURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
            NSString* fileToSaveTo = [[tmpDirURL path] stringByAppendingString:@"/"];
            NSString* file = [fileToSaveTo stringByAppendingString:fileName];
            NSLog(@"file(%@)", file);
            
            // 存入 Recording 資料庫
            [m_coreData addDataToRecording:wpSongData.post_id WithTitle:wpSongData.post_title AndFile:file AndContent:wpSongData.post_content];
            
            NSString *downloadFile = [NSString stringWithFormat:@"http://54.200.150.53/kbar/%@", wpSongData.mp3_url];
            NSLog(@"downloadFile(%@)", downloadFile );

            // 下載進度吧
            UIDownloadBar *bar = [[UIDownloadBar alloc] initWithURL:[NSURL URLWithString: downloadFile]
                                                   progressBarFrame:CGRectMake( 210, 18, 50, 20)
                                                            timeout:15
                                                           delegate:self];
            NSLog(@"%d", bar.tag);
        }
    }];
}

// 下載 MP3 完成
- (void)downloadBar:(UIDownloadBar *)downloadBar didFinishWithData:(NSData *)fileData suggestedFilename:(NSString *)filename
{
    //int row = [self loadRecordData:filename];
    NSLog(@"downloa file done!!! filename(%@)", filename);
    
    // 將檔案存至 tmp 目錄下
    NSURL *tmpDirURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSString* fileToSaveTo = [[tmpDirURL path] stringByAppendingString:@"/"];
    fileToSaveTo = [fileToSaveTo stringByAppendingString:filename];
    [fileData writeToFile:[NSString stringWithFormat:@"%@",fileToSaveTo] atomically:YES];

    [self gotoRecordingSong];
}

// 下載 MP3 失敗
- (void)downloadBar:(UIDownloadBar *)downloadBar didFailWithError:(NSError *)error
{
	NSLog(@"Error:%@", error);
}

// 下載 MP3 中
- (void)downloadBarUpdated:(UIDownloadBar *)downloadBar
{
    m_percentComplete = downloadBar.percentComplete;
}

// 播放 上傳中的進度吧
- (void) showUploadProgress
{
    m_percentComplete = 0.0f;

    m_HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:m_HUD];
 	m_HUD.mode = MBProgressHUDModeAnnularDeterminate;
    m_HUD.dimBackground = YES;
    m_HUD.delegate = self;
    m_HUD.labelText = @"緩存中";
    
    [m_HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

// 檢查是否下載完成
- (void)myTask
{
	while( m_percentComplete < 100.0f ) { // 等待下載中
        
        // 下載進度
        NSLog(@"m_percentComplete(%f)", m_percentComplete);
        m_HUD.progress = m_percentComplete / 100.0f;
        
        sleep(1);
    }
    
    NSLog(@"end task");
}

// 切換到 RecordingSong 頁面
- (void) gotoRecordingSong
{
    NSString *identifier = @"RecordingSong";
    UIViewController *singViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    singViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentModalViewController:singViewController animated:YES];
}

@end
