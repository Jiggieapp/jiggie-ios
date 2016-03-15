//
//  ViewController.m
//  PartyHost
//
//  Created by Sunny Clark on 12/26/14.
//  Copyright (c) 2014 Sunny Clark. All rights reserved.
//

#import "ViewController.h"
#import "AnalyticManager.h"
#import "Event.h"
#import "TicketListViewController.h"
#import "AddPaymentViewController.h"
#import "VirtualAccountViewController.h"
#import "TicketSuccessViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sharedData = [SharedData sharedInstance];
    
    
    ///TEST DISCONNECTED VIEWS
    //SetupView *v = [[SetupView alloc] initWithFrame:self.view.frame];
    //[self.view addSubview:v];
    //return;
    ///TEST DISCONNECTED VIEWS
    
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.canPoll = NO;
    
    //[[UINavigationBar appearance] setBarTintColor:[UIColor phDarkTitleColor]];
    //[[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont phBold:15.0] }];
    //[[UILabel appearance] setFont:[UIFont phBlond:12.0]];
    
    CGRect fullRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    self.mainCon = [[UIView alloc] initWithFrame:fullRect];
    self.dashboard = [[Dashboard alloc] initWithFrame:fullRect];
    [self.mainCon addSubview:self.dashboard];
    
    self.signupView = [[SignupView alloc] initWithFrame:fullRect];
    [self.signupView initClass];
    [self.mainCon addSubview:self.signupView];
    
    [self.view addSubview:self.mainCon];
    
    self.loadingView = [[UIView alloc] initWithFrame:fullRect];
    self.loadingView.hidden = YES;
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.frame = CGRectMake(0, 0, 100, 100);
    [spinner startAnimating];
    
    UIView *spinnerCon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    spinnerCon.layer.masksToBounds = YES;
    spinnerCon.layer.cornerRadius = 10;
    spinnerCon.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    spinnerCon.center = self.loadingView.center;
    //spinner.center = spinnerCon.center;
    [spinnerCon addSubview:spinner];
    [self.loadingView addSubview:spinnerCon];
    [self.view addSubview:self.loadingView];
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(startPollingChat)
     name:@"APP_LOADED"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(hideLogin)
     name:@"HIDE_LOGIN"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showLogin)
     name:@"SHOW_LOGIN"
     object:nil];
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showLoading)
     name:@"SHOW_LOADING"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(hideLoading)
     name:@"HIDE_LOADING"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(apnLoaded)
     name:@"APN_LOADED"
     object:nil];
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showGeneralInvite)
     name:@"SHOW_GENERAL_INVITE"
     object:nil];
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showHostingInvite)
     name:@"SHOW_HOSTING_INVITE"
     object:nil];
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showMessage)
     name:@"SHOW_MAIL_MESSAGE"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showTicketList:)
     name:@"SHOW_TICKET_LIST"
     object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:
     UIApplicationDidReceiveMemoryWarningNotification
                                                      object:[UIApplication sharedApplication] queue:nil
                                                  usingBlock:^(NSNotification *notif) {
                                                      //your code here
                                                      [self.sharedData.imagesDict removeAllObjects];
                                                  }];
    
    
    if([FBSDKAccessToken currentAccessToken].tokenString.length > 20)
    {
        [self hideLoginWithNoAnimation];
        [self enableTabBar:NO];
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"LaunchScreen" owner:nil options:nil];
    UIView *plainView = [nibContents lastObject];
    [plainView setFrame:self.view.frame];
    [self.view addSubview:plainView];
    
    [UIView animateWithDuration:0.75 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^()
    {
        plainView.alpha = 0;
    } completion:^(BOOL finished)
    {
        [plainView removeFromSuperview];
    }];

}

-(void)apnLoaded
{
    /*
    if(![FBSession activeSession].isOpen)
    {
       [self hideLoading];
    }
     
    */
    //[self hideLoading];
    //
    //[self performSelector:@selector(hideLoading) withObject:nil afterDelay:2.0];
}


-(void)showLoading
{
    self.loadingView.alpha = 1.0;
    self.loadingView.hidden = NO;
    self.mainCon.alpha = 0.8;
    self.mainCon.userInteractionEnabled = NO;
}

-(void)hideLoading
{
    [UIView animateWithDuration:0.25 animations:^(void)
    {
        self.mainCon.alpha = 1;
        self.loadingView.alpha = 0.0;
    } completion:^(BOOL finished)
    {
        self.mainCon.userInteractionEnabled = YES;
        self.loadingView.hidden = YES;
    }];
}

-(void)showLogin
{
    self.sharedData.walkthroughOn = NO;
    self.canPoll = NO;
    [[AnalyticManager sharedManager] trackMixPanel:@"display_login"];
    [self showLoading];
    self.signupView.hidden = NO;
    [self.signupView initClass];
    
    [FBSDKAccessToken setCurrentAccessToken:nil];
    FBSDKLoginManager *logMeOut = [[FBSDKLoginManager alloc] init];
    [logMeOut logOut];
    
    //[FBSession.activeSession closeAndClearTokenInformation];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [UIView animateWithDuration:0.25 animations:^(void)
     {
         self.signupView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
     } completion:^(BOOL finished)
     {
         [self hideLoading];
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"APP_UNLOADED"
          object:nil];
     }];
}

-(void)hideLogin
{
    
    [self enableTabBar:YES];
    
    //Put WALKTHROUGH behind login screen
    if(self.sharedData.walkthroughOn == YES)
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"SHOW_WALKTHROUGH"
         object:self];
    }
    
    [UIView animateWithDuration:0.25 animations:^(void)
     {
         self.signupView.frame = CGRectMake(0, self.view.frame.size.height+1, self.view.frame.size.width, self.view.frame.size.height);
     } completion:^(BOOL finished)
     {
         [self hideLoading];
         self.signupView.hidden = YES;
         
         if(self.sharedData.walkthroughOn == NO)
         {
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"APP_LOADED"
              object:self];
         }
     }];
}

-(void)hideLoginWithNoAnimation
{
    
    //Put WALKTHROUGH behind login screen
    if(self.sharedData.walkthroughOn == YES)
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"SHOW_WALKTHROUGH"
         object:self];
    }
    
    [UIView animateWithDuration:0 animations:^(void)
     {
         self.signupView.frame = CGRectMake(0, self.view.frame.size.height+1, self.view.frame.size.width, self.view.frame.size.height);
     } completion:^(BOOL finished)
     {
         [self hideLoading];
         self.signupView.hidden = YES;
         
         if(self.sharedData.walkthroughOn == NO)
         {
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"APP_LOADED"
              object:self];
         }
     }];
}

-(void)enableTabBar:(BOOL)enable {
    for (UIButton *navButton in self.dashboard.btnsA) {
        [navButton setEnabled:enable];
    }
    [self.dashboard.eventsPage.btnFilter setEnabled:enable];
}

-(void)checkIfPushIsEnabled
{
    if([self.sharedData.APN_PERMISSION_STATE isEqualToString:@"DISABLED"])
    {
        [self pollMessages];
    }
}

-(void)startPollingChat
{
    self.canPoll = YES;
    [self checkIfPushIsEnabled];
}

-(void)pollMessages
{
    if(self.canPoll)
    {
        [self loadConversations];
        [self performSelector:@selector(pollMessages) withObject:nil afterDelay:4.0];
    }
}

-(void)loadConversations
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"UPDATE_CONVERSATION_LIST"
     object:self];
}

-(void)showMessage
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        [picker setSubject:@"Support"];
        NSArray *myReceivers = [[NSArray alloc] initWithObjects:@"support@jiggieapp.com", nil];
        [picker setToRecipients:myReceivers];
        picker.delegate = self;
        picker.mailComposeDelegate = self;
        picker.navigationBar.barStyle = UIBarStyleDefault;
        //iipicker.navigationBar.tintColor = [UIColor whiteColor];
        [self presentViewController:picker animated:YES completion:^{}];
    }
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    NSLog(@"MAIL_RESULT");
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            //alert = [[UIAlertView alloc] initWithTitle:@"Draft Saved" message:@"Composed Mail is saved in draft." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            //[alert show];
            break;
        case MFMailComposeResultSent:
            //alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have successfully referred your friends." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            //[alert show];
            break;
        case MFMailComposeResultFailed:
            //alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Sorry! Failed to send." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            //[alert show];
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //[self dismissModalViewControllerAnimated:YES];
}


-(void)showGeneralInvite
{
    //[self shareText:@"Hey download Jiggie from the App Store so we can skip the line and get free drinks at the club!" andImage:nil andUrl:[[NSURL alloc] initWithString:[self getGeneralShareLink]]];
    
    [self getGeneralInviteLink];
}


-(void)getGeneralInviteLink
{
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    
     NSDictionary *params = @{ @"type" : @"general",
                              @"from_fb_id":self.sharedData.fb_id
                            };
     /*
    [self.sharedData.mixPanelCEventDict removeAllObjects];
    
    
    [self.sharedData.mixPanelCEventDict setObject:self.mainData[@"title"] forKey:@"Event Name"];
    [self.sharedData.mixPanelCEventDict setObject:self.mainData[@"start_datetime_str"] forKey:@"Event Start Time"];
    [self.sharedData.mixPanelCEventDict setObject:self.mainData[@"end_datetime_str"] forKey:@"Event End Time"];
    [self.sharedData.mixPanelCEventDict setObject:self.mainData[@"description"] forKey:@"Event Description"];
    [self.sharedData.mixPanelCEventDict setObject:self.mainData[@"venue_name"] forKey:@"Event Venue Name"];
    [self.sharedData.mixPanelCEventDict setObject:self.mainData[@"venue"][@"neighborhood"] forKey:@"Event Venue Neighborhood"];
    [self.sharedData.mixPanelCEventDict setObject:self.mainData[@"venue"][@"city"] forKey:@"Event Venue City"];
    [self.sharedData.mixPanelCEventDict setObject:self.mainData[@"venue"][@"state"] forKey:@"Event Venue State"];
    [self.sharedData.mixPanelCEventDict setObject:self.mainData[@"venue"][@"description"] forKey:@"Event Venue Description"];
    [self.sharedData.mixPanelCEventDict setObject:self.mainData[@"venue"][@"zip"] forKey:@"Event Venue Zip"];
    
     [tmpDict setObject:tmpUserGuestDict[@"first_name"] forKey:@"Hosting Guest First Name"];
     [tmpDict setObject:tmpUserGuestDict[@"last_name"] forKey:@"Hosting Guest Last Name"];
     [tmpDict setObject:[NSString stringWithFormat:@"%@ %@",tmpUserGuestDict[@"first_name"],tmpUserGuestDict[@"last_name"]] forKey:@"Hosting Host Whole Name"];
     
     [tmpDict setObject:tmpUserGuestDict[@"email"] forKey:@"Hosting Guest Email"];
     [tmpDict setObject:tmpUserGuestDict[@"fb_id"] forKey:@"Hosting Guest FB ID"];
     [tmpDict setObject:tmpUserGuestDict[@"gender"] forKey:@"Hosting Guest Gender"];
     [tmpDict setObject:tmpUserGuestDict[@"birthday"] forKey:@"Hosting Guest Birthday"];
     
     */
    
    
    NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
    [tmpDict setObject:self.sharedData.userDict[@"first_name"] forKey:@"Inviter First Name"];
    [tmpDict setObject:self.sharedData.userDict[@"last_name"] forKey:@"Inviter Last Name"];
    [tmpDict setObject:[NSString stringWithFormat:@"%@ %@",self.sharedData.userDict[@"first_name"],self.sharedData.userDict[@"last_name"]] forKey:@"Inviter Whole Name"];
    [tmpDict setObject:self.sharedData.userDict[@"fb_id"] forKey:@"Inviter FB ID"];
    [tmpDict setObject:self.sharedData.userDict[@"email"] forKey:@"Inviter Email"];
    [tmpDict setObject:self.sharedData.userDict[@"gender"] forKey:@"Inviter Gender"];
    [tmpDict setObject:self.sharedData.userDict[@"birthday"] forKey:@"Inviter Birthday"];
    [tmpDict setObject:@"general" forKey:@"type"];
    
    //[self.sharedData trackMixPanelWithDict:@"INVITE_GENERAL" withDict:tmpDict];
    
    //[self.sharedData trackMixPanel:@"display_login"];
    
    NSString *url = [NSString stringWithFormat:@"%@/invitelink",PHBaseURL];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"INVITE_LINK_RESPONSE :: %@",responseObject);
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         [self shareText:responseObject[@"message"] andImage:[UIImage imageNamed:@"splashLogoWhite"] andUrl:[[NSURL alloc] initWithString:responseObject[@"url"]]];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR :: %@",error);
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         [self shareText:@"Get Jiggie from the App Store so we can skip the line and get free drinks at the club!" andImage:[UIImage imageNamed:@"splashLogoWhite"] andUrl:[[NSURL alloc] initWithString:[self getGeneralShareLink]]];
     }];
}


-(void)getHostingInviteLink
{
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSLog(@">>> venue_name = %@",self.sharedData.shareHostingVenueName);
    NSLog(@">>> host_name = %@",self.sharedData.shareHostingHostName);
    NSLog(@">>> host_date = %@",self.sharedData.shareHostingHostDate);
    NSLog(@">>> host_fb_id = %@",self.sharedData.shareHostingHostFbId);
    NSLog(@">>> event_id = %@",self.sharedData.shareHostingId);
    
    NSDictionary *params = @{ @"type" : @"event",
                              @"from_fb_id":self.sharedData.fb_id,
                              @"venue_name":self.sharedData.shareHostingVenueName,
                              //@"host_name":self.sharedData.shareHostingHostName,
                              //@"host_date":self.sharedData.shareHostingHostDate,
                              //@"host_fb_id":self.sharedData.shareHostingHostFbId,
                              @"event_id":self.sharedData.shareHostingId
                              };
    /*
    UIImage *hostingImg = [self.sharedData.imagesDict objectForKey:self.sharedData.cHostVenuePicURL];
    CGImageRef newCgIm = CGImageCreateCopy(hostingImg.CGImage);
    UIImage *newImage = [UIImage imageWithCGImage:newCgIm scale:hostingImg.scale orientation:hostingImg.imageOrientation];
    */
    
    
    /*
    NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
    [tmpDict setObject:self.sharedData.userDict[@"first_name"] forKey:@"Inviter First Name"];
    [tmpDict setObject:self.sharedData.userDict[@"last_name"] forKey:@"Inviter Last Name"];
    [tmpDict setObject:[NSString stringWithFormat:@"%@ %@",self.sharedData.userDict[@"first_name"],self.sharedData.userDict[@"last_name"]] forKey:@"Inviter Whole Name"];
    [tmpDict setObject:self.sharedData.userDict[@"fb_id"] forKey:@"Inviter FB ID"];
    [tmpDict setObject:self.sharedData.userDict[@"email"] forKey:@"Inviter Email"];
    [tmpDict setObject:self.sharedData.userDict[@"gender"] forKey:@"Inviter Gender"];
    [tmpDict setObject:self.sharedData.userDict[@"birthday"] forKey:@"Inviter Birthday"];
    [tmpDict setObject:@"event" forKey:@"type"];
    */
    
    
    
    //[self.sharedData trackMixPanelWithDict:@"INVITE_HOSTING" withDict:params];
    
    NSLog(@"INVITE_LINK_PARAMS :: %@",params);
    
    NSString *url = [NSString stringWithFormat:@"%@/invitelink",PHBaseURL];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"INVITE_LINK_RESPONSE :: %@",responseObject);
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         //[self shareText:responseObject[@"message"] andImage:newImage andUrl:[[NSURL alloc] initWithString:responseObject[@"url"]]];
         
         UIImage *shareImage = [UIImage imageNamed:@"splashLogoWhite"];
         if (self.sharedData.cHostVenuePicURL && self.sharedData.cHostVenuePicURL.length > 0) {
             NSString *picURL = self.sharedData.cHostVenuePicURL;
             picURL = [self.sharedData picURL:picURL];
             if([self.sharedData.imagesDict objectForKey:picURL] && [[self.sharedData.imagesDict objectForKey:picURL] isKindOfClass:[UIImage class]]) {
                 shareImage = [self.sharedData.imagesDict objectForKey:picURL];
             }
         }
         
         [self shareText:responseObject[@"message"] andImage:shareImage andUrl:[[NSURL alloc] initWithString:responseObject[@"url"]]];

         //
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR :: %@",error);
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         [self shareText:[self getHostingShareTitle] andImage:[UIImage imageNamed:@"splashLogoWhite"] andUrl:[[NSURL alloc] initWithString:[self getHostingShareLink]]];
     }];
}

-(void)showHostingInvite
{
    NSLog(@"STARTING_LINK_LOAD :: %@",self.sharedData.cHostVenuePicURL);
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    [self.sharedData loadImage:self.sharedData.cHostVenuePicURL onCompletion:^()
     {
         NSLog(@"START_2");
         [self getHostingInviteLink];
     }];
    
    [self getHostingInviteLink];
}


-(NSString *)getHostingShareTitle
{
    NSString *realDateStrg = [self.sharedData.cHostDict[@"hosting"][@"time"] substringToIndex:19];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    [formatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss'"];
    NSDate *date = [formatter dateFromString:realDateStrg];
    formatter.dateFormat = @"MM-dd-yyyy h:mma";
    NSString *dateStrg = [formatter stringFromDate:date];
    
    return [NSString stringWithFormat:@"Checkout %@'s hosting at %@ on %@. We should join it!",self.sharedData.member_first_name,self.sharedData.cVenueName,dateStrg];
}

-(NSString *)getHostingShareLink
{
    NSString *link = @"http://get.partyhostapp.com/id906484188?pid=Host_invite&af_dp=partyhost%3A%2F%2F&hosting";
    link = [NSString stringWithFormat:@"%@&af_sub1=%@&af_sub2=%@",link,self.sharedData.member_fb_id,self.sharedData.cHosting_id];
    return link;
}

-(NSString *)getGeneralShareLink
{
    NSString *link = @"http://get.partyhostapp.com/id906484188?pid=App_invite&af_dp=partyhost%3A%2F%2F&hosting";
    link = [NSString stringWithFormat:@"%@&af_sub1=%@",link,self.sharedData.fb_id];
    return link;
}

/*
 General Invite: <link>Hey download PartyHost from the App Store so we can skip the line and get free drinks at the club! </link>
 
 Hosting Invite: <link>Checkout [first name of host]'s hosting at [name of venue] on [day of hosting]. We should join it! <link>
 */

- (void)shareText:(NSString *)text andImage:(UIImage *)image andUrl:(NSURL *)url
{
    NSMutableArray *sharingItems = [[NSMutableArray alloc] init];
    
    
    
    if (text)
    {
        [sharingItems addObject:text];
    }
    if (image)
    {
        [sharingItems addObject:image];
    }
    
    if (url)
    {
        [sharingItems addObject:url];
        //text = [NSString stringWithFormat:@"%@ %@",text,url.absoluteString];
    }
    
    
    NSArray *activityItems = [[NSArray alloc] initWithArray:sharingItems];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [activityController setValue:@"Lets go out with Jiggie" forKey:@"subject"];
    [self.view.window.rootViewController presentViewController:activityController animated:YES completion:nil];
}

#pragma mark - Ticket Notification 
- (void)showTicketList:(NSNotification *)notification {
//    Event *cEvent = (Event *)[notification object];
//    TicketListViewController *ticketListVC = [[TicketListViewController alloc] init];
//    ticketListVC.cEvent = cEvent;
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:ticketListVC];
//    [self presentViewController:navigationController animated:YES completion:nil];
    
    TicketSuccessViewController *addPaymentVC = [[TicketSuccessViewController alloc] init];
    [addPaymentVC setShowViewButton:YES];
    [addPaymentVC setShowCloseButton:YES];
    [[addPaymentVC navigationController] setNavigationBarHidden:YES];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addPaymentVC];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
