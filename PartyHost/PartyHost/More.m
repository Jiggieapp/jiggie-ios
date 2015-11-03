//
//  More.m
//  PartyHost
//
//  Created by Sunny Clark on 2/16/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "More.h"
#import "Feed.h"

#define SCREEN_LEVELS 3

@implementation More

#define SET_IF_NOT_NULL(TARGET, VAL) if(VAL && VAL != [NSNull null]) { TARGET = VAL; }else {TARGET = @"";}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    self.sharedData = [SharedData sharedInstance];
    
    //Set up data
    self.settingsData = [[NSMutableDictionary alloc] init];
    
    self.mainCon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width * SCREEN_LEVELS, frame.size.height)];
    //self.mainCon.layer.masksToBounds = YES;
    [self addSubview:self.mainCon];
    
    UIView *tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 60)];
    tabBar.backgroundColor = [UIColor phPurpleColor];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, frame.size.width, 40)];
    title.text = @"MORE";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont phBold:21];
    [tabBar addSubview:title];
    
    self.dataA = [[NSMutableArray alloc] init]; //Fill this out in initClass
    self.moreList = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, frame.size.width, frame.size.height - 60) style:UITableViewStyleGrouped];
    self.moreList.delegate = self;
    self.moreList.dataSource = self;
    self.moreList.allowsMultipleSelectionDuringEditing = NO;
    self.moreList.hidden = YES;
    self.moreList.backgroundColor = [UIColor phLightSilverColor];
    self.moreList.separatorColor = [UIColor phDarkGrayColor];
    [self.mainCon addSubview:self.moreList];
    
    self.profilePage = [[Profile alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth, 0, self.sharedData.screenWidth, frame.size.height)];
    //self.sharedData.profilePage  = self.profilePage;
    [self.mainCon addSubview:self.profilePage];
    
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
    self.btnBack.frame = CGRectMake(self.sharedData.screenWidth, 13, 50, 50);
    [self.btnBack setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [self.btnBack addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
    self.sharedData.morePageBtnBack = self.btnBack;
    
    self.btnPTBack = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnPTBack.frame = CGRectMake(self.sharedData.screenWidth * 2, 15, 50, 50);
    [self.btnPTBack setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [self.btnPTBack addTarget:self action:@selector(goPTBack) forControlEvents:UIControlEventTouchUpInside];
    
    //Create empty label
    self.labelEmpty = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.screenHeight)];
    self.labelEmpty.text = @"Please Try Again";
    self.labelEmpty.textAlignment = NSTextAlignmentCenter;
    self.labelEmpty.textColor = [UIColor lightGrayColor];
    self.labelEmpty.hidden = YES;
    self.labelEmpty.font = [UIFont phBlond:16];
    [self.mainCon addSubview:self.labelEmpty];
    
    //Add spinner to middle
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.frame = CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.screenHeight);
    self.spinner.hidden = NO;
    [self.mainCon addSubview:self.spinner];
    
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
    
    //Load settings now
    [self loadSettings];
}

-(void)checkIfGoBack
{
    /*
     if(self.mainCon.frame.origin.x != 0)
     {
     [self goBack];
     }
     */
}

-(void)goHome
{
    //self.btnBack.hidden = YES;
    [self.sharedData clearKeyBoards];
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.mainCon.frame = CGRectMake(0, 0, self.sharedData.screenWidth * SCREEN_LEVELS, self.sharedData.screenHeight - 60);
     }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 5;
    }else if (section==1) return 0;
    else if (section==2) return 1;
    else return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(self.sharedData.isHost)
        {
            if(indexPath.row==3 || indexPath.row==4) return 50.0;
        }
    }
    else if(indexPath.section == 1)
    {
        return 72.0;
    }
    
    return 50.0;
}

//This leaves the bottom blank
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == tableView.numberOfSections - 1) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 100)];
    }
    return nil;
}

//This leaves the bottom blank
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section==0)
    {
        if (indexPath.row==0)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"MyProfileCell"];
            if (cell == nil) {cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyProfileCell"];}
            cell.textLabel.font = [UIFont phBlond:19];
            cell.textLabel.text = @"Profile";
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            UserBubble *userBubble = [[UserBubble alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth - 32 - 16, 50/2 - 32/2, 32, 32)];
            [userBubble setName:self.sharedData.userDict[@"first_name"] lastName:nil];
            [userBubble loadFacebookImage:self.sharedData.fb_id];
            [cell addSubview:userBubble];
        } else if(indexPath.row==12)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"MyPurchasesCell"];
            if (cell == nil) {cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyPurchasesCell"];}
            cell.textLabel.font = [UIFont phBlond:19];
            cell.textLabel.text = @"Purchases";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if(indexPath.row==1)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"PhoneVerificationCell"];
            if (cell == nil) {cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PhoneVerificationCell"];}
            cell.textLabel.font = [UIFont phBlond:19];
            cell.textLabel.text = @"Phone Number";
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            if([self.sharedData.phone length]>0) cell.detailTextLabel.text = [NSString stringWithFormat:@"+%@",self.sharedData.phone];//[Constants formatPhoneNumber:self.sharedData.phone];
            else cell.detailTextLabel.text = @"N/A";
            
            cell.detailTextLabel.font = [UIFont phBold:16];
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
            cell.detailTextLabel.textColor = [UIColor phPurpleColor];
        }
        else if(indexPath.row==32)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"CreditCardCell"];
            if (cell == nil) {cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CreditCardCell"];}
            cell.textLabel.font = [UIFont phBlond:19];
            cell.textLabel.text = @"Credit Card";;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.detailTextLabel.font = [UIFont phBlond:16];
            
            if([self.sharedData.ccLast4 length]>0) cell.detailTextLabel.text = [NSString stringWithFormat:@"•••• %@",self.sharedData.ccLast4];
            else cell.detailTextLabel.text = @"N/A";
            
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
            cell.detailTextLabel.textColor = [UIColor colorFromHexCode:@"5C5C5C"];
        }
        else if(indexPath.row==2)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"InviteFriendsCell"];
            if (cell == nil) {cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InviteFriendsCell"];}
            cell.textLabel.font = [UIFont phBlond:19];
            cell.textLabel.text = @"Invite Friends";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else if(indexPath.row==3)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"EmailSupportCell"];
            if (cell == nil) {cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EmailSupportCell"];}
            cell.textLabel.font = [UIFont phBlond:19];
            cell.textLabel.text = @"Email Support";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else if(indexPath.row==4)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell"];
            if (cell == nil) {cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingsCell"];}
            cell.textLabel.font = [UIFont phBlond:19];
            cell.textLabel.text = @"Settings";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if(indexPath.row==5)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"PushNotificationsCell"];
            if (cell == nil) {cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PushNotificationsCell"];}
            cell.textLabel.font = [UIFont phBlond:19];
            cell.textLabel.text = @"Turn On Push Notifications";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        
        
        
        //Host
        /*
        else if(self.sharedData.isHost)
        {
            if(indexPath.row==100)
            {
                
                //cell = [tableView dequeueReusableCellWithIdentifier:@"MyHostingsCell"];
                //if (cell == nil) {cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyHostingsCell"];}
                //cell.textLabel.font = [UIFont phBlond:19];
                //cell.textLabel.text = @"Hostings";
                //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         
            }
            else if(indexPath.row==1)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"MyPurchasesCell"];
                if (cell == nil) {cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyPurchasesCell"];}
                cell.textLabel.font = [UIFont phBlond:19];
                cell.textLabel.text = @"Purchases";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else if(indexPath.row==2)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"PhoneVerificationCell"];
                if (cell == nil) {cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PhoneVerificationCell"];}
                cell.textLabel.font = [UIFont phBlond:19];
                cell.textLabel.text = @"Phone Number";
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                if([self.sharedData.phone length]>0) cell.detailTextLabel.text = [Constants formatPhoneNumber:self.sharedData.phone];
                else cell.detailTextLabel.text = @"N/A";
                
                cell.detailTextLabel.font = [UIFont phBlond:16];
                cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
                cell.detailTextLabel.textColor = [UIColor colorFromHexCode:@"5C5C5C"];
            }
            else if(indexPath.row==3)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"CreditCardCell"];
                if (cell == nil) {cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CreditCardCell"];}
                cell.textLabel.font = [UIFont phBlond:19];
                cell.textLabel.text = @"Credit Card";;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.detailTextLabel.font = [UIFont phBlond:16];

                if([self.sharedData.ccLast4 length]>0) cell.detailTextLabel.text = [NSString stringWithFormat:@"•••• %@",self.sharedData.ccLast4];
                else cell.detailTextLabel.text = @"N/A";
                
                cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
                cell.detailTextLabel.textColor = [UIColor colorFromHexCode:@"5C5C5C"];
            }
            else if(indexPath.row==4)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"InviteFriendsCell"];
                if (cell == nil) {cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InviteFriendsCell"];}
                cell.textLabel.font = [UIFont phBlond:19];
                cell.textLabel.text = @"Invite Friends";
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            else if(indexPath.row==5)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"EmailSupportCell"];
                if (cell == nil) {cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EmailSupportCell"];}
                cell.textLabel.font = [UIFont phBlond:19];
                cell.textLabel.text = @"Email Support";
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            else if(indexPath.row==6)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell"];
                if (cell == nil) {cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingsCell"];}
                cell.textLabel.font = [UIFont phBlond:19];
                cell.textLabel.text = @"Settings";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        
        //Guest
        else
        {
            if(indexPath.row==1)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"MyConfirmationsCell"];
                if (cell == nil) {cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyConfirmationsCell"];}
                cell.textLabel.font = [UIFont phBlond:19];
                cell.textLabel.text = @"Confirmations";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else if(indexPath.row==2)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"InviteFriendsCell"];
                if (cell == nil) {cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InviteFriendsCell"];}
                cell.textLabel.font = [UIFont phBlond:19];
                cell.textLabel.text = @"Invite Friends";
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            else if(indexPath.row==3)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"EmailSupportCell"];
                if (cell == nil) {cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EmailSupportCell"];}
                cell.textLabel.font = [UIFont phBlond:19];
                cell.textLabel.text = @"Email Support";
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            else if(indexPath.row==4)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell"];
                if (cell == nil) {cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingsCell"];}
                cell.textLabel.font = [UIFont phBlond:19];
                cell.textLabel.text = @"Settings";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        */
    }
    else if (indexPath.section==1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"HostGuestCell"];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HostGuestCell"];
            cell.detailTextLabel.textColor = [UIColor colorFromHexCode:@"5C5C5C"];
            cell.textLabel.font = [UIFont phBlond:19];
            cell.detailTextLabel.font = [UIFont phBlond:12];
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
    else if (indexPath.section==2)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"LogOutCell"];
        if (cell == nil) {cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LogOutCell"];}
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.font = [UIFont phBlond:19];
        cell.textLabel.text = @"Log Out";
    }
    
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Change role
    if (indexPath.section==0) {
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        //My profile
        if([cell.textLabel.text isEqualToString:@"Profile"])
        {
            self.settingsPage.hidden = YES;
            self.hostingsPage.hidden = YES;
            self.confirmationsPage.hidden = YES;
            self.purchasesPage.hidden = YES;
            
            self.profilePage.hidden = NO;
            [self.profilePage initClass];
            
            self.btnBack.hidden = NO;
            [UIView animateWithDuration:0.25 animations:^()
             {
                 self.mainCon.frame = CGRectMake(-self.sharedData.screenWidth, 0, self.sharedData.screenWidth * 3, self.sharedData.screenHeight - PHTabHeight);
             }];
        }
        
        //Invite friends
        else if([cell.textLabel.text isEqualToString:@"Invite Friends"])
        {
            [self.sharedData trackMixPanelWithDict:@"Share App" withDict:@{@"origin":@"More"}];
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"SHOW_GENERAL_INVITE"
             object:self];
            
            return;
        }
        
        //Email support
        else if([cell.textLabel.text isEqualToString:@"Email Support"])
        {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"SHOW_MAIL_MESSAGE"
             object:self];
            
            return;
        }
        
        //Settings
        else if([cell.textLabel.text isEqualToString:@"Settings"])
        {
            self.settingsPage.hidden = NO;
            self.profilePage.hidden = YES;
            self.hostingsPage.hidden = YES;
            self.confirmationsPage.hidden = YES;
            [self.settingsPage initClass];
            
            self.btnBack.hidden = NO;
            [UIView animateWithDuration:0.25 animations:^()
             {
                 self.mainCon.frame = CGRectMake(-self.sharedData.screenWidth, 0, self.sharedData.screenWidth * 3, self.sharedData.screenHeight - PHTabHeight);
             }];
        }
        
        //Confirmations
        else if([cell.textLabel.text isEqualToString:@"Confirmations"])
        {
            self.settingsPage.hidden = YES;
            self.profilePage.hidden = YES;
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
            self.profilePage.hidden = YES;
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
            self.profilePage.hidden = YES;
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
                [self.sharedData.feedPage forceReload];
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
                [self.sharedData.feedPage forceReload];
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
    else if(indexPath.section==2) //Logout
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"SHOW_LOGIN"
         object:self];
        
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
        
        return;
    }
 }


-(void)goToHosting
{
    self.confirmationsPage.hidden = YES;
    self.profilePage.hidden = YES;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Options";
            break;
        case 1:
            sectionName = @"";
            break;
        case 2:
            sectionName = @"Log Out";
            break;
    }
    return sectionName;
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

-(void)loadSettings
{
    //Start spinner
    if(!self.isLoaded)
    {
        self.spinner.hidden = NO;
        self.labelEmpty.hidden = YES;
        [self.spinner startAnimating];
    }
    
    NSString *facebookId = [self.sharedData.userDict objectForKey:@"fb_id"];
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSDictionary *params = @{ @"fb_id" : facebookId };
    NSString *url = [Constants memberSettingsURL];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"SETTINGS responseObject :: %@",responseObject);
         
         [self.sharedData trackMixPanelWithDict:@"View Settings" withDict:@{}];
         
         //Check if already equal
         if([self.settingsData isEqualToDictionary:responseObject])
         {
             NSLog(@"SETTINGS responseObject SAME");
             
             self.spinner.hidden = YES;
             [self.spinner stopAnimating];
             return;
         }
         
         //Clear table
         self.settingsData = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
         
         //Load data
         [self.sharedData loadSettingsResponse:responseObject];
         
         //Reload table view
         self.isLoaded = YES;
         
         //Update table
         [self updateTable];
         
         //Hide spinner
         self.spinner.hidden = YES;
         self.labelEmpty.hidden = YES;
         [self.spinner stopAnimating];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //self.spinner.hidden = YES;
         //self.labelEmpty.hidden = NO;
         //[self.spinner stopAnimating];
         
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


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = [UIFont phBold:12];
    header.backgroundView.backgroundColor = [UIColor clearColor];
    [header.textLabel setTextColor:[UIColor blackColor]];
}

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

@end
