//
//  MyViewController.h
//  myFans
//
//  Created by vincent on 13/1/16.
//  Copyright (c) 2013年 vincent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "ECSlidingViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SWSnapshotStackView.h"
#import "UIMenuBar.h"


@class AppDelegate;
@class ViewController;

@interface MyViewController : UIViewController <FBLoginViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIMenuBarDelegate> {
    
    // 代理物件的參照
    AppDelegate *appDelegate;
    
    IBOutlet UIImageView *imageView;

    NSOperationQueue *operationQueue;
    NSString* fbUID;
    
    SWSnapshotStackView *m_snapshotStackView;
    
    UIMenuBar *menuBar;
}

//@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *labelFirstName;
@property (strong)  NSOperationQueue *operationQueue;
@property (strong)  NSString* fbUID;
@property (nonatomic, retain) IBOutlet SWSnapshotStackView *snapshotStackView;

- (IBAction)revealMenu:(id)sender;
- (IBAction)singButtonTapped:(id)sender;
- (IBAction)accountButtonTapped:(id)sender;


@end


