//
//  FindFriendViewController.h
//  ECSlidingViewController
//
//  myFans
//
//  Created by vincent on 13/1/16.
//  Copyright (c) 2013年 vincent. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h" // 為了取得應用程式的代理物件參照
#import "FBCoreData.h"

#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"

@class AppDelegate;


@interface LoginViewController2 : UIViewController <FBLoginViewDelegate, SinaWeiboDelegate, SinaWeiboRequestDelegate> {

    // 代理物件的參照
    AppDelegate* appDelegate;

    FBCoreData *m_fbCoreData;

    // SinaWeibo
    UIButton *loginButton;
    NSDictionary *userInfo;
    NSArray *statuses;
}


@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePic;
@property (strong, nonatomic) IBOutlet UIButton *buttonPostStatus;
@property (strong, nonatomic) IBOutlet UIButton *buttonPostPhoto;
@property (strong, nonatomic) IBOutlet UIButton *buttonPickFriends;
@property (strong, nonatomic) IBOutlet UIButton *buttonPickPlace;
@property (strong, nonatomic) IBOutlet UILabel *labelFirstName;
@property (strong, nonatomic) id<FBGraphUser> loggedInUser;

- (IBAction)backButtonTapped:(id)sender;

- (IBAction)postStatusUpdateClick:(UIButton *)sender;
- (IBAction)postPhotoClick:(UIButton *)sender;
- (IBAction)pickFriendsClick:(UIButton *)sender;
- (IBAction)pickPlaceClick:(UIButton *)sender;

- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error;


@end
