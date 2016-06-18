//
//  SongListViewController.m
//  myFans
//
//  Created by vincent on 13/1/17.
//
//

#import "SongListViewController.h"
#import "Record.h"      // 錄音的資料庫互動類別


@interface SongListViewController ()
@property (nonatomic, strong) NSArray *sampleItems;
@end

@implementation SongListViewController
@synthesize m_recordData, sampleItems;

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

    // 取得應用程式的代理物件參照
    m_coreData = [[CoreData alloc] init];

    m_recordData = [self loadRecordData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    //return self.sampleItems.count;
    return [m_recordData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"SampleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    Record* currentRecord = [m_recordData objectAtIndex:indexPath.row];

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
    [button setTag:[indexPath row]];
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = button;

    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = currentRecord.title; //[self.sampleItems objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    
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
 
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)buttonTapped:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSString* text = button.titleLabel.text;
    NSString* row = [NSString stringWithFormat:@"%d", button.tag];
    NSLog( @"button(%@) row(%d)", text, row.intValue );
    
    Record* currentRecord = [m_recordData objectAtIndex:button.tag];
    if( currentRecord ) {

        NSString* index = currentRecord.index;
        NSString* title = currentRecord.title;
        //NSString* file_name = currentRecord.file_name;
        NSString* file = currentRecord.file;
        NSString* content = currentRecord.content;

        //NSLog( @"index(%@) title(%@) file_name(%@) file(%@) content(%@)", index, title, file_name, file, content );

        // 存入 Recording 資料庫
        [self addRecordingData:index WithTitle:title AndFile:file AndContent:content];
    }

    NSString *identifier =@"RecordingSong";
    UIViewController *singViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];

	singViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
	[self presentModalViewController:singViewController animated:YES];
}

// 從資料庫中讀取資料
- (NSMutableArray *) loadRecordData
{
    NSMutableArray* returnObjs = [m_coreData loadDataFromRecord];
    return returnObjs;
}

// 新增資料庫管理物件準備寫入
- (void) addRecordingData:(NSString *)index WithTitle:(NSString *)title AndFile:(NSString *)file AndContent:(NSString *)content
{
    NSLog(@"新增資料庫管理物件準備寫入");

    [m_coreData addDataToRecording:index WithTitle:title AndFile:file AndContent:content];
}

@end