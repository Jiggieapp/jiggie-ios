//
//  BookTable.m
//  PartyHost
//
//  Created by Tony Suriyathep on 7/15/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "BookTable.h"
#import "AnalyticManager.h"

#define SCREEN_LEVELS 7

@implementation BookTable {
    NSString *lastEventId;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    lastEventId = @"";
    self.backgroundColor = [UIColor whiteColor];
    
    self.offeringPath = 0;
    
    self.sharedData = [SharedData sharedInstance];
    self.mainArray = [[NSMutableArray alloc] init];
    self.offeringArray = [[NSMutableArray alloc] init];
    self.selectedTicket = [[NSMutableDictionary alloc] init];
    
    
    self.mainCon = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.sharedData.screenWidth*SCREEN_LEVELS, self.sharedData.screenHeight)];
    self.mainCon.backgroundColor = [UIColor phPurpleColor];
    [self addSubview:self.mainCon];
    
    //Add other screens
    self.bookTableDetails = [[BookTableDetails alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth*1,0,self.sharedData.screenWidth,self.sharedData.screenHeight)];
    [self.mainCon addSubview:self.bookTableDetails];
    self.bookTableConfirm = [[BookTableConfirm alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth*2,0,self.sharedData.screenWidth,self.sharedData.screenHeight)];
    [self.mainCon addSubview:self.bookTableConfirm];
    self.bookTableComplete = [[BookTableComplete alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth*3,0,self.sharedData.screenWidth,self.sharedData.screenHeight)];
    [self.mainCon addSubview:self.bookTableComplete];
    self.bookTableOffering = [[BookTableOffering alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth*4,0,self.sharedData.screenWidth,self.sharedData.screenHeight)];
    [self.mainCon addSubview:self.bookTableOffering];
    self.bookTableAbout = [[BookTableAbout alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth*2,0,self.sharedData.screenWidth,self.sharedData.screenHeight)];
    [self.mainCon addSubview:self.bookTableAbout];
    self.bookTableHostingComplete = [[BookTableHostingComplete alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth*3,0,self.sharedData.screenWidth,self.sharedData.screenHeight)];
    [self.mainCon addSubview:self.bookTableHostingComplete];
    
    UIView *tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 60)];
    tabBar.backgroundColor = [UIColor clearColor];
    [self.mainCon addSubview:tabBar];
    
    //Cancel button
    self.btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnCancel.frame = CGRectMake(8, 15, 80, 50);
    self.btnCancel.titleLabel.font = [UIFont phBold:14];
    self.btnCancel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.btnCancel setTitle:@"CANCEL" forState:UIControlStateNormal];
    [self.btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnCancel addTarget:self action:@selector(btnCancelClicked) forControlEvents:UIControlEventTouchUpInside];
    [tabBar addSubview:self.btnCancel];

    //Help button
    self.btnHelp = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnHelp.frame = CGRectMake(self.sharedData.screenWidth - 80 - 8, 15, 80, 50);
    self.btnHelp.titleLabel.font = [UIFont phBold:14];
    self.btnHelp.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.btnHelp setTitle:@"HELP" forState:UIControlStateNormal];
    [self.btnHelp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnHelp addTarget:self action:@selector(btnHelpClicked) forControlEvents:UIControlEventTouchUpInside];
    [tabBar addSubview:self.btnHelp];
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(20, 64, self.sharedData.screenWidth-40, 40)];
    self.title.text = @"PICK A VIP TABLE";
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.textColor = [UIColor whiteColor];
    self.title.font = [UIFont phBold:18];
    [self.mainCon addSubview:self.title];
    
    self.subtitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, self.sharedData.screenWidth-40, 40)];
    self.subtitle.text = @"...";
    self.subtitle.adjustsFontSizeToFitWidth = YES;
    self.subtitle.textAlignment = NSTextAlignmentCenter;
    self.subtitle.textColor = [UIColor whiteColor];
    self.subtitle.font = [UIFont phBlond:13];
    [self.mainCon addSubview:self.subtitle];
    
    //Button 1
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, self.sharedData.screenHeight-PHButtonHeight, self.sharedData.screenWidth, PHButtonHeight);
    button1.backgroundColor = [UIColor whiteColor];
    [button1 addTarget:self action:@selector(btnNoClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.mainCon addSubview:button1];
    UIView *button1View = [[UIView alloc] initWithFrame:button1.bounds];
    button1View.userInteractionEnabled = NO;
    UILabel *button1Line = [[UILabel alloc] initWithFrame:CGRectMake(32+8+8+16,4,button1.frame.size.width-32-8-8-16-8,button1.frame.size.height-8)];
    button1Line.text = @"I already have a table booked for this event";
    button1Line.textColor = [UIColor colorFromHexCode:@"999999"];
    button1Line.font = [UIFont phBlond:13];
    [button1View addSubview:button1Line];
    [button1 addSubview:button1View];
    self.check1 = [[SelectionCheckmark alloc] initWithFrame:CGRectMake(16, PHButtonHeight/2 - 32/2, 32, 32)];
    self.check1.userInteractionEnabled = NO;
    [button1 addSubview:self.check1];
    
    /*
    //Button 2
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, button1.frame.origin.y - 64, self.sharedData.screenWidth, 64);
    button2.backgroundColor = [UIColor whiteColor];
    [button2 addTarget:self action:@selector(btnYesClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.mainCon addSubview:button2];
    UIView *button2View = [[UIView alloc] initWithFrame:button1.bounds];
    button2View.userInteractionEnabled = NO;
    UILabel *button2Line = [[UILabel alloc] initWithFrame:CGRectMake(32+8+8+16,4,button1.frame.size.width-32-8-8-16-8,button1.frame.size.height-8)];
    button2Line.text = @"I need to request a custom table for this event";
    button2Line.textColor = [UIColor colorFromHexCode:@"999999"];
    button2Line.font = [UIFont phBlond:13];
    [button2View addSubview:button2Line];
    [button2 addSubview:button2View];
    self.check2 = [[SelectionCheckmark alloc] initWithFrame:CGRectMake(16, 16, 32, 32)];
    self.check2.userInteractionEnabled = NO;
    [button2 addSubview:self.check2];
    
    UIView *separator1 = [[UIView alloc] initWithFrame:CGRectMake(0,button1.frame.origin.y,self.sharedData.screenWidth,1)];
    separator1.backgroundColor = [UIColor colorWithWhite:0 alpha:0.10];
    [self.mainCon addSubview:separator1];
    */
    
    
    
    //Create list
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.subtitle.frame.size.height + self.subtitle.frame.origin.y + 16, self.sharedData.screenWidth, self.sharedData.screenHeight - (self.subtitle.frame.size.height + self.subtitle.frame.origin.y + 16) - (PHButtonHeight*0) )];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor phDarkGrayColor];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.allowsSelection = YES;
    self.tableView.hidden = YES;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.mainCon addSubview:self.tableView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 1)];
    line.backgroundColor = [UIColor phDarkGrayColor];
    self.tableView.tableHeaderView = line;
    
    UIView *separator1 = [[UIView alloc] initWithFrame:CGRectMake(0,self.tableView.frame.origin.y-1,self.sharedData.screenWidth,1)];
    separator1.backgroundColor = [UIColor colorWithWhite:1 alpha:0.05];
    [self.mainCon addSubview:separator1];
    
    //When there are no entries
    self.emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0,60,self.tableView.frame.size.width,self.tableView.frame.origin.y+self.tableView.frame.size.height-60)];
    self.emptyView.backgroundColor = [UIColor phDarkBodyColor];
    [self.emptyView setData:@"No tables available" subtitle:@"" imageNamed:@"tab_events"];
    [self.emptyView setMode:@"load"];
    [self.mainCon addSubview:self.emptyView];
    
    //Main screen
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(goToBookTable)
     name:@"GO_BOOKTABLE_MAIN"
     object:nil];
    
    //Details screen
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(goToBookTableDetails)
     name:@"GO_BOOKTABLE_DETAILS"
     object:nil];
    
    //Confirm screen
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(goToBookTableConfirm)
     name:@"GO_BOOKTABLE_CONFIRM"
     object:nil];
    
    //Complete screen
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(goToBookTableComplete)
     name:@"GO_BOOKTABLE_COMPLETE"
     object:nil];

    //Offering screen, after main
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(goToBookTableOffering)
     name:@"GO_BOOKTABLE_OFFERING"
     object:nil];
    
    //Offering screen, after booktable
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(goToBookTableAbout)
     name:@"GO_BOOKTABLE_ABOUT"
     object:nil];
    
    //Complete screen
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(goToBookTableHostingComplete)
     name:@"GO_BOOKTABLE_HOSTING_COMPLETE"
     object:nil];
    
    return self;
}

/*
-(void)btnYesClicked
{
    [self.check2 buttonSelect:YES animated:YES];
    if(self.check1.isSelected) [self.check1 buttonSelect:NO animated:YES];
    return;
    
    //Mixpanel
    //[self.sharedData trackMixPanel:@"quote_requested"];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *url = [NSString stringWithFormat:@"%@/quote/%@/%@",self.sharedData.baseHerokuAPIURL,self.sharedData.cEventId_toLoad,self.sharedData.fb_id];
    
    NSLog(@"QUOTE_URL :: %@",url);
    
    [manager GET:url parameters:NULL success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"QUOTE_RESPONSE :: %@",responseObject);
         
         if(![responseObject[@"success"] boolValue]) {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Hosting" message:responseObject[@"reason"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
             return;
         }
         
         //When they click YES show a message
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Quote Request" message:@"We are processing your quote request. In the meantime you may continue with your hosting creation." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
         
         [self.sharedData trackMixPanelWithDict:@"Tap Email Quote" withDict:@{}];
         
         [self.sharedData trackMixPanelIncrementWithDict:@{@"quote_request":@1}];
         
         [self exitHandler];
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         //Call with delay
         [self performSelector:@selector(createHosting) withObject:self afterDelay:0.20];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR :: %@",error);
         NSLog(@"%@",operation.responseString);
         NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
         id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         
         if([operation.response statusCode] == 409)
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:json[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
         
         [self exitHandler];
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
     }];
}
*/

-(void)btnNoClicked
{
    [self changeOfferingPath:0];
    
    [self.check1 buttonSelect:YES animated:YES];
    if(self.check2.isSelected) [self.check2 buttonSelect:NO animated:YES];
    
    //Call with delay
    [self performSelector:@selector(goToBookTableOffering) withObject:self afterDelay:0.20];
}

-(void)btnCancelClicked
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EXIT_BOOKTABLE"
     object:self];
}

-(void)btnHelpClicked
{
    [self helpSMS];
}

-(void)initClass
{
    self.mainCon.frame = CGRectMake(0, self.sharedData.screenHeight, self.sharedData.screenWidth * SCREEN_LEVELS, self.sharedData.screenHeight);
    
    self.hidden = NO;
    
    [self loadData:self.sharedData.eventDict[@"_id"]];
    
    //Restore checkmark
    [self.check1 buttonSelect:NO animated:NO];
    
    //Reset agree checkmark
    [self.bookTableConfirm.checkmarkAgree buttonSelect:NO animated:NO];
    
    //Reset purchases checkmarks
    for(int i = 0; i < [self.bookTableConfirm.checkmarkPurchases count]; i++)
    {
        SelectionCheckmark *checkmark = self.bookTableConfirm.checkmarkPurchases[i];
        [checkmark buttonSelect:NO animated:NO];
    }
    
    //Reset lists
    [self.bookTableOffering reset];
    [self.bookTableAbout reset];

    [UIView animateWithDuration:0.25
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^
     {
         self.mainCon.frame = CGRectMake(0, 0, self.sharedData.screenWidth * SCREEN_LEVELS, self.sharedData.screenHeight);
     }
                     completion:^(BOOL finished)
     {
         
     }];
}

-(void)exitHandler
{
    [UIView animateWithDuration:0.15
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^
     {
         self.mainCon.frame = CGRectMake(self.mainCon.frame.origin.x, self.sharedData.screenHeight + 1, self.sharedData.screenWidth * SCREEN_LEVELS, self.sharedData.screenHeight);
     }
                     completion:^(BOOL finished)
     {
         self.hidden = YES;
     }];
}

//This needed a delay because it was too slow?
-(void)createHosting
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"CREATE_HOSTING"
     object:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *data = self.mainArray[indexPath.row];
    
    BookTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookTableCell"];
    if (cell == nil)
    {
        cell = [[BookTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BookTableCell"];
    }
    
    [cell populateData:data];
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mainArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 112;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    /*
    //Check phone??
    if([self.sharedData.phone length]==0)
    {
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Phone Required"
                                                         message:@"Before booking a table you must have a valid phone number."
                                                        delegate:self
                                               cancelButtonTitle: @"Cancel"
                                               otherButtonTitles: @"Proceed",nil];
        alert.tag = 0;
        [alert show];
        return;
    }
    */
    /*
    //Check CC??
    if([self.sharedData.ccLast4 length]==0)
    {
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Credit Required"
                                                         message:@"Before booking a table you must have a valid credit card."
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"Proceed",nil];
        alert.tag = 1;
        [alert show];
        return;
    }
    */
    
    NSDictionary *dict = [self.mainArray objectAtIndex:indexPath.row];
    
    
    if([dict[@"status"] isEqualToString:@"sold out"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sold Out" message:@"This table has been sold out." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self changeOfferingPath:1];
    
    [self.selectedTicket removeAllObjects];
    [self.selectedTicket addEntriesFromDictionary:dict];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"GO_BOOKTABLE_DETAILS"
     object:self];
}

-(void)goToBookTable
{
    //Restore checkmark
    [self.check1 buttonSelect:NO animated:NO];
    
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.mainCon.frame = CGRectMake(-self.sharedData.screenWidth * 0, 0, self.sharedData.screenWidth * SCREEN_LEVELS, self.sharedData.screenHeight);
     } completion:^(BOOL finished)
     {
     }];
}

-(void)goToBookTableDetails
{
    [self.bookTableDetails initClass];
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.mainCon.frame = CGRectMake(-self.sharedData.screenWidth * 1, 0, self.sharedData.screenWidth * SCREEN_LEVELS, self.sharedData.screenHeight);
     } completion:^(BOOL finished)
     {
     }];
}

-(void)goToBookTableConfirm
{
    [self.bookTableConfirm initClass];
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.mainCon.frame = CGRectMake(-self.sharedData.screenWidth * 2, 0, self.sharedData.screenWidth * SCREEN_LEVELS, self.sharedData.screenHeight);
     } completion:^(BOOL finished)
     {
     }];
}

-(void)goToBookTableComplete
{
    [self.bookTableComplete initClass];
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.mainCon.frame = CGRectMake(-self.sharedData.screenWidth * 3, 0, self.sharedData.screenWidth * SCREEN_LEVELS, self.sharedData.screenHeight);
     } completion:^(BOOL finished)
     {
         [self.bookTableComplete.check1 buttonSelect:YES animated:YES];
     }];
}

-(void)changeOfferingPath:(int)offeringPath
{
    self.offeringPath = offeringPath;
    int screenLevel = (self.offeringPath*3)+1; //0=FromBookTable 1=FromAfterBuyingBookTable
    self.bookTableOffering.frame = CGRectMake(self.sharedData.screenWidth * screenLevel,0,self.sharedData.screenWidth,self.sharedData.screenHeight);
    self.bookTableAbout.frame = CGRectMake(self.sharedData.screenWidth * (screenLevel+1),0,self.sharedData.screenWidth,self.sharedData.screenHeight);
    self.bookTableHostingComplete.frame = CGRectMake(self.sharedData.screenWidth * (screenLevel+2),0,self.sharedData.screenWidth,self.sharedData.screenHeight);
}

//Place after first screen
-(void)goToBookTableOffering
{
    int screenLevel = (self.offeringPath*3)+1; //0=FromBookTable 1=FromAfterBuyingBookTable
    
    [self.bookTableOffering initClass];
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.mainCon.frame = CGRectMake(-self.sharedData.screenWidth * screenLevel, 0, self.sharedData.screenWidth * SCREEN_LEVELS, self.sharedData.screenHeight);
     } completion:^(BOOL finished)
     {
     }];
}

//Place after first screen
-(void)goToBookTableAbout
{
    int screenLevel = (self.offeringPath*3)+2; //0=FromBookTable 1=FromAfterBuyingBookTable
    
    [self.bookTableAbout initClass];
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.mainCon.frame = CGRectMake(-self.sharedData.screenWidth * screenLevel, 0, self.sharedData.screenWidth * SCREEN_LEVELS, self.sharedData.screenHeight);
     } completion:^(BOOL finished)
     {
     }];
}

//Place after first screen
-(void)goToBookTableHostingComplete
{
    int screenLevel = (self.offeringPath*3)+3; //0=FromBookTable 1=FromAfterBuyingBookTable
    
    [self.bookTableHostingComplete initClass];
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.mainCon.frame = CGRectMake(-self.sharedData.screenWidth * screenLevel, 0, self.sharedData.screenWidth * SCREEN_LEVELS, self.sharedData.screenHeight);
     } completion:^(BOOL finished)
     {
        [self.bookTableHostingComplete.check1 buttonSelect:YES animated:YES];
     }];
}

-(void)loadData:(NSString*)event_id
{
    [self reset];
    self.event_id = event_id;
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    NSString *url = [Constants eventProductsURL:event_id];
    
    NSLog(@"EVENT_PRODUCTS_URL :: %@",url);
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"EVENT_PRODUCTS_RESPONSE :: %@",responseObject);
         
         //Store this object for further pages
         [self.mainArray removeAllObjects];
         [self.mainArray addObjectsFromArray:responseObject];
         [self populateData:self.mainArray];
         
         NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
         [tmpDict addEntriesFromDictionary:self.sharedData.mixPanelCEventDict];
         
         
         [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Ticket List View" withDict:tmpDict];
         //Show empty
         if(self.mainArray.count == 0) {
             self.tableView.hidden = YES;
             [self.emptyView setMode:@"empty"];
         }
         else {
             self.tableView.hidden = NO;
             [self.emptyView setMode:@"hide"];
         }
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"EVENT_PRODUCTS_ERROR :: %@",error);
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
     }];
}

-(void)populateData:(NSMutableArray *)arr
{
    self.isLoaded = YES;
    
    //NSString *eventName = self.sharedData.eventDict[@"title"];
    NSString *venueName = self.sharedData.eventDict[@"venue_name"];
    NSString *eventStartDate = [Constants toTitleDate:self.sharedData.eventDict[@"start_datetime_str"]];
    
    self.subtitle.text = [NSString stringWithFormat:@"on %@, at %@",eventStartDate,venueName];
    
    [self.tableView reloadData];
}

-(void)reset
{
    //Don't reset view if its the same event, but still load
    if([lastEventId isEqualToString:self.event_id]) return;
    if(self.event_id!=nil) lastEventId = [NSString stringWithString:self.event_id];

    self.subtitle.text = @"...";
    
    [self.mainArray removeAllObjects];
    [self.tableView reloadData];
    self.tableView.hidden = YES;
    
    [self.emptyView setMode:@"hide"];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    self.isLoaded = NO;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 0 && buttonIndex==1)
    {
        self.sharedData.btnPhoneVerifyCancel.hidden = YES;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"SHOW_PHONE_VERIFY"
         object:self];
    }
    else if(alertView.tag == 1 && buttonIndex==1)
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"SHOW_CREDIT_CARD"
         object:self];
    }
}

-(void)helpSMS
{
    
    NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
    [tmpDict addEntriesFromDictionary:self.sharedData.mixPanelCEventDict];
    [tmpDict addEntriesFromDictionary:self.sharedData.bookTable.selectedTicket];
    
    
    NSString *wholeName = [NSString stringWithFormat:@"%@ %@",self.sharedData.userDict[@"first_name"],self.sharedData.userDict[@"last_name"]];
    [tmpDict setObject:self.sharedData.userDict[@"first_name"] forKey:@"User First Name"];
    [tmpDict setObject:self.sharedData.userDict[@"last_name"] forKey:@"User Last Name"];
    [tmpDict setObject:wholeName forKey:@"User Whole Name"];
    [tmpDict setObject:self.sharedData.userDict[@"email"] forKey:@"User Email"];
    [tmpDict setObject:self.sharedData.userDict[@"fb_id"] forKey:@"User FB ID"];
    [tmpDict setObject:self.sharedData.userDict[@"gender"] forKey:@"User Gender"];
    [tmpDict setObject:self.sharedData.userDict[@"birthday"] forKey:@"User Birthday"];

    
    [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Help Pressed" withDict:tmpDict];
    
    NSString *url = [NSString stringWithFormat:@"sms://%@",self.sharedData.help_phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

@end
