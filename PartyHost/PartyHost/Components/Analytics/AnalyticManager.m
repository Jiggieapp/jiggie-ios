//
//  AnalyticManager.m
//  Jiggie
//
//  Created by Setiady Wiguna on 12/14/15.
//  Copyright © 2015 Sunny Clark. All rights reserved.
//

#import "AnalyticManager.h"
#import <AdSupport/ASIdentifierManager.h>
#import "Mixpanel.h"
#import "AppsFlyerTracker.h"

@implementation AnalyticManager

static AnalyticManager *_sharedManager = nil;

+ (AnalyticManager *)sharedManager {
    @synchronized([AnalyticManager class])
    {
        if (!_sharedManager) {
            _sharedManager = [[AnalyticManager alloc] init];
        }
        return _sharedManager;
    }
    
    return nil;
}

#pragma mark - Start
- (void)startAnalytics {
    NSString *idfaString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = AppsFlyerDevKey;
    [AppsFlyerTracker sharedTracker].appleAppID = JiggieItunesID;
    [AppsFlyerTracker sharedTracker].customerUserID = idfaString;
    
    [Mixpanel sharedInstanceWithToken:MixpanelDevKey];
    
    self.sharedData = [SharedData sharedInstance];
}

#pragma mark - MixPanel
-(void)trackMixPanel:(NSString *)eventName
{
    /*
     if(PHMixPanelOn==NO) return;
     
     @{
     @"user_first_name": userFirstName,
     @"user_last_name": userLastName,
     @"fb_id" : facebookId,
     @"userId": userId,
     @"gender": gender,
     @"birthday": birthday,
     @"location": location,
     @"created_at":created_at,
     @"invited_by":invited_by,
     @"media_source":media_source,
     @"campaign":campaign
     };
     */
    /*
     NSMutableDictionary *dict;
     
     NSString *media_source = self.appsFlyerDict[@"media_source"];
     NSString *campaign = self.appsFlyerDict[@"campaign"];
     NSString *installType = self.appsFlyerDict[@"af_status"];
     
     if(self.isLoggedIn)
     {
     
     
     NSString *facebookId = [self.userDict objectForKey:@"fb_id"];
     NSString *userId = self.user_id;
     NSString *userFirstName = [self.userDict objectForKey:@"first_name"];
     NSString *userLastName = [self.userDict objectForKey:@"last_name"];
     //NSString *gender = [self.userDict objectForKey:@"gender"];
     NSString *email = [self.userDict objectForKey:@"email"];
     NSString *birthday = self.userDict[@"birthday"];
     NSString *location = [self.userDict[@"location"] lowercaseString];
     
     userFirstName = [userFirstName lowercaseString];
     userLastName = [userLastName lowercaseString];
     
     dict = [[NSMutableDictionary alloc] init];
     
     dict[@"user_first_name"] = userFirstName;
     dict[@"user_last_name"] = userLastName;
     dict[@"fb_id"] = facebookId;
     dict[@"user_id"] = userId;
     //dict[@"gender"] = gender;
     dict[@"birthday"] = birthday;
     dict[@"location"] = location;
     dict[@"email"] = email;
     dict[@"gender"] = self.gender; //Should this be included?
     dict[@"gender_interest"] = self.gender_interest; //Should this be included?
     
     //"host" or "guest"
     if(self.account_type)
     {
     dict[@"account_type"] = self.account_type;
     }
     
     //Calculate birthday, string must be in correct format and length
     if([birthday length]==10)
     {
     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
     [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
     [formatter setDateFormat:@"MM/dd/yyyy"];
     NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
     components:NSCalendarUnitYear
     fromDate:[formatter dateFromString:birthday]
     toDate:[NSDate date]
     options:0];
     int age = (int)[ageComponents year];
     if(age>0) {dict[@"age"] = [NSString stringWithFormat: @"%d", age];} //Sanity check
     }
     
     //Campaign
     if(media_source)
     {
     dict[@"media_source"] = media_source;
     dict[@"campaign"] = campaign;
     dict[@"install_type"] = installType;
     }
     
     dict[@"os_version"] = [UIDevice currentDevice].systemVersion;
     dict[@"device_type"] = self.deviceType;
     
     }else{
     dict = [[NSMutableDictionary alloc] init];
     if(media_source)
     {
     dict[@"media_source"] = media_source;
     dict[@"campaign"] = campaign;
     dict[@"install_type"] = installType;
     }
     
     dict[@"os_version"] = [UIDevice currentDevice].systemVersion;
     dict[@"device_type"] = self.deviceType;
     }
     
     NSLog(@"TRACKING_MIX_PANEL=======>");
     NSLog(@"%@",eventName);
     NSLog(@"TRACKING_MIX_PANEL_WITH_DATA");
     NSLog(@"%@",dict);
     NSLog(@"TRACKING_MIX_PANEL=======>");
     
     Mixpanel *mixpanel = [Mixpanel sharedInstance];
     [mixpanel track:eventName properties:dict];
     
     */
}

/*
 
 NSString *media_source = self.appsFlyerDict[@"media_source"];
 NSString *campaign = self.appsFlyerDict[@"campaign"];
 NSString *installType = self.appsFlyerDict[@"af_status"];
 
 NSString *facebookId = [self.userDict objectForKey:@"fb_id"];
 NSString *userId = self.user_id;
 NSString *userFirstName = [self.userDict objectForKey:@"first_name"];
 NSString *userLastName = [self.userDict objectForKey:@"last_name"];
 //NSString *gender = [self.userDict objectForKey:@"gender"];
 NSString *email = [self.userDict objectForKey:@"email"];
 NSString *birthday = self.userDict[@"birthday"];
 NSString *location = [self.userDict[@"location"] lowercaseString];
 
 userFirstName = [userFirstName lowercaseString];
 userLastName = [userLastName lowercaseString];
 
 NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
 
 dict[@"user_first_name"] = userFirstName;
 dict[@"user_last_name"] = userLastName;
 dict[@"fb_id"] = facebookId;
 dict[@"user_id"] = userId;
 //dict[@"gender"] = gender;
 dict[@"birthday"] = birthday;
 dict[@"location"] = location;
 dict[@"email"] = email;
 dict[@"gender"] = self.gender; //Should this be included?
 dict[@"gender_interest"] = self.gender_interest; //Should this be included?
 
 //"host" or "guest"
 if(self.account_type)
 {
 dict[@"account_type"] = self.account_type;
 }
 
 //Calculate birthday, string must be in correct format and length
 if([birthday length]==10)
 {
 NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
 [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
 [formatter setDateFormat:@"MM/dd/yyyy"];
 NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
 components:NSCalendarUnitYear
 fromDate:[formatter dateFromString:birthday]
 toDate:[NSDate date]
 options:0];
 int age = (int)[ageComponents year];
 if(age>0) {dict[@"age"] = [NSString stringWithFormat: @"%d", age];} //Sanity check
 }
 
 //Campaign
 if(media_source)
 {
 dict[@"media_source"] = media_source;
 dict[@"campaign"] = campaign;
 dict[@"install_type"] = installType;
 }
 
 dict[@"os_version"] = [UIDevice currentDevice].systemVersion;
 dict[@"device_type"] = self.deviceType;
 */

/*
 Mixpanel *mixpanel = [Mixpanel sharedInstance];
 
 // Send a "User Type: Paid" property will be sent
 // with all future track calls.
 [mixpanel registerSuperProperties:@{@"User Type": @"Paid"}];
 */


-(void)setMixPanelOnSignUp
{
    if(PHMixPanelOn==NO) return;
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel createAlias:[self.sharedData.userDict objectForKey:@"fb_id"] forDistinctID:mixpanel.distinctId];
    //[mixpanel identify:mixpanel.distinctId];
}

-(void)setMixPanelOnLogin
{
    if(PHMixPanelOn==NO) return;
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    //[mixpanel createAlias:[self.userDict objectForKey:@"fb_id"] forDistinctID:mixpanel.distinctId];
    [mixpanel identify:self.sharedData.fb_id];
}

-(void)setMixPanelSuperProperties
{
    if(PHMixPanelOn==NO) return;
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel identify:self.sharedData.fb_id];
    NSString *location = [self.sharedData.userDict[@"location"] lowercaseString];
    NSString *birthday = self.sharedData.userDict[@"birthday"];
    NSString *age = @"";
    NSString *first_name = [self.sharedData.userDict objectForKey:@"first_name"];
    NSString *last_name = [self.sharedData.userDict objectForKey:@"last_name"];
    NSString *email = [self.sharedData.userDict objectForKey:@"email"];
    
    
    if([birthday length]==10)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                           components:NSCalendarUnitYear
                                           fromDate:[formatter dateFromString:birthday]
                                           toDate:[NSDate date]
                                           options:0];
        int num_age = (int)[ageComponents year];
        if(num_age>0) {age = [NSString stringWithFormat: @"%d", num_age];} //Sanity check
    }
    
    [mixpanel registerSuperProperties:@{@"age": age}];
    //[mixpanel registerSuperProperties:@{@"account_type": self.account_type}];
    [mixpanel registerSuperProperties:@{@"gender": [SharedData sharedInstance].gender}];
    [mixpanel registerSuperProperties:@{@"gender_interest": [SharedData sharedInstance].gender_interest}];
    [mixpanel registerSuperProperties:@{@"os_version": [UIDevice currentDevice].systemVersion}];
    [mixpanel registerSuperProperties:@{@"device_type": [SharedData sharedInstance].deviceType}];
    [mixpanel registerSuperProperties:@{@"location": location}];
    [mixpanel registerSuperProperties:@{@"app_version":PHVersion}];
    [mixpanel registerSuperProperties:@{@"email":email}];
    
    
    [mixpanel registerSuperProperties:@{@"first_name": first_name}];
    [mixpanel registerSuperProperties:@{@"last_name": last_name}];
    [mixpanel registerSuperProperties:@{@"birthday": birthday}];
    
    
    NSString *facebookId = [self.sharedData.userDict objectForKey:@"fb_id"];
    
    [mixpanel registerSuperProperties:
     @{@"name_and_fb_id": [NSString stringWithFormat:@"%@_%@_%@",first_name,last_name,facebookId]}];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    //[dict setObject:self.account_type forKey:@"account_type"];
    [dict setObject:[SharedData sharedInstance].gender forKey:@"gender"];
    [dict setObject:[SharedData sharedInstance].gender_interest forKey:@"gender_interest"];
    [dict setObject:[UIDevice currentDevice].systemVersion forKey:@"os_version"];
    [dict setObject:[SharedData sharedInstance].deviceType forKey:@"device_type"];
    [dict setObject:location forKey:@"location"];
    [dict setObject:PHVersion forKey:@"app_version"];
    
    
    
    [dict setObject:first_name forKey:@"first_name"];
    [dict setObject:last_name forKey:@"last_name"];
    [dict setObject:birthday forKey:@"birthday"];
    [dict setObject:email forKey:@"email"];
    [dict setObject:location forKey:@"location"];
    [dict setObject:age forKey:@"age"];
    [dict setObject:facebookId forKey:@"fb_id"];
    [dict setObject:PHVersion forKey:@"app_version"];
    [dict setObject:[NSString stringWithFormat:@"%@_%@_%@",first_name,last_name,facebookId] forKey:@"name_and_fb_id"];
    
    [self.sharedData syncSuperPropertiesOnServer:dict];
}

-(void)setMixPanelUserProfile
{
    if(PHMixPanelOn==NO) return;
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel identify:[SharedData sharedInstance].fb_id];
    
    NSString *first_name = [self.sharedData.userDict objectForKey:@"first_name"];
    NSString *last_name = [self.sharedData.userDict objectForKey:@"last_name"];
    NSString *birthday = self.sharedData.userDict[@"birthday"];
    NSString *age = @"";
    NSString *email = [self.sharedData.userDict objectForKey:@"email"];
    
    NSString *facebookId = [self.sharedData.userDict objectForKey:@"fb_id"];
    
    if([birthday length]==10)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                           components:NSCalendarUnitYear
                                           fromDate:[formatter dateFromString:birthday]
                                           toDate:[NSDate date]
                                           options:0];
        int num_age = (int)[ageComponents year];
        if(num_age>0) {age = [NSString stringWithFormat: @"%d", num_age];} //Sanity check
    }
    
    [mixpanel.people set:@{@"first_name": first_name}];
    [mixpanel.people set:@{@"last_name": last_name}];
    [mixpanel.people set:@{@"birthday": birthday}];
    [mixpanel.people set:@{@"age": age}];
    [mixpanel.people set:@{@"email": email}];
    [mixpanel.people set:@{@"fb_id": facebookId}];
    [mixpanel.people set:@{@"gender": self.sharedData.gender}];
    [mixpanel.people set:@{@"gender_interest": self.sharedData.gender_interest}];
    [mixpanel.people set:@{@"app_version": PHVersion}];
    [mixpanel.people set:@{@"name_and_fb_id": [NSString stringWithFormat:@"%@_%@_%@",first_name,last_name,facebookId]}];
}


-(void)setMixPanelOnceParams
{
    if(PHMixPanelOn==NO) return;
    
    @try {
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel identify:self.sharedData.fb_id];
        NSString *media_source = self.sharedData.appsFlyerDict[@"media_source"];
        NSString *campaign = self.sharedData.appsFlyerDict[@"campaign"];
        NSString *installType = self.sharedData.appsFlyerDict[@"af_status"];
        
        
        [mixpanel registerSuperPropertiesOnce:@{@"AFmedia_source": media_source}];
        [mixpanel registerSuperPropertiesOnce:@{@"AFcampaign": campaign}];
        [mixpanel registerSuperPropertiesOnce:@{@"AFinstall_type": installType}];
        
        
        [mixpanel.people set:@{@"AFmedia_source": media_source}];
        [mixpanel.people set:@{@"AFcampaign": campaign}];
        [mixpanel.people set:@{@"AFinstall_type": installType}];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

-(void)trackMixPanelIncrementWithDict:(NSDictionary *)dict
{
    if(PHMixPanelOn==NO) return;
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel identify:self.sharedData.fb_id];
    
    [mixpanel.people increment:dict];
    
    /*
     [mixpanel.people increment:@{
     @"dollars spent": @17,
     @"credits remaining": @-34
     }];
     */
}

-(void)trackMixPanelIncrementWithEventDict:(NSDictionary *)eventDict
{
    if(PHMixPanelOn==NO) return;
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel identify:self.sharedData.fb_id];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict addEntriesFromDictionary:[mixpanel currentSuperProperties]];
}

-(void)trackMixPanelWithDict:(NSString *)eventName withDict:(NSDictionary *)dict
{
    if(PHMixPanelOn==NO) return;
    NSLog(@"TRACKING_EVENT :: %@",eventName);
    NSLog(@"WITH_INFO :: %@",dict);
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:eventName properties:dict];
}

-(void)createMixPanelDummyProfile
{
    if(PHMixPanelOn==NO) return;
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel identify:@"dummy123"];
    
    [mixpanel.people set:@{@"first_name": @"orphan_user"}];
    [mixpanel.people set:@{@"last_name": @"orphan_user"}];
    [mixpanel.people set:@{@"email": @"orphanuser@tfbnw.net"}];
    [mixpanel.people set:@{@"fb_id": @"orphan"}];
    
}

@end
