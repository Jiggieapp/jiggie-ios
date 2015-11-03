//
//  Messages.m
//  PartyHost
//
//  Created by Sunny Clark on 1/11/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "Messages.h"

#define MESSAGE_PLACEHOLDER @"Type your message here ..."

@implementation Messages

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.canCheckScrollDown = NO;
    self.backgroundColor = [UIColor whiteColor];
    self.sharedData = [SharedData sharedInstance];
    self.mainDataA  = [[NSMutableDictionary alloc] init];
    
    self.sectionsA = [[NSMutableArray alloc] init];
    self.hostingsConfA  = [[NSMutableArray alloc] init];
    self.dataDict = [[NSMutableDictionary alloc] init];
    
    self.isInBlockMode = NO;
    self.isConfMode = NO;
    self.startedPolling = NO;
    
    self.tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 60)];
    self.tabBar.backgroundColor = [UIColor phPurpleColor];
    
    self.confirmArea = [[UIView alloc] initWithFrame:CGRectMake(0, self.tabBar.frame.origin.y + self.tabBar.frame.size.height, frame.size.width, 40)];
    self.confirmArea.backgroundColor = [UIColor grayColor];
    
    //Confirm button
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.confirmButton.frame = CGRectMake(self.sharedData.screenWidth-(frame.size.width/3)-8,0,frame.size.width/3,40);
    [self.confirmButton setTitle:@"" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmButton.titleLabel setFont:[UIFont phBold:16]];
    self.confirmButton.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.25];
    [self.confirmButton setTitleEdgeInsets:UIEdgeInsetsMake(4, 6, 4, 6)];
    self.confirmButton.layer.cornerRadius = 4;
    self.confirmButton.layer.masksToBounds = YES;
    [self.confirmButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmArea addSubview:self.confirmButton];
    
    //Confirm label
    self.confirmLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,0,frame.size.width-16,40)];
    self.confirmLabel.text = @"";
    self.confirmLabel.textColor = [UIColor whiteColor];
    self.confirmLabel.font = [UIFont phBlond:14];
    self.confirmLabel.textAlignment = NSTextAlignmentLeft;
    [self.confirmArea addSubview:self.confirmLabel];
    
    self.messagesA = [[NSMutableArray alloc] init];
    self.messagesListFrame = CGRectMake(0, 70, frame.size.width, frame.size.height - 40);
    self.messagesList = [[UITableView alloc] initWithFrame:self.messagesListFrame style:UITableViewStyleGrouped];
    self.messagesList.backgroundColor = [UIColor greenColor];
    self.messagesList.delegate = self;
    self.messagesList.dataSource = self;
    self.messagesList.allowsMultipleSelectionDuringEditing = NO;
    self.messagesList.backgroundColor = [UIColor clearColor];
    self.messagesList.separatorColor = [UIColor clearColor];
    
    [self addSubview:self.messagesList];
    
    
    self.toLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, frame.size.width, 40)];
    self.toLabel.textColor = [UIColor whiteColor];
    self.toLabel.backgroundColor = [UIColor clearColor];
    self.toLabel.font = [UIFont phBold:21];
    self.toLabel.textAlignment = NSTextAlignmentCenter;
    [self.tabBar addSubview:self.toLabel];
    
    self.btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnBack.frame = CGRectMake(0, 13, 50, 50);
    [self.btnBack setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [self.btnBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:self.btnBack];
    
    
    self.btnInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnInfo.frame = CGRectMake(frame.size.width - 50 + 4, 15, 50, 50);
    //self.btnInfo.backgroundColor = [UIColor redColor];
    [self.btnInfo setImage:[UIImage imageNamed:@"nav_dots"] forState:UIControlStateNormal];
    self.btnInfo.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.btnInfo addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:self.btnInfo];
    
    
    self.input = [[UITextView alloc] initWithFrame:CGRectMake(0, frame.size.height - 40, frame.size.width - 50, 40)];
    self.input.font = [UIFont phBlond:15];
    self.input.delegate = self;
    self.input.backgroundColor = [UIColor whiteColor];
    self.input.textColor = [UIColor blackColor];
    self.input.returnKeyType = UIReturnKeyDefault;
    self.input.textContainerInset = UIEdgeInsetsMake(12, 10, 10, 10);
    self.input.text = MESSAGE_PLACEHOLDER;
    self.input.textColor = [UIColor grayColor];
    [self addSubview:self.input];
    
    
    CALayer *rightBorder = [CALayer layer];
    rightBorder.borderColor = [UIColor phDarkGrayColor].CGColor;
    rightBorder.borderWidth = 1;
    rightBorder.frame = CGRectMake(-1,0,self.sharedData.screenWidth+2,1);
    [self.input.layer addSublayer:rightBorder];
    
    
    self.inputNumLines = 1;
    
    [self.sharedData.keyboardsA addObject:self.input];
    
    self.btnSend = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width - 60, frame.size.height - 40, 60, 40)];
    self.btnSend.backgroundColor = [UIColor phBlueColor];
    self.btnSend.layer.masksToBounds = YES;
    [self addSubview:self.btnSend];
    
    self.sendTxt = [[UILabel alloc] initWithFrame:self.btnSend.bounds];
    self.sendTxt.font = [UIFont phBold:16];
    self.sendTxt.textColor = [UIColor whiteColor];
    self.sendTxt.textAlignment = NSTextAlignmentCenter;
    self.sendTxt.text = @"SEND";
    self.sendTxt.backgroundColor = [UIColor clearColor];
    self.sendTxt.userInteractionEnabled = NO;
    [self.btnSend addSubview:self.sendTxt];
    
    
    
    CALayer *topBorder = [CALayer layer];
    topBorder.borderColor = [UIColor phDarkGrayColor].CGColor;
    topBorder.borderWidth = 1;
    topBorder.frame = CGRectMake(-1,0,self.btnSend.frame.size.width+2,1);
    [self.btnSend.layer addSublayer:topBorder];
    
    
    self.btnSendDimView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 380)];
    self.btnSendDimView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.25];
    self.btnSendDimView.hidden = YES;
    [self.btnSend addSubview:self.btnSendDimView];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnSendTapHandler:)];
    longPress.minimumPressDuration = 0.01;
    [self.btnSend addGestureRecognizer:longPress];
    
    //UIImageView *btnSendIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 20, 20)];
    //btnSendIcon.image = [UIImage imageNamed:@"btn_send"];
    //[self.btnSend addSubview:btnSendIcon];
    
    //self.isKeyBoardShowing = NO;
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 65, frame.size.width, frame.size.height - 65)];
    self.loadingView.backgroundColor = self.backgroundColor;
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //[spinner setColor:[UIColor whiteColor]];
    [spinner startAnimating];
    spinner.center = CGPointMake(self.loadingView.center.x, 100);
    [self.loadingView addSubview:spinner];
    
    [self addSubview:self.loadingView];
    //[self addSubview:self.confirmArea];
    [self addSubview:self.tabBar];

    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(loadMessages)
     name:@"UPDATE_CURRENT_CONVERSATION"
     object:nil];
    
    /*
     auto save convos based upon person...
     add copy text feature...
     unread message convo count on convo page
     */
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(goBack)
     name:@"MESSAGES_GO_BACK"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(reLoadApp)
     name:@"RELOAD_CURRENT_CONVERSATION"
     object:nil];
    
    //Resign first responder when tapped away
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAwayFromKeyboard)];
    [self addGestureRecognizer:tap];
    
    
    [self keyboardOn];
    
    return self;
}

-(void)initClass
{
    self.canPoll = YES;
    self.sharedData.memberProfile.hidden = YES;
    self.sharedData.isInConversation = YES;
    self.isMessagesLoaded = NO;
    self.keyBoardHeight = 0;
    
    //Restart placeholder
    self.input.text = MESSAGE_PLACEHOLDER;
    self.input.textColor = [UIColor grayColor];
    
    
    [self adjustFrames];
    [self loadMessages];
}

-(void)loadMessages
{
    //self.isMessagesLoaded = NO;
    //[self.sharedData trackMixPanel:@"display_conversations_details"];
    
    //NSString *facebookId = [self.sharedData.userDict objectForKey:@"fb_id"];
    
    //facebookId = @"1376680319326091";
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    
    
    
    
    //NSLog(@"GET_MESSAGES :: %@",params);
    //NSString *urlToLoad = [NSString stringWithFormat:@"%@/%@/conversation/%@/%@",PHBaseURL,self.sharedData.account_type,self.sharedData.fb_id,self.toId];
    NSString *urlToLoad = [NSString stringWithFormat:@"%@/chat/conversation/%@/%@",PHBaseURL,self.sharedData.fb_id,self.toId];
    //chat/conversation/
    
    NSLog(@"MESSAGES_URL :: %@",urlToLoad);
    [manager GET:urlToLoad parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"MESSAGES :: %@",responseObject);
         
         if(responseObject[@"success"])
         {
             if(![responseObject[@"success"] boolValue])
             {
                 return;
             }
         }
         
         [self.dataDict removeAllObjects];
         [self.dataDict addEntriesFromDictionary:responseObject];
         
         
         self.confirmMode = 0;
         /*
         if(![responseObject[@"has_hostings"] boolValue])
         {
             self.confirmMode = 0;
         }else{
             if(![responseObject[@"has_confirmation"] boolValue])
             {
                 self.confirmMode = 1;
             }else{
                 if(![responseObject[@"both_confirmed"] boolValue])
                 {
                     if(([responseObject[@"is_host_confirmed"] boolValue] && [responseObject[@"is_from_host"] boolValue]) || ([responseObject[@"is_guest_confirmed"] boolValue] && [responseObject[@"is_from_guest"] boolValue]))
                     {
                         self.confirmMode = 2;
                     }else{
                         self.confirmMode = 3;
                     }
                 }else{
                     self.confirmMode = 6;
                 }
             }
         }
         
         if(self.confirmMode==0)
         {
             [self setConfirmArea:[UIColor lightGrayColor] title:@"" description:@"No one has a hosting coming up"];
         }
         else if(self.confirmMode==1)
         {
             [self setConfirmArea:[UIColor grayColor] title:@"Confirm" description:@"No one has confirmed the hosting"];
         }
         else if(self.confirmMode==2)
         {
            [self setConfirmArea:[UIColor orangeColor] title:@"Cancel" description:@"Waiting for member to confirm"];
         }
         else if(self.confirmMode==3)
         {
             [self setConfirmArea:[UIColor orangeColor] title:@"Confirm" description:@"Member has confirmed you"];
         }
         else if(self.confirmMode==4)
         {
             [self setConfirmArea:[UIColor redColor] title:@"Confirm" description:@"Member has cancelled the hosting"];
         }
         else if(self.confirmMode==5)
         {
             [self setConfirmArea:[UIColor redColor] title:@"Re-Confirm" description:@"You have cancelled this hosting"];
         }
         else if(self.confirmMode==6)
         {
             [self setConfirmArea:[UIColor colorFromHexCode:@"409040"] title:@"Cancel" description:@"You have both confirmed"];
         }
         else if(self.confirmMode==7)
         {
             [self setConfirmArea:[UIColor grayColor] title:@"Confirm" description:@"Tap to confirm this hosting"];
         }
         */
         
         if(self.isMessagesLoaded && [responseObject[@"messages"] isEqualToArray:self.messagesA])
         {
             NSLog(@"SAME_MESSAGES");
             [self pollMessages];
             return;
         }
         
         self.isMessagesLoaded = YES;
         
         [self.messagesA removeAllObjects];
         [self.messagesA addObjectsFromArray:responseObject[@"messages"]];
         
         [self sanitizeData];
         
         [self.messagesList reloadData];
         
         [self scrollToBottom:NO];
         
         /*
          int numSections = (int)self.messagesList.numberOfSections;
          if(numSections > 0)
          {
          int row_count = (int)[self.messagesList numberOfRowsInSection:numSections - 1];
          [self.messagesList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row_count - 1  inSection:numSections - 1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
          }
          */
         
         //Modify button
         
         [UIView animateWithDuration:0.15 animations:^(void)
          {
              self.loadingView.alpha = 0;
          } completion:^(BOOL finished)
          {
              self.loadingView.hidden = YES;
          }];
         
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"UPDATE_CONVERSATION_LIST"
          object:self];
         
         [self pollMessages];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"MESSAGE_ERROR :: %@",error);
     }];
}

-(void)pollMessages
{
    NSLog(@"POLLING_MESSAGES");
    //[self.sharedData.APN_PERMISSION_STATE isEqualToString:@"DISABLED"]
    if(self.canPoll)
    {
        [self performSelector:@selector(loadMessages) withObject:nil afterDelay:4.0];
    }
}


-(void)reset
{
    self.sendTxt.textColor = [UIColor whiteColor];
    self.canCheckScrollDown = NO;
    self.loadingView.alpha = 1.0;
    self.loadingView.hidden = NO;
    self.isMessagesLoaded = NO;
    self.input.frame = CGRectMake(0, self.frame.size.height - 40, self.frame.size.width - 50, 40);
    self.btnSend.frame = CGRectMake(self.frame.size.width - 50, self.frame.size.height - 40, 50, 40);
    self.messagesList.frame = self.messagesListFrame;
    self.inputNumLines = 1;
    
    //Clean button area while loading
    [self setConfirmArea:[UIColor grayColor] title:@"" description:@""];
}


-(void)confirmButtonClicked
{
    //NSLog(@"CONFIRM_CLICKED");
    
    
    switch (self.confirmMode)
    {
        case 0:
            NSLog (@"zero");
            break;
        case 1:
            NSLog (@"one");
            [self optionOneTapped];
            break;
        case 2:
            NSLog (@"two");
            [self optionTwoTapped];
            break;
        case 3:
            NSLog (@"three");
            [self optionThreeTapped];
            break;
        case 4:
            NSLog (@"four");
            break;
        case 5:
            NSLog (@"five");
            break;
        case 6:
            NSLog (@"five");
            [self optionsCancelledTapped];
            break;
    }
    
    
}

-(void)sendAction:(int)index
{
    NSMutableArray *allHostings = [[NSMutableArray alloc] init];
    [allHostings addObjectsFromArray:self.dataDict[@"from_hostings"]];
    [allHostings addObjectsFromArray:self.dataDict[@"to_hostings"]];
    
    //Get the selected hosting
    NSMutableDictionary *selectedHosting = allHostings[index];
    
    //Get the action to make if we selected that hosting
    BOOL isHost = YES;
    NSString *url;
    if(index < [self.dataDict[@"from_hostings"] count])
    {
        url = [NSString stringWithFormat:@"%@/user/hostings/hostconfirmed/%@/%@",PHBaseURL,self.toId,selectedHosting[@"_id"]];
    }else{
        isHost = NO;
        url = [NSString stringWithFormat:@"%@/user/hostings/guestconfirmed/%@/%@",PHBaseURL,self.sharedData.fb_id,selectedHosting[@"_id"]];
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSDictionary *params =
    @{
      @"from_name":self.sharedData.userDict[@"first_name"],
      @"from_id":self.sharedData.fb_id,
      @"to_id":self.toId
      };
    
    NSLog(@"ADD_CONFIRMATION_URL :: %@",url);
    NSLog(@"ADD_CONFIRMATION_PARAMS :: %@",params);
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"ADD_CONFIRMATION_RESPONSE :: %@",operation.responseString);
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         if(isHost)
         {
             [self.sharedData trackMixPanelWithDict:@"Add Host Confirmation" withDict:@{}];
         }else{
             [self.sharedData trackMixPanelWithDict:@"Add Guest Confirmation" withDict:@{}];
         }
         
         [self.sharedData trackMixPanelIncrementWithDict:@{@"confirm_hosting":@1}];
         
         [self alertConfirm];
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"RELOAD_CURRENT_CONVERSATION"
          object:self];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR_ADDING_CONFIRMATION :: %@",operation.response);
         NSLog(@"error: %@",  operation.responseString);
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an issue posting to server, please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"RELOAD_CURRENT_CONVERSATION"
          object:self];
     }];
}

-(void)optionOneTapped
{
    int totalHostings = (int)[self.dataDict[@"from_hostings"] count] + (int)[self.dataDict[@"to_hostings"] count];
    
    //Only 1 option just pick it now
    if(totalHostings==1) {
        [self sendAction:0];
        return;
    }
    
    //Present list of hostings to select
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Select Hosting"
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    NSMutableArray *tmpA = [[NSMutableArray alloc] init];
    [tmpA addObjectsFromArray:self.dataDict[@"from_hostings"]];
    [tmpA addObjectsFromArray:self.dataDict[@"to_hostings"]];
    
    if (self.sharedData.osVersion >= 8)
    {
        NSMutableArray *tmpActionA =[[NSMutableArray alloc] init];
        
        for (int i = 0; i < [tmpA count]; i++)
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict addEntriesFromDictionary:[tmpA objectAtIndex:i]];
            NSLog(@"DICT :: %@",dict);
            
            UIAlertAction *eventAction =
            [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@ on %@",dict[@"event"][@"title"], [dict[@"event"][@"start_datetime_str"] componentsSeparatedByString:@","][0]]
                                     style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
             {
                 NSLog(@"ACTION :: %@",action);
                 for (int i = 0; i < [tmpActionA count]; i++)
                 {
                     if([tmpActionA objectAtIndex:i] == action)
                     {
                         [self sendAction:i];
                     }
                 }
             }];
            [tmpActionA addObject:eventAction];
            [alertController addAction:eventAction];
        }
        
        [alertController addAction:cancelAction];
        
        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        
    }else{
        // iOS 7.0
        [self.hostingsConfA removeAllObjects];
        [self.hostingsConfA addObjectsFromArray:tmpA];
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Hosting" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        for (int i = 0; i < [tmpA count]; i++)
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict addEntriesFromDictionary:[tmpA objectAtIndex:i]];
            [actionSheet addButtonWithTitle:[NSString stringWithFormat:@"%@ on %@",dict[@"event"][@"title"], [dict[@"event"][@"start_datetime_str"] componentsSeparatedByString:@","][0]]];
        }
        actionSheet.delegate = self;
        [actionSheet addButtonWithTitle:@"Cancel"];
        self.isConfMode = YES;
        [actionSheet showInView:self];
    }
    
}


-(void)optionTwoTapped
{
    //confirmMode
    
    NSString *urlToLoad = @"";
    
    if([self.dataDict[@"is_from_host"] boolValue])
    {
        urlToLoad = [NSString stringWithFormat:@"%@/user/hostings/unhostconfirmed/%@/%@",PHBaseURL,self.toId,self.dataDict[@"cHosting"][@"_id"]];
    }else{
        urlToLoad = [NSString stringWithFormat:@"%@/user/hostings/unguestconfirmed/%@/%@",PHBaseURL,self.sharedData.fb_id,self.dataDict[@"cHosting"][@"_id"]];
    }
    
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSDictionary *params =
    @{
      @"from_name":self.sharedData.userDict[@"first_name"],
      @"from_id":self.sharedData.fb_id,
      @"to_id":self.toId
      };
    
    [manager POST:urlToLoad parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"ADD_CONFIRMATION_RESPONSE :: %@",responseObject);
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         [self.sharedData trackMixPanelWithDict:@"Unconfirm Hosting" withDict:@{@"origin":@"Chat"}];
         [self.sharedData trackMixPanelIncrementWithDict:@{@"unconfirm_hosting":@1}];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cancelled" message:@"You have cancelled this hosting." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
         
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"RELOAD_CURRENT_CONVERSATION"
          object:self];
         
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR_ADDING_CONFIRMATION :: %@",operation.response);
         NSLog(@"error: %@",  operation.responseString);
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an issue posting to server, please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"RELOAD_CURRENT_CONVERSATION"
          object:self];
     }];
    
}


-(void)optionThreeTapped
{
    //confirmMode
    
    NSString *urlToLoad = @"";
    
    NSString *origin;
    
    if([self.dataDict[@"is_from_host"] boolValue])
    {
        urlToLoad = [NSString stringWithFormat:@"%@/user/hostings/hostconfirmed/%@/%@",PHBaseURL,self.toId,self.dataDict[@"cHosting"][@"_id"]];
        origin = @"Add Host Confirmation";
    }else{
        urlToLoad = [NSString stringWithFormat:@"%@/user/hostings/guestconfirmed/%@/%@",PHBaseURL,self.sharedData.fb_id,self.dataDict[@"cHosting"][@"_id"]];
        origin = @"Add Guest Confirmation";
    }
    
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSDictionary *params =
    @{
      @"from_name":self.sharedData.userDict[@"first_name"],
      @"from_id":self.sharedData.fb_id,
      @"to_id":self.toId
      };
    
    [manager POST:urlToLoad parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"ADD_CONFIRMATION_RESPONSE :: %@",operation.responseString);
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         [self.sharedData trackMixPanelIncrementWithDict:@{@"confirm_hosting":@1}];
         [self.sharedData trackMixPanelWithDict:origin withDict:@{}];
         
         [self alertConfirm];
         
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"RELOAD_CURRENT_CONVERSATION"
          object:self];
         
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR_ADDING_CONFIRMATION :: %@",operation.response);
         NSLog(@"error: %@",  operation.responseString);
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an issue posting to server, please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"RELOAD_CURRENT_CONVERSATION"
          object:self];
     }];
    
}


-(void)optionsCancelledTapped
{
    //user/hostings/cancelled/
    
    
    NSString *urlToLoad = @"";
    NSString *origin;
    
    if([self.dataDict[@"is_from_host"] boolValue])
    {
        urlToLoad = [NSString stringWithFormat:@"%@/user/hostings/cancelled/%@/%@",PHBaseURL,self.toId,self.dataDict[@"cHosting"][@"_id"]];
        origin = @"Cancel Host Confirmation";
    }else{
        urlToLoad = [NSString stringWithFormat:@"%@/user/hostings/cancelled/%@/%@",PHBaseURL,self.sharedData.fb_id,self.dataDict[@"cHosting"][@"_id"]];
         origin = @"Cancel Guest Confirmation";
    }
    
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSDictionary *params =
    @{
      @"from_name":self.sharedData.userDict[@"first_name"],
      @"from_id":self.sharedData.fb_id,
      @"to_id":self.toId
      };
    
    [manager POST:urlToLoad parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"ADD_CONFIRMATION_RESPONSE :: %@",responseObject);
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         [self.sharedData trackMixPanelIncrementWithDict:@{@"cancelled_hosting":@1}];
         
         [self.sharedData trackMixPanelWithDict:origin withDict:@{}];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cancelled" message:@"You have cancelled this hosting." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
         
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"RELOAD_CURRENT_CONVERSATION"
          object:self];
         
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR_ADDING_CONFIRMATION :: %@",operation.response);
         NSLog(@"error: %@",  operation.responseString);
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an issue posting to server, please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"RELOAD_CURRENT_CONVERSATION"
          object:self];
     }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

-(void)onPanHandler:(UIPanGestureRecognizer *)sender
{
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self];
    
    NSLog(@"POINT :: %f",translatedPoint.y);
}

-(void)btnSendTapHandler:(UILongPressGestureRecognizer *)sender
{
    if([self.input.text isEqualToString:@""] || [self.input.text isEqual:MESSAGE_PLACEHOLDER])
    {
        return;
    }
    
    
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        self.btnSendDimView.hidden = NO;
    }
    
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        self.btnSendDimView.hidden = YES;
        [self addMessage:[self.sharedData clipSpace:self.input.text]];
        
        dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.1);
        dispatch_after(delay, dispatch_get_main_queue(), ^(void)
                       {
                           //[self.sharedData trackMixPanel:@"chat_updated"];
                       });
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    //NSLog(@"COMPARE :: %f :: %f",scrollView.contentOffset.y,self.contentOffSetYToCompare);
    
    if(self.canCheckScrollDown && scrollView == self.messagesList)
    {
        CGPoint location = [scrollView.panGestureRecognizer locationInView:self.window.rootViewController.view];
        
        if(location.y > self.tabBar.frame.size.height + self.messagesList.frame.size.height + 90 - (self.inputNumLines * 20))
        {
            NSLog(@"POINT ::  %@",NSStringFromCGPoint(location));
            [self dismissKeyBoardDown];
        }
    }
}


-(void)dismissKeyBoardDown
{
    NSLog(@"DISMISS_KEYBOARD");
    self.canCheckScrollDown = NO;
    [self.messagesList setContentOffset:self.messagesList.contentOffset animated:NO];
    [self.input resignFirstResponder];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    CGRect tableFrame = self.messagesList.frame;
    tableFrame.size.height = screenHeight - 105;
    [UIView animateWithDuration:0.25 animations:^(void)
     {
         self.messagesList.frame = tableFrame;
         self.input.frame = CGRectMake(0, self.frame.size.height - self.input.frame.size.height, self.frame.size.width - 60, self.input.frame.size.height);
         self.btnSend.frame = CGRectMake(self.frame.size.width - 60, self.frame.size.height - self.btnSend.frame.size.height, 60, self.btnSend.frame.size.height);
     }];
}

-(void)keyboardPostUpdateDismiss
{
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.input.frame = CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 50);
         self.messagesList.frame = CGRectMake(0, 65, self.frame.size.width, self.frame.size.height - 65 - 40);
     } completion:^(BOOL finished)
     {
         //NSUInteger sectionCount = [self.sectionsA count] - 1;
         //NSString *lastKey = [self.sectionsA objectAtIndex:sectionCount];
         //NSUInteger rowCount    = [[self.mainDataA objectForKey:lastKey] count] - 1;
         
         [self scrollToBottom:YES];
         /*
          int numSections = (self.messagesList.numberOfSections < 1)?1:(int)self.messagesList.numberOfSections;
          int row_count = (int)[self.messagesList numberOfRowsInSection:numSections - 1];
          [self.messagesList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row_count - 1  inSection:numSections - 1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
          */
         
     }];
}

-(void)goBack
{
    self.startedPolling = NO;
    self.canPoll = NO;
    self.sharedData.isInConversation = NO;
    
    [self keyboardOff];
    [self endEditing:YES];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EXIT_MESSAGES"
     object:self];
}


-(void)showInfo
{
    [self dismissKeyBoardDown];
    NSString *toName = [self.dataDict[@"fromName"] capitalizedString];
    if (self.sharedData.osVersion >= 8)
    {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:NULL
                                              message:NULL
                                              preferredStyle:UIAlertControllerStyleActionSheet];
        
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Cancel action");
                                       }];
        
        UIAlertAction *blockAction = [UIAlertAction
                                      actionWithTitle:[NSString stringWithFormat:@"Block %@?",toName]
                                      style:UIAlertActionStyleDestructive
                                      handler:^(UIAlertAction *action)
                                      {
                                          //[self blockUser];
                                          
                                          //self.isInBlockMode = YES;
                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Block" message:@"Are you sure you want to block this user?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                          [alert addButtonWithTitle:@"Cancel"];
                                          [alert show];
                                      }];
        
        
        
        UIAlertAction *profileAction = [UIAlertAction
                                        actionWithTitle:[NSString stringWithFormat:@"%@'s Profile",toName]
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction *action)
                                        {
                                            self.sharedData.member_fb_id = self.toId;
                                            self.sharedData.member_first_name = self.toLabel.text;
                                            [self performSelector:@selector(showMemberProfile) withObject:nil afterDelay:0.1];
                                            
                                        }];
        
        
        
        [alertController addAction:profileAction];
        [alertController addAction:blockAction];
        [alertController addAction:cancelAction];
        
        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    }else
    {
        self.isInBlockMode = YES;
        NSString *profileName = [NSString stringWithFormat:@"%@'s Profile",toName];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:profileName,[NSString stringWithFormat:@"Block %@?",toName],nil];
        
        [actionSheet showInView:self];
    }
}


-(void)showMemberProfile
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_MEMBER_PROFILE"
     object:self];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(self.isInBlockMode)
    {
        if(buttonIndex == 0)
        {
            
            self.sharedData.member_fb_id = self.toId;
            self.sharedData.member_first_name = self.toLabel.text;
            [self performSelector:@selector(showMemberProfile) withObject:nil afterDelay:0.1];
        }
        
        if(buttonIndex == 1)
        {
            //self.isInBlockMode = YES;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Block" message:@"Are you sure you want to block this user?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert addButtonWithTitle:@"Cancel"];
            [alert show];
        }
    }
    
    if(self.isConfMode)
    {
        NSLog(@"BUTTON_INDEX :: %d",(int)buttonIndex);
        
        NSString *urlToLoad = @"";
        NSMutableDictionary *dictInfo = [[NSMutableDictionary alloc] init];
        [dictInfo addEntriesFromDictionary:[self.hostingsConfA objectAtIndex:buttonIndex]];
        NSString *origin;
        
        if(buttonIndex < [self.dataDict[@"from_hostings"] count])
        {
            urlToLoad = [NSString stringWithFormat:@"%@/user/hostings/hostconfirmed/%@/%@",PHBaseURL,self.toId,dictInfo[@"_id"]];
            origin = @"Host Confirmed";
        }else{
            urlToLoad = [NSString stringWithFormat:@"%@/user/hostings/guestconfirmed/%@/%@",PHBaseURL,self.sharedData.fb_id,dictInfo[@"_id"]];
            origin = @"Guest Confirmed";
        }
        
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"SHOW_LOADING"
         object:self];
        
        AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
        
        
        NSDictionary *params =
        @{
          @"from_name":self.sharedData.userDict[@"first_name"],
          @"from_id":self.sharedData.fb_id,
          @"to_id":self.toId
          };
        
        [manager POST:urlToLoad parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"ADD_CONFIRMATION_RESPONSE :: %@",operation.responseString);
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"HIDE_LOADING"
              object:self];
             
             [self.sharedData trackMixPanelIncrementWithDict:@{@"confirm_hosting":@1}];
             [self.sharedData trackMixPanelWithDict:origin withDict:@{}];
             
             [self alertConfirm];
             
             
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"RELOAD_CURRENT_CONVERSATION"
              object:self];
             
             
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"ERROR_ADDING_CONFIRMATION :: %@",operation.response);
             NSLog(@"error: %@",  operation.responseString);
             
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"HIDE_LOADING"
              object:self];
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an issue posting to server, please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
             
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"RELOAD_CURRENT_CONVERSATION"
              object:self];
         }];
        
        
        
    }
    
    
    self.isConfMode = NO;
    self.isInBlockMode = NO;
}


-(void)goProfile
{
    
}

-(void)reLoadApp
{
    [self.sharedData clearKeyBoards];
    [self reset];
    [self initClass];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionsA count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *cKey = [self.sectionsA objectAtIndex:section];
    
    return (self.isMessagesLoaded == NO)?1:[[self.mainDataA objectForKey:cKey] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *secCon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 15)];
    secCon.backgroundColor = [UIColor whiteColor];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.frame.size.width, 10)];
    title.font = [UIFont phBlond:9];
    title.textColor = [UIColor phDarkGrayColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = [self.sectionsA objectAtIndex:section];
    [secCon addSubview:title];
    
    return secCon;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //MessageCell *cell = (MessageCell *)[tableView cellForRowAtIndexPath:indexPath];
    if(!self.isMessagesLoaded)
    {
        return 70.0;
    }
    
    NSString *cKey = [self.sectionsA objectAtIndex:indexPath.section];
    NSMutableDictionary *dict = [[self.mainDataA objectForKey:cKey] objectAtIndex:indexPath.row];
    //BOOL isMe = [[dict objectForKey:@"isFromYou"] boolValue];
    
    //Add header to message
    NSString *text = [dict objectForKey:@"message"];
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(![[dict objectForKey:@"header"] isEqualToString:@""])
    {
        text = [NSString stringWithFormat:@"%@\n%@",[dict objectForKey:@"header"],text];
    }
    
    UITextView *calculationView = [[UITextView alloc] initWithFrame:CGRectMake(70, 0, self.frame.size.width - 20 - 70, 30)];
    calculationView.font = [UIFont phBlond:self.sharedData.messageFontSize];
    [calculationView setText:text];
    //CGFloat wrappingWidth = calculationView.bounds.size.width - (calculationView.textContainerInset.left + calculationView.textContainerInset.right + 2 * calculationView.textContainer.lineFragmentPadding);
    
    [calculationView sizeToFit];
    
    CGRect boundingRect = calculationView.frame;//[text boundingRectWithSize:CGSizeMake(wrappingWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: calculationView.font }                                              context:nil];
    
    int newHeight = (boundingRect.size.height + 44 < 70)?70:boundingRect.size.height + 44;
    
    
    
    return newHeight;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MessageCell";
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(self.isMessagesLoaded)
    {
        [cell showLoading:NO];
        NSString *cKey = [self.sectionsA objectAtIndex:indexPath.section];
        NSMutableDictionary *dict = [[self.mainDataA objectForKey:cKey] objectAtIndex:indexPath.row];
        cell.isMe = [[dict objectForKey:@"isFromYou"] boolValue];
        cell.textLabel.text = @"";//[dict objectForKey:@"message"];
        [cell loadData:dict];
    }else{
        [cell showLoading:YES];
        cell.textLabel.text = @"Loading";
    }
    
    
    return cell;
}


-(void)scrollToBottom:(BOOL )animated
{
    
    
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.15);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        // do work in the UI thread here
        int num = (int)self.messagesList.numberOfSections;
        num = (num < 1)?1:num;
        NSUInteger row_count = [self.messagesList numberOfRowsInSection:num - 1];
        row_count = (row_count < 1)?1:row_count;
        
        if([self.messagesA count] < 1)
        {
            return;
        }
        
        @try {
            //[self.tableView scrollToRowAtIndexPath: // etc etc etc
            [self.messagesList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row_count - 1  inSection:num - 1] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
        }
        @catch ( NSException *e )
        {
            NSLog(@"bummer: %@",e);
        }
    });
}

-(void) adjustFrames
{
    float rows = (self.input.contentSize.height - self.input.textContainerInset.top - self.input.textContainerInset.bottom) / self.input.font.lineHeight;
    NSLog(@"text_rows :: %f",rows);
    self.inputNumLines = (int)floor(rows);
    self.inputNumLines = (self.inputNumLines > 10)?10:self.inputNumLines;
    CGRect textFrame = CGRectMake(0, self.frame.size.height - 40 - self.keyBoardHeight, self.frame.size.width - 60, 40);
    textFrame.size.height += 20 * (self.inputNumLines - 1);
    textFrame.origin.y -= 20 * (self.inputNumLines - 1);
    self.input.frame = textFrame;
    
    CGRect btnFrame = CGRectMake(self.frame.size.width - 60, self.frame.size.height - 40 - self.keyBoardHeight, 60, 40);
    btnFrame.size.height += 20 * (self.inputNumLines - 1);
    btnFrame.origin.y -= 20 * (self.inputNumLines - 1);
    self.btnSend.frame = btnFrame;
    
    self.sendTxt.frame = CGRectMake(0,self.btnSend.bounds.size.height - 25,self.btnSend.bounds.size.width,20);
    
    int length = (self.input.text.length < 1)?1:(int)self.input.text.length;
    NSRange range = NSMakeRange(length - 1, 1);
    [self.input scrollRangeToVisible:range];
}

-(void)sanitizeData
{
    [self.mainDataA removeAllObjects];
    [self.sectionsA removeAllObjects];
    for (int i = 0; i < [self.messagesA count]; i++)
    {
        NSDictionary *dict = [self.messagesA objectAtIndex:i];
        NSString *dateTime = [[dict objectForKey:@"created_at"] substringToIndex:19];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [dateFormat setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss'"];
        [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
        NSDate *dte = [dateFormat dateFromString:dateTime];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"EEEE MMMM d"];
        NSString *day = [formatter stringFromDate:dte];
        
        if(![self.mainDataA objectForKey:day])
        {
            NSMutableArray *tmpA = [[NSMutableArray alloc] init];
            [self.mainDataA setObject:tmpA forKey:day];
            [self.sectionsA addObject:day];
        }
        
        [[self.mainDataA objectForKey:day] addObject:dict];
    }
    
    NSLog(@"SANITIZED_DATA_BEGIN");
    NSLog(@"%@",self.mainDataA);
    NSLog(@"SANITIZED_DATA_END");
}


-(void)addMessage:(NSString *)message
{
    
    if(self.isKeyBoardShowing)
    {
        self.input.frame = CGRectMake(0, self.frame.size.height - 40 - self.keyBoardHeight, self.frame.size.width - 50, 40);
        self.btnSend.frame = CGRectMake(self.frame.size.width - 50, self.frame.size.height - 40 - self.keyBoardHeight, 50, 40);
    }
    else
    {
        self.btnSend.frame = CGRectMake(self.frame.size.width - 50, self.frame.size.height - 40, 50, 40);
        self.input.frame = CGRectMake(0, self.frame.size.height - 40, self.frame.size.width - 50, 40);
    }
    
    
    self.sendTxt.frame = CGRectMake(0,self.btnSend.bounds.size.height - 25,self.btnSend.bounds.size.width,20);
    self.input.text = @"";
    
    self.inputNumLines = 1;
    self.canCheckScrollDown = NO;
    [self scrollToBottom:YES];
    
    [self sendMessageToServer:message];
    
    self.sendTxt.textColor = [UIColor whiteColor];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:message forKey:@"message"];
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormat setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss'"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSString *created_at = [dateFormat stringFromDate:now];
    [dict setObject:created_at forKey:@"created_at"];
    [dict setObject:@"" forKey:@"header"];
    [dict setObject:@"1" forKey:@"isFromYou"];
    
    NSLog(@"MESSAGE_DICT :: %@",dict);
    
    [self.messagesA addObject:dict];
    [self sanitizeData];
    [self.messagesList reloadData];
    
    
    [self performSelector:@selector(updateKeyBoard) withObject:nil afterDelay:1.0];
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.1);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void)
                   {
                       // do work in the UI thread here
                       /*
                        int numSections = (self.messagesList.numberOfSections < 1)?1:(int)self.messagesList.numberOfSections;
                        int row_count = (int)[self.messagesList numberOfRowsInSection:numSections - 1];
                        [self.messagesList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row_count - 1  inSection:numSections - 1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                        */
                       [self scrollToBottom:YES];
                   });
    
}


-(void)addMessageFromAPN:(NSString *)message
{
    
}

-(BOOL)isSameDate:(NSDate *)compareDate
{
    BOOL isSame = NO;
    
    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:compareDate];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    if([today day] == [otherDay day] &&
       [today month] == [otherDay month] &&
       [today year] == [otherDay year] &&
       [today era] == [otherDay era]) {
        //do stuff
        isSame = YES;
    }
    
    return isSame;
}


-(void)sendMessageToServer:(NSString *)message
{
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSDictionary *params =@{
                            @"fromId" : self.sharedData.fb_id,
                            @"toId":self.toId,
                            @"message":message,
                            @"header":@"",
                            @"fromName":[self.sharedData.userDict[@"first_name"] lowercaseString],
                            @"key":self.sharedData.appKey,
                            @"hosting_id":@""};
    
    NSString *url = [NSString stringWithFormat:@"%@/messages/add",PHBaseURL];
    
    NSLog(@"MESSAGE_PARAMS");
    
    NSLog(@"%@",params);
    
    NSLog(@"MESSAGE_PARAMS");
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"DONE!! :: %@",responseObject);
         
         [self.sharedData trackMixPanelIncrementWithDict:@{@"send_message":@1}];
         
         //[self.sharedData trackMixPanel:responseObject[@"chat_state"]];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"SEND_MESSAGE_ERROR :: %@",error);
     }];
}


-(void)blockUser
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    
    NSDictionary *params =@{
                            @"fromId" : self.sharedData.fb_id,
                            @"toId":self.sharedData.member_fb_id,
                            };
    NSLog(@"PARAMS :: %@",params);
    
    NSString *urlToLoad = [NSString stringWithFormat:@"%@/blockuserwithfbid",PHBaseURL];
    [manager GET:urlToLoad parameters:params success:^
     (AFHTTPRequestOperation *operation, id resultObj)
     {
         NSLog(@"RESULT :: %@",resultObj);
         
         [self goBack];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //[self showFail];
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Block" message:@"There was an error blocking this user, try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert addButtonWithTitle:nil];
         [alert show];
         
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
     }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"BUTTON_INDEX :: %d",(int)buttonIndex);
    if(buttonIndex == 0)
    {
        [self blockUser];
    }
}

-(void)alertConfirm
{
    NSString *msg;
    
    if([self.sharedData.account_type isEqualToString:@"guest"])
    {
        msg = @"You have confirmed the host for this invitation.";
    } else {
        msg = @"You have confirmed the guest for this hosting.";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmed" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

//Set everything about the confirm area
-(void)setConfirmArea:(UIColor*)backgroundColor title:(NSString*)title description:(NSString*)description
{
    //Measure button so we can size up the dim area
    if([title length]>0)
    {
        NSDictionary *attributes = @{NSFontAttributeName:self.confirmButton.titleLabel.font};
        CGRect rect = [title boundingRectWithSize:CGSizeMake(0, CGFLOAT_MAX)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
        int widthOfConfirmButton = rect.size.width+(8*2);
        
        self.confirmButton.frame = CGRectMake(self.sharedData.screenWidth-widthOfConfirmButton-4,4,widthOfConfirmButton,40 - 9);
        [self.confirmButton setTitle:title forState:UIControlStateNormal];
        self.confirmButton.hidden = NO;
    } else {
        self.confirmButton.hidden = YES;
        [self.confirmButton setTitle:@"" forState:UIControlStateNormal];
    }
    
    //Set others in confirm area
    self.confirmLabel.text = description;
    self.confirmArea.backgroundColor = backgroundColor;
}


///TEXTVIEW


- (BOOL)textViewShouldBeginEditing:(UITextView *)aTextView
{
    return YES;
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:MESSAGE_PLACEHOLDER]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    if([textView.text length]==0)
    {
        textView.text = MESSAGE_PLACEHOLDER;
        textView.textColor = [UIColor grayColor];
    }
   //[textView resignFirstResponder];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [self performSelector:@selector(adjustFrames) withObject:nil afterDelay:0.1];
        return YES;
    }
    
    [self adjustFrames];
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView
{
    [self adjustFrames];
}


- (BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}


///KEYBOARD




-(void)keyboardOn
{
    NSLog(@"keyboardOn");
    
    //Remove keyboard observer
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillShowNotification
     object:nil];
    
    //Remove keyboard observer
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillHideNotification
     object:nil];
    
    //Add keyboard observer
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onKeyboardShow:)
     name:UIKeyboardWillShowNotification
     object:nil];
    
    //Add keyboard observer
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onKeyboardHide:)
     name:UIKeyboardWillHideNotification
     object:nil];
}


-(void)keyboardOff
{
    NSLog(@"keyboardOff");
    /*
    //Remove keyboard observer
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillShowNotification
     object:nil];
    
    //Remove keyboard observer
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillHideNotification
     object:nil];
    */
}


-(void)clickAwayFromKeyboard
{
    [self endEditing:YES];
}


-(void)onKeyboardShow:(NSNotification *)notification
{
    if(!self.sharedData.isInConversation)
    {
        return;
    }
    
    NSLog(@"onKeyboardShow");
    
    self.isKeyBoardShowing = YES;
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [keyboardFrameBegin CGRectValue];
    self.keyBoardHeight = keyboardFrame.size.height;
    
    self.input.frame = CGRectMake(0, self.frame.size.height - 40 - self.keyBoardHeight - ((self.inputNumLines - 1) * 20), self.frame.size.width - 60, 40 + ((self.inputNumLines - 1) * 20));
    self.btnSend.frame = CGRectMake(self.frame.size.width - 60, self.frame.size.height - 40 - self.keyBoardHeight - ((self.inputNumLines - 1) * 20), 60, 40 + ((self.inputNumLines - 1) * 20));
    self.messagesList.frame = CGRectMake(0, 65, self.frame.size.width, self.frame.size.height - 65 - 40 - self.keyBoardHeight);
    
    [self scrollToBottom:NO];
    
    self.contentOffSetYToCompare = self.messagesList.contentOffset.y + self.keyBoardHeight;
    
    [self performSelector:@selector(updateKeyBoard) withObject:nil afterDelay:0.5];
}


-(void)updateKeyBoard
{
    self.canCheckScrollDown = YES;
}


-(void)onKeyboardHide:(NSNotification *)notification
{
    if(!self.sharedData.isInConversation)
    {
        return;
    }
    
    NSLog(@"onKeyboardHide");
    
    self.isKeyBoardShowing = NO;
    
    /*
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [keyboardFrameBegin CGRectValue];
    self.keyBoardHeight = keyboardFrame.size.height;
    */
    
    self.input.frame = CGRectMake(0, self.frame.size.height - 40, self.frame.size.width - 60, 40);
    self.btnSend.frame = CGRectMake(self.frame.size.width - 60, self.frame.size.height - 40, 60, 40);
    self.messagesList.frame = CGRectMake(0, 65, self.frame.size.width, self.frame.size.height - 65 - 40);
}


@end



