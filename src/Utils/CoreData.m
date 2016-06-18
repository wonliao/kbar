//
//  CoreData.m
//  kBar
//
//  Created by wonliao on 13/3/25.
//
//
#import "CoreData.h"
#import "Playing.h"     // 目前播放歌的資料庫互動類別
#import "FBUserInfo.h"  // fbUserInfo的資料庫互動類別
#import "Recording.h"   // 目前要錄音的資料庫互動類別
#import "Record.h"      // 錄音的資料庫互動類別
#import "RecordSongList.h"  // 可錄歌曲列表的資料庫互動類別
#import "HomePageData.h"  // 首頁的資料庫互動類別


@implementation CoreData

@synthesize m_manageObjectContext;
@synthesize m_manageObjectModel;
@synthesize m_persistentStoreCoordinator;


// 傳回這個應用程式目錄底下的Documents子目錄
- (NSURL *) applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager]
             URLsForDirectory:NSDocumentDirectory
             inDomains:NSUserDomainMask] lastObject];
}

// 傳回這個應用程式中管理資料庫的Persistent Store Coordinator物件
- (NSPersistentStoreCoordinator *) persistentStoreCoordinator
{
    // 如果已經初始化就直接傳回
    if( m_persistentStoreCoordinator != nil ) {

        return m_persistentStoreCoordinator;
    }

    // 從Documents目錄下指定物件的路徑
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"data.sqlite"];

    NSError *error = nil;

    // 初始化並傳回
    m_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];

    if( ![m_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {

        NSLog( @"在存取資料庫時發生不可預期的錯誤 %@, %@", error, [error userInfo]);
    }

    return m_persistentStoreCoordinator;
}

// 傳回這個應用程式中的物件模型管理員，負責讀取data model
- (NSManagedObjectModel *) managedObjectModel
{
    // 如果物件已經初始化過就直接回傳
    if( m_manageObjectModel != nil ) {

        return m_manageObjectModel;
    }

    // 沒有的話就直接載入該檔案之後回傳
    // 在URLForResource中傳入書名
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"kbarCoreData" withExtension:@"momd"];

    // 從Model檔案中實例化m_managedObjectModel
    m_manageObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

    return m_manageObjectModel;
}

// 傳回這個應用程式的物件文本管理員，用來作物件的同步
- (NSManagedObjectContext *) managedObjectContext
{
    // 如果物件已經初始化就直接回傳
    if( m_manageObjectContext != nil ) {

        return m_manageObjectContext;
    }

    // 不然就使用persistentStoreCoordinator從資料庫中讀取
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];

    if( coordinator != nil ) {

        m_manageObjectContext = [[NSManagedObjectContext alloc] init];
        [m_manageObjectContext setPersistentStoreCoordinator:coordinator];
    }

    return m_manageObjectContext;
}

// 將物件同步進Core Data
- (void) saveContext
{
    NSError *error = nil;

    // 取得NSManagedObjectContext物件
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];

    // 如果存在就進行儲存的動作
    if( managedObjectContext != nil ) {

        // 如果資料有變更就進行儲存
        if( [managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {

            //資料儲存發生錯誤
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

// 新增資料庫管理物件準備寫入
- (void) addDataToPlaying:(NSString *)post_id WithTitle:(NSString *)title AndImageFileName:(NSString *)imageFilename AndFBImageFileName:(NSString *)fbImageFilename AndName:(NSString *)name
{
    // 設定從Core Data框架中取出Beverage的Entity
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Playing" inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];

    NSError* error = nil;

    // 執行存取的指令並且將資料載入returnObjs
    NSMutableArray* returnObjs = [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];

    // 刪除全部資料
    for( Playing* currentPlaying in returnObjs ) {

        [m_manageObjectContext deleteObject: currentPlaying];
    }

    // 新增一個entity
    Playing *playing = (Playing*)[NSEntityDescription insertNewObjectForEntityForName:@"Playing" inManagedObjectContext:[self managedObjectContext]];
    playing.post_id = post_id;
    playing.title = title;
    playing.fbImageFilename = fbImageFilename;
    playing.imageFilename = imageFilename;
    playing.name = name;

    // 準備將Entity存進Core Data
    if( ![[self managedObjectContext] save:&error]) {

        NSLog(@"新增遇到錯誤");
    }
}

- (id) loadDataFromPlaying
{
    // 設定從Core Data框架中取出Beverage的Entity
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Playing" inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];

    NSError* error = nil;
    // 執行存取的指令並且將資料載入returnObjs
    NSMutableArray* returnObjs = [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];

    for( Playing* currentPlaying in returnObjs ) {

        NSLog(@"post_id(%@) title(%@) imageFilename(%@) fbImageFilename(%@)", currentPlaying.post_id, currentPlaying.title, currentPlaying.imageFilename, currentPlaying.fbImageFilename);
        return currentPlaying;
    }

    return nil;
}

// 新增資料庫管理物件準備寫入
- (void) addDataToFBUserInfo:(NSString *)fbUID WithName:(NSString *)fbName AndPlace:(NSString *)fbPlace AndLink:(NSString *)fbLink
{
    // 設定從Core Data框架中取出Beverage的Entity
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FBUserInfo" inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];

    NSError* error = nil;
    // 執行存取的指令並且將資料載入returnObjs
    NSMutableArray* returnObjs = [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];

    // 刪除舊的資料
    for( FBUserInfo* currentFBUserInfo in returnObjs ) {

        [[self managedObjectContext] deleteObject: currentFBUserInfo];
    }

    // 新增一個entity
    FBUserInfo *fbUserInfo = (FBUserInfo*)[NSEntityDescription insertNewObjectForEntityForName:@"FBUserInfo" inManagedObjectContext:[self managedObjectContext]];
    fbUserInfo.fbUID = fbUID;
    fbUserInfo.fbName = fbName;
    fbUserInfo.fbPlace = fbPlace;
    fbUserInfo.fbLink = fbLink;

    // 準備將Entity存進Core Data
    if( ![[self managedObjectContext] save:&error]) {

        NSLog(@"新增遇到錯誤");
    }
}

- (id) loadDataFromFBUserInfo
{
    // 設定從Core Data框架中取出Beverage的Entity
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FBUserInfo" inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];

    NSError* error = nil;
    // 執行存取的指令並且將資料載入returnObjs
    NSMutableArray* returnObjs = [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];

    if( [returnObjs count] > 0 ) {

        for( FBUserInfo* currentFBUserInfo in returnObjs ) {

            NSLog(@"fbUID(%@) fbName(%@) fbPlace(%@) fbLink(%@)", currentFBUserInfo.fbUID, currentFBUserInfo.fbName, currentFBUserInfo.fbPlace, currentFBUserInfo.fbLink);
            return currentFBUserInfo;
        }
    }

    return nil;
}

// 新增資料庫管理物件準備寫入
- (void) addDataToRecording:(NSString *)index WithTitle:(NSString *)title AndFile:(NSString *)file AndContent:(NSString *)content
{
    // 設定從Core Data框架中取出Beverage的Entity
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Recording" inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];

    NSError* error = nil;
    // 執行存取的指令並且將資料載入returnObjs
    NSMutableArray* returnObjs = [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];

    // 刪除全部
    for( Recording* currentRecording in returnObjs ) {

        [[self managedObjectContext] deleteObject: currentRecording];
    }

    // 新增一個entity
    Recording *recording = (Recording*)[NSEntityDescription insertNewObjectForEntityForName:@"Recording" inManagedObjectContext:[self managedObjectContext]];
    recording.index = index;
    recording.title = title;
    recording.file = file;
    recording.content = content;

    // 準備將Entity存進Core Data
    if( ![[self managedObjectContext] save:&error]) {

        NSLog(@"新增遇到錯誤");
    }
}

- (id) loadDataFromRecording
{
    // 設定從Core Data框架中取出Beverage的Entity
    NSFetchRequest* request2 = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Recording" inManagedObjectContext:[self managedObjectContext]];
    [request2 setEntity:entity];

    NSError* error = nil;
    // 執行存取的指令並且將資料載入returnObjs
    NSMutableArray* returnObjs = [[[self managedObjectContext] executeFetchRequest:request2 error:&error] mutableCopy];
    if( [returnObjs count] > 0 ) {

        Recording* currentRecording = [returnObjs objectAtIndex:0];
        return currentRecording;
    }

    return nil;
}

// 新增資料庫管理物件準備寫入
- (void) addDataToRecord:(NSString *)index WithTitle:(NSString *)title AndFileName:(NSString *)name AndFile:(NSString *)file AndRow:(NSString *)row AndContent:(NSString *)content
{
    // 設定從Core Data框架中取出Beverage的Entity
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Record" inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];

    NSError* error = nil;
    // 執行存取的指令並且將資料載入returnObjs
    NSMutableArray* returnObjs = [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];

    // 刪除 index 重覆的資料
    for( Record* currentRecord in returnObjs ) {

        if( [currentRecord.index isEqualToString: index] ) {

            [[self managedObjectContext] deleteObject: currentRecord];
        }
    }

    // 新增一個entity
    Record *record = (Record*)[NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:[self managedObjectContext]];
    record.row = row;
    record.index = index;
    record.title = title;
    record.file_name = name;
    record.file = file;
    record.content = content;
    record.downloaded = @"NO";

    // 準備將Entity存進Core Data
    if( ![[self managedObjectContext] save:&error]) {

        NSLog(@"新增遇到錯誤");
    }
}

- (id) loadDataFromRecord
{
    // 設定從Core Data框架中取出Beverage的Entity
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Record" inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];

    NSError* error = nil;
    // 執行存取的指令並且將資料載入returnObjs
    NSMutableArray* returnObjs = [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];

    return returnObjs;
}

- (BOOL) checkRecordSongList
{
    // 設定從Core Data框架中取出Beverage的Entity
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RecordSongList" inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];

    NSError* error = nil;
    // 執行存取的指令並且將資料載入returnObjs
    NSMutableArray* returnObjs = [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    if( returnObjs && [returnObjs count] > 0 ) return YES;

    return NO;
}

- (void) clearRecordSongList
{
    // 設定從Core Data框架中取出Beverage的Entity
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RecordSongList" inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];

    NSError* error = nil;
    // 執行存取的指令並且將資料載入returnObjs
    NSMutableArray* returnObjs = [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];

    // 刪除全部
    for( RecordSongList* currentRecordSongList in returnObjs ) {

        [[self managedObjectContext] deleteObject: currentRecordSongList];
    }
}

- (void) addDataToRecordSongList:(NSString *)name
{
    NSError* error = nil;

    // 新增一個entity
    RecordSongList *recordSongList = (RecordSongList*)[NSEntityDescription insertNewObjectForEntityForName:@"RecordSongList" inManagedObjectContext:[self managedObjectContext]];
    recordSongList.name = name;

    // 準備將Entity存進Core Data
    if( ![[self managedObjectContext] save:&error]) {

        NSLog(@"新增遇到錯誤");
    }
}

- (id) loadDataFromRecordSongList
{
    // 設定從Core Data框架中取出Beverage的Entity
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RecordSongList" inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];

    NSError* error = nil;
    // 執行存取的指令並且將資料載入returnObjs
    NSMutableArray* returnObjs = [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];

    return returnObjs;
}

// HomePage 資料庫管理
- (BOOL) checkHomePageData:(NSString *)area
{
    // 設定從Core Data框架中取出Beverage的Entity
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"HomePageData" inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];

    NSError* error = nil;
    // 執行存取的指令並且將資料載入returnObjs
    NSMutableArray* returnObjs = [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    for( HomePageData* currentHomePageData in returnObjs ) {

        if( [currentHomePageData.area isEqualToString:area] ) {

            return YES;
        }
    }

    return NO;
}

- (void) clearHomePageData
{
    // 設定從Core Data框架中取出Beverage的Entity
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"HomePageData" inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];

    NSError* error = nil;
    // 執行存取的指令並且將資料載入returnObjs
    NSMutableArray* returnObjs = [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];

    // 刪除全部
    for( HomePageData* currentRecordSongList in returnObjs ) {

        [[self managedObjectContext] deleteObject: currentRecordSongList];
    }
}

- (void) addDataToHomePageData:(NSString *)area WithPostId:(NSString *)post_id AndFbImageFilename:(NSString *)fbImageFilename AndImgURL:(NSString *)imgURL AndName:(NSString *)name AndKeyName:(NSString *)keyName AndTitle:(NSString *)title AndSize:(NSString *)size AndImageFilename:(NSString *)imageFilename
{
    NSError* error = nil;

    // 新增一個entity
    HomePageData *homePageData = (HomePageData*)[NSEntityDescription insertNewObjectForEntityForName:@"HomePageData" inManagedObjectContext:[self managedObjectContext]];
    homePageData.area = area;
    homePageData.fbImageFilename = fbImageFilename;
    homePageData.imgURL = imgURL;
    homePageData.name = name;
    homePageData.keyName = keyName;
    homePageData.title = title;
    homePageData.size = [NSString stringWithFormat:@"%@", size];
    homePageData.post_id = post_id;
    homePageData.imageFilename = imageFilename;

    // 準備將Entity存進Core Data
    if( ![[self managedObjectContext] save:&error]) {

        NSLog(@"新增遇到錯誤");
    }
}

- (id) loadDataFromHomePageData
{
    // 設定從Core Data框架中取出Beverage的Entity
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"HomePageData" inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];

    NSError* error = nil;
    // 執行存取的指令並且將資料載入returnObjs
    NSMutableArray* returnObjs = [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];

    return returnObjs;
}

@end
