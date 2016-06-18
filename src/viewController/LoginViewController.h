//
//  FindFriendViewController.h
//  ECSlidingViewController
//
//  myFans
//
//  Created by wonliao on 13/1/16.
//  Copyright (c) 2013年 wonliao. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "UnderRightViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "KKAPI.h"
#import "FBCoreData.h"

#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"

@class AppDelegate;

@interface LoginViewController : UIViewController <FBLoginViewDelegate, SinaWeiboDelegate, SinaWeiboRequestDelegate> {
    
    // 代理物件的參照
    AppDelegate* appDelegate;
    
    FBCoreData *m_fbCoreData;

    // SinaWeibo
    UIButton *loginButton;
    NSDictionary *userInfo;
    NSArray *statuses;
}

- (IBAction)revealMenu:(id)sender;
- (IBAction)revealUnderRight:(id)sender;

@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePic;
@property (strong, nonatomic) IBOutlet UIButton *buttonPostStatus;
@property (strong, nonatomic) IBOutlet UIButton *buttonPostPhoto;
@property (strong, nonatomic) IBOutlet UIButton *buttonPickFriends;
@property (strong, nonatomic) IBOutlet UIButton *buttonPickPlace;
@property (strong, nonatomic) IBOutlet UILabel *labelFirstName;
@property (strong, nonatomic) id<FBGraphUser> loggedInUser;

- (IBAction)postStatusUpdateClick:(UIButton *)sender;
- (IBAction)postPhotoClick:(UIButton *)sender;
- (IBAction)pickFriendsClick:(UIButton *)sender;
- (IBAction)pickPlaceClick:(UIButton *)sender;

- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error;


@end
