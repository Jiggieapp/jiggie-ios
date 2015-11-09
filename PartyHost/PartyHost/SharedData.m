//
//  SharedData.m
//  PartyHost
//
//  Created by Sunny Clark on 12/26/14.
//  Copyright (c) 2014 Sunny Clark. All rights reserved.
//

#import "SharedData.h"

#import "NWURLConnection.h"

@implementation SharedData


static SharedData *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (SharedData *)sharedInstance
{
    if (sharedInstance == nil)
    {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}


- (id)init
{
    self = [super init];
    if (self)
    {
        self.apnToken   =   @"";
        self.toImgURL   =   @"";
        self.userDict   =   [[NSMutableDictionary alloc] init];
        self.photosDict =   [[NSMutableDictionary alloc] init];
        self.imagesDict =   [[NSMutableDictionary alloc] init];
        self.venuesNameList =   [[NSMutableArray alloc] init];
        self.keyboardsA     =   [[NSMutableArray alloc] init];
        self.appsFlyerDict  = [[NSMutableDictionary alloc] init];
        self.memberProfileDict  = [[NSMutableDictionary alloc] init];
        self.selectedHost = [[NSMutableDictionary alloc] init];
        self.selectedEvent = [[NSMutableDictionary alloc] init];
        self.messagesPage = nil;
        self.profilePage  = nil;
        self.memberProfile = nil;
        self.messageFontSize    = 14;
        self.maxProfilePics     = 4;
        self.appKey             =   @"kT7bgkacbx73i3yxma09su0u901nu209mnuu30akhkpHJJ";
        self.fb_id              =   @"";
        self.isInConversation = NO;
        self.cPageIndex     = 0;
        self.hasMessageToLoad = NO;
        self.ph_token       = @"";
        self.user_id        = @"";
        self.cVenueListIndex = 0;
        self.isLoggedIn     = NO;
        self.cHostDict      = [[NSMutableDictionary alloc] init];
        self.cHostVenuePicURL   = @"";
        self.imdowntext         = @"Send Message";
        self.baseAPIURL         = @"https://api.partyhostapp.com";
        self.member_fb_id       = @"";
        self.cEventsDatesStrg   = @"";
        self.cVenueName         = @"";
        self.member_first_name  = @"";
        self.cHost_fb_id        = @"";
        self.cHost_index        = -1;
        self.cHost_index_path   = nil;
        self.cHosting_id        = @"";
        self.cInitHosting_id    = @"";
        self.member_user_id     = @"";
        self.cEventId_toLoad    = @"";
        self.tapDict            = [[NSMutableDictionary alloc] init];
        self.hasInitHosting     = NO;
        self.cEventId           = @"";
        self.cInviteName        = @"";
        self.cameFromEventsTab  = NO;
        self.mostRecentEventSelectedId = @"";
        self.cGuestId           = @"";
        self.cHostingIdFromInvite   = @"";
        self.cAddEventDict      = [[NSMutableDictionary alloc] init];
        self.eventDict          = [[NSMutableDictionary alloc] init];
        self.unreadChatCount    = 0;
        self.unreadFeedCount    = 0;
        self.cShareHostingId    = @"";
        self.mixPanelCEventDict = [[NSMutableDictionary alloc] init];
        self.cEventId_Feed      = @"";
        self.cEventId_Modal     = @"";
        self.matchMe            = YES;
        self.isInFeed           = NO;
        self.cFillType          = @"";
        self.cFillValue          = @"";
        self.btnYesTxt           = @"";
        self.btnNOTxt           = @"";
        self.phoneCountry       = @"";
        self.isInAskingNotification = NO;
        self.didAppsFlyerLoad   = NO;
        //int numLives = MPTweakValue(@"number of lives", 5);
        
        
        //self.btnYesTxt = MPTweakValue(@"PartyFeedButtonYesText", @"YES");
        //self.btnNOTxt = MPTweakValue(@"PartyFeedButtonNoText", @"NO");
        
        self.btnYesTxt = @"YES";
        self.btnNOTxt = @"NO";
        
        self.ABTestChat = @"";
        
        NSArray *vComp = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
        
        self.osVersion = [[vComp objectAtIndex:0] intValue];
        
        self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
        self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
        
        NSLog(@"SCREEN_WIDTH :: %d",self.screenWidth);
        NSLog(@"SCREEN_HEIGHT :: %d",self.screenHeight);
        
        self.isIphone4 = (self.screenHeight == 480);
        self.isIphone5 = (self.screenHeight == 568);
        self.isIphone6 = (self.screenHeight == 667);
        self.isIphone6plus = (self.screenHeight == 736);
        
        UIDevice *deviceInfo = [UIDevice currentDevice];
        
        self.deviceType = @"iPhone4";
        
        if(self.isIphone5)
        {
            self.deviceType = @"iPhone5";
        }
        
        if(self.isIphone6)
        {
            self.deviceType = @"iPhone6";
        }
        
        if(self.isIphone6plus)
        {
            self.deviceType = @"iPhone6plus";
        }
        
        NSLog(@"DEVICE_NAME:  %@", deviceInfo.name);
        NSLog(@"DEVICE_SYSTEM_NAME:  %@", deviceInfo.systemName);
        NSLog(@"DEVICE_SYSTEM_VERSION:  %@", deviceInfo.systemVersion);
        NSLog(@"DEVICE_MODEL:  %@", deviceInfo.model);
        NSLog(@"DEVICE_LOCALIZED_MODEL:  %@", deviceInfo.localizedModel);
        //NSLog(@"DEVICE_USERINTERFACE_IDIOM:  %ld", deviceInfo.userInterfaceIdiom);
        NSLog(@"DEVICE_IDFORVENDOR:  %@", deviceInfo.identifierForVendor);
        
        
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
        NSLog(@"DEVICE_TYPE: %@",[self platformType:platform]);
        free(machine);
        
        self.deviceType = [self platformType:platform];
        
        self.isGuestListingsShowing = NO;
        
        //Height of feed cells
        self.feedCellHeightShort = 80;
        self.feedCellHeightLong = 405;
        if(self.isIphone4)
        {
            self.feedCellHeightLong = 405 - 86;
        } else if (self.isIphone6)
        {
            self.feedCellHeightLong = 504;
        } else if (self.isIphone6plus)
        {
            self.feedCellHeightLong = 574;
        }
        
        //Member reviews side padding
        self.memberReviewSidePadding = 30;
        self.memberReviewFontSize = 13;
        
        //Host venue details push
        self.hostVenueDetailPage = nil;
        
        //Notifications settings
        self.notification_feed = NO;
        self.notification_messages = NO;
        
        //Location setting
        self.location_on = NO;
        
        //Gender preferences
        self.gender = @"male";
        self.gender_interest = @"female";
        
        //Credit card
        self.ccType = @"";
        self.ccName = @"";
        self.ccLast4 = @"";
        
        //Phone
        self.phone = @"";
        self.has_phone = NO;
        
        //Experiences
        self.experiences = [[NSMutableArray alloc] init];
        
        //Walkthrough
        self.walkthroughOn = NO;
        
        //Location manager
        self.locationManager = [[CLLocationManager alloc] init];
    }
    return self;
}

-(NSString *)picURL:(NSString *)url
{
    return [NSString stringWithFormat:@"%@/image?url=%@",PHBaseDomain,url];
}

-(NSString *)profileImg:(NSString *)fb_id
{
    //http://res.cloudinary.com/hkw5xutzo/image/facebook/w_100,h_100,c_fill/1376680319326091.jpg
    //http://res.cloudinary.com/hkw5gxutzo/image/facebook/1376680319326091.jpg
    return [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=100&height=100",fb_id];
}



-(NSString *)profileImgLarge:(NSString *)fb_id
{
    //http://res.cloudinary.com/hkw5xutzo/image/facebook/w_100,h_100,c_fill/1376680319326091.jpg
    //http://res.cloudinary.com/hkw5xutzo/image/facebook/1376680319326091.jpg
    return [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=1000&height=1000",fb_id];
}

/*
-(UIColor *)purpleColor
{
    //return [self colorWithHexString:@"0x672d91"];
    return [self colorWithHexString:@"0x462A53"];
    //8d288f
}
*/

-(void)loadImage:(NSString *)imgURL onCompletion:(void (^)(void))completionHandler
{
    
    imgURL = [NSString stringWithFormat:@"%@",imgURL];
    
    if([imgURL isEqualToString:@""])
    {
        return;
    }
    
    if([self.imagesDict objectForKey:imgURL])
    {
        completionHandler();
        return;
    }
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:imgURL]];
        if (data == nil)
        {
            return;
        }
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           if([self contentTypeForImageData:data])
                           {
                               if([data length] > 0)
                               {
                                   [self.imagesDict setObject:[UIImage imageWithData: data] forKey:imgURL];
                                   completionHandler();
                               }
                           }
                       });
    });
}

-(void)loadImageCue:(NSString *)imgURL
{
    if([self.imagesDict objectForKey:imgURL])
    {
        
        return;
    }
    char const *uniqueString = [imgURL  UTF8String];
    dispatch_queue_t queue = dispatch_queue_create(uniqueString, 0);
    
    dispatch_async(queue, ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:imgURL]];
        if([self contentTypeForImageData:data])
        {
            [self.imagesDict setObject:[UIImage imageWithData: data] forKey:imgURL];
        }
    });
}

-(void)clearKeyBoards
{
    for (int i = 0; i < [self.keyboardsA count]; i++)
    {
        UIResponder *responder = (UIResponder *)[self.keyboardsA objectAtIndex:i];
        [responder resignFirstResponder];
    }
}


-(BOOL)contentTypeForImageData:(NSData *)data
{
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            //NSLog(@"image/jpeg");
            return YES;//@"image/jpeg";
        case 0x89:
            //NSLog(@"image/png");
            return YES;//@"image/png";
        case 0x47:
            //NSLog(@"image/gif");
            return YES;//@"image/gif";
        case 0x49:
        case 0x4D:
            return YES;//@"image/tiff";
    }
    //NSLog(@"NOT_IMAGE!!!");
    return NO;
}


-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

-(CGSize)sizeForLabelString:(NSString *)text withFont:(UIFont *)font andMaxSize:(CGSize)maxSize
{
    NSDictionary *attributedDict = @{ NSFontAttributeName : font};
    CGRect attributedLabelRect = [text boundingRectWithSize:maxSize
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:attributedDict
                                                    context:nil];
    return attributedLabelRect.size;
}

- (NSDictionary *)parseQueryString:(NSString *)query
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}


-(NSString*)capitalizeFirstLetter:(NSString *)strg
{
    if(strg)
    {
        if([strg length] > 0)
        {
            NSString *firstCharacterInString = [[strg substringToIndex:1] capitalizedString];
            NSString *sentenceString = [strg stringByReplacingCharactersInRange:NSMakeRange(0,1) withString: firstCharacterInString];
            return sentenceString;
        }else{
            return @"";
        }
    }else
    {
        return @"";
    }
}


-(NSString *)clipSpace:(NSString *)strg
{
    return [strg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


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
    [mixpanel createAlias:[self.userDict objectForKey:@"fb_id"] forDistinctID:mixpanel.distinctId];
    //[mixpanel identify:mixpanel.distinctId];
}

-(void)setMixPanelOnLogin
{
    if(PHMixPanelOn==NO) return;
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    //[mixpanel createAlias:[self.userDict objectForKey:@"fb_id"] forDistinctID:mixpanel.distinctId];
    [mixpanel identify:self.fb_id];
}

-(void)setMixPanelSuperProperties
{
    if(PHMixPanelOn==NO) return;
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel identify:self.fb_id];
    NSString *location = [self.userDict[@"location"] lowercaseString];
    
    [mixpanel registerSuperProperties:@{@"account_type": self.account_type}];
    [mixpanel registerSuperProperties:@{@"gender": self.gender}];
    [mixpanel registerSuperProperties:@{@"gender_interest": self.gender_interest}];
    [mixpanel registerSuperProperties:@{@"os_version": [UIDevice currentDevice].systemVersion}];
    [mixpanel registerSuperProperties:@{@"device_type": self.deviceType}];
    [mixpanel registerSuperProperties:@{@"location": location}];
    [mixpanel registerSuperProperties:@{@"app_version":PHVersion}];
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:self.account_type forKey:@"account_type"];
    [dict setObject:self.gender forKey:@"gender"];
    [dict setObject:self.gender_interest forKey:@"gender_interest"];
    [dict setObject:[UIDevice currentDevice].systemVersion forKey:@"os_version"];
    [dict setObject:self.deviceType forKey:@"device_type"];
    [dict setObject:location forKey:@"location"];
    [dict setObject:PHVersion forKey:@"app_version"];
    
    [self syncSuperPropertiesOnServer:dict];
}

-(void)setMixPanelUserProfile
{
    if(PHMixPanelOn==NO) return;
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel identify:self.fb_id];
    
    NSString *first_name = [self.userDict objectForKey:@"first_name"];
    NSString *last_name = [self.userDict objectForKey:@"last_name"];
    NSString *birthday = self.userDict[@"birthday"];
    NSString *age = @"";
    NSString *email = [self.userDict objectForKey:@"email"];
    
    NSString *facebookId = [self.userDict objectForKey:@"fb_id"];
    
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
    
    
    [mixpanel.people set:@{@"name_and_fb_id": [NSString stringWithFormat:@"%@_%@_%@",first_name,last_name,facebookId]}];
    
}


-(void)setMixPanelOnceParams
{
    if(PHMixPanelOn==NO) return;
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel identify:self.fb_id];
    NSString *media_source = self.appsFlyerDict[@"media_source"];
    NSString *campaign = self.appsFlyerDict[@"campaign"];
    NSString *installType = self.appsFlyerDict[@"af_status"];
    
    
    [mixpanel registerSuperPropertiesOnce:@{@"AFmedia_source": media_source}];
    [mixpanel registerSuperPropertiesOnce:@{@"AFcampaign": campaign}];
    [mixpanel registerSuperPropertiesOnce:@{@"AFinstall_type": installType}];
    
    
    [mixpanel.people set:@{@"AFmedia_source": media_source}];
    [mixpanel.people set:@{@"AFcampaign": campaign}];
    [mixpanel.people set:@{@"AFinstall_type": installType}];
}

-(void)trackMixPanelIncrementWithDict:(NSDictionary *)dict
{
    if(PHMixPanelOn==NO) return;
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel identify:self.fb_id];
    
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
    [mixpanel identify:self.fb_id];
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

- (NSString *) platformType:(NSString *)platform
{
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini 2G (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini 2G (Cellular)";
    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,7"])      return @"iPad Mini 3 (WiFi)";
    if ([platform isEqualToString:@"iPad4,8"])      return @"iPad Mini 3 (Cellular)";
    if ([platform isEqualToString:@"iPad4,9"])      return @"iPad Mini 3 (China)";
    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2 (WiFi)";
    if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air 2 (Cellular)";
    if ([platform isEqualToString:@"AppleTV2,1"])   return @"Apple TV 2G";
    if ([platform isEqualToString:@"AppleTV3,1"])   return @"Apple TV 3";
    if ([platform isEqualToString:@"AppleTV3,2"])   return @"Apple TV 3 (2013)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    
    return platform;
}

-(void)updateBadgeIcon
{
    //When it comes to the app badge, feed count should always be considered 1
    int modifiedFeedCount = self.unreadFeedCount;
    if(modifiedFeedCount>1) modifiedFeedCount = 1;
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: modifiedFeedCount + self.unreadChatCount];
}


-(AFHTTPRequestOperationManager *)getOperationManager
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:self.ph_token forHTTPHeaderField:@"ph_token"];
    
    return manager;
}


//===================================================================================================//
//GENDER

-(BOOL)isGuest
{
    return [self.account_type isEqualToString:@"guest"];
}

-(BOOL)isHost
{
    return [self.account_type isEqualToString:@"host"];
}

-(BOOL)isMember
{
    return YES;
}

//Choose account_type and gender_interest based on gender
-(void)calculateDefaultGenderSettings
{
    if([self.gender isEqualToString:@"male"]) //Male
    {
        self.account_type = @"host";
        self.gender_interest = @"female";
    }
    else //Female
    {
        self.account_type = @"guest";
        self.gender_interest = @"male";
    }
}
//===================================================================================================//



//===================================================================================================//
//TONY
//Special cancelable load image


-(NWURLConnection*)loadImageCancelable:(NSString *)imgURL completionBlock:(void (^)(UIImage *image))completionBlock
{
    //Already exists
    if([self.imagesDict objectForKey:imgURL])
    {
        if([[self.imagesDict objectForKey:imgURL] isKindOfClass:[UIImage class]])
        {
            completionBlock([self.imagesDict objectForKey:imgURL]);
            return [[NWURLConnection alloc] init];
        }
    }
    
    //Download image and add to shared dict
    return [self downloadImageCancelable:[[NSURL alloc] initWithString:imgURL] completionBlock:^(BOOL succeed, UIImage *result, NSString *pic_url)
     {
         if(succeed)
         {
             [self.imagesDict setObject:result forKey:pic_url];
             completionBlock(result);
         }
     }];
}

- (NWURLConnection*)downloadImageCancelable:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image, NSString *key))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //Load async but allow cancel
    return [NWURLConnection sendAsynchronousRequest:request
                                                         queue:[NSOperationQueue mainQueue]
                                             completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                                 if ( !error )
                                                 {
                                                     
                                                     if([self contentTypeForImageData:data])
                                                     {
                                                         UIImage *image = [[UIImage alloc] initWithData:data];
                                                         completionBlock(YES,image,url.absoluteString);
                                                     }else{
                                                         completionBlock(NO,nil,url.absoluteString);
                                                     }
                                                 } else{
                                                     completionBlock(NO,nil,url.absoluteString);
                                                 }
                                             }];
}
//===================================================================================================//
//Save settings helper

-(void)loadTimeImage:(NSString *)imgURL withTimeOut:(float)time
{
    [self performSelector:@selector(loadImageCue:) withObject:imgURL afterDelay:time];
}

-(NSDictionary*)createSaveSettingsParams
{
    return @{
         @"fb_id" : self.fb_id,
         @"account_type": self.account_type,
         @"gender": self.gender,
         @"gender_interest": self.gender_interest,
         @"feed": [NSNumber numberWithInt:(self.notification_feed)?1:0],
         @"chat": [NSNumber numberWithInt:(self.notification_messages)?1:0],
         @"location": [NSNumber numberWithInt:(self.location_on)?1:0],
         @"experiences": [self.experiences componentsJoinedByString:@","]
         };
}


-(void)syncSuperPropertiesOnServer:(NSMutableDictionary *)dict
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *urlToLoad = [NSString stringWithFormat:@"%@/user/sync/superproperties/%@",PHBaseURL,self.fb_id];
    
    NSLog(@"MIXPANEL_URL :: %@",urlToLoad);
    NSLog(@"DATA_ :: %@",dict);
    
    [manager POST:urlToLoad parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"SUCCESS_SYNC_MIXPANEL :: %@",responseObject);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR_SYNC_MIXPANEL :: %@",error);
     }];
}

//Copy over data
-(void)loadSettingsResponse:(NSDictionary *)dict
{
    self.account_type = dict[@"data"][@"account_type"];
    
    self.gender = dict[@"data"][@"gender"];
    self.gender_interest =dict[@"data"][@"gender_interest"];
    
    if(self.gender_interest==nil)
    {
        self.gender_interest = ([self.gender isEqualToString:@"female"])?@"male":@"female";
    };
    
    self.notification_feed = [dict[@"data"][@"notifications"][@"feed"] boolValue];
    self.notification_messages = [dict[@"data"][@"notifications"][@"chat"] boolValue];
    
    self.location_on = [dict[@"data"][@"location_on"] boolValue];
    
    [self.experiences removeAllObjects];
    [self.experiences addObjectsFromArray:dict[@"data"][@"experiences"]];
    
    self.phone = dict[@"data"][@"phone"];
    if(self.phone==nil) self.phone = @"";
    
    self.ccName = dict[@"data"][@"payment"][@"creditCard"][@"cardholderName"];
    self.ccType = dict[@"data"][@"payment"][@"creditCard"][@"cardType"];
    self.ccLast4 = dict[@"data"][@"payment"][@"creditCard"][@"last4"];
    if(self.ccLast4==nil) self.ccLast4 = @"";
    
    self.has_phone = [dict[@"has_phone"] boolValue];
}
//===================================================================================================//

@end
