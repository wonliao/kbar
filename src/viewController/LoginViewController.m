//
//  FindFriendViewController.m
//  myFans
//
//  Created by vincent on 13/1/16.
//  Copyright (c) 2013年 vincent. All rights reserved.
//
#import "LoginViewController.h"
#import <CoreLocation/CoreLocation.h>

@implementation LoginViewController

@synthesize buttonPostStatus = _buttonPostStatus;
@synthesize buttonPostPhoto = _buttonPostPhoto;
@synthesize buttonPickFriends = _buttonPickFriends;
@synthesize buttonPickPlace = _buttonPickPlace;
@synthesize labelFirstName = _labelFirstName;
@synthesize loggedInUser = _loggedInUser;
@synthesize profilePic = _profilePic;

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  // shadowPath, shadowOffset, and rotation is handled by ECSlidingViewController.
  // You just need to set the opacity, radius, and color.
  // 上層View的陰影
  self.view.layer.shadowOpacity = 0.75f;
  self.view.layer.shadowRadius = 10.0f;
  self.view.layer.shadowColor = [UIColor blackColor].CGColor;

  //初始左側下一層View
  if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {

    self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
  }
  //初始右側下一層View
  if (![self.slidingViewController.underRightViewController isKindOfClass:[UnderRightViewController class]]) {

    self.slidingViewController.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UnderRight"];
  }

  [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (IBAction)revealMenu:(id)sender
{
  //把上層向右滑
  [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)revealUnderRight:(id)sender
{
  //把上層向左滑
  [self.slidingViewController anchorTopViewTo:ECLeft];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 取得應用程式的代理物件參照
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    m_fbCoreData = [[FBCoreData alloc] init];
    [m_fbCoreData load];
    
    FBLoginView *loginview = [appDelegate getLoginview];
    loginview.frame = (CGRect){ { 80, 300 }, loginview.frame.size};
    loginview.delegate = self;
    [self.view addSubview:loginview];
    [loginview sizeToFit];
    
/*
    // SinaWeibo login button
    if(appDelegate.sinaweibo == nil) {
        
        appDelegate.sinaweibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:self];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
        if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"]) {
            
            appDelegate.sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
            appDelegate.sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
            appDelegate.sinaweibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
        }
    }
   
    // SinaWeibo login button
    if(appDelegate.sinaweibo.userID != nil && ![m_fbCoreData.fbUID isEqualToString:@""]) {
        
        NSString *login = @"登出微博";
        loginButton = [self buttonWithFrame:CGRectMake(80, 350, 150, 44) action:@selector(logoutButtonPressed)];
        [loginButton setTitle:login forState:UIControlStateNormal];
    } else {
        
        NSString *login = @"登入微博";
        loginButton = [self buttonWithFrame:CGRectMake(80, 350, 150, 44) action:@selector(loginButtonPressed)];
        [loginButton setTitle:login forState:UIControlStateNormal];
    }
*/
}

- (void)viewDidUnload {
    self.buttonPickFriends = nil;
    self.buttonPickPlace = nil;
    self.buttonPostPhoto = nil;
    self.buttonPostStatus = nil;
    self.labelFirstName = nil;
    self.loggedInUser = nil;
    self.profilePic = nil;
    [super viewDidUnload];
}

#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    // first get the buttons set for login mode
    self.buttonPostPhoto.enabled = YES;
    self.buttonPostStatus.enabled = YES;
    self.buttonPickFriends.enabled = YES;
    self.buttonPickPlace.enabled = YES;
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    // here we use helper properties of FBGraphUser to dot-through to first_name and
    // id properties of the json response from the server; alternatively we could use
    // NSDictionary methods such as objectForKey to get values from the my json object
    self.labelFirstName.text = [NSString stringWithFormat:@"Hello %@!", user.first_name];
    // setting the profileID property of the FBProfilePictureView instance
    // causes the control to fetch and display the profile picture for the user
    self.profilePic.profileID = user.id;
    self.loggedInUser = user;

    // 取得 facebook 資料
    NSLog(@"fbUID(%@)", user.id);               // fbuid
    NSLog(@"fbName(%@)", user.name);            // 名稱
    NSLog(@"fbPlace(%@)", user.location.name);  // 位置
    NSLog(@"fbLink(%@)", user.link);            // fb 個人網頁連結

    m_fbCoreData.fbUID = user.id;                 // fbuid
    m_fbCoreData.fbName = user.name;              // 名稱
    m_fbCoreData.fbPlace = user.location.name;    // 位置
    m_fbCoreData.fbLink = user.link;              // fb 個人網頁連結
    [m_fbCoreData save];
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    BOOL canShareAnyhow = [FBNativeDialogs canPresentShareDialogWithSession:nil];
    self.buttonPostPhoto.enabled = canShareAnyhow;
    self.buttonPostStatus.enabled = canShareAnyhow;
    self.buttonPickFriends.enabled = NO;
    self.buttonPickPlace.enabled = NO;
    self.profilePic.profileID = nil;
    self.labelFirstName.text = nil;
    self.loggedInUser = nil;

    [m_fbCoreData clear];
}

#pragma mark -

// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action
{
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                                   defaultAudience:FBSessionDefaultAudienceFriends
                                                 completionHandler:^(FBSession *session, NSError *error) {
                                                     if (!error) {
                                                         action();
                                                     }
                                                     //For this example, ignore errors (such as if user cancels).
                                                 }];
    } else {

        action();
    }
}

// Post Status Update button handler; will attempt to invoke the native
// share dialog and, if that's unavailable, will post directly
- (IBAction)postStatusUpdateClick:(UIButton *)sender
{
    // Post a status update to the user's feed via the Graph API, and display an alert view
    // with the results or an error.
    NSString *name = self.loggedInUser.first_name;
    NSString *message = [NSString stringWithFormat:@"Updating status for %@ at %@",
                         name != nil ? name : @"me" , [NSDate date]];

    // if it is available to us, we will post using the native dialog
    BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:self
                                                                    initialText:nil
                                                                          image:nil
                                                                            url:nil
                                                                        handler:nil];
    if (!displayedNativeDialog) {

        [self performPublishAction:^{
            // otherwise fall back on a request for permissions and a direct post
            [FBRequestConnection startForPostStatusUpdate:message
                                        completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                            
                                            [self showAlert:message result:result error:error];
                                            self.buttonPostStatus.enabled = YES;
                                        }];

            self.buttonPostStatus.enabled = NO;
        }];
    }
}

// Post Photo button handler; will attempt to invoke the native
// share dialog and, if that's unavailable, will post directly
- (IBAction)postPhotoClick:(UIButton *)sender
{
    // Just use the icon image from the application itself.  A real app would have a more
    // useful way to get an image.
    UIImage *img = [UIImage imageNamed:@"Icon-72@2x.png"];

    // if it is available to us, we will post using the native dialog
    BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:self
                                                                    initialText:nil
                                                                          image:img
                                                                            url:nil
                                                                        handler:nil];
    if (!displayedNativeDialog) {
        [self performPublishAction:^{

            [FBRequestConnection startForUploadPhoto:img
                                   completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                       [self showAlert:@"Photo Post" result:result error:error];
                                       self.buttonPostPhoto.enabled = YES;
                                   }];

            self.buttonPostPhoto.enabled = NO;
        }];
    }
}

// Pick Friends button handler
- (IBAction)pickFriendsClick:(UIButton *)sender
{
    FBFriendPickerViewController *friendPickerController = [[FBFriendPickerViewController alloc] init];
    friendPickerController.title = @"Pick Friends";
    [friendPickerController loadData];

    // Use the modal wrapper method to display the picker.
    [friendPickerController presentModallyFromViewController:self animated:YES handler:
     ^(FBViewController *sender, BOOL donePressed) {

         if (!donePressed) {

             return;
         }

         NSString *message;
         if (friendPickerController.selection.count == 0) {

             message = @"<No Friends Selected>";
         } else {
             
             NSMutableString *text = [[NSMutableString alloc] init];

             // we pick up the users from the selection, and create a string that we use to update the text view
             // at the bottom of the display; note that self.selection is a property inherited from our base class
             for (id<FBGraphUser> user in friendPickerController.selection) {

                 if ([text length]) {

                     [text appendString:@", "];
                 }
                 [text appendString:user.name];
             }
             message = text;
         }

         [[[UIAlertView alloc] initWithTitle:@"You Picked:"
                                     message:message
                                    delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil]
          show];
     }];
}

// Pick Place button handler
- (IBAction)pickPlaceClick:(UIButton *)sender
{
    FBPlacePickerViewController *placePickerController = [[FBPlacePickerViewController alloc] init];
    placePickerController.title = @"Pick a Seattle Place";
    placePickerController.locationCoordinate = CLLocationCoordinate2DMake(47.6097, -122.3331);
    [placePickerController loadData];

    // Use the modal wrapper method to display the picker.
    [placePickerController presentModallyFromViewController:self animated:YES handler:
     ^(FBViewController *sender, BOOL donePressed) {

         if (!donePressed) {

             return;
         }

         NSString *placeName = placePickerController.selection.name;
         if (!placeName) {

             placeName = @"<No Place Selected>";
         }

         [[[UIAlertView alloc] initWithTitle:@"You Picked:"
                                     message:placeName
                                    delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil]
          show];
     }];
}

// UIAlertView helper for post buttons
- (void)showAlert:(NSString *)message result:(id)result error:(NSError *)error
{
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {

        alertMsg = error.localizedDescription;
        alertTitle = @"Error";
    } else {

        NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.\nPost ID: %@",
                    message, [resultDict valueForKey:@"id"]];
        alertTitle = @"Success";
    }

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark -
#pragma mark SinaWeibo

- (SinaWeibo *)sinaweibo
{
    return appDelegate.sinaweibo;
}

- (void)removeAuthData
{
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
}

- (void)storeAuthData
{
    /*
     SinaWeibo *sinaweibo = [self sinaweibo];
     
     NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
     sinaweibo.accessToken, @"AccessTokenKey",
     sinaweibo.expirationDate, @"ExpirationDateKey",
     sinaweibo.userID, @"UserIDKey",
     sinaweibo.refreshToken, @"refresh_token", nil];
     
     [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
     [[NSUserDefaults standardUserDefaults] synchronize];
     */
}

- (void)loginButtonPressed
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    NSLog(@"%@", [keyWindow subviews]);
    
    //[userInfo release], userInfo = nil;
    //[statuses release], statuses = nil;
    
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo logIn];
}

- (void)logoutButtonPressed
{
    [m_fbCoreData clear];

    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo logOut];
}

- (void)resetButtons
{
    // SinaWeibo login button
    if(appDelegate.sinaweibo.userID != nil) {
        
        NSString *login = @"登出微博";
        loginButton = [self buttonWithFrame:CGRectMake(80, 350, 150, 44) action:@selector(logoutButtonPressed)];
        [loginButton setTitle:login forState:UIControlStateNormal];
    } else {
        
        NSString *login = @"登入微博";
        loginButton = [self buttonWithFrame:CGRectMake(80, 350, 150, 44) action:@selector(loginButtonPressed)];
        [loginButton setTitle:login forState:UIControlStateNormal];
    }
}

- (UIButton *)buttonWithFrame:(CGRect)frame action:(SEL)action
{
    UIImage *buttonBackgroundImage = [[UIImage imageNamed:@"button_up.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    UIImage *disabledButtonBackgroundImage = [[UIImage imageNamed:@"button_down.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    [button setBackgroundImage:disabledButtonBackgroundImage forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    return button;
}

#pragma mark - SinaWeibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    
    SinaWeibo *mySinaweibo = [self sinaweibo];
    [mySinaweibo requestWithURL:@"users/show.json"
                         params:[NSMutableDictionary dictionaryWithObject:mySinaweibo.userID forKey:@"uid"]
                     httpMethod:@"GET"
                       delegate:self];
    
    //[self resetButtons];
    //[self storeAuthData];
    
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
    [self removeAuthData];
    [self resetButtons];
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
    [self removeAuthData];
    [self resetButtons];
}

#pragma mark - SinaWeiboRequest Delegate

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"users/show.json"])
    {
        userInfo = nil;
    }
    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        statuses = nil;
    }
    else if ([request.url hasSuffix:@"statuses/update.json"])
    {
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
         message:[NSString stringWithFormat:@"Post status \"%@\" failed!", postStatusText]
         delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
         [alertView show];
         [alertView release];
         */
        
        NSLog(@"Post status failed with error : %@", error);
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
         message:[NSString stringWithFormat:@"Post image status \"%@\" failed!", postImageStatusText]
         delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
         [alertView show];
         [alertView release];
         */
        NSLog(@"Post image status failed with error : %@", error);
    }
    
    
    [self resetButtons];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"users/show.json"]) {

        userInfo = result;
        
        // 取得 facebook 資料
        NSLog(@"userID(%@)", [userInfo objectForKey:@"id"]);               // fbuid
        NSLog(@"fbName(%@)", [userInfo objectForKey:@"screen_name"]);      // 名稱
        NSLog(@"fbPlace(%@)", [userInfo objectForKey:@"location"]);        // 位置
        NSLog(@"fbLink(%@)", [userInfo objectForKey:@"url"]);              // fb 個人網頁連結
        
        m_fbCoreData.fbUID = [NSString stringWithFormat:@"%@", [userInfo objectForKey:@"id"]];                // fbuid
        m_fbCoreData.fbName = [NSString stringWithFormat:@"%@", [userInfo objectForKey:@"screen_name"]];      // 名稱
        m_fbCoreData.fbPlace = [NSString stringWithFormat:@"%@", [userInfo objectForKey:@"location"]];        // 位置
        m_fbCoreData.fbLink = @"test";//[userInfo objectForKey:@"url"];              // fb 個人網頁連結
        [m_fbCoreData save];
    
        self.labelFirstName.text = [NSString stringWithFormat:@"Hi %@", m_fbCoreData.fbName];
    }
    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        //[statuses release];
        //statuses = [[result objectForKey:@"statuses"] retain];
    }
    else if ([request.url hasSuffix:@"statuses/update.json"])
    {
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
         message:[NSString stringWithFormat:@"Post status \"%@\" succeed!", [result objectForKey:@"text"]]
         delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
         [alertView show];
         [alertView release];
         */
        //[postStatusText release], postStatusText = nil;
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        /*
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
         message:[NSString stringWithFormat:@"Post image status \"%@\" succeed!", [result objectForKey:@"text"]]
         delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
         [alertView show];
         [alertView release];
         */
        //[postImageStatusText release], postImageStatusText = nil;
    }
    
    [self resetButtons];
}

@end