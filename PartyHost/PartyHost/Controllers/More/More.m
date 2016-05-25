//
//  More.m
//  PartyHost
//
//  Created by Sunny Clark on 2/16/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "More.h"
#import "AnalyticManager.h"
#import "UserManager.h"

#define SCREEN_LEVELS 3

@implementation More

#define SET_IF_NOT_NULL(TARGET, VAL) if(VAL && VAL != [NSNull null]) { TARGET = VAL; }else {TARGET = @"";}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    self.sharedData = [SharedData sharedInstance];
    
    self.mainCon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width * SCREEN_LEVELS, frame.size.height)];
    //self.mainCon.layer.masksToBounds = YES;
    [self addSubview:self.mainCon];
    
    UIView *tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 60)];
    tabBar.backgroundColor = [UIColor phPurpleColor];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, frame.size.width, 40)];
    title.text = @"MORE";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont phBold:18];
    [tabBar addSubview:title];
    
    int OffSet = (self.sharedData.isIphone4)?18:0;
    int OffSetLargeDevice = 0;
    int OffsetFontLargeDevice = 0;
    if (self.sharedData.isIphone6) {
        OffSetLargeDevice = 10;
        OffsetFontLargeDevice = 1;
    } else if (self.sharedData.isIphone6plus) {
        OffSetLargeDevice = 20;
        OffsetFontLargeDevice = 3;
    }
    
    self.userProfilePicture = [[UserBubble alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth/2 - 45 , 90 + OffSetLargeDevice - OffSet, 90, 90)];
    [self.userProfilePicture addTarget:self action:@selector(goProfile) forControlEvents:UIControlEventTouchUpInside];
    [self.mainCon addSubview:self.userProfilePicture];
    
    UIImage *editProfileImage = [UIImage imageNamed:@"edit-profile-icon"];
    
    self.editProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editProfileButton.frame = CGRectMake(CGRectGetMaxX(self.userProfilePicture.frame) - editProfileImage.size.width,
                                              CGRectGetMaxY(self.userProfilePicture.frame) - editProfileImage.size.height,
                                              editProfileImage.size.width,
                                              editProfileImage.size.height);
    [self.editProfileButton setImage:editProfileImage forState:UIControlStateNormal];
    [self.editProfileButton addTarget:self action:@selector(goEditProfile) forControlEvents:UIControlEventTouchUpInside];
    [self.mainCon addSubview:self.editProfileButton];
    
    self.userProfileName = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.userProfilePicture.frame) + 12, self.sharedData.screenWidth, 20)];
    self.userProfileName.textAlignment = NSTextAlignmentCenter;
    self.userProfileName.font = [UIFont phBlond:17];
    self.userProfileName.textColor = [UIColor blackColor];
    self.userProfileName.backgroundColor = [UIColor clearColor];
    [self.mainCon addSubview:self.userProfileName];
    
    self.userProfilePhone = [UIButton buttonWithType:UIButtonTypeCustom];
    self.userProfilePhone.frame = CGRectMake(self.sharedData.screenWidth/2 - 100, CGRectGetMaxY(self.userProfileName.frame), 200, 10);
    self.userProfilePhone.titleLabel.font = [UIFont phBlond:15];
    [self.userProfilePhone setTitleColor:[UIColor phBlueColor] forState:UIControlStateNormal];
    [self.userProfilePhone addTarget:self action:@selector(goVerifyPhone) forControlEvents:UIControlEventTouchUpInside];
    [self.userProfilePhone setHidden:YES];
    [self.mainCon addSubview:self.userProfilePhone];
    
    CGFloat moreListY = CGRectGetMaxY(self.userProfilePhone.frame) + 14 + OffSetLargeDevice - OffSet;
    self.dataA = [[NSMutableArray alloc] init]; //Fill this out in initClass
    self.moreList = [[UITableView alloc] initWithFrame:CGRectMake(0, moreListY, frame.size.width, self.bounds.size.height - moreListY) style:UITableViewStylePlain];
    self.moreList.delegate = self;
    self.moreList.dataSource = self;
    self.moreList.allowsMultipleSelectionDuringEditing = NO;
    self.moreList.hidden = YES;
    self.moreList.backgroundColor = [UIColor whiteColor];
    self.moreList.separatorColor = [UIColor phLightGrayColor];
    self.moreList.showsVerticalScrollIndicator = NO;
    self.moreList.bounces = NO;
//    self.moreList.scrollEnabled = (self.sharedData.isIphone4)?YES:NO;
    [self.mainCon addSubview:self.moreList];
    
    //Hostings page
    self.hostingsPage = [[MyHostings alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth, 0, self.sharedData.screenWidth, frame.size.height)];
    //self.sharedData.hostingsPage = self.hostingsPage;
    //[self.mainCon addSubview:self.hostingsPage];
    
    //Purchases page
    self.purchasesPage = [[MyPurchases alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth, 0, self.sharedData.screenWidth, frame.size.height)];
    //self.sharedData.purchasesPage = self.purchasesPage;
    [self.mainCon addSubview:self.purchasesPage];
    
    //Confirmatons page
    self.confirmationsPage = [[MyConfirmations alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth, 0, self.sharedData.screenWidth, frame.size.height)];
    //self.sharedData.confirmationsPage = self.confirmationsPage;
    //[self.mainCon addSubview:self.confirmationsPage];
    
    self.settingsPage = [[Settings alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth, 0, self.sharedData.screenWidth, frame.size.height)];
    self.sharedData.settingsPage  = self.settingsPage;
    [self.mainCon addSubview:self.settingsPage];
    
    self.termsPage = [[Privacy alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth*2, 0, self.sharedData.screenWidth, frame.size.height)];
    self.termsPage.webURL = @"http://www.partyhostapp.com/terms/";
    self.termsPage.mainTitle = @"TERMS OF USE";
    [self.mainCon addSubview:self.termsPage];
    
    self.privacyPage = [[Privacy alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth*2, 0, self.sharedData.screenWidth, frame.size.height)];
    self.privacyPage.webURL = @"http://www.partyhostapp.com/privacy/";
    self.privacyPage.mainTitle = @"PRIVACY POLICY";
    [self.mainCon addSubview:self.privacyPage];
    
    self.btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnBack.frame = CGRectMake(self.sharedData.screenWidth, 20, 40, 40);
    [self.btnBack setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [self.btnBack setImageEdgeInsets:UIEdgeInsetsMake(8, 14, 8, 14)];
    [self.btnBack addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
    self.sharedData.morePageBtnBack = self.btnBack;
    
    self.btnPTBack = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnPTBack.frame = CGRectMake(self.sharedData.screenWidth * 2, 20, 40, 40);
    [self.btnPTBack setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [self.btnPTBack setImageEdgeInsets:UIEdgeInsetsMake(8, 14, 8, 14)];
    [self.btnPTBack addTarget:self action:@selector(goPTBack) forControlEvents:UIControlEventTouchUpInside];
        
//    self.emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0,
//                                                                 tabBar.bounds.size.height,
//                                                                 self.sharedData.screenWidth,
//                                                                 self.sharedData.screenHeight - tabBar.bounds.size.height - PHTabHeight)];
//    [self.emptyView setData:@"Please Try Again" subtitle:@"" imageNamed:@""];
//    self.emptyView.backgroundColor = [UIColor whiteColor];
//    [self addSubview:self.emptyView];
    
    //Add others
    [self.mainCon addSubview:tabBar];
    [self.mainCon addSubview:self.btnBack];
    [self.mainCon addSubview:self.btnPTBack];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(creditCardComplete)
     name:@"GO_CREDIT_CARD_COMPLETE"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(moreTappedHandler)
     name:@"MORE_TAPPED"
     object:nil];
    
    return self;
}

//They changed their credit card
-(void)creditCardComplete {
    [self.moreList reloadData];
}

-(void)moreTappedHandler
{
    if(self.mainCon.frame.origin.x < 0) //Not on events page
    {
        [self goHome];
    }else{ //Scroll to top
        [self.moreList setContentOffset:CGPointZero animated:YES];
    }
}

//This recreates list depending on HOST/GUEST
-(void)initClass
{
    //[self.sharedData trackMixPanel:@"more_page"];

    CGRect mainConFrame = self.mainCon.frame;
    mainConFrame.origin.x = 0;
    mainConFrame.origin.y = 0;
    self.mainCon.frame = mainConFrame;
    
    [self.hostingsPage goQuickBack];
    [self.confirmationsPage goQuickBack];
    
    [self.userProfilePicture loadProfileImage:self.sharedData.fb_id];
    self.userProfileName.text = self.sharedData.userDict[@"first_name"];
    if([self.sharedData.phone length]>0)
    {
        [self.userProfilePhone setTitle:[NSString stringWithFormat:@"+%@",self.sharedData.phone] forState:UIControlStateNormal];
    }
    else
    {
       [self.userProfilePhone setTitle:@"Verify Phone Number" forState:UIControlStateNormal];
    }
    
    self.creditAmount = [[NSUserDefaults standardUserDefaults] objectForKey:@"CURRENT_CREDIT_AMOUNT"] ?: @"0";
    
    [self loadCredit];
    
    //Load settings now
    [self loadSettings];
    [self updateTable];
}

#pragma mark - API
- (void)loadCredit {
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    NSString *url = [NSString stringWithFormat:@"%@/credit/balance_credit/%@", PHBaseNewURL, self.sharedData.fb_id];
    
    [manager GET:url parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSString *responseString = operation.responseString;
         NSError *error;
         NSDictionary *json = (NSDictionary *)[NSJSONSerialization
                                               JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]
                                               options:kNilOptions
                                               error:&error];
         dispatch_async(dispatch_get_main_queue(), ^{
             @try {
                 NSDictionary *data = [json objectForKey:@"data"];
                 if (data && data != nil) {
                     NSDictionary *balanceCredit = data[@"balance_credit"];
                     self.creditAmount = balanceCredit[@"tot_credit_active"];
                     
                     [[NSUserDefaults standardUserDefaults] setObject:self.creditAmount forKey:@"CURRENT_CREDIT_AMOUNT"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                 }
                 
                 [self.moreList reloadData];
             }
             @catch (NSException *exception) {
             }
             @finally {
             }
         });
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     }];
}

-(void)loadSettings
{
    //Start spinner
    if(!self.isLoaded)
    {
//        [self.emptyView setMode:@"load"];
    }
    
    NSString *facebookId = [self.sharedData.userDict objectForKey:@"fb_id"];
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSDictionary *params = @{ @"fb_id" : facebookId };
    NSString *url = [Constants memberSettingsURL];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"SETTINGS responseObject :: %@",responseObject);
         NSString *responseString = operation.responseString;
         NSError *error;
         NSDictionary *json = (NSDictionary *)[NSJSONSerialization
                                               JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]
                                               options:kNilOptions
                                               error:&error];
         dispatch_async(dispatch_get_main_queue(), ^{
             @try {
                 NSDictionary *data = [json objectForKey:@"data"];
                 if (data && data != nil) {
                     NSDictionary *membersettings = [data objectForKey:@"membersettings"];
                     if (membersettings && membersettings != nil) {
                         [UserManager saveUserSetting:membersettings];
                         [UserManager updateLocalSetting];
                     }
                 }
                 
                 //Reload table view
                 self.isLoaded = YES;
                 
                 //Update table
                 [self updateTable];
             }
             @catch (NSException *exception) {
                 
             }
             @finally {
                 
             }
        });
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         NSLog(@"ERROR :: %@",error);
     }];
}

-(void)saveSettings
{
    //Start spinner
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSString *url = [Constants memberSettingsURL];
    [manager POST:url parameters:[self.sharedData createSaveSettingsParams] success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"SETTINGS responseObject :: %@",responseObject);
         
         //Update table
         [self updateTable];
         
         //Hide spinner
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR :: %@",error);
     }];
}

-(void)updateTable {
    //Section 1
    [self.dataA removeAllObjects];
    [self.dataA addObject:@"Profile"];
    
    //This must be refreshed when changing roles
    if([self.sharedData isGuest])
    {
        [self.dataA addObject:@"Confirmations"];
    }
    else if([self.sharedData isHost])
    {
        [self.dataA addObject:@"Hostings"];
        [self.dataA addObject:@"Purchases"];
        [self.dataA addObject:@"Credit Card"];
        [self.dataA addObject:@"Phone Number"];
    }
    
    [self.dataA addObject:@"Invite Friends"];
    [self.dataA addObject:@"Email Support"];
    [self.dataA addObject:@"Settings"];
    
    [self.moreList reloadData];
    [self.moreList setContentOffset:CGPointZero animated:NO];
    self.moreList.hidden = NO;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 6;
    } else if (section==1) {
        return 0;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section==0)
    {
        if(indexPath.row==0)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"PurchaseHistoryCell"];
            if (cell == nil) {cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PurchaseHistoryCell"];}
            
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, 180, 20)];
            textLabel.backgroundColor = [UIColor clearColor];
            textLabel.font = [UIFont phBlond:16];
            textLabel.text = @"Bookings";
            [[cell contentView] addSubview:textLabel];
            
            UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 40, 40)];
            cellImage.backgroundColor = [UIColor colorFromHexCode:@"A74CC9"];
            cellImage.layer.cornerRadius = 20;
            [[cell contentView] addSubview:cellImage];
            
            UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
            [iconImage setImage:[UIImage imageNamed:@"icon_purchase_history.png"]];
            [cellImage addSubview:iconImage];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 11.0, 21.0)];
            [imageView setBackgroundColor:[UIColor clearColor]];
            [imageView setImage:[UIImage imageNamed:@"forward.png"]];
            [cell setAccessoryView:imageView];
            [[cell accessoryView] setBackgroundColor:[UIColor clearColor]];
            
        }
        else if(indexPath.row==1)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"PromotionsCell"];
            if (cell == nil) {cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PromotionsCell"];}
            
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, 180, 20)];
            textLabel.backgroundColor = [UIColor clearColor];
            textLabel.font = [UIFont phBlond:16];
            textLabel.text = @"Promotions";
            [[cell contentView] addSubview:textLabel];
            
            UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 40, 40)];
            cellImage.layer.cornerRadius = 20;
            [[cell contentView] addSubview:cellImage];
            
            UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            [iconImage setImage:[UIImage imageNamed:@"promotions_icon.png"]];
            [cellImage addSubview:iconImage];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 11.0, 21.0)];
            [imageView setBackgroundColor:[UIColor clearColor]];
            [imageView setImage:[UIImage imageNamed:@"forward.png"]];
            [cell setAccessoryView:imageView];
            [[cell accessoryView] setBackgroundColor:[UIColor clearColor]];
            
        }
        else if(indexPath.row==2)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell"];
            if (cell == nil) {cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingsCell"];}
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.sharedData.screenWidth, 0.4)];
            [lineView setBackgroundColor:[UIColor phLightGrayColor]];
            [[cell contentView] addSubview:lineView];
            
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, 180, 20)];
            textLabel.backgroundColor = [UIColor clearColor];
            textLabel.font = [UIFont phBlond:16];
            textLabel.text = @"Settings";
            [[cell contentView] addSubview:textLabel];
            
            UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 40, 40)];
            cellImage.backgroundColor = [UIColor phBlueColor];
            cellImage.layer.cornerRadius = 20;
            [[cell contentView] addSubview:cellImage];
            
            UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
            [iconImage setImage:[UIImage imageNamed:@"icon_settings.png"]];
            [cellImage addSubview:iconImage];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 11.0, 21.0)];
            [imageView setBackgroundColor:[UIColor clearColor]];
            [imageView setImage:[UIImage imageNamed:@"forward.png"]];
            [cell setAccessoryView:imageView];
            [[cell accessoryView] setBackgroundColor:[UIColor clearColor]];
        }
        else if(indexPath.row==3)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"InviteFriendsCell"];
            if (cell == nil) {cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InviteFriendsCell"];}
            
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, 180, 20)];
            textLabel.backgroundColor = [UIColor clearColor];
            textLabel.font = [UIFont phBlond:16];
            textLabel.text = @"Get Free Credits";
            [[cell contentView] addSubview:textLabel];
            
            UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 40, 40)];
            cellImage.backgroundColor = [UIColor colorFromHexCode:@"68CE49"];
            cellImage.layer.cornerRadius = 20;
            [[cell contentView] addSubview:cellImage];
            
            UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
            [iconImage setImage:[UIImage imageNamed:@"icon_friends.png"]];
            [cellImage addSubview:iconImage];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 11.0, 21.0)];
            [imageView setBackgroundColor:[UIColor clearColor]];
            [imageView setImage:[UIImage imageNamed:@"forward.png"]];
            [cell setAccessoryView:imageView];
            [[cell accessoryView] setBackgroundColor:[UIColor clearColor]];

        }
        else if(indexPath.row==4)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"EmailSupportCell"];
            if (cell == nil) {cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EmailSupportCell"];}
            
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, 180, 20)];
            textLabel.backgroundColor = [UIColor clearColor];
            textLabel.font = [UIFont phBlond:16];
            textLabel.text = @"Support";
            [[cell contentView] addSubview:textLabel];
            
            UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 40, 40)];
            cellImage.backgroundColor = [UIColor phGrayColor];
            cellImage.layer.cornerRadius = 20;
            [[cell contentView] addSubview:cellImage];
            
            UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
            [iconImage setImage:[UIImage imageNamed:@"icon_support.png"]];
            [cellImage addSubview:iconImage];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 11.0, 21.0)];
            [imageView setBackgroundColor:[UIColor clearColor]];
            [imageView setImage:[UIImage imageNamed:@"forward.png"]];
            [cell setAccessoryView:imageView];
            [[cell accessoryView] setBackgroundColor:[UIColor clearColor]];

        }
        else if (indexPath.row==5)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"LogOutCell"];
            if (cell == nil) {cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LogOutCell"];}
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.font = [UIFont phBlond:16];
            cell.textLabel.text = @"Log Out";
            cell.textLabel.textColor = [UIColor phDarkGrayColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.accessoryView = nil;
        }
    }
    else if (indexPath.section==1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"HostGuestCell"];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HostGuestCell"];
            cell.detailTextLabel.textColor = [UIColor colorFromHexCode:@"5C5C5C"];
            cell.textLabel.font = [UIFont phBlond:17];
            cell.detailTextLabel.font = [UIFont phBlond:11];
        }
        
        if(indexPath.row==0)
        {
            cell.accessoryType = ([self.sharedData isHost] && self.isLoaded) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            cell.textLabel.text = @"Host User";
            cell.detailTextLabel.text = @"Host a party and make fun and beautiful new friends!";
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        }
        else if(indexPath.row==1)
        {
            cell.accessoryType = ([self.sharedData isGuest] && self.isLoaded) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            cell.textLabel.text = @"Guest User";
            cell.detailTextLabel.text = @"See who's hosting hot parties with the best perks!";
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        }
    }
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"id_ID"]];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    
    NSString *creditAmount = [numberFormatter stringFromNumber:[NSNumber numberWithInteger:self.creditAmount.integerValue]];

    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, 180, 20)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = [UIFont phBlond:16];
    textLabel.text = [NSString stringWithFormat:@"Credit: Rp %@", creditAmount];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 40, 40)];
    [imageView setImage:[UIImage imageNamed:@"credit_icon.png"]];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(.0f,
                                                                  .0f,
                                                                  CGRectGetWidth([UIScreen mainScreen].bounds),
                                                                  60.f)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    [headerView addSubview:textLabel];
    [headerView addSubview:imageView];
    
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Change role
    if (indexPath.section==0) {
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if(indexPath.row == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_EDIT_PROFILE"
                                                                object:nil];
//            [self goProfile];
            
            return;
        }
        
        //Purchase History
        else if(indexPath.row == 1)
        {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"SHOW_PURCHASE_HISTORY"
             object:self];
            
            return;
        }
        
        //Promotions
        else if(indexPath.row == 2)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_PROMOTIONS"
                                                                object:nil];
            
            return;
        }
        
        //Settings
        else if(indexPath.row == 3 && [UserManager updateLocalSetting])
        {
            self.settingsPage.hidden = NO;
            self.hostingsPage.hidden = YES;
            self.confirmationsPage.hidden = YES;
            [self.settingsPage initClass];
            
            self.btnBack.hidden = NO;
            [UIView animateWithDuration:0.25 animations:^()
             {
                 self.mainCon.frame = CGRectMake(-self.sharedData.screenWidth, 0, self.sharedData.screenWidth * 3, self.sharedData.screenHeight - PHTabHeight);
             }];
        }

        //Invite friends
        else if(indexPath.row == 4)
        {
            [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Share App" withDict:@{@"origin":@"More"}];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_INVITE_FRIENDS"
                                                                object:nil];
            
            return;
        }
        
        //Email support
        else if(indexPath.row == 5)
        {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"SHOW_MAIL_MESSAGE"
             object:self];
            
            return;
        }
        
        //Log Out
        else if(indexPath.row == 6)
        {
            
            [[UserManager sharedManager] clearAllUserData];
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"SHOW_LOGIN"
             object:self];
            
            [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
            
            return;
        }
        
        //Confirmations
        else if([cell.textLabel.text isEqualToString:@"Confirmations"])
        {
            self.settingsPage.hidden = YES;
            self.hostingsPage.hidden = YES;
            self.purchasesPage.hidden = YES;
            self.confirmationsPage.hidden = NO;
            [self.confirmationsPage initClass];
            
            self.btnBack.hidden = NO;
            [UIView animateWithDuration:0.25 animations:^()
             {
                 self.mainCon.frame = CGRectMake(-self.sharedData.screenWidth, 0, self.sharedData.screenWidth * 3, self.sharedData.screenHeight - PHTabHeight);
             }];
        }
        
        //Hostings
        else if([cell.textLabel.text isEqualToString:@"Hostings"])
        {
            self.settingsPage.hidden = YES;
            self.hostingsPage.hidden = NO;
            self.purchasesPage.hidden = YES;
            self.confirmationsPage.hidden = YES;
            [self.hostingsPage initClass];
            
            self.btnBack.hidden = NO;
            [UIView animateWithDuration:0.25 animations:^()
             {
                 self.mainCon.frame = CGRectMake(-self.sharedData.screenWidth, 0, self.sharedData.screenWidth * 3, self.sharedData.screenHeight - PHTabHeight);
             }];
        }
        
        //Purchases
        else if([cell.textLabel.text isEqualToString:@"Purchases"])
        {
            self.settingsPage.hidden = YES;
            self.hostingsPage.hidden = YES;
            self.confirmationsPage.hidden = YES;
            self.purchasesPage.hidden = NO;
            [self.purchasesPage initClass];
            
            self.btnBack.hidden = NO;
            [UIView animateWithDuration:0.25 animations:^()
             {
                 self.mainCon.frame = CGRectMake(-self.sharedData.screenWidth, 0, self.sharedData.screenWidth * 3, self.sharedData.screenHeight - PHTabHeight);
             }];
        }

        //Phone Number
        else if([cell.textLabel.text isEqualToString:@"Phone Number"])
        {
            if([self.sharedData.phone length]>0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Phone Number" message:@"Change your phone number?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Change",nil];
                alert.tag = 1;
                [alert show];
                return;
            }
            else
            {
                self.sharedData.btnPhoneVerifyCancel.hidden = NO;
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"SHOW_PHONE_VERIFY"
                 object:self];
            }
            
        
        }
        
        
        else if([cell.textLabel.text isEqualToString:@"Turn On Push Notifications"])
        {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            //PushNotificationsCell
        }
        
        //Credit Card
        else if([cell.textLabel.text isEqualToString:@"Credit Card"])
        {
            if([self.sharedData.ccLast4 length]>0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Credit Card" message:@"Change your credit card?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Change",nil];
                alert.tag = 2;
                [alert show];
                return;
            }
            else
            {
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"SHOW_CREDIT_CARD"
                 object:self];
            }
        }
    }
    else if (indexPath.section==1) {
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
        
        UITableViewCell *hostCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        UITableViewCell *guestCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
        if (indexPath.row==0) {
            if (self.sharedData.isHost == NO) {
                [self.sharedData.eventsPage resetApp];
                guestCell.accessoryType = UITableViewCellAccessoryNone;
                hostCell.accessoryType = UITableViewCellAccessoryCheckmark;
                self.sharedData.account_type = @"host";
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Host Mode"
                                                                message:@"You are now in host mode."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                alert.tag = 0;
                [alert show];
            }
        }
        else if (indexPath.row==1) {
            if (self.sharedData.isGuest == NO) {
                [self.sharedData.eventsPage resetApp];
                guestCell.accessoryType = UITableViewCellAccessoryCheckmark;
                hostCell.accessoryType = UITableViewCellAccessoryNone;
                self.sharedData.account_type = @"guest";
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Guest Mode"
                                                                message:@"You are now in guest mode."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                alert.tag = 0;
                [alert show];
            }
        }
        return;
    }
 }

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 0) //Host/Guest mode change
    {
        [self saveSettings];
    }
    else if(alertView.tag == 1 && buttonIndex == 1) //Change phone
    {
        self.sharedData.btnPhoneVerifyCancel.hidden = NO;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"SHOW_PHONE_VERIFY"
         object:self];
    }
    else if(alertView.tag==2 && buttonIndex == 1) //Change CC
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"SHOW_CREDIT_CARD"
         object:self];
    }
}

#pragma mark - Navigation
-(void)goHome
{
    //self.btnBack.hidden = YES;
    [self.sharedData clearKeyBoards];
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.mainCon.frame = CGRectMake(0, 0, self.sharedData.screenWidth * SCREEN_LEVELS, self.sharedData.screenHeight - 60);
     }];
}

-(void)goProfile {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_PROFILE"
                                                        object:nil];
}

-(void)goEditProfile {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_EDIT_PROFILE"
                                                        object:nil];
}

-(void)goVerifyPhone {
    if([self.sharedData.phone length]>0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Phone Number" message:@"Change your phone number?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Change",nil];
        alert.tag = 1;
        [alert show];
        return;
    }
    else
    {
        self.sharedData.btnPhoneVerifyCancel.hidden = NO;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"SHOW_PHONE_VERIFY"
         object:self];
    }
}

-(void)goToHosting
{
    self.confirmationsPage.hidden = YES;
    self.settingsPage.hidden = YES;
    self.btnBack.hidden = NO;
    self.hostingsPage.hidden = NO;
    self.confirmationsPage.hidden = YES;
    [self.hostingsPage initClass];
    [self.hostingsPage loadHostingFromEvents];
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.mainCon.frame = CGRectMake(-self.sharedData.screenWidth, 0, self.sharedData.screenWidth * 3, self.sharedData.screenHeight - PHTabHeight);
     } completion:^(BOOL finished)
     {
         self.hostingsPage.btnAdd.hidden = YES;
     }];
}

-(void)goPrivacy
{
    self.privacyPage.hidden = NO;
    self.termsPage.hidden = YES;
    [self.privacyPage initClass];
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.mainCon.frame = CGRectMake(-self.sharedData.screenWidth * 2, 0, self.sharedData.screenWidth * 3, self.sharedData.screenHeight - PHTabHeight);
     }];
}

-(void)goTerms
{
    self.privacyPage.hidden = YES;
    self.termsPage.hidden = NO;
    [self.termsPage initClass];
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.mainCon.frame = CGRectMake(-self.sharedData.screenWidth * 2, 0, self.sharedData.screenWidth * 3, self.sharedData.screenHeight- PHTabHeight);
     }];
}

-(void)goPTBack
{
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.mainCon.frame = CGRectMake(-self.sharedData.screenWidth, 0, self.sharedData.screenWidth * 3, self.sharedData.screenHeight - PHTabHeight);
     }];
}

@end
