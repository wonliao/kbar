//
//  FollowViewController.m
//  myFans
//
//  Created by vincent on 13/1/16.
//  Copyright (c) 2013年 vincent. All rights reserved.
//


#import "FollowViewController.h"
#import <CoreLocation/CoreLocation.h>


#define kCustomRowHeight  60.0
#define kCustomRowCount   7
#define kAppIconHeight    48


@interface FollowViewController ()

@end

@implementation FollowViewController

@synthesize entries;


- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder])) {
        
		lazyImages = [[MHLazyTableImages alloc] init];
		lazyImages.placeholderImage = [UIImage imageNamed:@"Placeholder"];
		lazyImages.delegate = self;
        
        m_rankType = 1;
	}
	return  self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    // 取得應用程式的代理物件參照
    m_coreData = [[CoreData alloc] init];
    
    lazyImages.tableView = m_tableView;
	m_tableView.rowHeight = kCustomRowHeight;
    
    m_wordpress = [[wordpress alloc] init];
    
    [self checkFacebook];
    [self loadRecordData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getCommentList];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	lazyImages.tableView = nil;
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

			WpFollowData* wpFollowData = [self.entries objectAtIndex:indexPath.row];
			cell.textLabel.text = wpFollowData.user_name;
			cell.detailTextLabel.text = wpFollowData.post_title;
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
	WpFollowData* wpFollowData = [self.entries objectAtIndex:indexPath.row];
	return [NSURL URLWithString:wpFollowData.imageURLString];
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

- (void)getCommentList
{
    NSString *query = [NSString stringWithFormat:@"follow.php?uid=FB_%@", m_FbCoreData.fbUID];
    [m_wordpress queryWordpress:query completion:^(NSArray *parsedElements){
        
        if( [parsedElements count] > 0 ) {
            
            NSMutableArray *workingArray = [[NSMutableArray alloc] init];
            for (NSDictionary *aModuleDict in parsedElements) {
                
                WpFollowData* wpFollowData = [[WpFollowData alloc] initWithDictionary:aModuleDict];
                [workingArray addObject:wpFollowData];
            }
            
            self.entries = workingArray;
            [m_tableView reloadData];
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 新增資料庫管理物件準備寫入
    WpFollowData* wpFollowData = [self.entries objectAtIndex:indexPath.row];
    [self addPlayingData:wpFollowData.post_id WithTitle:wpFollowData.post_title AndImageFileName:wpFollowData.imageURLString AndFBImageFileName:wpFollowData.imageURLString AndName:wpFollowData.post_title];
    
    NSString *identifier =@"PlaySong";
    UIViewController *singViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
	singViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentModalViewController:singViewController animated:YES];
}

// 新增資料庫管理物件準備寫入
- (void) addPlayingData:(NSString *)post_id WithTitle:(NSString *)title AndImageFileName:(NSString *)imageFilename AndFBImageFileName:(NSString *)fbImageFilename AndName:(NSString *)name
{
    [m_coreData addDataToPlaying:post_id WithTitle:title AndImageFileName:imageFilename AndFBImageFileName:fbImageFilename AndName:name];
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

@end

