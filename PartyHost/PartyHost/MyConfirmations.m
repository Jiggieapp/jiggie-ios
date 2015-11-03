//
//  Hostings.m
//  PartyHost
//
//  Created by Sunny Clark on 1/1/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "MyConfirmations.h"

@implementation MyConfirmations

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    self.sharedData = [SharedData sharedInstance];
    
    self.isHostingsLoaded = NO;
    self.isLoading = NO;
    self.isVenuesListLoaded = NO;
    self.cEditId            = 0;
    self.hasHostings        = NO;
    
    self.mainCon = [[UIView alloc] initWithFrame:CGRectMake(0, 60, self.sharedData.screenWidth * 2, self.sharedData.screenHeight - 100)];
    [self addSubview:self.mainCon];
    
    self.tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 60)];
    self.tabBar.backgroundColor = [UIColor phLightTitleColor];
    [self addSubview:self.tabBar];
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, frame.size.width, 40)];
    self.title.text = @"CONFIRMATIONS";
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.textColor = [UIColor whiteColor];
    self.title.font = [UIFont phBold:21];
    [self.tabBar addSubview:self.title];
    
    self.btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnBack.frame = CGRectMake(0, 13, 50, 50);
    [self.btnBack setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [self.btnBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.btnBack.hidden = YES;
    [self.tabBar addSubview:self.btnBack];
    
    self.hostingsA = [[NSMutableArray alloc] init];
    self.hostingsList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 60)];
    self.hostingsList.delegate = self;
    self.hostingsList.dataSource = self;
    self.hostingsList.allowsMultipleSelectionDuringEditing = NO;
    [self.mainCon addSubview:self.hostingsList];
    
    self.addEditCon = [[UIScrollView alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth, 0, self.sharedData.screenWidth, self.frame.size.height - 60)];
    self.addEditCon.backgroundColor = [UIColor whiteColor];
    self.addEditCon.delegate = self;
    [self.mainCon addSubview:self.addEditCon];
    
    self.addEditImg = [[PHImage alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 75)];
    self.addEditImg.contentMode = UIViewContentModeScaleAspectFill;
    self.addEditImg.backgroundColor = [UIColor blackColor];
    self.addEditImg.layer.masksToBounds = YES;
    [self.addEditCon addSubview:self.addEditImg];
    
    self.addEditTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, 20)];
    self.addEditTitle.font = [UIFont phBold:20];
    self.addEditTitle.textColor = [UIColor whiteColor];
    self.addEditTitle.backgroundColor = [UIColor clearColor];
    self.addEditTitle.userInteractionEnabled = NO;
    self.addEditTitle.shadowColor = [UIColor blackColor];
    self.addEditTitle.shadowOffset = CGSizeMake(0.5,0.5);
    [self.addEditCon addSubview:self.addEditTitle];
    
    self.addEditSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 32, self.frame.size.width - 20, 20)];
    self.addEditSubtitle.font = [UIFont phBlond:14];
    self.addEditSubtitle.textColor = [UIColor whiteColor];
    self.addEditSubtitle.userInteractionEnabled = NO;
    self.addEditSubtitle.backgroundColor = [UIColor clearColor];
    self.addEditSubtitle.shadowColor = [UIColor blackColor];
    self.addEditSubtitle.shadowOffset = CGSizeMake(0.5,0.5);
    [self.addEditCon addSubview:self.addEditSubtitle];
    
    UILabel *whenLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 85, self.frame.size.width - 20, 20)];
    whenLabel.text = @"Hosting Start Time";
    whenLabel.textColor = [UIColor blackColor];
    whenLabel.font = [UIFont phBold:16];
    [self.addEditCon addSubview:whenLabel];
    
    self.addEditTitleInput = [[UITextField alloc] initWithFrame:CGRectMake(10, 110, self.frame.size.width - 20, 30)];
    self.addEditTitleInput.font = [UIFont phBlond:18];
    self.addEditTitleInput.borderStyle = UITextBorderStyleRoundedRect;
    self.addEditTitleInput.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.addEditTitleInput.layer.borderWidth = 1.0;
    self.addEditTitleInput.layer.masksToBounds = YES;
    self.addEditTitleInput.layer.cornerRadius = 10.0;
    self.addEditTitleInput.userInteractionEnabled = NO;
    self.addEditTitleInput.textColor = [UIColor grayColor];
    [self.addEditCon addSubview:self.addEditTitleInput];
    
    UILabel *whenLabelTwo = [[UILabel alloc] initWithFrame:CGRectMake(10, 145, self.frame.size.width - 20, 20)];
    whenLabelTwo.text = @"Hosting End Time";
    whenLabelTwo.textColor = [UIColor blackColor];
    whenLabelTwo.font = [UIFont phBold:16];
    [self.addEditCon addSubview:whenLabelTwo];
    
    self.addEditTitleTwoInput = [[UITextField alloc] initWithFrame:CGRectMake(10, 170, self.frame.size.width - 20, 30)];
    self.addEditTitleTwoInput.font = [UIFont phBlond:18];
    self.addEditTitleTwoInput.borderStyle = UITextBorderStyleRoundedRect;
    self.addEditTitleTwoInput.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.addEditTitleTwoInput.layer.borderWidth = 1.0;
    self.addEditTitleTwoInput.layer.masksToBounds = YES;
    self.addEditTitleTwoInput.layer.cornerRadius = 10.0;
    self.addEditTitleTwoInput.textColor = [UIColor grayColor];
    self.addEditTitleTwoInput.userInteractionEnabled = NO;
    [self.addEditCon addSubview:self.addEditTitleTwoInput];
    
    UILabel *whatLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 210, self.frame.size.width - 20, 20)];
    whatLabel.text = @"Hosting Description";
    whatLabel.textColor = [UIColor blackColor];
    whatLabel.font = [UIFont phBold:16];
    [self.addEditCon addSubview:whatLabel];
    
    self.addEditSubtitleTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 235, self.frame.size.width - 20, 110)];
    self.addEditSubtitleTextView.editable = YES;
    self.addEditSubtitleTextView.font = [UIFont phBlond:18];
    self.addEditSubtitleTextView.textColor = [UIColor grayColor];
    self.addEditSubtitleTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.addEditSubtitleTextView.layer.borderWidth = 1.0;
    self.addEditSubtitleTextView.layer.masksToBounds = YES;
    self.addEditSubtitleTextView.layer.cornerRadius = 10.0;
    self.addEditSubtitleTextView.returnKeyType = UIReturnKeyDefault;
    self.addEditSubtitleTextView.userInteractionEnabled = NO;
    [self.addEditCon addSubview:self.addEditSubtitleTextView];
    
    self.addEditShareBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.addEditShareBtn.frame = CGRectMake( 10, self.addEditSubtitleTextView.frame.size.height + self.addEditSubtitleTextView.frame.origin.y + 10, self.sharedData.screenWidth - 20, 40);
    [self.addEditShareBtn setTitle:@"Share Hosting" forState:UIControlStateNormal];
    self.addEditShareBtn.titleLabel.font  = [UIFont phBold:16.0];
    [self.addEditShareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addEditShareBtn setBackgroundColor:[UIColor grayColor]];
    [self.addEditShareBtn addTarget:self action:@selector(shareHostingHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.addEditCon addSubview:self.addEditShareBtn];
    
    self.addEditCon.contentSize = CGSizeMake(self.sharedData.screenWidth, 800);
    
    self.cDeleteId = 0;
    
    [self.hostingsList beginUpdates];
    [self.hostingsList endUpdates];
    
    //Create empty label
    self.labelEmpty = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.screenHeight)];
    self.labelEmpty.text = @"No confirmations yet.";
    self.labelEmpty.textAlignment = NSTextAlignmentCenter;
    self.labelEmpty.textColor = [UIColor lightGrayColor];
    self.labelEmpty.hidden = YES;
    self.labelEmpty.font = [UIFont phBlond:16];
    [self addSubview:self.labelEmpty];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(resetApp)
     name:@"APP_UNLOADED"
     object:nil];
    
    return self;
}

-(void)resetApp
{
    self.isHostingsLoaded = NO;
    self.isLoading = NO;
    self.isVenuesListLoaded = NO;
    self.cEditId = 0;
    self.hasHostings = NO;
    
    [self.hostingsA removeAllObjects];
    [self.hostingsList reloadData];
    [self goBack];
    
    [self.hostingsList beginUpdates];
    [self.hostingsList endUpdates];
}

-(void)shareHostingHandler
{
    self.sharedData.member_first_name = [self.sharedData capitalizeFirstLetter:[self.sharedData.userDict objectForKey:@"first_name"]];
    self.sharedData.member_fb_id = self.sharedData.fb_id;
    NSMutableDictionary *dict = [self.hostingsA objectAtIndex:self.cEditId];
    
    //Everything needed for share link
    self.sharedData.shareHostingId = dict[@"_id"];
    self.sharedData.shareHostingVenueName = dict[@"event"][@"venue"][@"name"];
    self.sharedData.shareHostingHostName = dict[@"host"][@"first_name"];
    self.sharedData.shareHostingHostFbId = dict[@"host"][@"fb_id"];
    self.sharedData.shareHostingHostDate = dict[@"start_datetime_str"];
    self.sharedData.cHostVenuePicURL = [Constants eventImageURL:dict[@"event"][@"_id"]]; //Need for SHARE HOSTING
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_HOSTING_INVITE" object:self];
    
    //Mixpanel
    //[self.sharedData trackMixPanelWithDict:@"Share Hosting" withDict:@{@"origin":@"MyConfirmations"}];
}

-(void)updateTextField:(id)sender
{
    UIDatePicker *picker = sender;//(UIDatePicker*)self.eEditInput.inputView;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [formatter setDateFormat:@"MMM d, YYYY h:mm a"];
    self.eEditInput.text = [formatter stringFromDate:picker.date];
    self.cDate = picker.date;
}

-(void)initClass
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    self.labelEmpty.hidden = YES;
    self.hostingsList.hidden = YES;
    self.hostingsList.contentOffset = CGPointMake(0, 0);
    
    self.sharedData.morePageBtnBack.hidden = NO;
    
    [self loadData];
}


-(void)loadData
{
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    //userhostingsconfirmationsall
    NSString *url = [NSString stringWithFormat:@"%@/user/hostings/confirmations/all/%@",PHBaseURL,self.sharedData.fb_id];
    NSLog(@"URL :: %@",url);
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"MY_CONFIRMATIONS :: %@",responseObject);
         
         [self.sharedData trackMixPanelWithDict:@"View MyConfirmations" withDict:@{}];
         
         self.hasHostings = ([responseObject count] > 0);
         self.isHostingsLoaded = YES;
         [self.hostingsA removeAllObjects];
         [self.hostingsA addObjectsFromArray:responseObject];
         [self.hostingsList reloadData];
         
         //Show empty
         if([self.hostingsA count]==0)
         {
             self.labelEmpty.hidden = NO;
             self.hostingsList.hidden = YES;
         }
         else
         {
             self.labelEmpty.hidden = YES;
             self.hostingsList.hidden = NO;
         }
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR :: %@",error);
     }];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if([alertView tag]==15) {
        if (buttonIndex == 1)
        {
            [self unconfirmConfirmation];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        self.cDeleteId = (int)indexPath.row;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unconfirm Hosting?" message:@"Are you sure you want to unconfirm this hosting?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        alert.delegate = self;
        alert.tag = 15;
        [alert addButtonWithTitle:@"Yes"];
        [alert show];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.isHostingsLoaded == NO)?1:([self.hostingsA count] > 0)?[self.hostingsA count]:1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *buttonDelete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Unconfirm" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                          {
                                              self.cDeleteId = (int)indexPath.row;
                                              
                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unconfirm Hosting?" message:@"Are you sure you want to unconfirm this hosting?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                                              alert.delegate = self;
                                              alert.tag = 15;
                                              [alert addButtonWithTitle:@"Yes"];
                                              [alert show];
                                          }];
    buttonDelete.backgroundColor = [UIColor redColor];
    
    if(self.isHostingsLoaded && [self.hostingsA count] > 0)
    {
        return @[buttonDelete];
    }else
    {
        return @[];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    if(!self.isHostingsLoaded || [self.hostingsA count] == 0)
    {
        return;
    }
    
    //Mixpanel
    //[self.sharedData trackMixPanel:@"edit_hosting_tapped"];
    
    self.cEditId = (int)indexPath.row;
    NSDictionary *dict = [self.hostingsA objectAtIndex:indexPath.row];
    
    //Venue info
    self.addEditTitle.text = dict[@"event"][@"title"];
    self.addEditSubtitle.text = dict[@"event"][@"venue"][@"name"];
    
    if([dict[@"event"][@"venue"][@"address"] isEqualToString:dict[@"event"][@"venue"][@"name"]])
    {
        self.addEditSubtitle.text = dict[@"event"][@"venue"][@"neighborhood"];
    }
    else
    {
        self.addEditSubtitle.text = dict[@"event"][@"venue"][@"address"];
    }
    
    if([dict[@"event"][@"venue"][@"photos"] count]>0)
    {
        NSString *picURL = dict[@"event"][@"venue"][@"photos"][0];
        picURL = [self.sharedData picURL:picURL];
        self.sharedData.cHostVenuePicURL = picURL;
        [self.addEditImg loadImage:picURL defaultImageNamed:@"nightclub_default"];
    }
        
    self.addEditTitleInput.text = dict[@"start_datetime_str"];
    self.addEditTitleTwoInput.text = dict[@"end_datetime_str"];
    self.addEditSubtitleTextView.text = dict[@"description"];
    
    self.sharedData.morePageBtnBack.hidden = YES;
    self.addEditShareBtn.hidden = NO;
    [self.addEditCon setContentOffset:CGPointMake(0, 0)];
    self.title.text = @"CONFIRMATION DETAILS";
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.mainCon.frame = CGRectMake(-self.frame.size.width, 60, self.frame.size.width * 2, self.frame.size.height - 60);
     } completion:^(BOOL fin)
     {
         self.btnBack.hidden = NO;
     }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MyConfirmationsCell";
    
    MyConfirmationsCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[MyConfirmationsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if(self.isHostingsLoaded && [self.hostingsA count] > 0)
    {
        NSDictionary *dict = [self.hostingsA objectAtIndex:indexPath.row];
        [cell loadData:dict];
        [cell hideLoading];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }else if(self.isHostingsLoaded && [self.hostingsA count] == 0){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell showNone];
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell showLoading];
    }
    
    return cell;
}

-(void)goBack
{
    self.btnBack.hidden = YES;
    self.sharedData.morePageBtnBack.hidden = NO;
    
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.mainCon.frame = CGRectMake(0, 60, self.frame.size.width * 2, self.frame.size.height - 60);
     } completion:^(BOOL fin)
     {
     }];
}

-(void)goQuickBack
{
    self.btnBack.hidden = YES;
    self.sharedData.morePageBtnBack.hidden = NO;
    
    [UIView animateWithDuration:0 animations:^()
     {
         self.mainCon.frame = CGRectMake(0, 60, self.frame.size.width * 2, self.frame.size.height - 60);
     } completion:^(BOOL fin)
     {
     }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y < 50)
    {
        [self.addEditSubtitleTextView resignFirstResponder];
    }
}

-(void)unconfirmConfirmation
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];

    NSDictionary *dict = self.hostingsA[self.cDeleteId];
    
    NSString *url = [NSString stringWithFormat:@"%@/user/hostings/unguestconfirmed/%@/%@",PHBaseURL,self.sharedData.fb_id,dict[@"_id"]];
    
    NSDictionary *params =
    @{
      @"from_name":self.sharedData.userDict[@"first_name"],
      @"from_id":self.sharedData.fb_id,
      @"to_id":dict[@"host"][@"fb_id"]
      };
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"UNCONFIRM_HOSTING_RESPONSE :: %@",responseObject);
         
         [self.sharedData trackMixPanelWithDict:@"Unconfirm Hosting" withDict:@{@"origin":@"MyConfirmations"}];
         
         [self.sharedData trackMixPanelIncrementWithDict:@{@"unconfirm_hosting":@1}];
         
         [self loadData];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"UNCONFIRM_HOSTING_ERROR :: %@",error);
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error unconfirming the hosting, please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
     }];
}

@end
