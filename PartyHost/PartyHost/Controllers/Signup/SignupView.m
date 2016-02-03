//
//  SignupView.m
//  PartyHost
//
//  Created by Tony Suriyathep on 6/30/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "SignupView.h"
#import "AnalyticManager.h"
#import "UserManager.h"

#define SET_IF_NOT_NULL(TARGET, VAL) if(VAL && VAL != [NSNull null]) { TARGET = VAL; } else {TARGET = @"";}

@implementation SignupView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"Signup" owner:self options:nil] objectAtIndex:0];
        self.frame = frame;
        
        //Init
        self.sharedData = [SharedData sharedInstance];
        self.pageIndex = 0;
        self.pageControlUsed = NO;
        self.didAPNUpdate = NO;
        self.didFBInitInfo = NO;
        self.didHerokuLogin = NO;
        self.didFBLogin = NO;
        self.didLogin = NO;
        self.currentUser = [[NSMutableDictionary alloc] init];
        
        
        //Load all pages
        self.pageViews = [[NSMutableArray alloc] init];
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"SignupPages" owner:self options:nil];
        self.totalPages = (int)[nibs count];
        for(int i=0;i<self.totalPages;i++) {
            UIView *pageView = nibs[i];
            [pageView setFrame:CGRectMake(self.frame.origin.x+(self.frame.size.width*i),self.frame.origin.y,self.frame.size.width,self.frame.size.height)];
            pageView.backgroundColor = [UIColor clearColor];
            self.pageViews[i] = pageView;
            [self.scrollView addSubview:pageView];
        }
        
        //Setup paging
        self.scrollView.delegate = self;
        self.scrollView.contentScaleFactor = 1;
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width * self.totalPages, self.frame.size.height);
        self.scrollView.scrollsToTop = NO;
        self.scrollView.delaysContentTouches = NO;
        self.pageControl.numberOfPages = self.totalPages;
        
        //Hide images get ready for fading
        self.backgroundImages = [[NSMutableArray alloc] init];
        [self.backgroundImages addObject:self.backgroundImage1];
        [self.backgroundImages addObject:self.backgroundImage2];
        [self.backgroundImages addObject:self.backgroundImage2];
        [self.backgroundImages addObject:self.backgroundImage2];
        [self.backgroundImages addObject:self.backgroundImage2];
        [self.backgroundImages addObject:self.backgroundImage2];
        for(int i=1;i<[self.backgroundImages count];i++) [self.backgroundImages[i] setAlpha:0.0f];
        [self.backgroundImages[0] setAlpha:1.0f];
        
        //Facbook login, this is hidden and will be fake-fired
       /*
        self.loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile",@"user_birthday", @"email", @"user_photos",@"user_friends",@"user_likes",@"user_relationships",@"user_about_me",@"user_location",@"user_photos",@"user_status",@"user_friends"]];
        self.loginView.delegate = self;*/
        [self.buttonFacebook setTitle:@"SIGN IN WITH FACEBOOK" forState:UIControlStateNormal];
        [self.buttonFacebook addTarget:self action:@selector(buttonFacebookDidTap) forControlEvents:UIControlEventTouchUpInside];
        
        /*
        self.btnLoginFB = [[FBSDKLoginButton alloc] init];
        
        self.btnLoginFB.readPermissions = @[@"public_profile",@"user_birthday", @"email", @"user_photos",@"user_friends",@"user_likes",@"user_about_me",@"user_location",@"user_photos"];
        */
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(checkIfAPNisLoaded)
         name:@"APN_LOADED"
         object:nil];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(resetApp)
         name:@"APP_UNLOADED"
         object:nil];
        
        
        
        NSLog(@"TOKEN____ :: %@",[FBSDKAccessToken currentAccessToken].tokenString);
        
//        [self performSelector:@selector(skipLogin) withObject:nil afterDelay:0.1];
        
//        [self checkIfHasLogin];
        [self performSelector:@selector(checkIfHasLogin) withObject:nil afterDelay:0.0];
    }
    return self;
}

-(void)checkIfHasLogin
{
    if([FBSDKAccessToken currentAccessToken].tokenString.length > 20)
    {   
        self.isAutoLoginMode = YES;
        
        [self autoLogin];
    }else{
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"HIDE_LOADING"
         object:self];
    }
}

-(void)autoLogin
{
    [FBSDKAccessToken refreshCurrentAccessToken:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            self.sharedData.fb_access_token = [FBSDKAccessToken currentAccessToken].tokenString;
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"/me" parameters:@{@"fields":@"first_name,last_name,name,bio,gender,email,location,birthday,photos,albums"}]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
             {
                 if (!error) {
                     NSLog(@"Fetched User Information:%@", result);
                     self.cAlbumId = [self getProfileAlbumId:result[@"albums"][@"data"]];
                     [self.currentUser removeAllObjects];
                     [self.currentUser addEntriesFromDictionary:result];
                     self.sharedData.fb_id = result[@"id"];
                     [self doubleCheckPermissions];
                 }
                 else {
                     NSLog(@"Error %@",error);
                     
                     if (self.isAutoLoginMode) {
                         [[NSNotificationCenter defaultCenter]
                          postNotificationName:@"SHOW_LOGIN"
                          object:self];
                     } else {
                         [[NSNotificationCenter defaultCenter]
                          postNotificationName:@"HIDE_LOADING"
                          object:self];
                     }
                     
                 }
             }];
        } else {
            if (self.isAutoLoginMode) {
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"SHOW_LOGIN"
                 object:self];
            } else {
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"HIDE_LOADING"
                 object:self];
            }
        }
    }];
}

-(void)skipLogin
{
    [self.sharedData.userDict setObject:@"Setiady" forKey:@"first_name"];
    [self.sharedData.userDict setObject:@"Wiguna" forKey:@"last_name"];
    [self.sharedData.userDict setObject:@"" forKey:@"birthday"];
    [self.sharedData.userDict setObject:@"" forKey:@"email"];
    [self.sharedData.userDict setObject:@"" forKey:@"location"];
    [self.sharedData.userDict setObject:@"" forKey:@"about"];
    [self.sharedData.userDict setObject:@"male" forKey:@"gender"];
    
    
    self.sharedData.gender = @"male";
    self.sharedData.gender_interest = @"both";
    self.sharedData.isLoggedIn = YES;
    
    
    self.sharedData.fb_id = @"10153278717718981";
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"HIDE_LOGIN"
     object:self];
}


-(void)resetApp
{
    self.didAPNUpdate = NO;
    self.didFBLogin = NO;
    self.didHerokuLogin = NO;
    self.sharedData.isLoggedIn = NO;
    self.didFBInitInfo = NO;
}

-(void)initClass
{
    self.isAutoLoginMode = NO;
    [self.buttonFacebook setTitle:@"SIGN IN WITH FACEBOOK" forState:UIControlStateNormal];
}

-(void)buttonFacebookDidTap
{
    [self.buttonFacebook setTitle:@"SIGNING INTO JIGGIE" forState:UIControlStateNormal];
    [FBSDKAccessToken setCurrentAccessToken:nil];
    
    FBSDKLoginManager *logMeOut = [[FBSDKLoginManager alloc] init];
    [logMeOut logOut];
    
    /*
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             NSLog(@"Fetched User Information:%@", result);
             NSLog(@"Fetched User Information:%@", result);
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"HIDE_LOADING"
              object:self];
         }
         else {
             NSLog(@"Error %@",error);
         }
     }];
    */
    
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile",@"user_birthday", @"email", @"user_photos",@"user_friends",@"user_about_me",@"user_location"]
     fromViewController:self.window.rootViewController
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         NSLog(@"RESULT___ :: %@",result);
         if (error) {
             NSLog(@"FB Process error :: %@",error);
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"HIDE_LOADING"
              object:self];
         } else if (result.isCancelled) {
             NSLog(@"FB Cancelled");
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"HIDE_LOADING"
              object:self];
         } else {
             NSLog(@"Logged in :: %@",[FBSDKAccessToken currentAccessToken].tokenString);
             
             [self autoLogin];
         }
     }];
    
    /*
    FBSession *session = [[FBSession alloc] initWithPermissions:@[@"public_profile",@"user_birthday", @"email", @"user_photos",@"user_friends",@"user_likes",@"user_relationships",@"user_about_me",@"user_location",@"user_photos",@"user_status",@"user_friends"]];
    
    // Set the active session
    [FBSession setActiveSession:session];
    // Open the session
    [session openWithBehavior:FBSessionLoginBehaviorForcingWebView
            completionHandler:^(FBSession *session,
                                FBSessionState status,
                                NSError *error) {
                
                if(error == nil)
                {
                    NSLog(@"login successful :: %@",session);
                    // Respond to session state changes,
                    // ex: updating the view
                }
                else
                {
                    NSLog(@"login unsuccessful");
                }
                
            }];
    */

}


-(NSString *)getProfileAlbumId:(NSMutableArray *)dataA
{
    NSString *albumId;
    
    for (int i = 0; i < [dataA count]; i++)
    {
        NSString *name = [dataA objectAtIndex:i][@"name"];
        if([name isEqualToString:@"Profile Pictures"])
        {
            albumId = [dataA objectAtIndex:i][@"id"];
        }
    }
    return albumId;
}

/*
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
//    return;
    if(self.didFBInitInfo)
    {
        return;
    }
    self.didFBInitInfo = YES;
    self.currentUser = user;
    self.sharedData.fb_access_token = [FBSession activeSession].accessTokenData.accessToken;
    self.sharedData.fb_id = user[@"id"];
    [self doubleCheckPermissions];
    
    
    NSLog(@"FB_TOKEN :: %@",self.sharedData.fb_access_token);
    NSLog(@"FB_USER :: %@",user);
    
    [self.buttonFacebook setTitle:@"SIGNING INTO JIGGIE" forState:UIControlStateNormal];
}

*/

-(void)loginWithToken
{
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    NSDictionary *params = @{
                             @"fb_token" : self.sharedData.fb_access_token
                             };
    
    NSString *urlToLoad = [NSString stringWithFormat:@"%@/app/userlogin",PHBaseDomain];
    
    NSLog(@"urlToLoad :: %@",urlToLoad);
    
    [manager POST:urlToLoad parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"TOKEN_responseObject :: %@",responseObject);
         if([responseObject[@"success"] boolValue])
         {
             self.didFBLogin = YES;
             self.sharedData.ph_token = responseObject[@"token"];
             [self checkIfAPNisLoaded];
         }else{
             [[NSNotificationCenter defaultCenter] postNotificationName:@"HIDE_LOADING" object:self];
             
             [FBSDKAccessToken setCurrentAccessToken:nil];
             FBSDKLoginManager *logMeOut = [[FBSDKLoginManager alloc] init];
             [logMeOut logOut];
             
             if (self.isAutoLoginMode) {
                 [[NSNotificationCenter defaultCenter]
                  postNotificationName:@"SHOW_LOGIN"
                  object:self];
             }
             
             //[FBSession.activeSession closeAndClearTokenInformation];
             self.didFBInitInfo = NO;
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"There was an issue logging in, please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"FAILING_responseObject :: %@",operation.responseString);
     }];
}


-(void)doubleCheckPermissions
{
    NSLog(@"doubleCheckPermissions");
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"/me/permissions" parameters:nil]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
     {
         
          NSLog(@"PERMISSION_RESULT :: %@",result[@"data"]);
          
          BOOL canDo = YES;
          NSString *errorMessage = @"To get the full benefits of Jiggie please accept the following Facebook permission(s):";
          
          for (int i = 0; i < [(NSArray *)result[@"data"] count]; i++)
          {
              NSDictionary *dict = [(NSArray *)result[@"data"] objectAtIndex:i];
              if([[dict objectForKey:@"status"] isEqualToString:@"declined"])
              {
                  NSLog(@"NOT_GRANTED!!! :: %@",[dict objectForKey:@"permission"] );
                  canDo = NO;
                  NSString *permission = [dict objectForKey:@"permission"];
                  permission = [permission stringByReplacingOccurrencesOfString:@"user_" withString:@""];
                  permission = [self.sharedData capitalizeFirstLetter:permission];
                  errorMessage = [NSString stringWithFormat:@"%@ %@,",errorMessage,permission];
              }
              
          }
          
          if(!canDo)
          {
              self.didFBInitInfo = NO;
              [self clearLogin:self.currentUser[@"id"]];
              
              if (self.isAutoLoginMode) {
                  [[NSNotificationCenter defaultCenter]
                   postNotificationName:@"SHOW_LOGIN"
                   object:self];
              }
              
              errorMessage = [errorMessage substringToIndex:[errorMessage length] - 1];
              
              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Permission Error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
              [alert show];
          }else{
              SET_IF_NOT_NULL(self.sharedData.userDict[@"first_name"],self.currentUser[@"first_name"]);
              SET_IF_NOT_NULL(self.sharedData.userDict[@"last_name"],self.currentUser[@"last_name"]);
              SET_IF_NOT_NULL(self.sharedData.userDict[@"fb_id"],self.currentUser[@"id"]);
              SET_IF_NOT_NULL(self.sharedData.userDict[@"gender"],self.currentUser[@"gender"]);
              SET_IF_NOT_NULL(self.sharedData.userDict[@"email"],self.currentUser[@"email"]);
              SET_IF_NOT_NULL(self.sharedData.userDict[@"birthday"],self.currentUser[@"birthday"]);
              SET_IF_NOT_NULL(self.sharedData.userDict[@"location"],self.currentUser[@"location"][@"name"]);
              SET_IF_NOT_NULL(self.sharedData.userDict[@"about"],self.currentUser[@"bio"]);
              
              NSLog(@"self.sharedData.userDict");
              NSLog(@"%@",self.sharedData.userDict);
              
              //[self checkIfAPNisLoaded];
              [self loginWithToken];
          }
          
      }];
}

-(void)changePage:(int)newPage {
    if(newPage >= self.totalPages) return;
    
    int lastPage = self.pageIndex;
    self.pageIndex = newPage;
    
    //Fade background between pages
    [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self.backgroundImages[lastPage] setAlpha:0.0f];
        [self.backgroundImages[newPage] setAlpha:1.0f];
    } completion:^(BOOL finished) {
    }];
}

- (IBAction)pageControlChanged:(id)sender {
    // Set the boolean used when scrolls originate from the page control.
    [self changePage:(int)self.pageControl.currentPage];
    self.pageControlUsed = YES;
    
    // Update the scroll view to the appropriate page
    CGFloat pageWidth  = self.scrollView.frame.size.width;
    CGFloat pageHeight = self.scrollView.frame.size.height;
    CGRect rect = CGRectMake(pageWidth * self.pageIndex, 0, pageWidth, pageHeight);
    [self.scrollView scrollRectToVisible:rect animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView*)sender {
    // If the scroll was initiated from the page control, do nothing.
    if (!self.pageControlUsed) {
        //Switch the page control when more than 50% of the previous/next
        CGFloat pageWidth = self.scrollView.frame.size.width;
        CGFloat xOffset = self.scrollView.contentOffset.x;
        int index = floor((xOffset - pageWidth/2) / pageWidth) + 1;
        if (index != self.pageIndex && index < self.totalPages) {
            self.pageControl.currentPage = index;
            [self changePage:index];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView {
    self.pageControlUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView {
    self.pageControlUsed = NO;
}
//---------------------------------------------------------------------//
//FACEBOOK

/*
//Fake click the fb login view
- (IBAction)buttonFacebookClicked:(id)sender {
    for(id object in self.loginView.subviews){
        if([[object class] isSubclassOfClass:[UIButton class]]){
            UIButton* button = (UIButton*)object;
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
}


- (void)loginView:(FBLoginView *)loginView handleError:	(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HIDE_LOADING" object:self];
    
    NSLog(@"FB_LOGIN_ERROR :: %@",error);
}

*/
//---------------------------------------------------------------------//



-(void)checkIfAPNisLoaded
{
    if(self.didFBLogin && !self.didAPNUpdate)
    {
        self.didAPNUpdate = YES;
        [self apnUpdate];
    }
}



-(void)apnUpdate
{
    
    NSString *facebookId = [self.sharedData.userDict objectForKey:@"fb_id"];
    NSString *apnToken = self.sharedData.apnToken;
    NSString *userId = self.sharedData.user_id;
    NSString *userFirstName = [self.sharedData.userDict objectForKey:@"first_name"];
    NSString *userLastName = [self.sharedData.userDict objectForKey:@"last_name"];
    NSString *profile_image_url = @"";
    NSString *gender = [self.sharedData.userDict objectForKey:@"gender"];
    NSString *email = [self.sharedData.userDict objectForKey:@"email"];
    
    
    NSString *birthday = self.sharedData.userDict[@"birthday"];
    NSString *location = self.sharedData.userDict[@"location"];
    
    NSString *about = self.sharedData.userDict[@"about"];
    
    
    if([about isEqualToString:@"undefined"])
    {
        about = @"";
    }
    
    location = [location lowercaseString];
    
    userFirstName = [userFirstName lowercaseString];
    userLastName = [userLastName lowercaseString];
    
    NSLog(@"APN_TOKEN :: %@",self.sharedData.apnToken);

    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    NSDictionary *params = @{
                             @"fb_id" : facebookId,
                             @"apn_token" : apnToken,
                             @"userId": userId,
                             @"user_first_name": userFirstName,
                             @"user_last_name": userLastName,
                             @"profile_image_url": profile_image_url,
                             @"gender": gender,
                             @"email": email,
                             @"birthday": birthday,
                             @"location": location,
                             @"about":about,
                             @"version":PHVersion
                             };
    
    NSLog(@"START_LOGIN");
    NSLog(@"%@",params);
    
    NSString *urlToLoad = [NSString stringWithFormat:@"%@/login",PHBaseURL];
    
    [manager POST:urlToLoad parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"START_LOGIN_RESPONSE :: %@",operation.responseString);
         NSLog(@"APN_responseObject :: %@",responseObject);
         if([responseObject[@"success"] boolValue])
         {
             NSLog(@"APN_SUCCESS!!!!");
             
             self.sharedData.isLoggedIn = YES;
             
             //Load data
             [UserManager saveUserSetting:responseObject];
             [UserManager updateLocalSetting];

             self.sharedData.help_phone = responseObject[@"help_phone"];
             
             self.didHerokuLogin = YES;
             
             //This should be after settings are set!
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"HIDE_LOGIN"
              object:self];
             
             
             self.sharedData.matchMe = [responseObject[@"matchme"] boolValue];
             self.sharedData.feedBadge.hidden = !(self.sharedData.matchMe);
             self.sharedData.feedBadge.canShow = self.sharedData.matchMe;
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             
             
             AnalyticManager *analyticManager = [AnalyticManager sharedManager];
             if([responseObject[@"is_new_user"] boolValue])
             {
                 [analyticManager setMixPanelOnSignUp];
                 [analyticManager trackMixPanelWithDict:@"Sign Up" withDict:@{}];
                 [analyticManager setMixPanelOnceParams];
             }else{
                 // tech debt : set dummy profile!!
                 [analyticManager createMixPanelDummyProfile];
                 [analyticManager setMixPanelOnLogin];
                
                 NSString *isFirst = ([defaults objectForKey:@"FIRST_RUN"])?@"NO":@"YES";
                 
                 [analyticManager trackMixPanelWithDict:@"Log In" withDict:@{@"new_device":isFirst}];
                 [analyticManager trackMixPanelIncrementWithDict:@{@"login_count":@1}];
             }
             [analyticManager setMixPanelUserProfile];
             [analyticManager setMixPanelSuperProperties];
             [self checkAppsFlyerData];
             [self performSelector:@selector(getUserImages) withObject:nil afterDelay:2.0];
             
         }else{
             NSLog(@"APN_NOT_SUCCESS!!!!");
             [self showUpgrade];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"APN_SEND_ERROR :: %@",error);
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Temporary Maintenance" message:@"We are undergoing maintenance, please try again in a few minutes." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
         
         [self.buttonFacebook setTitle:@"SIGNOUT FROM FACEBOOK" forState:UIControlStateNormal];
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
     }];
    
}


-(void)getUserImages
{
    
    
    NSMutableDictionary *infoToSend = [[NSMutableDictionary alloc] init];
    
    [infoToSend setObject:[self.sharedData.userDict objectForKey:@"fb_id"] forKey:@"fb_id"];
    [infoToSend setObject:@"" forKey:@"photo1"];
    [infoToSend setObject:@"" forKey:@"photo2"];
    [infoToSend setObject:@"" forKey:@"photo3"];
    [infoToSend setObject:@"" forKey:@"photo4"];

  
    NSLog(@"START_PHOTO");
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"%@/photos",self.cAlbumId] parameters:@{@"fields":@"name,link,images"}]
               startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
               {
              
              
              NSLog(@"PHOTO_RESULTS :: %@",result);
                   
                   NSMutableArray *tmpA = [[NSMutableArray alloc] init];
                   int total = ([result[@"data"] count] >= self.sharedData.maxProfilePics)?self.sharedData.maxProfilePics:(int)[result[@"data"] count];
                   [self.sharedData.photosDict removeAllObjects];
                   
                   for (int i = 0; i < total; i++)
                   {
                       NSDictionary *dict = [[result[@"data"] objectAtIndex:i][@"images"] objectAtIndex:0];
                       
                       if(i == 0)
                       {
                           [infoToSend setObject:[dict objectForKey:@"source"] forKey:@"photo1"];
                           [tmpA addObject:[dict objectForKey:@"source"]];
                       }
                       if(i == 1)
                       {
                           [infoToSend setObject:[dict objectForKey:@"source"] forKey:@"photo2"];
                           [tmpA addObject:[dict objectForKey:@"source"]];
                       }
                       if(i == 2)
                       {
                           [infoToSend setObject:[dict objectForKey:@"source"] forKey:@"photo3"];
                           [tmpA addObject:[dict objectForKey:@"source"]];
                       }
                       if(i == 3)
                       {
                           [infoToSend setObject:[dict objectForKey:@"source"] forKey:@"photo4"];
                           [tmpA addObject:[dict objectForKey:@"source"]];
                       }
                   }
                   
                   
                   if(total == 0)
                   {
                       //[infoToSend setObject:PHBlankImgURL forKey:@"photo1"];
                       //[tmpA addObject:PHBlankImgURL];
                       
                   }
                   
                   
                   [self.sharedData.photosDict setObject:tmpA forKey:@"photos"];
                   [self photosupdate:infoToSend];
                   NSLog(@"PHOTOS_DICT :: %@",self.sharedData.photosDict);
                   [self loadProfilePhotos];
                   
                   /*
              int total = ([result[@"data"] count] >= self.sharedData.maxProfilePics)?self.sharedData.maxProfilePics:(int)[result[@"data"] count];
              NSLog(@"total :: %d",total);
              total = (total < 0)?0:total;
              
              
              [self.sharedData.photosDict removeAllObjects];
              
              NSMutableArray *tmpA = [[NSMutableArray alloc] init];
              
              NSLog(@"%@",result[@"data"]);
              for (int i = 0; i < total; i++)
              {
                  NSDictionary *dict = [[result[@"data"] objectAtIndex:i][@"images"] objectAtIndex:0];
                  
                  if(i == 0)
                  {
                      [infoToSend setObject:[dict objectForKey:@"source"] forKey:@"photo1"];
                      [tmpA addObject:[dict objectForKey:@"source"]];
                  }
                  if(i == 1)
                  {
                      [infoToSend setObject:[dict objectForKey:@"source"] forKey:@"photo2"];
                      [tmpA addObject:[dict objectForKey:@"source"]];
                  }
                  if(i == 2)
                  {
                      [infoToSend setObject:[dict objectForKey:@"source"] forKey:@"photo3"];
                      [tmpA addObject:[dict objectForKey:@"source"]];
                  }
                  if(i == 3)
                  {
                      [infoToSend setObject:[dict objectForKey:@"source"] forKey:@"photo4"];
                      [tmpA addObject:[dict objectForKey:@"source"]];
                  }
                  
              }
              
              if(total == 0)
              {
                  [infoToSend setObject:PHBlankImgURL forKey:@"photo4"];
                  [tmpA addObject:PHBlankImgURL];
                  
              }
              
              [self.sharedData.photosDict setObject:tmpA forKey:@"photos"];
              [self photosupdate:infoToSend];
              NSLog(@"PHOTOS_DICT :: %@",self.sharedData.photosDict);
              [self loadProfilePhotos];
              //[self performSelector:@selector(loadProfilePhotos) withObject:nil afterDelay:4.0];
                   
                   */
          }];
    
}


-(void)loadProfilePhotos
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"LOAD_PROFILE_PHOTOS"
     object:self];
}



-(void)photosupdate:(NSMutableDictionary *)params
{
    
    if (!params) {
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    NSLog(@"START_PHOTO_UPLOAD");
    NSLog(@"%@",params);
    NSString *urlToLoad = [NSString stringWithFormat:@"%@/updatephotos",PHBaseURL];
    [manager POST:urlToLoad parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"PHOTO_UPDATE_responseObject :: %@",responseObject);
         if(responseObject[@"success"])
         {
             NSLog(@"PHOTO_UPDATE_SUCCESS!!!!");
             
         }else{
             NSLog(@"PHOTO_UPDATE_SUCCESS!!!!");
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"PHOTOS_UPDATE_ERROR :: %@",error);
     }];
    
    
    //[self putUserInfo];
}



-(NSMutableArray *)checkIfGotAllData:(id)user
{
    NSMutableArray *tmpA = [[NSMutableArray alloc] init];
    if(user[@"first_name"] && user[@"last_name"] && user[@"email"] && user[@"birthday"] && user[@"gender"] && user[@"photos"])
    {
        //return YES;
    }
    
    if(!user[@"first_name"])
    {
        [tmpA addObject:@"First Name"];
    }
    
    if(!user[@"last_name"])
    {
        [tmpA addObject:@"Last Name"];
    }
    
    if(!user[@"email"])
    {
        [tmpA addObject:@"Email"];
    }
    
    if(!user[@"birthday"])
    {
        [tmpA addObject:@"Birthday"];
    }
    
    if(!user[@"gender"])
    {
        [tmpA addObject:@"Gender"];
    }
    
    
    return tmpA;
}

-(void)showUpgrade
{
    UpgradeScreen *upgradeScreen = [[UpgradeScreen alloc] initWithFrame:CGRectMake(0, self.sharedData.screenHeight, self.sharedData.screenWidth, self.sharedData.screenHeight)];
    [self addSubview:upgradeScreen];
    [UIView animateWithDuration:0.25 animations:^(void)
     {
         upgradeScreen.frame = CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.screenHeight);
     } completion:^(BOOL finished)
     {
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
     }];
}


-(void)checkAppsFlyerData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"checkAppsFlyerData :: %@",[defaults objectForKey:@"sent_appsflyer_data"]);
    if(![defaults objectForKey:@"sent_appsflyer_data"])
    {
        
        
        
        NSLog(@"STARTING_APPSFLYER_POST");
        NSString *facebookId = self.sharedData.fb_id;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.sharedData.appsFlyerDict
                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                             error:&error];
        
        NSString *info = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSDictionary *params = @ {@"appsflyer" :info,@"fb_id":facebookId };
        
        NSLog(@"FB_ID :: %@",facebookId);
        NSLog(@"APPSFLYER OBJ :: %@",info);
        NSString *urlToLoad = [NSString stringWithFormat:@"%@/appsflyerinfo",PHBaseURL];
        [manager POST:urlToLoad parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"APPSFLYER: %@", responseObject);
             
             [defaults setObject:@"YES" forKey:@"sent_tapstream_data"];
         }
              failure:
         ^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
        
    }
}

-(void)clearLogin:(NSString *)fb_id
{
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/permissions"
                                       parameters:nil
                                       HTTPMethod:@"DELETE"]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         NSLog(@"PERMISSION_DELETE_RESULT");
         NSLog(@"%@",result);
         
         [FBSDKAccessToken setCurrentAccessToken:nil];
         FBSDKLoginManager *logMeOut = [[FBSDKLoginManager alloc] init];
         [logMeOut logOut];
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
     }];
}

@end
