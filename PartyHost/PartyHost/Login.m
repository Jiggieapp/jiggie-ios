//
//  Login.m
//  PartyHost
//
//  Created by Sunny Clark on 12/26/14.
//  Copyright (c) 2014 Sunny Clark. All rights reserved.
//

#import "Login.h"

@implementation Login

#define TOTAL_LANDING_PAGES 5
#define SET_IF_NOT_NULL(TARGET, VAL) if(VAL && VAL != [NSNull null]) { TARGET = VAL; }else {TARGET = @"";}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor blackColor];
    
    /*
    UIImageView *bk = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    bk.image = [UIImage imageNamed:@"LoginBK"];
    [self addSubview:bk];
    */
    
    self.sharedData = [SharedData sharedInstance];
    //self.didLogin = NO;
    self.didAPNUpdate = NO;
    self.didFBLogin = NO;
    self.didRubyLogin = NO;
    self.didHerokuLogin = NO;
    self.didFBInitInfo = NO;
    
    
    self.landingView = [self createLandingView];
    [self addSubview:self.landingView];
    
    
    
    self.loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile",@"user_birthday", @"email", @"user_photos",@"user_friends",@"user_likes",@"user_relationships",@"user_about_me",@"user_location",@"user_photos",@"user_status",@"user_friends"]];
    
    int logOffset = 0;
    int pControlOffset = 0;
    
    if(self.sharedData.isIphone4)
    {
        pControlOffset = -15;
        logOffset = -15;
    }
    
    
    if(self.sharedData.isIphone6)
    {
        pControlOffset = 14;
        logOffset = 13;
    }
    
    if(self.sharedData.isIphone6plus)
    {
        logOffset = 22;
        pControlOffset = 27;
    }
    
    self.loginView.delegate = self;
    self.loginView.frame = CGRectMake(0, 0, 275, 40);
    self.loginView.layer.masksToBounds = YES;
    self.loginView.layer.cornerRadius = 5.0;
    self.loginView.center = CGPointMake(self.center.x, self.frame.size.height - 65 - logOffset);
    [self addSubview:self.loginView];
    
    self.btnLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnLogin.frame = CGRectMake(0, 0, 275, 40);
    self.btnLogin.center = CGPointMake(self.center.x, self.frame.size.height - 65 - logOffset);
    self.btnLogin.backgroundColor = [self.sharedData colorWithHexString:@"0x3B5998"];
    self.btnLogin.layer.masksToBounds = YES;
    self.btnLogin.layer.cornerRadius = 5.0;
    [self.btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnLogin setTitle:@"Log in with Facebook" forState:UIControlStateNormal];
    //[self addSubview:self.btnLogin];
    
    UIImageView *fbIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    fbIcon.image = [UIImage imageNamed:@"fb_icon_white"];
    [self.btnLogin addSubview:fbIcon];
    
    self.pControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 125 - pControlOffset, self.sharedData.screenWidth, 50)];
    self.pControl.userInteractionEnabled = NO;
    self.pControl.numberOfPages = TOTAL_LANDING_PAGES;
    self.pControl.currentPage   = 0;
    [self addSubview:self.pControl];
    
    
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
    
    return self;
}


-(void)initClass
{
    
    
    
}

-(UIView *)createLandingView
{
    UIView *landing = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.screenHeight)];
    
    
    UIScrollView *carousel = [[UIScrollView alloc] initWithFrame:landing.frame];
    carousel.showsVerticalScrollIndicator    = NO;
    carousel.showsHorizontalScrollIndicator  = NO;
    carousel.scrollEnabled                   = YES;
    carousel.userInteractionEnabled          = YES;
    carousel.delegate                        = self;
    carousel.pagingEnabled                   = YES;
    carousel.backgroundColor                 = [UIColor blackColor];
    carousel.contentSize                     = CGSizeMake(self.sharedData.screenWidth * TOTAL_LANDING_PAGES, self.sharedData.screenHeight);
    carousel.layer.masksToBounds             = YES;
    [landing addSubview:carousel];
    
    NSString *version = @"4";
    
    if(self.sharedData.screenHeight == 568)
    {
        version = @"5";
    }
    
    if(self.sharedData.screenHeight == 667)
    {
        version = @"6";
    }
    
    if(self.sharedData.screenHeight == 736)
    {
        version = @"6plus";
    }
    
    NSLog(@"version :: %@",version);
    
    for(int i = 0; i < TOTAL_LANDING_PAGES; i++)
    {
        NSString *imgName = [NSString stringWithFormat:@"iphone%@_landing%d",version,(i + 1)];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth * i, 0, self.sharedData.screenWidth, self.sharedData.screenHeight)];
        img.image = [UIImage imageNamed:imgName];
        [carousel addSubview:img];
    }
    
    //iphone5_landing1
    
    
    return landing;
}

-(void)resetApp
{
    self.didAPNUpdate = NO;
    self.didFBLogin = NO;
    self.didRubyLogin = NO;
    self.didHerokuLogin = NO;
    self.sharedData.isLoggedIn = NO;
    self.didTryRubyLogin    = NO;
    self.didFBInitInfo = NO;
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    if(self.didFBInitInfo)
    {
        return;
    }
    self.didFBInitInfo = YES;
    //[self.sharedData trackMixPanel:@"auto_login"];
    
    NSLog(@"USER ::: %@",user);
    /*
    if([[self checkIfGotAllData:user] count] > 0)
    {
        NSString *errorMessage = @"To get the full benefits of PartyHost please accept the following Facebook permission(s):";
        for (int i = 0; i < [[self checkIfGotAllData:user] count]; i++)
        {
            if(i == [[self checkIfGotAllData:user] count] - 1)
            {
                errorMessage = [NSString stringWithFormat:@"%@ %@",errorMessage,[self checkIfGotAllData:user][i]];
            }else
            {
                errorMessage = [NSString stringWithFormat:@"%@ %@,",errorMessage,[self checkIfGotAllData:user][i]];
            }
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Permission Error" message:errorMessage delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"HIDE_LOADING"
         object:self];
        
        
        [self clearLogin:user[@"id"]];
        
        return;
    }
    
    */
    
    self.currentUser = user;
    
    self.sharedData.fb_access_token = [FBSession activeSession].accessTokenData.accessToken;
    self.sharedData.fb_id = user[@"id"];
    
    [self doubleCheckPermissions];
}


- (void)loginView:	(FBLoginView *)loginView handleError:	(NSError *)error;
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"HIDE_LOADING"
     object:self];
    
    NSLog(@"ERROR :: %@",error);
}

-(NSMutableArray *)checkIfGotAllData:(id<FBGraphUser>)user
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

-(void)doubleCheckPermissions
{
    NSLog(@"doubleCheckPermissions");
    
    [FBRequestConnection startWithGraphPath:@"/me/permissions"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              
                              NSLog(@"PERMISSION_RESULT :: %@",result[@"data"]);
                              
                              BOOL canDo = YES;
                              NSString *errorMessage = @"To get the full benefits of PartyHost please accept the following Facebook permission(s):";
                              
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
                                  [self clearLogin:self.currentUser[@"id"]];
                                  
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
                                  self.sharedData.profilePage.toLabel.text = [NSString stringWithFormat:@"%@",self.currentUser[@"first_name"]];
                                  SET_IF_NOT_NULL(self.sharedData.userDict[@"about"],self.currentUser[@"bio"]);
                                  
                                  
                                  
                                  
                                  NSLog(@"self.sharedData.userDict");
                                  NSLog(@"%@",self.sharedData.userDict);
                                  self.didFBLogin = YES;
                                  [self checkIfAPNisLoaded];
                              }
                              
                          }];
}

-(void)clearLogin:(NSString *)fb_id
{
    [FBRequestConnection startWithGraphPath:@"/me/permissions"
                                 parameters:nil
                                 HTTPMethod:@"DELETE"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              /* handle the result */
                              
                              NSLog(@"PERMISSION_DELETE_RESULT");
                              NSLog(@"%@",result);
                              /* handle the result */
                              [FBSession.activeSession closeAndClearTokenInformation];
                              
                              [[NSNotificationCenter defaultCenter]
                               postNotificationName:@"HIDE_LOADING"
                               object:self];
                          }];
}

-(BOOL)hasAllPermissions
{
    BOOL canDo = NO;
    
    /*
     {
     data =     (
     {
     permission = "public_profile";
     status = granted;
     },
     {
     permission = email;
     status = granted;
     },
     {
     permission = "user_birthday";
     status = granted;
     },
     {
     permission = "user_relationships";
     status = granted;
     },
     {
     permission = "user_location";
     status = granted;
     },
     {
     permission = "user_likes";
     status = granted;
     },
     {
     permission = "user_activities";
     status = granted;
     },
     {
     permission = "user_photos";
     status = granted;
     },
     {
     permission = "user_friends";
     status = granted;
     },
     {
     permission = "user_about_me";
     status = granted;
     },
     {
     permission = "user_status";
     status = granted;
     }
     );
     }
     
     
     
     {
     data =     (
     {
     permission = "public_profile";
     status = granted;
     },
     {
     permission = "user_birthday";
     status = declined;
     },
     {
     permission = email;
     status = declined;
     },
     {
     permission = "user_photos";
     status = declined;
     },
     {
     permission = "user_friends";
     status = declined;
     }
     );
     }
     */
    
    return canDo;
}

-(void)checkIfAPNisLoaded
{
    if(![self.sharedData.apnToken isEqualToString:@""] && self.didFBLogin && !self.didTryRubyLogin)
    {
        self.didTryRubyLogin = YES;
        //[self loginToRubyServer];
        [self apnUpdate];
    }
}



-(void)loadProfilePhotos
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"LOAD_PROFILE_PHOTOS"
     object:self];
}



-(void)loginToRubyServer
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user_ref = @"";
    if([self.sharedData.appsFlyerDict objectForKey:@"af_sub1"] && ![defaults objectForKey:@"sent_appsflyer_data"])
    {
        user_ref = [self.sharedData.appsFlyerDict objectForKey:@"af_sub1"];
    }
    
    NSDictionary *params = @{
                             @"fb_id" : self.sharedData.fb_id,
                             @"oauth_token" : self.sharedData.fb_access_token,
                             @"user_ref":user_ref
                             };
    
    //10152901432247953
    NSLog(@"RUBY_LOGIN_PARAMS :: %@",params);
    [manager POST:[NSString stringWithFormat:@"%@/%@", self.sharedData.baseAPIURL, @"users"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"RUBY_USER:: %@",responseObject);
        //user.facebookId = facebookId;
        
        NSLog(@"PH_TOKEN :: %@",responseObject[@"user"][@"ph_token"]);
        self.sharedData.ph_token =  responseObject[@"user"][@"ph_token"];
        self.sharedData.user_id = responseObject[@"user"][@"id"];
        
        
        //user_ref
        
        //SET_IF_NOT_NULL(self.sharedData.userDict[@"about"],responseObject[@"user"][@"about"]);
        //[self.sharedData.userDict setObject:responseObject[@"user"][@"about"] forKey:@"about"];
        
        
        
        //id
        /*
         //NSLog(@"user.facebookId :: %@",user.facebookId);
         //user.access_token = accessToken;
         [user setFromDictionary:responseObject[@"user"]];
         loggedIn = user;
         
         NSLog(@"PROFILE_URL :: %@",user.profile_image_url);
         
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         [defaults setObject:facebookId forKey:@"facebookId"];
         [defaults setObject:accessToken forKey:@"accessToken"];
         [defaults setObject:[user.userId stringValue] forKey:@"userId"];
         [defaults setObject:user.first_name forKey:@"userFirstName"];
         [defaults setObject:user.profile_image_url forKey:@"profile_image_url"];
         [defaults synchronize];
         */
        self.didRubyLogin = YES;
        //[self apnUpdate];
        //completion(user, [responseObject[@"new_signup"] isEqualToNumber:@1]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"LOGIN_ERROR :: %@",error);
         
     }];
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
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
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
                             @"version":@"3.0"
                             };
    
    NSLog(@"START_LOGIN");
    NSLog(@"%@",params);
    NSString *urlToLoad = [NSString stringWithFormat:@"%@/login",self.sharedData.baseHerokuAPIURL];
    [manager POST:urlToLoad parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"APN_responseObject :: %@",responseObject);
         if([responseObject[@"success"] boolValue])
         {
             NSLog(@"APN_SUCCESS!!!!");
             
             //Settings
             self.sharedData.isLoggedIn = YES;
             self.sharedData.account_type = responseObject[@"data"][@"account_type"];
             SET_IF_NOT_NULL(self.sharedData.gender,responseObject[@"data"][@"gender"]);
             SET_IF_NOT_NULL(self.sharedData.gender_interest,responseObject[@"data"][@"gender_interest"]);
             self.sharedData.notification_feed = [responseObject[@"data"][@"notifications"][@"feed"] boolValue];
             self.sharedData.notification_messages = [responseObject[@"data"][@"notifications"][@"chat"] boolValue];
             self.didHerokuLogin = YES;
             self.didAPNUpdate = YES;
             [self checkAppsFlyerData];
             /*
             NSDate *date = [NSDate date];
             NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
             [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
             [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
             NSString *dateNow = [formatter stringFromDate:date];
             NSLog(@"dateNow :: >>%@<<",dateNow);
             */
             
             
             
             
             //This should be after settings are set!
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"HIDE_LOGIN"
              object:self];
             
             
             
             
             
             if([responseObject[@"is_new_user"] boolValue])
             {
                 [self.sharedData setMixPanelOnSignUp];
                 [self.sharedData trackMixPanelWithDict:@"Sign Up" withDict:@{}];
             }else{
                 [self.sharedData setMixPanelOnLogin];
                 [self.sharedData trackMixPanelWithDict:@"Log In" withDict:@{}];
                 [self.sharedData trackMixPanelIncrementWithDict:@{@"login_count":@1}];
                // [self.sharedData trackMixPanelIncrementWithEventDict:@{}];
             }
             
             [self.sharedData setMixPanelUserProfile];
             [self.sharedData setMixPanelSuperProperties];
             
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
    
    FBRequest *request = [FBRequest requestForGraphPath:@"me/albums"];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         NSDictionary *album;// = matched[0];
         NSArray *albums = result[@"data"];
         for (int i = 0; i < [albums count]; i++)
         {
             if([[[albums objectAtIndex:i] objectForKey:@"type"] isEqualToString:@"profile"])
             {
                 album = [albums objectAtIndex:i];
             }
             NSLog(@"TYPE :: %@",[[albums objectAtIndex:i] objectForKey:@"type"]);
         }
         
         FBRequest *request2 = [FBRequest requestForGraphPath:[NSString stringWithFormat:@"%@/photos", album[@"id"]]];
         [request2 startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
          {
              NSLog(@"PHOTO_RESULTS");
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
                  [infoToSend setObject:@"https://partyhostapp.herokuapp.com/img/fbperson_blank_square.png" forKey:@"photo4"];
                  [tmpA addObject:@"https://partyhostapp.herokuapp.com/img/fbperson_blank_square.png"];
                  
              }
              
              [self.sharedData.photosDict setObject:tmpA forKey:@"photos"];
              [self photosupdate:infoToSend];
              NSLog(@"PHOTOS_DICT :: %@",self.sharedData.photosDict);
              [self loadProfilePhotos];
              //[self performSelector:@selector(loadProfilePhotos) withObject:nil afterDelay:4.0];
          }];
     }];
}


-(void)photosupdate:(NSMutableDictionary *)params
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSLog(@"START_PHOTO_UPLOAD");
    NSLog(@"%@",params);
    NSString *urlToLoad = [NSString stringWithFormat:@"%@/updatephotos",self.sharedData.baseHerokuAPIURL];
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




-(void)checkTapStreamData
{
    /*
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"checkTapStreamData :: %@",[defaults objectForKey:@"sent_tapstream_data"]);
    if(![defaults objectForKey:@"sent_tapstream_data"])
    {
        
        //facebookId
        NSLog(@"STARTING_TAPSTREAM_POST");
        NSString *facebookId = self.sharedData.fb_id;
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.sharedData.tapDict
                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                             error:&error];
        
        NSString *info = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSDictionary *params = @ {@"tapstream" :info,@"fb_id":facebookId };
        
        NSLog(@"FB_ID :: %@",facebookId);
        NSLog(@"TAPSTREAM OBJ :: %@",info);
        
        [manager POST:@"https://partyhostapp.herokuapp.com/tapstreaminfo" parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"TAPSTREAM_JSON: %@", responseObject);
             
             [defaults setObject:@"YES" forKey:@"sent_tapstream_data"];
             
             [self checkAppsFlyerData];
             
         }
              failure:
         ^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             
             [self checkAppsFlyerData];
         }];
    }
    */
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
        NSString *urlToLoad = [NSString stringWithFormat:@"%@/appsflyerinfo",self.sharedData.baseHerokuAPIURL];
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

-(void)putUserInfo
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer   = [AFJSONRequestSerializer serializer];
    manager.responseSerializer  = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:self.sharedData.ph_token forHTTPHeaderField:@"ph_token"];
    
    NSLog(@"putUserInfo_START :: %d",(int)[self.sharedData.userDict[@"birthday"] length]);
    
    NSString *newBday = @"";
    
    if([self.sharedData.userDict[@"birthday"] length] == 10)
    {
        NSString *birthYear = [self.sharedData.userDict[@"birthday"] substringFromIndex:6];
        NSString *birthDay = [[self.sharedData.userDict[@"birthday"] substringToIndex:5] substringFromIndex:3];
        NSString *birthMonth = [self.sharedData.userDict[@"birthday"] substringToIndex:2];
        NSLog(@"birthDay :: %@ birthMonth :: %@ birthYear :: %@",birthDay,birthMonth,birthYear);
        newBday = [NSString stringWithFormat:@"%@-%@-%@",birthYear,birthMonth,birthDay];
    }
    
    
    
    
    
    
    NSMutableDictionary *params = [@{@"fb_id" :self.sharedData.fb_id,
        @"email":self.sharedData.userDict[@"email"],
        @"first_name":self.sharedData.userDict[@"first_name"],
        @"last_name":self.sharedData.userDict[@"last_name"],
        @"birthday":newBday,
        @"nick_name":@"",
        @"gender":self.sharedData.userDict[@"gender"],
        @"location":self.sharedData.userDict[@"location"],
        @"tagline":@"",
        @"about":self.sharedData.userDict[@"about"],
        @"id":self.sharedData.user_id
    } mutableCopy];
    
    if([[self.sharedData.photosDict objectForKey:@"photos"] count] >= 1)
    {
        params[@"profile_image_url"] = [[self.sharedData.photosDict objectForKey:@"photos"] objectAtIndex:0];
    }
    
    if([[self.sharedData.photosDict objectForKey:@"photos"] count] >= 2)
    {
        params[@"profile_image_url_2"] = [[self.sharedData.photosDict objectForKey:@"photos"] objectAtIndex:1];
    }
    
    if([[self.sharedData.photosDict objectForKey:@"photos"] count] >= 3)
    {
        params[@"profile_image_url_3"] = [[self.sharedData.photosDict objectForKey:@"photos"] objectAtIndex:2];
    }
    
    if([[self.sharedData.photosDict objectForKey:@"photos"] count] >= 4)
    {
        params[@"profile_image_url_4"] = [[self.sharedData.photosDict objectForKey:@"photos"] objectAtIndex:3];
    }
    
    params[@"apn_token"] = self.sharedData.apnToken;
    
    //[self.sharedData.photosDict
    
    NSLog(@"RUBY_USER_PARAMS :: %@",params);
    
    [manager PUT:[NSString stringWithFormat:@"%@/users/%@", self.sharedData.baseAPIURL,self.sharedData.user_id ] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
    
        NSLog(@"SAVE_USER_RESPONSE");
        NSLog(@"%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR_PUT_USER");
        NSLog(@"%@",operation.responseString);
    }];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int width = scrollView.frame.size.width;
    float xPos = scrollView.contentOffset.x+10;
    self.pControl.currentPage = (int)xPos/width;
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


/*
 NSMutableDictionary *json = [@{@"fb_id" : self.facebookId,
 @"email" : self.email,
 @"first_name" : self.first_name,
 @"last_name" : self.last_name
 } mutableCopy];
 if (self.birthday) {
 json[@"birthday"] = [self.birthday isoDateValue];
 }
 if (self.nick_name) {
 json[@"nick_name"] = self.nick_name;
 }
 if (self.gender) {
 json[@"gender"] = self.gender;
 }
 
 if (self.location) {
 json[@"location"] = self.location;
 }
 if (self.tagline) {
 json[@"tagline"] = self.tagline;
 }
 if (self.about) {
 json[@"about"] = self.about;
 }
 if (self.userId) {
 json[@"id"] = self.userId;
 }
 if (self.profile_image_url) {
 json[@"profile_image_url"] = self.profile_image_url;
 }
 if (self.profile_image_url_2) {
 json[@"profile_image_url_2"] = self.profile_image_url_2;
 }
 if (self.profile_image_url_3) {
 json[@"profile_image_url_3"] = self.profile_image_url_3;
 }
 if (self.profile_image_url_4) {
 json[@"profile_image_url_4"] = self.profile_image_url_4;
 }
 */

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
