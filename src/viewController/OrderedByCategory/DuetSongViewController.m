//
//  DuetSongViewController.m
//  myFans
//
//  Created by wonliao on 13/1/17.
//
//

#import "DuetSongViewController.h"

@interface DuetSongViewController ()
@property (nonatomic, strong) NSArray *sampleItems;
@end

@implementation DuetSongViewController
@synthesize sampleItems;

- (void)awakeFromNib
{
    self.sampleItems = [NSArray arrayWithObjects:
                        @"今天你要嫁給我",
                        @"寧夏",
                        @"挪威的森林",
                        @"一千個傷心的理由",
                        @"日不落",
                        @"寶貝對不起",
                        @"失戀陣線聯盟",
                        @"記事本",
                        @"大海",
                        @"很愛很愛你",
                        @"世界第一等",
                        @"笨小孩",
                        @"用生命所愛的人",
                        @"再會啦心愛的無緣的人",
                        @"你愛誰",
                        @"原來你什麼都不要",
                        @"小鎮姑娘",
                        @"菊花台",
                        @"寂寞沙洲冷",
                        @"你不愛我",
                        @"十年",
                        @"星語心願",
                        @"一路上有你",
                        @"小城故事",
                        @"天高地厚",
                        @"死了都要愛",
                        @"忠孝東路走九遍",
                        @"除了愛你還能愛誰",
                        nil];
    
}

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [button setTitle:@"演唱" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonTapped:)
     forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = button;

    
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [self.sampleItems objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    
    //if (indexPath.row > 0)
    //    cell.detailTextLabel.text = @"演唱者";
    //else
    //    cell.detailTextLabel.text = nil;
    
    
    return cell;
}

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}
*/
/*使第一行不作用
 -(NSIndexPath *)tableView:(UITableView *)tableView
 willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 NSUInteger row = [indexPath row];
 
 if (row == 0)
 return nil;
 
 return indexPath;
 }
 */
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    NSString *rowValue = [sampleItems objectAtIndex:row];
    
    NSString *message = [[NSString alloc] initWithFormat:
                         @"您點播了 %@", rowValue];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"系統"
                          message:message
                          delegate:nil
                          cancelButtonTitle:@"知道了"
                          otherButtonTitles:nil];
    [alert show];
    
    
    
    /*
     NSString *identifier =@"SongList";
     UIViewController *singViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
     //singViewController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
     //[self presentModalViewController:singViewController animated:YES];
     
     [self.navigationController pushViewController:singViewController animated:YES];
     
     */
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    
    
}
- (IBAction)buttonTapped:(id)sender {
    //UIButton *senderButton = (UIButton *)sender;
    //UITableViewCell *buttonCell =
    //(UITableViewCell *)[senderButton superview];
    //NSUInteger buttonRow = [[self.tableView indexPathForCell:buttonCell] row];
    //NSString *buttonTitle = [list objectAtIndex:buttonRow];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"點歌完成"
                          message:[NSString stringWithFormat:
                                   @"點歌完成,播歌準備中"]
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}
@end