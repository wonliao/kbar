//
//  fbCoreData.m
//  kBar
//
//  Created by wonliao on 13/2/22.
//
//

#import "FBCoreData.h"
#import "FBUserInfo.h"  // fbUserInfo的資料庫互動類別

@implementation FBCoreData

@synthesize fbUID;
@synthesize fbName;
@synthesize fbPlace;
@synthesize fbLink;

- (id) init
{
    self = [super init];
    if (self) {

        m_coreData = [[CoreData alloc] init];
    }
    return self;
}

// 新增資料庫管理物件準備寫入
- (void) save
{
    NSLog(@"新增資料庫管理物件準備寫入");

    [m_coreData addDataToFBUserInfo:fbUID WithName:fbName AndPlace:fbPlace AndLink:fbLink];

    [self updateWordpress];
}

// 從資料庫中讀取資料
- (void) load
{
    FBUserInfo *currentFBUserInfo = [m_coreData loadDataFromFBUserInfo];
    if( currentFBUserInfo ) {

        self.fbUID = currentFBUserInfo.fbUID;
        self.fbName = currentFBUserInfo.fbName;
        self.fbPlace = currentFBUserInfo.fbPlace;
        self.fbLink = currentFBUserInfo.fbLink;
    } else {

        self.fbUID = @"";
        self.fbName = @"";
        self.fbPlace = @"";
        self.fbLink = @"";
    }
}

- (void) clear
{
    NSLog(@"清除資料庫資料");

    self.fbUID = @"";
    self.fbName = @"";
    self.fbPlace = @"";
    self.fbLink = @"";

    [self save];
}

// 登入wordpress
- (void) updateWordpress
{
    NSLog(@"fbUID(%@) fbName(%@)", self.fbUID, self.fbName);

    // 抓取 wordpress 的首頁清單
    NSString *query = [NSString stringWithFormat:@"http://54.200.150.53/kbar/login.php?uid=%@&name=%@", self.fbUID, self.fbName];
    NSString *urlString = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString: urlString];
    NSData *elementsData = [NSData dataWithContentsOfURL:url];
    NSError *anError = nil;
    NSArray *parsedElements = [NSJSONSerialization JSONObjectWithData:elementsData
                                                              options:NSJSONReadingAllowFragments
                                                                error:&anError];
    if( [parsedElements count] > 0 ) {

        NSDictionary *aModuleDict = [parsedElements objectAtIndex:0];
        NSString* result = [aModuleDict objectForKey:@"RESULT"];
        NSString* msg = [aModuleDict objectForKey:@"MSG"];
        NSLog(@"result(%@) msg(%@)", result, msg);
    }
}
@end
