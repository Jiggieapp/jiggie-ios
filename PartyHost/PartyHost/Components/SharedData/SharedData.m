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
        self.userDict   =   [[NSMutableDictionary alloc] init]; // user login when
        self.photosDict =   [[NSMutableDictionary alloc] init]; // user's photos
        self.imagesDict =   [[NSMutableDictionary alloc] init]; // all photos member profile, events, event detail
        self.venuesNameList =   [[NSMutableArray alloc] init]; // not use anymore
        self.keyboardsA     =   [[NSMutableArray alloc] init]; // clear for the keyboard.. all object to resign the keyboard
        self.appsFlyerDict  = [[NSMutableDictionary alloc] init]; // dict for appsflyer when login or app launch
        self.memberProfileDict  = [[NSMutableDictionary alloc] init]; // other user member profile
        self.selectedHost = [[NSMutableDictionary alloc] init]; // not use
        self.selectedEvent = [[NSMutableDictionary alloc] init]; // not use or for share link
        self.messagesPage = nil; // messages
        self.profilePage  = nil; // profile
        self.memberProfile = nil; // memberprofile
        self.messageFontSize    = 14;
        self.maxProfilePics     = 4;
        self.appKey             =   @"kT7bgkacbx73i3yxma09su0u901nu209mnuu30akhkpHJJ"; // not use anymore
        self.fb_id              =   @""; // user's fb id
        self.isInConversation = NO; // if in the user conversation
        self.cPageIndex     = 0;
        self.hasMessageToLoad = NO; // boolean to open the message when going to the app
        self.hasFeedToLoad = NO; // boolean to open the social feed when going to the app
        self.ph_token       = @""; // not use
        self.user_id        = @""; //
        self.cVenueListIndex = 0; // not use
        self.isLoggedIn     = NO; // not use
        self.cHostDict      = [[NSMutableDictionary alloc] init]; // not use
        self.cHostVenuePicURL   = @""; // for share link
        self.imdowntext         = @"Send Message"; // not use
        self.baseAPIURL         = @"https://api.partyhostapp.com"; // not use
        self.member_fb_id       = @""; // use for share link
        self.cEventsDatesStrg   = @""; // not use
        self.cVenueName         = @""; // not use
        self.member_first_name  = @""; // for member profile
        self.cHost_fb_id        = @""; // not use
        self.cHost_index        = -1; // event / deep linking
        self.cHost_index_path   = nil; //
        self.cHosting_id        = @"";
        self.cInitHosting_id    = @"";
        self.member_user_id     = @"";
        self.cEventId_toLoad    = @"";
        self.tapDict            = [[NSMutableDictionary alloc] init]; // not use
        self.hasInitEventSelection     = NO; // not use
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
        self.mixPanelCEventDict = [[NSMutableDictionary alloc] init]; // mixpanel data
        self.mixPanelCTicketDict = [[NSMutableDictionary alloc] init]; // mixpanel data
        self.cEventId_Feed      = @""; // current feed id
        self.cEventId_Modal     = @""; // current modal id
        self.cEventId_Summary   = @""; // current summary id
        self.matchMe            = YES; // use in feed
        self.isInFeed           = NO;
        self.cFillType          = @"";
        self.cFillValue         = @"";
        self.btnYesTxt          = @""; // on matching button
        self.btnNOTxt           = @""; // on matching
        self.phoneCountry       = @"";
        self.isInAskingNotification = NO;
        self.didAppsFlyerLoad   = NO;
        self.feedMatchEvent     = @"";
        //int numLives = MPTweakValue(@"number of lives", 5);
        
        
        //self.btnYesTxt = MPTweakValue(@"PartyFeedButtonYesText", @"YES");
        //self.btnNOTxt = MPTweakValue(@"PartyFeedButtonNoText", @"NO");
        
        self.btnYesTxt = @"YES";
        self.btnNOTxt = @"NO";
        
        self.ABTestChat = @""; // feed 
        
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
        self.feedCellHeightLong = 345;
        if(self.isIphone4)
        {
            self.feedCellHeightLong = 290;
        } else if (self.isIphone6)
        {
            self.feedCellHeightLong = 444;
        } else if (self.isIphone6plus)
        {
            self.feedCellHeightLong = 504;
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
        
        //Social Filter preferences
        self.gender = @"male";
        self.gender_interest = @"female";
        self.distance = @"160";
        self.from_age = @"18";
        self.to_age = @"60";
        
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
    
    /*
    NSLog(@"url___ :: %@",url);
    NSMutableArray *tmpA = [[NSMutableArray alloc] initWithArray:[url componentsSeparatedByString:@".png"]];
    NSMutableArray *tmpAA = [[NSMutableArray alloc] initWithArray:[tmpA[0] componentsSeparatedByString:@"://"]];
    NSLog(@"new_url:: %@",[NSString stringWithFormat:@"%@.jpg",tmpA[0]]);
    NSMutableArray *tmpAAA = [[NSMutableArray alloc] initWithArray:[tmpAA[1] componentsSeparatedByString:@"."]];
    NSString *joined = [tmpAAA componentsJoinedByString:@"_"];
    NSMutableArray *tmpAAAA = [[NSMutableArray alloc] initWithArray:[joined componentsSeparatedByString:@"/"]];
    NSString *joinedA = [tmpAAAA componentsJoinedByString:@"_"];
    NSLog(@"joined___%@",joinedA);
    // https://s3-us-west-2.amazonaws.com/cdnpartyhost/1447944614629.png
    // s3-us-west-2_amazonaws_com_cdnpartyhost_1447944614629
    // s3-us-west-2_amazonaws_com_cdnpartyhost_1447944614629
    
    // http://res.cloudinary.com/havbengny/image/upload/v1448704756/s3-us-west-2_amazonaws_com_cdnpartyhost_1447059934749.jpg
    
    
    //return url;
    //return [NSString stringWithFormat:@"http://res.cloudinary.com/havbengny/image/upload/v1448704756/%@.jpg",joinedA];//[NSString stringWithFormat:@"%@.jpg",tmpA[0]];
    */
    
    NSString *newUrl = [url stringByReplacingOccurrencesOfString:@"_original.png" withString:@"_540.jpg"];
    return newUrl;
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



#pragma mark -
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
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPod7,1"])      return @"iPod Touch 6G";
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
    if ([platform isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([platform isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (Cellular)";
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
    
    [manager.requestSerializer setValue:self.ph_token forHTTPHeaderField:@"Authorization"];
    
//    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//    policy.validatesDomainName = NO;
//    policy.allowInvalidCertificates = YES;
//    manager.securityPolicy = policy;
    
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    return manager;
}

- (void)loginWithFBToken:(void (^)(AFHTTPRequestOperation *, id))success
                 failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    NSDictionary *parameters = @{@"fb_token" : self.fb_access_token};
    AFHTTPRequestOperationManager *manager = [self getOperationManager];
    NSString *urlToLoad = [NSString stringWithFormat:@"%@/userlogin", PHBaseNewURL];
    
    [manager POST:urlToLoad
       parameters:parameters
          success:success
          failure:failure];
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
    NSDictionary *settingsParams = nil;
    @try {
        settingsParams = @{
                         @"fb_id" : self.fb_id,
                         @"account_type": self.account_type,
                         @"gender": self.gender,
                         @"gender_interest": self.gender_interest,
                         @"distance": self.distance,
                         @"from_age": self.from_age,
                         @"to_age": self.to_age,
                         @"feed": [NSNumber numberWithInt:(self.notification_feed)?1:0],
                         @"chat": [NSNumber numberWithInt:(self.notification_messages)?1:0],
                         @"location": [NSNumber numberWithInt:(self.location_on)?1:0],
                         @"experiences": [self.experiences componentsJoinedByString:@","]
                         };
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }

    return settingsParams;
}


-(void)syncSuperPropertiesOnServer:(NSMutableDictionary *)dict
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *urlToLoad = [NSString stringWithFormat:@"%@/user/sync/superproperties/%@",PHBaseNewURL,self.fb_id];
    
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
    @try {
        self.account_type = dict[@"account_type"];
        
        self.gender = dict[@"gender"];
        self.gender_interest =dict[@"gender_interest"];
        
        if(self.gender_interest==nil)
        {
            self.gender_interest = ([self.gender isEqualToString:@"female"])?@"male":@"female";
        };
        
        self.distance = (dict[@"distance"])?:self.distance;
        self.from_age = (dict[@"from_age"])?:self.from_age;
        self.to_age = (dict[@"to_age"])?:self.to_age;
        
        self.notification_feed = [dict[@"notifications"][@"feed"] boolValue];
        self.notification_messages = [dict[@"notifications"][@"chat"] boolValue];
        
        self.location_on = [dict[@"location_on"] boolValue];
        
        [self.experiences removeAllObjects];
        [self.experiences addObjectsFromArray:dict[@"experiences"]];
        
        self.phone = dict[@"phone"];
        if(self.phone==nil) self.phone = @"";
        
        self.ccName = dict[@"payment"][@"creditCard"][@"cardholderName"];
        self.ccType = dict[@"payment"][@"creditCard"][@"cardType"];
        self.ccLast4 = dict[@"payment"][@"creditCard"][@"last4"];
        if(self.ccLast4==nil) self.ccLast4 = @"";
        
        self.has_phone = [dict[@"has_phone"] boolValue];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

//Copy over data
-(void)saveSettingsResponse
{
    @try {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *dict = [prefs objectForKey:@"user.setting"];
        
        NSDictionary *newDict = @{@"_id":dict[@"_id"],
                                  @"account_type":dict[@"account_type"],
                                  @"experiences":self.experiences,
                                  @"fb_id":dict[@"fb_id"],
                                  @"gender":dict[@"gender"],
                                  @"gender_interest":self.gender_interest,
                                  @"distance": self.distance,
                                  @"from_age": self.from_age,
                                  @"to_age": self.to_age,
                                  @"matchme":dict[@"matchme"],
                                  @"notifications":@{
                                          @"chat":[NSNumber numberWithBool:self.notification_messages],
                                          @"feed":[NSNumber numberWithBool:self.notification_feed],
                                          @"location":[NSNumber numberWithBool:self.location_on]},
                                  @"payment":dict[@"payment"],
                                  @"phone":self.phone,
                                  @"updated_at":dict[@"updated_at"]
                                  };
        
        [prefs setObject:newDict forKey:@"user.setting"];
        [prefs synchronize];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.description);
    }
    @finally {
        
    }
}
//===================================================================================================//

- (NSString *)formatCurrencyString:(NSString *)price {
    if (price.length < 4) {
        return price;
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setGroupingSeparator:@"."];
    [formatter setGroupingSize:3];
    NSNumber *priceNumber = [NSNumber numberWithInteger:[price integerValue]];
    NSString *newPrice = [formatter stringFromNumber:priceNumber];
    
    newPrice = [newPrice stringByReplacingCharactersInRange:NSMakeRange(newPrice.length - 4, 4) withString:@"K"];
    
    return newPrice;
}

- (BOOL)validateEmailWithString:(NSString*)checkString {
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


@end
