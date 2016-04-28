//
//  FeedCell.m
//  PartyHost
//
//  Created by Tony Suriyathep on 4/24/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//



#import "FeedCell.h"
#import "AnalyticManager.h"

#define CIRCLE_SIZE 44
#define INNER_PADDING 12
#define BUTTON_TINT_DURATION 0.15
#define DATE_SHORT_DISPLAY @"MMM d, yyyy h:mm a"

@implementation FeedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //self.layer.borderWidth = 1;
        //self.layer.borderColor = [UIColor phDarkGrayColor].CGColor;
        
        self.sharedData = [SharedData sharedInstance];
        self.mainData = [[NSMutableDictionary alloc] init];
        
        self.mainCon = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.sharedData.screenWidth-20, self.sharedData.feedCellHeightLong)];
        self.mainCon.backgroundColor = [UIColor clearColor];
        self.mainCon.layer.masksToBounds = YES;
        self.mainCon.layer.cornerRadius = 10;
        self.mainCon.layer.borderColor = [UIColor phLightGrayColor].CGColor;
        self.mainCon.layer.borderWidth = 1.0;
        [self addSubview:self.mainCon];
        
        
        UIView *tmpWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.feedCellHeightLong)];
        tmpWhiteView.layer.cornerRadius = 10;
        tmpWhiteView.layer.masksToBounds = YES;
        tmpWhiteView.backgroundColor = [UIColor whiteColor];
        [self.mainCon addSubview:tmpWhiteView];
        
        self.cardOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mainCon.bounds.size.width, self.mainCon.bounds.size.height)];
        [self.mainCon addSubview:self.cardOne];
        
        self.cardTwo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mainCon.bounds.size.width, self.mainCon.bounds.size.height)];
        self.cardTwo.backgroundColor = [UIColor whiteColor];
        [self.mainCon addSubview:self.cardTwo];
        
        
        int OffSet = (self.sharedData.isIphone4)?96:0;
        int OffSetLargeDevice = 0;
        int OffsetFontLargeDevice = 0;
        if (self.sharedData.isIphone6) {
            OffSetLargeDevice = 86;
            OffsetFontLargeDevice = 1;
        } else if (self.sharedData.isIphone6plus) {
            OffSetLargeDevice = 146;
            OffsetFontLargeDevice = 3;
        }
        
        /// ---- CARD ONE ---- ///
        self.btnUserImage = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnUserImage.frame = CGRectMake(0, 0, self.mainCon.bounds.size.width, 185 - OffSet/2 + OffSetLargeDevice/2);
        self.btnUserImage.contentMode = UIViewContentModeScaleAspectFill;
        self.btnUserImage.layer.masksToBounds = YES;
        [self.btnUserImage addTarget:self action:@selector(profileHandler) forControlEvents:UIControlEventTouchUpInside];
        [self.cardOne addSubview:self.btnUserImage];
        
        self.greenCircle = [[UIView alloc] initWithFrame:CGRectMake((self.mainCon.bounds.size.width/2) - 30, 185 - 35  - OffSet/2 + OffSetLargeDevice/2, 60, 60)];
        self.greenCircle.backgroundColor = [UIColor phBlueColor];
        self.greenCircle.layer.cornerRadius = 30;
        self.greenCircle.layer.masksToBounds = YES;
        [self.cardOne addSubview:self.greenCircle];
        
        UIImageView *textIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        textIcon.image = [UIImage imageNamed:@"text-icon"];
        [self.greenCircle addSubview:textIcon];

        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 205 - OffSet/2 + OffSetLargeDevice * 0.7, self.mainCon.bounds.size.width, 30)];
        self.nameLabel.textColor = [self.sharedData colorWithHexString:@"5c5c5c"];
        self.nameLabel.font = [UIFont phBlond:15 + OffsetFontLargeDevice];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.cardOne addSubview:self.nameLabel];
        
        self.eventLabel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.eventLabel.frame = CGRectMake(0, 235 - OffSet/2 + OffSetLargeDevice * 0.7, self.mainCon.bounds.size.width, 40);
        [self.eventLabel setTitleColor:[UIColor phBlueColor] forState:UIControlStateNormal];
        self.eventLabel.titleLabel.font = [UIFont phBold:16 + OffsetFontLargeDevice];
        self.eventLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.eventLabel.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.eventLabel.titleLabel.numberOfLines = 2;
        if (self.sharedData.isIphone4) {
            self.eventLabel.titleLabel.numberOfLines = 1;
        }
//        self.eventLabel.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        [self.eventLabel setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 30)];
        [self.eventLabel addTarget:self action:@selector(eventInfoHandler) forControlEvents:UIControlEventTouchUpInside];
        [self.cardOne addSubview:self.eventLabel];
        
        self.recLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 255 - OffSet/2 + OffSetLargeDevice * 0.7, self.mainCon.bounds.size.width, 30)];
        self.recLabel.textColor = [self.sharedData colorWithHexString:@"5c5c5c"];
        self.recLabel.font = [UIFont phBlond:15 + OffsetFontLargeDevice];
        self.recLabel.textAlignment = NSTextAlignmentCenter;
        [self.cardOne addSubview:self.recLabel];
        
        
        
        /// ---- CARD TWO ---- ///
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 250 - OffSet/2 + OffSetLargeDevice * 0.7, self.mainCon.bounds.size.width, 30)];
        self.titleLabel.textColor = [self.sharedData colorWithHexString:@"5c5c5c"];
        self.titleLabel.font = [UIFont phBold:16 + OffsetFontLargeDevice];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = @"Party Tonight?";
        [self.cardTwo addSubview:self.titleLabel];
        
        
        self.nameLabelTwo = [[UILabel alloc] initWithFrame:CGRectMake(0, 40 - OffSet/3 + OffSetLargeDevice * 0.3, self.mainCon.bounds.size.width, 30)];
        self.nameLabelTwo.textColor = [self.sharedData colorWithHexString:@"5c5c5c"];
        self.nameLabelTwo.font = [UIFont phBlond:15 + OffsetFontLargeDevice];
        self.nameLabelTwo.textAlignment = NSTextAlignmentCenter;
        [self.cardTwo addSubview:self.nameLabelTwo];
        
        self.eventLabelTwo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.eventLabelTwo.frame = CGRectMake(0, 66 - OffSet/3 + OffSetLargeDevice * 0.4, self.mainCon.bounds.size.width, 40);
        [self.eventLabelTwo setTitleColor:[UIColor phBlueColor] forState:UIControlStateNormal];
        
        self.eventLabelTwo.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.eventLabelTwo.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.eventLabelTwo.titleLabel.numberOfLines = 2;
        self.eventLabelTwo.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        [self.eventLabelTwo setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 30)];
        [self.eventLabelTwo addTarget:self action:@selector(eventInfoHandler) forControlEvents:UIControlEventTouchUpInside];
        self.eventLabelTwo.titleLabel.font = [UIFont phBold:15 + OffsetFontLargeDevice];
        [self.cardTwo addSubview:self.eventLabelTwo];
        
        
        self.greenCircleTwo = [[UIView alloc] initWithFrame:CGRectMake((self.mainCon.bounds.size.width/2) + 10, 120 - OffSet/3 + OffSetLargeDevice/2, 90, 90)];
        self.greenCircleTwo.backgroundColor = [UIColor phBlueColor];
        self.greenCircleTwo.layer.cornerRadius = 45;
        self.greenCircleTwo.layer.masksToBounds = YES;
        [self.cardTwo addSubview:self.greenCircleTwo];
        
        UIImageView *textIconTwo = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 50, 50)];
        textIconTwo.image = [UIImage imageNamed:@"text-icon"];
        [self.greenCircleTwo addSubview:textIconTwo];
        
        self.btnUserImageTwo = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnUserImageTwo.frame = CGRectMake((self.mainCon.bounds.size.width/2) - 100, 120 - OffSet/3 + OffSetLargeDevice/2, 90, 90);
        self.btnUserImageTwo.contentMode = UIViewContentModeScaleAspectFill;
        self.btnUserImageTwo.layer.masksToBounds = YES;
        self.btnUserImageTwo.layer.cornerRadius = 45;
        self.btnUserImageTwo.layer.masksToBounds = YES;
        [self.btnUserImageTwo addTarget:self action:@selector(profileHandler) forControlEvents:UIControlEventTouchUpInside];
        [self.cardTwo addSubview:self.btnUserImageTwo];
        
        self.grayLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.mainCon.bounds.size.height - 50, self.mainCon.bounds.size.width, 1)];
        self.grayLine.backgroundColor = [UIColor phLightGrayColor];
        [self.mainCon addSubview:self.grayLine];
        
        int btnWidth = self.mainCon.bounds.size.width/2;
        
        self.btnDeny = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.btnDeny.frame = CGRectMake(0, self.mainCon.bounds.size.height - 50, btnWidth, 50);
        self.btnDeny.backgroundColor = [self.sharedData colorWithHexString:@"c2c2c2"];
        [self.btnDeny setTitle:@"NO" forState:UIControlStateNormal];
        [self.btnDeny setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnDeny setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        self.btnDeny.titleLabel.font = [UIFont phBold:15];
        self.btnDeny.layer.masksToBounds = YES;
        [self.btnDeny addTarget:self action:@selector(denyHandler) forControlEvents:UIControlEventTouchUpInside];
        [self.mainCon addSubview:self.btnDeny];
        
        
        self.btnApprove = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.btnApprove.frame = CGRectMake(btnWidth, self.mainCon.bounds.size.height - 50, btnWidth, 50);
        self.btnApprove.backgroundColor = [UIColor phBlueColor];
        [self.btnApprove setTitle:@"YES" forState:UIControlStateNormal];
        [self.btnApprove setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnApprove setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        self.btnApprove.titleLabel.font = [UIFont phBold:15];
        self.btnApprove.layer.masksToBounds = YES;
        [self.btnApprove addTarget:self action:@selector(approveHandler) forControlEvents:UIControlEventTouchUpInside];
        [self.mainCon addSubview:self.btnApprove];
    }
    
    return self;
}

-(void)loadData:(NSMutableDictionary *)dict
{
    [self reset];
    
    [self.btnApprove setTitle:self.sharedData.btnYesTxt forState:UIControlStateNormal];
    [self.btnDeny setTitle:self.sharedData.btnNOTxt forState:UIControlStateNormal];
    
    //[self.btnApprove setTitle:@"YES" forState:UIControlStateNormal];
    //[self.btnDeny setTitle:@"NO" forState:UIControlStateNormal];
    
    [self.mainData removeAllObjects];
    [self.mainData addEntriesFromDictionary:dict];
    
    
    self.cardTwo.hidden = ![self.mainData[@"type"] isEqualToString:@"approved"];
    
    [self.btnUserImage setImage:[UIImage imageNamed:@"fbperson_blank_square"] forState:UIControlStateNormal];
    self.btnUserImage.contentMode = UIViewContentModeScaleToFill;
    self.btnUserImage.imageView.contentMode = UIViewContentModeScaleToFill;
    
    [self.btnUserImageTwo setImage:[UIImage imageNamed:@"fbperson_blank_square"] forState:UIControlStateNormal];
    
//    NSString *usrImgURL = [self.sharedData profileImgLarge:self.mainData[@"from_fb_id"]];
    NSString *usrImgURL = [self.mainData objectForKey:@"image"];
    
    [self.sharedData loadImage:usrImgURL onCompletion:^(){
        [self.btnUserImage setImage:[self.sharedData.imagesDict objectForKey:usrImgURL] forState:UIControlStateNormal];
        self.btnUserImage.contentMode = UIViewContentModeScaleAspectFill;
        self.btnUserImage.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.btnUserImageTwo setImage:[self.sharedData.imagesDict objectForKey:usrImgURL] forState:UIControlStateNormal];
        
        self.btnUserImageTwo.contentMode = UIViewContentModeScaleAspectFill;
        self.btnUserImageTwo.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }];

    NSString *first_name = [self.sharedData capitalizeFirstLetter:self.mainData[@"from_first_name"]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ is also interested in",first_name];
    NSString *eventLabelText = [NSString stringWithFormat:@"%@",self.mainData[@"event_name"]];
    [self.eventLabel setTitle:eventLabelText forState:UIControlStateNormal];
    
    
    if([self.sharedData.ABTestChat isEqualToString:@"YES"])
    {
        self.nameLabelTwo.text = [NSString stringWithFormat:@"%@ wants to go with you to",first_name];
        self.recLabel.text = [NSString stringWithFormat:@"Connect with %@?",first_name];
        self.titleLabel.text = [NSString stringWithFormat:@"Interested?"];
    }else{
        self.nameLabelTwo.text = [NSString stringWithFormat:@"%@ wants to chat with you about",first_name];
        self.recLabel.text = [NSString stringWithFormat:@"Chat with %@?",first_name];
        self.titleLabel.text = [NSString stringWithFormat:@"Chat with %@?",first_name];
    }
    
    [self.eventLabelTwo setTitle:[NSString stringWithFormat:@"%@",self.mainData[@"event_name"]] forState:UIControlStateNormal];
    
    
    
    CGSize eventSize = CGSizeMake(self.eventLabel.bounds.size.width - 60, 40);
    if (self.sharedData.isIphone4) {
        eventSize = CGSizeMake(self.eventLabel.bounds.size.width - 60, 20);
    }
    CGRect stringFrame = [eventLabelText boundingRectWithSize:eventSize
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:self.eventLabel.titleLabel.font}
                                                      context:nil];
    
    int Offset = -8;
    if (self.sharedData.isIphone6 || self.sharedData.isIphone6plus) {
        Offset = 4;
    }
    
    self.eventLabel.frame = CGRectMake(self.eventLabel.frame.origin.x,
                                       CGRectGetMaxY(self.nameLabel.frame) + Offset,
                                       self.eventLabel.frame.size.width,
                                       stringFrame.size.height + 10);
    self.recLabel.frame = CGRectMake(self.recLabel.frame.origin.x,
                                     CGRectGetMaxY(self.eventLabel.frame) + Offset,
                                     self.recLabel.frame.size.width,
                                     self.recLabel.frame.size.height);
    
    
    //NSLog(@"TYPE_______ :: %@",self.mainData[@"type"]);
    
    /*
     //from_first_name
    NSString* fbId = dict[@"user"][@"fb_id"];
    NSString* userName = dict[@"user"][@"first_name"];
    NSString* eventName = dict[@"event"][@"title"];
    NSString* eventNeighborhood = dict[@"event"][@"venue"][@"name"];
    NSString* eventAddress = dict[@"event"][@"venue"][@"address"];
    NSString* typeCell = dict[@"type"];
    NSString* eventStartDate = dict[@"event"][@"start_datetime_str"];
    NSString* eventEndDate = dict[@"event"][@"end_datetime_str"];
    //Jun 23, 2015 11:00 PM
    
    //Check images
    NSString* imageUrl = @"";
    if([dict[@"event"][@"photos"] count]>0)
    {
        imageUrl = dict[@"event"][@"photos"][0];
    }
    
    NSDateFormatter *shortFormat = [[NSDateFormatter alloc] init];
    [shortFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [shortFormat setDateFormat:DATE_SHORT_DISPLAY];
    
    //NSDate *startDate = [shortFormat dateFromString:eventStartDate];
    [shortFormat setDateFormat:@"EEEE"];
    //NSString *dayOfWeek = [shortFormat stringFromDate:startDate];
    int cellHeight = self.sharedData.feedCellHeightLong;
    if([typeCell isEqualToString:@"login"] || [typeCell isEqualToString:@"signedup"]) {cellHeight = self.sharedData.feedCellHeightShort;}
    
    //Cleanup data?
    if(userName == NULL || userName.length==0) {userName = @"Unknown";}
    if(imageUrl.length==0) {imageUrl = NULL;}
    userName = [userName capitalizedString];
    eventName = [eventName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    eventName = [eventName capitalizedString];
    eventNeighborhood = [eventNeighborhood stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    eventNeighborhood = [eventNeighborhood capitalizedString];
    eventAddress = [eventAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //Get choices
    NSString* choice1Icon;
    NSString* choice2Icon;
    if([typeCell isEqualToString:@"invitation"]) { //Host invites guest
        self.choice1 = @"Interested"; //API = accepted
        self.choice2 = @"Pass"; //API = rejected
        self.apiChoice1 = @"accepted"; //API = accepted
        self.apiChoice2 = @"rejected"; //API = rejected
        choice1Icon = @"icon_chat";
        choice2Icon = @"icon_cancel";
    }
    else if([typeCell isEqualToString:@"newhosting"]) { //Made by host, seen by guest
        self.choice1 = @"Interested"; //API = accepted
        self.choice2 = @"Pass"; //API = passed
        self.apiChoice1 = @"accepted"; //API = accepted
        self.apiChoice2 = @"passed"; //API = passed
        choice1Icon = @"icon_chat";
        choice2Icon = @"icon_cancel";
    }
    else if([typeCell isEqualToString:@"accepted"]) { //Made by host, seen by guest
        self.choice1 = @"Chat"; //API = accepted
        self.choice2 = @"Pass"; //API = passed
        self.apiChoice1 = @"accepted"; //API = accepted
        self.apiChoice2 = @"passed"; //API = passed
        choice1Icon = @"icon_chat";
        choice2Icon = @"icon_cancel";
    }
    else if([typeCell isEqualToString:@"viewed"] || [typeCell isEqualToString:@"event_viewed"]) { //Made by guest, seen by hosts
        self.choice1 = @"Invite"; //API = invited
        self.choice2 = @"Pass"; //API = passed
        self.apiChoice1 = @"invited"; //API = invited
        self.apiChoice2 = @"passed"; //API = passed
        choice1Icon = @"icon_chat";
        choice2Icon = @"icon_cancel";
    }
    else if([typeCell isEqualToString:@"confirmed_invite"]) {
        self.choice1 = @"Chat"; //Goes to chat
        self.choice2 = @"Pass"; //??? Nothing
        self.apiChoice1 = @"accepted"; //API = accepted
        self.apiChoice2 = @"passed"; //API = passed
        choice1Icon = @"icon_chat";
        choice2Icon = @"icon_cancel";
    }
    
    //Different text depending on the feed type
    NSString* line1;
    if([typeCell isEqualToString:@"signedup"]) {line1 = [NSString stringWithFormat:@"%@ just signed up", userName];}
    else if([typeCell isEqualToString:@"login"]) {line1 = [NSString stringWithFormat:@"%@ has logged in", userName];}
    else if([typeCell isEqualToString:@"viewed"]) {line1 = [NSString stringWithFormat:@"%@ is interested in your hosting", userName];}
    else if([typeCell isEqualToString:@"event_viewed"]) {line1 = [NSString stringWithFormat:@"%@ is interested in event", userName];}
    else if([typeCell isEqualToString:@"newhosting"]) {line1 = [NSString stringWithFormat:@"%@ has a new hosting", userName];}
    else if([typeCell isEqualToString:@"invitation"]) {line1 = [NSString stringWithFormat:@"%@ has invited you to", userName];}
    else if([typeCell isEqualToString:@"confirmed_invite"]) {line1 = [NSString stringWithFormat:@"%@ has confirmed your invitation", userName];}
    else if([typeCell isEqualToString:@"accepted"]) {line1 = [NSString stringWithFormat:@"You have accepted %@'s invitation", userName];}
    
    //Set text and data
    self.textLine1.text = line1;
    self.textLine2.text = [NSString stringWithFormat:@"%@ at %@", eventName, eventNeighborhood];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSDate *date = [dateFormatter dateFromString:dict[@"created_at"]];
    
    self.title.text = eventName;
    self.subtitle.text = eventAddress;
    self.textTime.text = [date timeAgo];
    
    //Show event date range? I'm gonna null check just in case
    if(eventStartDate!=NULL && eventEndDate!=NULL)
    {
        self.imageTimeLabel.text = [Constants toDisplayDateRange:eventStartDate dbEndDateString:eventEndDate];
    }
    else {
        self.imageTimeLabel.text = @"";
    }
    
    //Load member icon circle
    [self.circle loadFacebookImage:fbId];
    
    //Could be a long cell (with buttons) or short cell (login,signup)
    if([typeCell isEqualToString:@"viewed"] || [typeCell isEqualToString:@"event_viewed"] || [typeCell isEqualToString:@"newhosting"] || [typeCell isEqualToString:@"invitation"] || [typeCell isEqualToString:@"confirmed_invite"] || [typeCell isEqualToString:@"accepted"]) {
        
        //Unhide stuff below
        self.image.hidden = NO;
        self.button1.hidden = NO;
        self.button2.hidden = NO;;
        self.sepImage.hidden = self.button2.hidden;
        
        //Set button 1
        [self.button1 setTitle:[self.choice1 uppercaseString] forState:UIControlStateNormal];
        
        //Set button 2
        [self.button2 setTitle:[self.choice2 uppercaseString] forState:UIControlStateNormal];

        //Load image picture URL
        if(imageUrl != NULL)
        {
            imageUrl = [self.sharedData picURL:imageUrl];
            [self.sharedData loadImage:imageUrl onCompletion:^()
             {
                 self.image.image = [self.sharedData.imagesDict objectForKey:imageUrl];
             }];
            [self addSubview:self.circle];
        }
    }
    else
    {
        //Hide stuff below for short feed items
        self.image.hidden = YES;
        self.button1.hidden = YES;
        self.button2.hidden = YES;
        self.sepImage.hidden = YES;
    }
    */
}


-(void)eventInfoHandler
{
    self.sharedData.cEventId_Feed = self.mainData[@"event_id"];
    self.sharedData.cEventId_Modal = self.mainData[@"event_id"];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_EVENT_MODAL"
     object:self];
}

-(void)profileHandler
{
    self.sharedData.member_fb_id = self.mainData[@"from_fb_id"];
    self.sharedData.member_user_id = self.mainData[@"from_fb_id"];//self.mainData[@"id"];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_MEMBER_PROFILE"
     object:self];
}

-(void)approveHandler
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    
    NSString *val = @"";
    if([self.sharedData.ABTestChat isEqualToString:@"YES"])
    {
        val = @"Connect";
    }else{
        val = @"Chat";
    }
    
    // [paramsToSend setObject:[self.feedData objectAtIndex:0][@"type"] forKey:@"feed_item_type"];
    
    AnalyticManager *analyticManager = [AnalyticManager sharedManager];
    [analyticManager trackMixPanelWithDict:@"Accept Feed Item" withDict:@{
                                                                        @"ABTestChat":val,
                                                                        @"feed_item_type":self.mainData[@"type"]
                                                                        }];
    
    
    //[self.sharedData trackMixPanelWithDict:@"Accept Feed Item" withDict:@{}];
    
    [analyticManager trackMixPanelIncrementWithDict:@{@"feed_item_accept":@1}];
    [analyticManager trackMixPanelIncrementWithDict:@{@"feed_item_response":@1}];
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSDictionary *params = @{
                             
                             };
    
    NSLog(@"FEEDITEM-SAVE Started :: %@",self.mainData);
    NSLog(@"FEEDITEM-SAVE Params Sent :: %@",params);
    
    NSString *url = [NSString stringWithFormat:@"%@/partyfeed_socialmatch/match/%@/%@/%@",PHBaseNewURL,self.sharedData.fb_id,self.mainData[@"from_fb_id"],@"approved"];
    NSLog(@"FEEDITEM-SAVE URL :: %@",url);
    
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"FEEDITEM-SAVE Response :: %@",responseObject);
         
         if ([self.mainData[@"type"] isEqualToString:@"approved"]) {
             self.sharedData.conversationId = self.mainData[@"from_fb_id"];
             self.sharedData.messagesPage.toId = self.mainData[@"from_fb_id"];
             self.sharedData.messagesPage.toLabel.text = [self.mainData[@"from_first_name"] uppercaseString];
             self.sharedData.feedMatchEvent = self.mainData[@"event_name"];
             self.sharedData.feedMatchImage = self.mainData[@"image"];
             self.sharedData.toImgURL = [self.sharedData profileImg:self.sharedData.fromMailId];
             
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"SHOW_FEED_MATCH"
              object:self];
         }
         
         [self.sharedData.feedPage loadData];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
     }];
}

-(void)denyHandler
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    
    NSString *val = @"";
    if([self.sharedData.ABTestChat isEqualToString:@"YES"])
    {
        val = @"Connect";
    }else{
        val = @"Chat";
    }
    
    AnalyticManager *analyticManager = [AnalyticManager sharedManager];
    [analyticManager trackMixPanelWithDict:@"Passed Feed Item" withDict:@{
                                                                          @"ABTestChat":val,
                                                                          @"feed_item_type":self.mainData[@"type"]
                                                                          }];
    
    
    //[self.sharedData trackMixPanelWithDict:@"Passed Feed Item" withDict:@{}];
    
    [analyticManager trackMixPanelIncrementWithDict:@{@"feed_item_passed":@1}];
    [analyticManager trackMixPanelIncrementWithDict:@{@"feed_item_response":@1}];
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSDictionary *params = @{
                             
                             };
    
    NSLog(@"FEEDITEM-SAVE Started :: %@",self.mainData);
    NSLog(@"FEEDITEM-SAVE Params Sent :: %@",params);
    
    NSString *url = [NSString stringWithFormat:@"%@/partyfeed_socialmatch/match/%@/%@/%@",PHBaseNewURL,self.sharedData.fb_id,self.mainData[@"from_fb_id"],@"denied"];
    ///app/v3/partyfeed/match/:fb_id/:member_fb_id/:match
    NSLog(@"FEEDITEM-SAVE URL :: %@",url);
    
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         [self.sharedData.feedPage loadData];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
     }];
}

-(void)reset
{
    self.image.image = [UIImage imageNamed:@""];
    [self.circle setImage:[UIImage imageNamed:@"fbperson_blank_square"] forState:UIControlStateNormal];
    self.textLine1.text = @"";
    self.textLine2.text = @"";
    self.textTime.text = @"";
}

//This just opens the chat
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
}

//Open chat
-(void)openChat
{
    //Show chat now
    self.sharedData.toImgURL = [self.sharedData profileImg:self.mainData[@"from_fb_id"]];
    self.sharedData.messagesPage.toId = self.mainData[@"from_fb_id"];
    self.sharedData.messagesPage.toLabel.text = [self.mainData[@"user"][@"first_name"] uppercaseString];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_MESSAGES"
     object:self];
}

//Image tapped
-(void)imageHandler:(UITapGestureRecognizer *)sender
{
    UIView *tintView = [self viewWithTag:202];
    tintView.hidden = NO;
    tintView.alpha = 0.2;
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:BUTTON_TINT_DURATION delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        tintView.alpha = 0;
    } completion:^(BOOL finished) {
        //Switch the data now
        [self.sharedData.hostVenueDetailPage loadData:self.mainData];
     
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"SHOW_HOST_VENUE_DETAIL"
         object:self];
        
        tintView.hidden = YES;
        
        //Reenable presses to the view, but do it later
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            self.userInteractionEnabled = YES;
        });
    }];
}


@end
