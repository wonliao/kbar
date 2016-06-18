//
//  FindFriendViewController.m
//  myFans
//
//  Created by vincent on 13/1/16.
//  Copyright (c) 2013年 vincent. All rights reserved.
//


#import "CommentViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "FBCoreData.h"
#import "ASIHTTPRequest.h"
#import "MHImageCache.h"
#import "Playing.h"     // 目前播放歌的資料庫互動類別
#import "WpCommentData.h"

#define kCustomRowHeight  60.0
#define kCustomRowCount   7
#define kAppIconHeight    48


@interface CommentViewController ()

@end

@implementation CommentViewController

@synthesize entries;


- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder])) {

		lazyImages = [[MHLazyTableImages alloc] init];
		lazyImages.placeholderImage = [UIImage imageNamed:@"Placeholder"];
		lazyImages.delegate = self;
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
		}

		cell.detailTextLabel.text = @"載入中…";
		return cell;
	} else {

		static NSString* CellIdentifier = @"LazyTableCell";

		UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {

			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
        
		if (nodeCount > 0) {

			WpCommentData* wpCommentData = [self.entries objectAtIndex:indexPath.row];
			cell.textLabel.text = wpCommentData.author;
			cell.detailTextLabel.text = wpCommentData.content;
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
	WpCommentData* wpCommentData = [self.entries objectAtIndex:indexPath.row];
	return [NSURL URLWithString:wpCommentData.imageURLString];
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
	//[alertView release];
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
    NSString *query = [NSString stringWithFormat:@"comment.php?song_id=%@&uid=FB_%@", m_post_id, m_FbCoreData.fbUID];
    [m_wordpress queryWordpress:query completion:^(NSArray *parsedElements){

        if( [parsedElements count] > 0 ) {

            NSMutableArray *workingArray = [[NSMutableArray alloc] init];
            for (NSDictionary *aModuleDict in parsedElements) {

                WpCommentData* wpCommentData = [[WpCommentData alloc] initWithDictionary:aModuleDict];
                [workingArray addObject:wpCommentData];
            }

            self.entries = workingArray;
            [m_tableView reloadData];
        }
    }];
}

- (IBAction)backButtonTapped:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
    
@end