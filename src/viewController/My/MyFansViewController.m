//
//  MyFansViewController.m
//  kBar
//
//  Created by wonliao on 13/2/19.
//
//

#import "MyFansViewController.h"

@interface MyFansViewController ()
@property (nonatomic, retain) NSMutableArray *dataArray;
@end

@implementation MyFansViewController
@synthesize dataArray,characterImageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CharacterData" ofType:@"plist"];
	self.dataArray = [NSMutableArray arrayWithContentsOfFile:path];

    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden = YES;
}


/*
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
 {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50; // your dynamic height...
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //	static NSString *kCustomCellID = @"MyCellID";
    UILabel *mainLabel, *secondLabel;
    NSDictionary *item = [dataArray objectAtIndex:indexPath.row];
	NSString* title = [item objectForKey:@"text"];
    NSString* detail = [item objectForKey:@"detail"];
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] ;
    
    
    cell.backgroundColor = [UIColor redColor];
    characterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 40.0, 40.0)];
    [cell.contentView addSubview:characterImageView];
    UIImage *Image1 = [UIImage imageNamed:[item objectForKey:@"image"]];
    characterImageView.image = Image1;
    
    
    mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0, 4.0, 150.0, 25.0)];
    mainLabel.font = [UIFont systemFontOfSize:14.0];
    mainLabel.textAlignment = UITextAlignmentLeft;
    mainLabel.textColor = [UIColor colorWithRed:2371.0 / 255.0 green:129.0 / 255.0 blue:41.0 / 255.0 alpha:1.0];
    [cell.contentView addSubview:mainLabel];
    mainLabel.text = title;
    
    secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0, 30.0, 200.0, 15.0)] ;
    secondLabel.font = [UIFont systemFontOfSize:12.0];
    secondLabel.textAlignment = UITextAlignmentLeft;
    secondLabel.textColor = [UIColor grayColor];
    [cell.contentView addSubview:secondLabel];
    secondLabel.text = detail;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    
	return cell;
}




- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    /*
     //[appDelegate showDetail:infoDict];
     NSDictionary *item = [dataArray objectAtIndex:indexPath.row];
     characterImage.imagename = [item objectForKey:@"image"];
     //init Setting View
     TakePhotoViewController *takePhotoViewController =[[TakePhotoViewController alloc]init];
     takePhotoViewController.characterImage=characterImage;
     //Set modalTransitionStyle
     takePhotoViewController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
     [self presentModalViewController:takePhotoViewController animated:YES];
     */
    NSString *identifier =@"OthersHome";
    UIViewController *singViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self.navigationController pushViewController:singViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     //[appDelegate showDetail:infoDict];
     NSDictionary *item = [dataArray objectAtIndex:indexPath.row];
     characterImage.imagename = [item objectForKey:@"image"];
     //init Setting View
     TakePhotoViewController *takePhotoViewController =[[TakePhotoViewController alloc]init];
     takePhotoViewController.characterImage=characterImage;
     //Set modalTransitionStyle
     takePhotoViewController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
     [self presentModalViewController:takePhotoViewController animated:YES];
     */
    NSString *identifier =@"OthersHome";
    UIViewController *singViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self.navigationController pushViewController:singViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonTapped:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end
