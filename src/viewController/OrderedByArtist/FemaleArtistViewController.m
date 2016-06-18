//
//  FemaleArtistViewController.m
//  myFans
//
//  Created by wonliao on 13/1/17.
//
//

#import "FemaleArtistViewController.h"

@interface FemaleArtistViewController ()
@property (nonatomic, strong) NSArray *sampleItems;
@end

@implementation FemaleArtistViewController
@synthesize sampleItems;

- (void)awakeFromNib
{
    self.sampleItems = [NSArray arrayWithObjects: @"蔡依林",@"梅豔芳", @"鄧麗君",@"張惠妹",@"梁靜茹",
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    /*
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
     
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
     */
    
    
    NSString *identifier =@"SongList";
    UIViewController *singViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    //singViewController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    //[self presentModalViewController:singViewController animated:YES];
    
    [self.navigationController pushViewController:singViewController animated:YES];
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    
    
}

@end