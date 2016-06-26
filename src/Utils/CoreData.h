//
//  CoreData.h
//  kBar
//
//  Created by wonliao on 13/3/25.
//
//

#import <Foundation/Foundation.h>



@interface CoreData : NSObject {

    // 增加Core Data的成員變數
    NSManagedObjectContext *m_manageObjectContext;
    NSManagedObjectModel *m_manageObjectModel;
    NSPersistentStoreCoordinator *m_persistentStoreCoordinator;
}

@property (strong, nonatomic) NSManagedObjectContext *m_manageObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *m_manageObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *m_persistentStoreCoordinator;

// 將物件同步進Core Data
- (void) saveContext;
// 傳回這個應用程式目錄底下的Documents子目錄
- (NSURL *) applicationDocumentsDirectory;
// 傳回這個應用程式中管理資料庫的Persistent Store Coordinator物件
- (NSPersistentStoreCoordinator *) persistentStoreCoordinator;
// 傳回這個應用程式中的物件模型管理員，負責讀取data model
- (NSManagedObjectModel *) managedObjectModel;
// 傳回這個應用程式的物件文本管理員，用來作物件的同步
- (NSManagedObjectContext *) managedObjectContext;




// 播放歌 資料庫管理
- (void) addDataToPlaying:(NSString *)post_id WithTitle:(NSString *)title AndImageFileName:(NSString *)imageFilename AndFBImageFileName:(NSString *)fbImageFilename AndName:(NSString *)name;
- (id) loadDataFromPlaying;

// fb使用者 資料庫管理
- (void) addDataToFBUserInfo:(NSString *)fbUID WithName:(NSString *)fbName AndPlace:(NSString *)fbPlace AndLink:(NSString *)fbLink;
- (id) loadDataFromFBUserInfo;

// 錄音中 資料庫管理
- (void) addDataToRecording:(NSString *)index WithTitle:(NSString *)title AndFile:(NSString *)file AndContent:(NSString *)content;
- (id) loadDataFromRecording;

// 錄音 資料庫管理
- (void) addDataToRecord:(NSString *)index WithTitle:(NSString *)title AndFileName:(NSString *)name AndFile:(NSString *)file AndRow:(NSString *)row AndContent:(NSString *)content;
- (id) loadDataFromRecord;
- (void)deleteRecordData:(NSString *)index;

// 錄音歌曲 資料庫管理
- (BOOL) checkRecordSongList;
- (void) clearRecordSongList;
- (void) addDataToRecordSongList:(NSString *)name;
- (id) loadDataFromRecordSongList;

// HomePage 資料庫管理
- (BOOL) checkHomePageData:(NSString *)area;
- (void) clearHomePageData;
- (void) addDataToHomePageData:(NSString *)area WithPostId:(NSString *)post_id AndFbImageFilename:(NSString *)fbImageFilename AndImgURL:(NSString *)imgURL AndName:(NSString *)name AndKeyName:(NSString *)keyName AndTitle:(NSString *)title AndSize:(NSString *)size AndImageFilename:(NSString *)imageFilename;
- (id) loadDataFromHomePageData;

@end
