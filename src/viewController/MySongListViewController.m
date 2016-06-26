//
//  MySongListViewController.m
//  kBar
//
//  Created by wonliao on 2016/6/23.
//
//

#import "MySongListViewController.h"
#import "Record.h"      // 錄音的資料庫互動類別
#import "YFJLeftSwipeDeleteTableView.h"


@interface MySongListViewController ()
@property (nonatomic, strong) NSArray *songTitle;
@property (nonatomic, strong) NSArray *songKsc;
@property (nonatomic, strong) YFJLeftSwipeDeleteTableView * tableView;
@end



@implementation MySongListViewController
@synthesize m_recordData;
@synthesize songTitle, songKsc;

- (void)awakeFromNib
{    
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
    
    
    
    CGRect frame = self.view.bounds;
    self.tableView = [[YFJLeftSwipeDeleteTableView alloc] initWithFrame:frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    //return self.songTitle.count;
    m_recordData = [self loadRecordData];
    return [m_recordData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
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
    [button setTitle:@"播放" forState:UIControlStateNormal];
    [button setTag:[indexPath row]];
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = button;
    
    cell.textLabel.text = currentRecord.title;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"錄製日期：%@", currentRecord.file_name];
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:12];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [m_coreData deleteRecordData: [NSString stringWithFormat:@"%d",indexPath.row]];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (IBAction)buttonTapped:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSString* text = button.titleLabel.text;
    NSString* row = [NSString stringWithFormat:@"%d", button.tag];
    NSLog( @"button(%@) row(%d)", text, row.intValue );
    
    //Record* currentRecord = [m_recordData objectAtIndex:button.tag];
    Record* currentRecord = [self.songTitle objectAtIndex:button.tag];
    if( currentRecord ) {
        
        [[NSUserDefaults standardUserDefaults] setInteger:row.integerValue forKey:@"songId"];
        [[NSUserDefaults standardUserDefaults] setObject:[self.songTitle objectAtIndex:row.intValue] forKey:@"songTitle"];
        [[NSUserDefaults standardUserDefaults] setObject:[self.songKsc objectAtIndex:row.intValue] forKey:@"songKsc"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        /*
         NSString* index = currentRecord.index;
         NSString* title = currentRecord.title;
         NSString* file_name = currentRecord.file_name;
         NSString* file = currentRecord.file;
         NSString* content = currentRecord.content;
         
         //NSLog( @"index(%@) title(%@) file_name(%@) file(%@) content(%@)", index, title, file_name, file, content );
         
         // 存入 Recording 資料庫
         [self addRecordingData:index WithTitle:title AndFile:file AndContent:content];
         */
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

-(void) deleteRecordDataByIndex:(NSString *)index
{
    
    [m_coreData deleteRecordData:index];
}

/*
// 新增資料庫管理物件準備寫入
- (void) addRecordingData:(NSString *)index WithTitle:(NSString *)title AndFile:(NSString *)file AndContent:(NSString *)content
{
    NSLog(@"新增資料庫管理物件準備寫入");
 
    [m_coreData addDataToRecording:index WithTitle:title AndFile:file AndContent:content];
}
*/



@end