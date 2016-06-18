//
//  RankingViewController.m
//  myFans
//
//  Created by wonliao on 13/1/16.
//  Copyright (c) 2013年 wonliao. All rights reserved.
//


#import "RankingViewController.h"

@interface RankingViewController ()
@property (nonatomic, strong) NSArray *sampleItems;
@end

@implementation RankingViewController

@synthesize sampleItems;



- (void)awakeFromNib
{
    self.sampleItems = [NSArray arrayWithObjects:
                        @"週新人榜",
                        @"週熱門歌榜",
                        @"最紅歌手榜",
                        @"最紅歌曲榜",
                        @"合唱歌曲榜",
                        nil];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
    // shadowPath, shadowOffset, and rotation is handled by ECSlidingViewController.
    // You just need to set the opacity, radius, and color.
    // 上層View的陰影
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;

    //初始左側下一層View
  if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
    self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
  }
  self.slidingViewController.underRightViewController = nil;
  self.slidingViewController.anchorLeftPeekAmount     = 0;
  self.slidingViewController.anchorLeftRevealAmount   = 0;
  
  [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (IBAction)revealMenu:(id)sender
{
  [self.slidingViewController anchorTopViewTo:ECRight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.sampleItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"SampleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [self.sampleItems objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // 週新人榜
    if (indexPath.row == 0) {

        NSString *identifier =@"WeekNewArtistBoard";
        UIViewController *singViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        [self.navigationController pushViewController:singViewController animated:YES];
    // 週熱門歌榜
    }else if(indexPath.row == 1){

        NSString *identifier =@"WeekHotSongBoard";
        UIViewController *singViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        [self.navigationController pushViewController:singViewController animated:YES];
    // 最紅歌手榜
    } else if(indexPath.row == 2){

        NSString *identifier =@"HotArtistBoard";
        UIViewController *singViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        singViewController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
        [self.navigationController pushViewController:singViewController animated:YES];
    // 最紅歌曲榜
    } else if(indexPath.row == 3){

        NSString *identifier =@"HotSongBoard";
        UIViewController *singViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        [self.navigationController pushViewController:singViewController animated:YES];
    // 合唱歌曲榜
    }else{

        NSString *identifier =@"HotDuetBoard";
        UIViewController *singViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        [self.navigationController pushViewController:singViewController animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
