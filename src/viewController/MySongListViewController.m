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
    // 歌名
    self.songTitle = [NSArray arrayWithObjects:
                      @"寂寞沙洲冷",
                      @"你不知道的事",
                      @"花心",
                      nil];
    
    // 歌詞 KSC
    self.songKsc = [NSArray arrayWithObjects:
                    // 寂寞沙洲冷
                    @"diffTime:4;karaoke.add('00:32.110', '00:35.430', '自你走後心憔悴', '560,570,430,570,500,430,260');karaoke.add('00:35.730', '00:38.980', '白色油桐風中紛飛', '310,260,310,370,250,440,310,1000');karaoke.add('00:40.210', '00:45.650', '落花似人有情這個季節', '440,440,250,370,440,570,370,440,620,1500');karaoke.add('00:48.090', '00:51.520', '河畔的風放肆拼命的吹', '440,430,380,370,320,310,310,380,240,250');karaoke.add('00:51.780', '00:55.340', '無端撥弄離人的眼淚', '250,240,380,380,310,380,310,310,1000');karaoke.add('00:55.750', '00:59.370', '那樣濃烈的愛再也無法給', '250,320,300,380,250,370,380,310,310,440,310');karaoke.add('01:00.060', '01:03.750', '傷感一夜一夜', '500,560,440,440,370,1380');karaoke.add('01:07.820', '01:10.130', '當記憶的線纏繞過往', '430,320,310,190,240,250,260,180,130');karaoke.add('01:10.380', '01:11.440', '支離破碎', '190,250,240,380');karaoke.add('01:11.820', '01:15.130', '是慌亂占據了心扉', '370,310,250,250,320,370,440,1000');karaoke.add('01:15.690', '01:17.820', '有花兒伴著蝴碟', '500,320,240,320,250,250,250');karaoke.add('01:18.060', '01:19.880', '孤雁可以雙飛', '440,320,250,250,250,310');karaoke.add('01:20.190', '01:22.750', '夜深人靜獨徘徊', '310,250,260,240,320,500,680');karaoke.add('01:23.630', '01:26.190', '當幸福戀人寄來紅色', '560,310,320,250,310,190,250,180,190');karaoke.add('01:26.380', '01:27.380', '分享喜悅', '190,310,190,310');karaoke.add('01:27.750', '01:31.250', '閉上雙眼難過頭也不敢回', '320,250,250,250,250,250,370,250,250,190,870');karaoke.add('01:31.690', '01:34.320', '仍然撿盡寒枝不肯安歇', '310,250,250,320,250,250,250,310,250,190');karaoke.add('01:34.500', '01:35.690', '微帶著後悔', '190,190,250,250,310');karaoke.add('01:36.070', '01:39.320', '寂寞沙洲我該思念誰', '430,320,250,250,310,250,250,370,820');karaoke.add('01:48.150', '01:51.460', '自你走後心憔悴', '560,500,440,490,510,430,380');karaoke.add('01:51.680', '01:55.060', '白色油桐風中紛飛', '320,310,310,380,310,430,380,940');karaoke.add('01:56.120', '02:01.740', '落花似人有情這個季節', '370,510,310,440,310,620,380,440,560,1680');karaoke.add('02:04.120', '02:07.500', '河畔的風放肆拼命的吹', '440,440,310,370,320,310,310,380,310,190');karaoke.add('02:07.750', '02:11.370', '無端撥弄離人的眼淚', '310,250,310,380,310,370,440,310,940');karaoke.add('02:11.810', '02:15.680', '那樣濃烈的愛再也無法給', '250,310,250,250,440,440,310,310,310,380,620');karaoke.add('02:16.180', '02:20.250', '傷感一夜一夜', '440,560,500,380,440,1750');karaoke.add('02:23.710', '02:26.210', '當記憶的線纏繞過往', '500,380,250,250,250,250,250,190,180');karaoke.add('02:26.400', '02:27.400', '支離破碎', '190,310,190,310');karaoke.add('02:27.770', '02:30.900', '是慌亂占據了心扉', '440,310,260,250,250,370,440,810');karaoke.add('02:31.710', '02:33.840', '有花兒伴著蝴碟', '440,310,320,250,310,250,250');karaoke.add('02:34.150', '02:35.840', '孤雁可以雙飛', '380,310,180,320,250,250');karaoke.add('02:36.210', '02:38.770', '夜深人靜獨徘徊', '310,260,240,260,310,500,680');karaoke.add('02:39.720', '02:41.710', '當幸福戀人寄來', '490,310,260,310,250,190,180');karaoke.add('02:41.900', '02:43.400', '紅色分享喜悅', '190,250,250,250,250,310');karaoke.add('02:43.770', '02:47.150', '閉上雙眼難過頭也不敢回', '260,240,250,250,260,310,380,240,190,250,750');karaoke.add('02:47.720', '02:50.210', '仍然撿盡寒枝不肯安歇', '300,320,250,190,250,310,250,250,190,180');karaoke.add('02:50.400', '02:51.650', '微帶著後悔', '250,190,250,250,310');karaoke.add('02:52.210', '02:55.400', '寂寞沙洲我該思念誰', '320,250,310,250,250,250,250,430,880');karaoke.add('03:23.770', '03:26.140', '當記憶的線纏繞過往', '500,310,250,250,250,250,190,250,120');karaoke.add('03:26.330', '03:27.390', '支離破碎', '250,250,250,310');karaoke.add('03:27.770', '03:31.210', '是慌亂占據了心扉', '430,250,320,250,250,250,500,1190');karaoke.add('03:31.950', '03:33.830', '有花兒伴著蝴碟', '320,250,250,250,250,250,310');karaoke.add('03:34.080', '03:35.830', '孤雁可以雙飛', '440,250,250,310,250,250');karaoke.add('03:36.210', '03:38.770', '夜深人靜獨徘徊', '310,250,250,250,250,560,690');karaoke.add('03:39.640', '03:41.700', '當幸福戀人寄來', '560,320,250,250,250,190,240');karaoke.add('03:41.890', '03:43.330', '紅色分享喜悅', '190,250,250,190,310,250');karaoke.add('03:43.710', '03:47.210', '閉上雙眼難過頭也不敢回', '310,250,250,250,250,250,310,250,250,250,880');karaoke.add('03:47.640', '03:50.210', '仍然撿盡寒枝不肯安歇', '380,250,250,250,250,250,250,250,250,190');karaoke.add('03:50.390', '03:51.770', '微帶著後悔', '190,250,250,250,440');karaoke.add('03:52.200', '03:55.270', '寂寞沙洲我該思念誰', '250,320,250,250,250,310,190,370,880');karaoke.add('03:55.770', '03:58.080', '仍然撿盡寒枝不肯安歇', '310,250,250,190,250,250,250,190,180,190');karaoke.add('03:58.330', '03:59.770', '微帶著後悔', '190,250,250,310,440');karaoke.add('04:00.210', '04:03.330', '寂寞沙洲我該思念誰', '310,250,250,310,250,250,250,370,880');",
                    // 你不知道的事
                    @"diffTime:5;karaoke.add('00:12.510', '00:16.260', '蝴蝶擦幾次眼睛', '310,320,620,440,1000,310,750');karaoke.add('00:17.920', '00: 20.920', '再學會飛行', '370,320,690,370,1250');karaoke.add('00:23.550', '00:27.420', '夜空灑滿了星星', '370,310,630,370,880,430,880');karaoke.add(' 00:28.850', '00:31.920', '但幾顆會落地', '320,250,750,500,370,880');karaoke.add('00:33.730', '00:38.730', '我飛[行]但你墜落之際', '620,510,930,500,440,310,560,630,500');karaoke.add('00:39.350', '00:44.230', '很靠[近]還聽見呼吸', '380,630,1000,370,370,630,440,1060');karaoke.add( '00:45.170', '00:52.670', '對不[起]我卻沒捉緊你', '370,440,1380,370,560,500,690,620,2570');karaoke.add('00:54.350', '00: 59.480', '你不知道我為什麼離開你', '320,310,370,320,370,630,370,440,560,1000,440');karaoke.add('00:59.850', '01:04.850', '我堅持不能說放任你哭泣', '320,310,250,370,320,930,320,500,560,500,620 ');karaoke.add('01:05.330', '01:09.140', '你的淚滴像傾盆大雨', '370,310,320,310,370,630,440,680,380');karaoke.add('01:09.760', '01:15.570', '碎落滿[地]在心裡清晰', '630,440,560,1060,690,370,630,560,870');karaoke.add('01:16.200', '01:21.570', '你不知道我為什麼狠下心', '430,320,370,380,440,620,380,680,630,620,500' );karaoke.add('01:22.010', '01:26.950', '盤旋在你看不見那高空裡', '380,250,310,370,380,560,380,620,630,560,500');karaoke.add('01:29.010', '01:37.010', '多的[是]你不知道的事', '560,570,1430,380,560,380,810,690,2620');karaoke.add('01:46.320', '01:50.140', '蝴蝶擦幾次眼睛', '380,370,560,440,940,440,690 ');karaoke.add('01:51.860', '01:54.420', '再學會飛行', '310,320,620,440,870');karaoke.add('01:57.170', '02:01.170', '夜空灑滿了星星', '440,370,570,440,930,380,870');karaoke.add('02:02.670', '02:05.800', '但幾顆會落地', '320,310,620,440,440,1000');karaoke.add('02:07.550', '02:12.490', '我飛[行]但你墜落之際', '440,620,880,500,370,630,430,630,440');karaoke.add('02:13.110', '02:17.860', '很靠[近]還聽見呼吸' , '380,690,1060,370,320,620,370,940');karaoke.add('02:18.610', '02:26.360', '對不[起]我卻沒捉緊你', '440,620,1440,380,560,440,680,630,2560') ;karaoke.add('02:28.110', '02:33.230', '你不知道我為什麼離開你', '380,310,310,310,380,620,380,370,690,880,490');karaoke.add('02:33.610', '02:38.670', '我堅持不能說放任你哭泣', '380,310,250,370,380,750,310,690,560,380,680');karaoke.add('02:39.130', '02:42.880', '你的淚滴像傾盆大雨', '380,310,320,310,370,690,370,630,370');karaoke.add('02 :43.450', '02:49.510', '碎落滿[地]在心裡清晰', '810,310,630,1060,690,440,620,690,810');karaoke.add('02:50.130', '02:55.450', '你不知道我為什麼狠下心', '440,310,380,370,380,620,440,630,620,690,440');karaoke.add('02:55.820', '03:01.010', '盤旋在你看不見那高空裡', '370,320,310,380,370,630,370,630,620,690,500');karaoke.add('03 :03.220', '03:10.350', '多的[是]你不知道的事', '560,500,1380,500,500,370,1000,440,1880');karaoke.add('03:30.780', '03 :35.660', '我飛[行]但你墜落之際', '440,560,1190,310,380,500,430,690,380');karaoke.add('03:40.370', '03:45.240', '你不知道我為什麼離開你', '250,310,310,310,440,690,310,370,750,750,380');karaoke.add('03:45.680', '03:50.860', '我堅持不能說放任你哭泣', '370,310,320,310,370,690,380,620,630,740,440');karaoke.add('03:51.130', '03 :54.950', '你的淚滴像傾盆大雨', '380,310,380,310,380,620,380,620,440');karaoke.add('03:55.570', '04:01.510', '碎落滿[地]在心裡清晰', '630,430,570, 1060,690,430,690,630,810');karaoke.add('04:02.130', '04:07.510', '你不知道我為什麼狠下心', '440,310,440,310,440,570,430,630,680,630,500');karaoke.add('04:07.880', '04: 13.070', '盤旋在你看不見那高空裡', '320,370,310,380,310,630,370,630,680,630,560');karaoke.add('04:15.210', '04:22.770', '多的[是]你不知道的事', '630,430 ,1380,440,560,440,930,440,2310');",
                    // 花心
                    @"diffTime:-3;karaoke.add('00:17.970', '00:21.500', '花的心藏在蕊中', '250,560,1220,250,280,600,370');karaoke.add('00:21.720', '00:25.000', '空把花期都錯過', '280,320,240,320,590,630,900');karaoke.add('00:27.280', '00:30.850', '你的心忘了季節', '290,590,1150,250,320,590,380');karaoke.add('00:31.000', '00:35.280', '從不輕易讓人懂', '290,270,320,310,620,600,1870');karaoke.add('00:36.560', '00:40.140', '為何不牽我的手', '330,630,1120,250,310,600,340');karaoke.add('00:40.360', '00:45.110', '共聽日月唱首歌', '250,310,280,290,620,620,2380');karaoke.add('00:45.200', '00:47.420', '黑夜又白晝', '380,280,310,630,620');karaoke.add('00:47.640', '00:49.480', '黑夜又白晝', '280,310,290,560,400');karaoke.add('00:49.670', '00:53.450', '人生為歡有幾何', '250,280,350,280,560,630,1430');karaoke.add('00:54.890', '00:59.240', '春去春會來', '280,280,600,900,2290');karaoke.add('00:59.580', '01:03.700', '花謝花會再開', '250,310,630,560,1190,1180');karaoke.add('01:03.920', '01:06.050', '只要你願意', '310,290,310,590,630');karaoke.add('01:06.270', '01:08.110', '只要你願意', '280,280,310,630,340');karaoke.add('01:08.300', '01:12.140', '讓夢劃向你心海', '280,280,310,250,600,620,1500');karaoke.add('01:13.590', '01:17.740', '春去春會來', '250,250,620,910,2120');karaoke.add('01:18.210', '01:22.370', '花謝花會再開', '280,310,600,530,1190,1250');karaoke.add('01:22.550', '01:24.680', '只要你願意', '320,310,280,590,630');karaoke.add('01:24.870', '01:26.770', '只要你願意', '310,310,320,590,370');karaoke.add('01:26.930', '01:31.090', '讓夢劃向你心海', '280,310,290,310,590,560,1820');karaoke.add('02:09.850', '02:13.420', '花瓣淚飄落風中', '410,470,1130,280,280,590,410');karaoke.add('02:13.500', '02:17.170', '雖有悲意也從容', '350,320,310,280,600,590,1220');karaoke.add('02:19.100', '02:22.730', '你的淚晶瑩剔透', '350,560,1160,280,250,620,410');karaoke.add('02:22.920', '02:27.040', '心中一定還有夢', '250,280,310,310,600,590,1780');karaoke.add('02:28.450', '02:32.010', '為何不牽我的手', '280,630,1090,310,280,600,370');karaoke.add('02:32.230', '02:36.920', '同看海天成一色', '250,280,310,280,660,530,2380');karaoke.add('02:37.170', '02:39.290', '潮起又潮落', '280,280,310,600,650');karaoke.add('02:39.510', '02:41.420', '潮起又潮落', '280,280,320,620,410');karaoke.add('02:41.570', '02:45.480', '送走人間許多愁', '250,280,320,250,650,600,1560');karaoke.add('02:46.750', '02:51.170', '春去春會來', '320,320,590,880,2310');karaoke.add('02:51.480', '02:55.700', '花謝花會再開', '250,340,570,560,1220,1280');karaoke.add('02:55.860', '02:57.980', '只要你願意', '280,280,310,560,690');karaoke.add('02:58.170', '03:00.110', '只要你願意', '280,310,310,600,440');karaoke.add('03:00.230', '03:04.200', '讓夢劃向你心海', '250,280,310,320,560,590,1660');karaoke.add('03:05.480', '03:09.570', '春去春會來', '250,280,590,910,2060');karaoke.add('03:10.130', '03:14.230', '花謝花會再開', '260,310,560,600,1210,1160');karaoke.add('03:14.450', '03:16.570', '只要你願意', '310,280,310,600,620');karaoke.add('03:16.760', '03:18.730', '只要你願意', '310,320,280,620,440');karaoke.add('03:18.760', '03:23.140', '讓夢劃向你心海', '340,280,320,280,630,590,1940');karaoke.add('03:23.820', '03:25.920', '只要你願意', '290,270,320,590,630');karaoke.add('03:26.130', '03:28.100', '只要你願意', '290,280,310,620,470');karaoke.add('03:28.130', '03:32.570', '讓夢劃向你心海', '350,250,280,310,630,590,2030');",
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    //m_recordData = [self loadRecordData];
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
    cell.detailTextLabel.text = [NSString stringWithFormat:@"錄製日期：%@", currentRecord.fileName];
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

    Record* currentRecord = [m_recordData objectAtIndex:button.tag];
    //Record* currentRecord = [self.songTitle objectAtIndex:button.tag];
    if( currentRecord ) {

        NSString *playFlag = @"YES";
        [[NSUserDefaults standardUserDefaults] setObject:playFlag forKey:@"playFlag"];
        //[[NSUserDefaults standardUserDefaults] setObject:currentRecord.index forKey:@"index"];
        [[NSUserDefaults standardUserDefaults] setObject:currentRecord.songId forKey:@"songId"];
        [[NSUserDefaults standardUserDefaults] setObject:currentRecord.title forKey:@"songTitle"];
        [[NSUserDefaults standardUserDefaults] setObject:currentRecord.content forKey:@"songKsc"];
        [[NSUserDefaults standardUserDefaults] setObject:currentRecord.fileName forKey:@"fileName"];
        [[NSUserDefaults standardUserDefaults] setObject:currentRecord.file forKey:@"file"];
        [[NSUserDefaults standardUserDefaults] setObject:currentRecord.isVideo forKey:@"isVideo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
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