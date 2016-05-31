//
//  Settings.m
//  PartyHost
//
//  Created by Tony Suriyathep on 4/14/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "Settings.h"
#import "FeedView.h"
#import "UserManager.h"

@implementation Settings

#define SET_IF_NOT_NULL(TARGET, VAL) if(VAL && VAL != [NSNull null]) { TARGET = VAL; }else {TARGET = @"";}

#pragma mark - Object Lifecycle
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    self.sharedData = [SharedData sharedInstance];
    self.isLoaded = NO;
    
    self.mainCon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width * 2, frame.size.height)];
    [self addSubview:self.mainCon];
    
    UIView *tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 60)];
    tabBar.backgroundColor = [UIColor phPurpleColor];
    [self.mainCon addSubview:tabBar];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, frame.size.width, 40)];
    title.text = @"Settings";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont phBlond:16];
    [tabBar addSubview:title];
    
    self.settingsList = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, frame.size.width, frame.size.height - 60) style:UITableViewStyleGrouped];
    self.settingsList.delegate = self;
    self.settingsList.dataSource = self;
    self.settingsList.allowsMultipleSelectionDuringEditing = NO;
    self.settingsList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.settingsList.backgroundColor = [UIColor phLightSilverColor];
    self.settingsList.separatorColor = [UIColor phDarkGrayColor];
    [self.mainCon addSubview:self.settingsList];
    
    return self;
}

-(void)initClass
{
    [self.settingsList setContentOffset:CGPointZero animated:NO];
    [self.settingsList reloadData];
}

#pragma mark - Methods
-(void)loadSettings
{
    //Start spinner
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    self.isLoaded = NO;
    
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
                 [self.settingsList reloadData];

             }
             @catch (NSException *exception) {
                 
             }
             @finally {
                 
             }
         });
         
         //Hide spinner
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR :: %@",error);
     }];
}

-(void)notificationPartyFeedChanged:(id)sender
{
    UISwitch* switchControl = sender;
    self.sharedData.notification_feed = switchControl.on;
    [self.sharedData saveSettingsResponse];
    [self saveSettings];
}


-(void)notificationChatMessagesChanged:(id)sender
{
    UISwitch* switchControl = sender;
    self.sharedData.notification_messages = switchControl.on;
    [self.sharedData saveSettingsResponse];
    [self saveSettings];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self saveSettings];
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
         
         //Reload table view
         [self.settingsList reloadData];
         
         //Hide spinner
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR :: %@",error);
     }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if([appDelegate notificationServicesEnabled])
        {
            return 2;
        }else{
            return 3;
        }
        
    }
    else if (section==1) {
        return 1;
    }
    else if (section==2) {
        return 2;
    }
    else if (section==3) {
        return 1;
    }
    return 0;
}

//This leaves the bottom blank
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == tableView.numberOfSections - 1) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    }
    return nil;
}

//This leaves the bottom blank
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == tableView.numberOfSections - 1) {
        return 100;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Notifications";
            break;
        case 1:
            sectionName = @"Gender Interest";
            break;
        case 2:
            sectionName = @"Documents";
            break;
    }
    
    
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40.0)];
    // Add the label
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0, 10.0, tableView.bounds.size.width - 20, 30.0)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.text = sectionName;
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.font = [UIFont phBold:13];
    [headerView addSubview: headerLabel];
    
    // Return the headerView
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) //Notifications
    {
        
        if (indexPath.row==2)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DocumentsCell"];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DocumentsCell"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.textColor = [UIColor darkGrayColor];
                cell.textLabel.font = [UIFont phBlond:17];
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            cell.textLabel.text = @"Turn On Push Notifications";
            return cell;
            
            
        }else{
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsSwitch"];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingsSwitch"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
                [switchView setOnTintColor:[UIColor phPurpleColor]];
                cell.accessoryView = switchView;
                cell.backgroundColor = [UIColor whiteColor];
                cell.textLabel.textColor = [UIColor darkGrayColor];
                cell.textLabel.font = [UIFont phBlond:17];
            }
            
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            if(![appDelegate notificationServicesEnabled])
            {
                cell.userInteractionEnabled = NO;
                cell.alpha = cell.textLabel.alpha = 0.15;
                UISwitch *switchView = (UISwitch*)cell.accessoryView;
                switchView.hidden = YES;
            }else{
                UISwitch *switchView = (UISwitch*)cell.accessoryView;
                switchView.hidden = NO;
                cell.alpha = cell.textLabel.alpha = 1;
                cell.userInteractionEnabled = YES;
            }
            
            if (indexPath.row==0)
            {
                cell.textLabel.text = @"Social Feed";
                UISwitch *switchView = (UISwitch*)cell.accessoryView;
                [switchView setOn:self.sharedData.notification_feed animated:NO];
                [switchView addTarget:self action:@selector(notificationPartyFeedChanged:) forControlEvents:UIControlEventValueChanged];
                return cell;
            }
            else if (indexPath.row==1)
            {
                cell.textLabel.text = @"Chat Messages";
                UISwitch *switchView = (UISwitch*)cell.accessoryView;
                [switchView setOn:self.sharedData.notification_messages animated:NO];
                [switchView addTarget:self action:@selector(notificationChatMessagesChanged:) forControlEvents:UIControlEventValueChanged];
                return cell;
            }
            
        }
    }
    else if (indexPath.section==2) //Documents
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DocumentsCell"];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DocumentsCell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.textLabel.font = [UIFont phBlond:17];
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        if(indexPath.row==0)
        {
            cell.textLabel.text = @"Privacy Policy";
            return cell;
        }
        else if(indexPath.row==1)
        {
            cell.textLabel.text = @"Terms of Use";
            return cell;
        }
    }
    else if (indexPath.section==1) //Preferences
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GenderPreference"];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"GenderPreference"];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.textLabel.font = [UIFont phBlond:17];
            cell.backgroundColor = [UIColor whiteColor];
            cell.detailTextLabel.font = [UIFont phBold:14];
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
            cell.detailTextLabel.textColor = [UIColor phPurpleColor];
        }
        
        if(indexPath.row==1)
        {
            cell.textLabel.text = @"I am a";
            if([self.sharedData.gender isEqualToString:@"female"])
            {
                cell.detailTextLabel.text = @"Woman";
            } else if([self.sharedData.gender isEqualToString:@"male"]) {
                cell.detailTextLabel.text = @"Man";
            }else{
                cell.detailTextLabel.text = @"Both";
            }
            return cell;
        }
        else if(indexPath.row==0)
        {
            cell.textLabel.text = @"Interested in meeting";
            [cell.textLabel sizeToFit];
            if([self.sharedData.gender_interest isEqualToString:@"female"])
            {
                cell.detailTextLabel.text = @"Women";
            } else if([self.sharedData.gender_interest isEqualToString:@"male"]) {
                cell.detailTextLabel.text = @"Men";
            } else {
                cell.detailTextLabel.text = @"Both";
            }
            
            return cell;
        }
    }
    else if (indexPath.section==3) //Logout
    {
        if(indexPath.row==0)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeleteAccountCell"];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DeleteAccountCell"];
                cell.textLabel.font = [UIFont phBlond:17];
                cell.textLabel.textColor = [UIColor redColor];
                cell.textLabel.text = @"Delete Account";
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.backgroundColor = [UIColor whiteColor];
            }
            return cell;
        }
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0 && indexPath.row==2)
    {
        if (&UIApplicationOpenSettingsURLString != NULL) {
            NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:appSettings];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General"]];
        }
        
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
    
    
    if (indexPath.section==2)
    {
        if(indexPath.row == 0)
        {
            [self.sharedData.morePage goPrivacy];
        }
        
        if(indexPath.row == 1)
        {
            [self.sharedData.morePage goTerms];
        }
        
        self.sharedData.morePage.btnBack.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^()
         {
             //self.mainCon.frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width * 2, self.frame.size.height);
         }];
    }
    else if (indexPath.section==1) //Gender
    {
        //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(indexPath.row==1)
        {
            if([self.sharedData.gender isEqualToString:@"female"]) {
                self.sharedData.gender = @"male";
                //self.sharedData.gender_interest = @"female";
            } else {
                self.sharedData.gender = @"female";
                //self.sharedData.gender_interest = @"male";
            }
            [self saveSettings];
        } else if(indexPath.row==0) {
            if([self.sharedData.gender_interest isEqualToString:@"female"]) {
                self.sharedData.gender_interest = @"male";
                //self.sharedData.gender = @"female";
            } else if([self.sharedData.gender_interest isEqualToString:@"male"]){
                self.sharedData.gender_interest = @"both";
                //self.sharedData.gender = @"male";
            }else {
                self.sharedData.gender_interest = @"female";
                //self.sharedData.gender = @"male";
            }
        }
        
        [self.sharedData saveSettingsResponse];
        [self.settingsList reloadData];
        [self.sharedData.eventsPage resetApp];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"EVENTS_GO_HOME"
         object:self];
        
        //Start spinner
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"SHOW_LOADING"
         object:self];
        [self.sharedData.feedPage loadDataAndShowHUD:NO withCompletionHandler:^(NSArray *feeds, NSInteger statusCode, NSError *error) {
            //Hide spinner
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"HIDE_LOADING"
             object:self];
        }];
        
        [self saveSettings];
    }
    else if (indexPath.section==3) //Delete
    {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Delete Account"
                                message:@"Are you really sure?"
                               delegate:nil
                      cancelButtonTitle:@"NO"
                      otherButtonTitles:@"YES",nil];
        [alert show];
    }
    
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

@end


