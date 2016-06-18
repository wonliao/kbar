//
//  AppDelegate.h
//
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CoreData.h"
#import "KKMediaPlayer.h"
#import "KKUser.h"

#define kAppKey             @"2095369374"
#define kAppSecret          @"f06e3f824d3dd5b6467037b375658d2f"
#define kAppRedirectURI     @"http://54.200.150.53/kbar/"


@class SinaWeibo;
@class LoginViewController2;


@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    FBLoginView *loginview;
    CoreData *m_coreData;
@public
    SinaWeibo *sinaweibo;
}

@property (strong, nonatomic) UIWindow      *window;
@property (strong, nonatomic) CoreData      *m_coreData;
@property (nonatomic,retain) KKMediaPlayer  *player;
@property KKUser                            *user;

@property (strong, nonatomic) SinaWeibo *sinaweibo;


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


- (FBLoginView *) getLoginview;

@end
