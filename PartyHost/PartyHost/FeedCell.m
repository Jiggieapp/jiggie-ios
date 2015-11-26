//
//  FeedCell.m
//  PartyHost
//
//  Created by Tony Suriyathep on 4/24/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//



#import "FeedCell.h"


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
        /*
        //White card background
        self.bg = [[UIView alloc] init];
        self.bg.frame = CGRectMake(4,4,self.sharedData.screenWidth-8,self.sharedData.feedCellHeightLong-4);
        self.bg.backgroundColor = [UIColor whiteColor];
        self.bg.layer.cornerRadius = 4;
        self.bg.layer.masksToBounds = YES;
        [self addSubview:self.bg];
        
        //User facebook icon
        self.circle = [[UserBubble alloc] initWithFrame:CGRectMake(10+4, 10+4, 50, 50)];
        [self.circle addTarget:self action:@selector(circleTapHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self.bg addSubview:self.circle];
        
        self.textLine1 = [[UILabel alloc] init];
        self.textLine1.frame = CGRectMake(INNER_PADDING+CIRCLE_SIZE+16,INNER_PADDING,self.bg.frame.size.width-CIRCLE_SIZE-(INNER_PADDING*2)-8,16);
        self.textLine1.textColor = [UIColor blackColor];
        self.textLine1.font = [UIFont phBold:12];
        self.textLine1.adjustsFontSizeToFitWidth = YES;
        [self.bg addSubview:self.textLine1];
        
        //Line 2
        self.textLine2 = [[UILabel alloc] init];
        self.textLine2.frame = CGRectMake(self.textLine1.frame.origin.x,self.textLine1.frame.origin.y+self.textLine1.frame.size.height,self.textLine1.frame.size.width,16);
        self.textLine2.font = [UIFont phBlond:12];
        self.textLine2.textColor = [UIColor blackColor];
        self.textLine2.adjustsFontSizeToFitWidth = YES;
        [self.bg addSubview:self.textLine2];
        
        //Time
        self.textTime = [[UILabel alloc] init];
        self.textTime.frame = CGRectMake(self.textLine1.frame.origin.x,self.textLine2.frame.origin.y+self.textLine2.frame.size.height+1,self.textLine1.frame.size.width,12);
        self.textTime.font = [UIFont phBlond:10];
        self.textTime.textColor = [UIColor grayColor];
        [self.bg addSubview:self.textTime];
        
        //BUTTON 1
        self.button1 = [[UIButton alloc] init];
        self.button1.frame = CGRectMake(self.bg.frame.size.width/2,self.bg.frame.size.height-44,self.bg.frame.size.width/2,44);
        self.button1.backgroundColor = [UIColor phPurpleColor];
        self.button1.titleLabel.font = [UIFont phBold:17];
        [self.button1 setTitleEdgeInsets:UIEdgeInsetsMake(3,0,0,0)];
        [self.button1 setTitle:@"" forState:UIControlStateNormal];
        [self.button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.button1 addTarget:self action:@selector(button1Handler:) forControlEvents:UIControlEventTouchUpInside];
        [self.bg addSubview:self.button1];
        
        //BUTTON 2
        self.button2 = [[UIButton alloc] init];
        self.button2.frame = CGRectMake(0,self.bg.frame.size.height-44,self.bg.frame.size.width/2,44);
        self.button2.backgroundColor = [UIColor phPurpleColor];
        self.button2.titleLabel.font = [UIFont phBold:17];
        [self.button2 setTitleEdgeInsets:UIEdgeInsetsMake(3,0,0,0)];
        [self.button2 setTitle:@"" forState:UIControlStateNormal];
        [self.button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.button2 addTarget:self action:@selector(button2Handler:) forControlEvents:UIControlEventTouchUpInside];
        [self.bg addSubview:self.button2];
        
        //Separator for buttons
        self.sepImage = [[UIImageView alloc] init];
        self.sepImage.frame = CGRectMake(self.bg.frame.size.width/2-1,self.bg.frame.size.height-44+8,1,44-16);
        self.sepImage.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        [self.bg addSubview:self.sepImage];
        
        //Large image
        self.image = [[UIImageView alloc] init];
        self.image.frame = CGRectMake(0,self.textTime.frame.origin.y+self.textTime.frame.size.height+12,self.bg.frame.size.width,self.button1.frame.origin.y - self.textTime.frame.origin.y - self.textTime.frame.size.height - 12);
        [self.image setContentMode:UIViewContentModeScaleAspectFill];
        self.image.userInteractionEnabled = YES;
        self.image.layer.masksToBounds = YES;
        [self.bg addSubview:self.image];
        
        
        //Add light tint
        self.imageTint = [[UIView alloc] init];
        self.imageTint.frame = self.image.bounds;
        self.imageTint.backgroundColor = [UIColor blackColor];
        self.imageTint.alpha = 0.2;
        self.imageTint.tag = 202;
        self.imageTint.hidden = YES;
        self.imageTint.userInteractionEnabled = NO;
        [self.image addSubview:self.imageTint];
        
        //Image press
        UITapGestureRecognizer *imagePress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageHandler:)];
        [self.image addGestureRecognizer:imagePress];
        
        //Big white title of venue
        self.title = [[UILabel alloc] init];
        self.title.frame = CGRectMake(8, self.image.frame.origin.y+8, self.sharedData.screenWidth - 32, 24);
        self.title.textColor = [UIColor whiteColor];
        self.title.textAlignment = NSTextAlignmentLeft;
        self.title.font = [UIFont phBold:24];
        self.title.shadowColor = [UIColor blackColor];
        self.title.shadowOffset = CGSizeMake(0.5,0.5);
        //[self.bg addSubview:self.title];
        
        //Neighborhood of venue
        self.subtitle = [[UILabel alloc] init];
        self.subtitle.frame = CGRectMake(8, self.title.frame.origin.y+self.title.frame.size.height+3, self.sharedData.screenWidth - 32, 16);
        self.subtitle.textColor = [UIColor whiteColor];
        self.subtitle.textAlignment = NSTextAlignmentLeft;
        self.subtitle.font = [UIFont phBlond:16];
        self.subtitle.shadowColor = [UIColor blackColor];
        self.subtitle.shadowOffset = CGSizeMake(0.25,0.25);
        //[self.bg addSubview:self.subtitle];
        
        //Time
        self.imageTimeLabel = [[UILabel alloc] init];
        self.imageTimeLabel.frame = CGRectMake(8, self.subtitle.frame.origin.y+self.subtitle.frame.size.height+3, self.sharedData.screenWidth - 32, 16);
        self.imageTimeLabel.textColor = [UIColor colorFromHexCode:@"EEEEEE"];
        self.imageTimeLabel.textAlignment = NSTextAlignmentLeft;
        self.imageTimeLabel.font = [UIFont phBlond:12];
        self.imageTimeLabel.shadowColor = [UIColor blackColor];
        self.imageTimeLabel.shadowOffset = CGSizeMake(0.25,0.25);
        //[self.bg addSubview:self.imageTimeLabel];
        */
        
        
        self.cardOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mainCon.bounds.size.width, self.mainCon.bounds.size.height)];
        [self.mainCon addSubview:self.cardOne];
        
        self.cardTwo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mainCon.bounds.size.width, self.mainCon.bounds.size.height)];
        self.cardTwo.backgroundColor = [UIColor whiteColor];
        [self.mainCon addSubview:self.cardTwo];
        
        
        int OffSet = (self.sharedData.isIphone4)?86:0;
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
        self.btnUserImage.frame = CGRectMake(0, 0, self.mainCon.bounds.size.width, 185 - OffSet + OffSetLargeDevice/2);
        self.btnUserImage.contentMode = UIViewContentModeScaleAspectFill;
        self.btnUserImage.layer.masksToBounds = YES;
        [self.btnUserImage addTarget:self action:@selector(profileHandler) forControlEvents:UIControlEventTouchUpInside];
        [self.cardOne addSubview:self.btnUserImage];
        
        self.greenCircle = [[UIView alloc] initWithFrame:CGRectMake((self.mainCon.bounds.size.width/2) - 30, 185 - 35  - OffSet + OffSetLargeDevice/2, 60, 60)];
        self.greenCircle.backgroundColor = [UIColor phBlueColor];
        self.greenCircle.layer.cornerRadius = 30;
        self.greenCircle.layer.masksToBounds = YES;
        [self.cardOne addSubview:self.greenCircle];
        
        UIImageView *textIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        textIcon.image = [UIImage imageNamed:@"text-icon"];
        [self.greenCircle addSubview:textIcon];

        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 215 - OffSet + OffSetLargeDevice * 0.7, self.mainCon.bounds.size.width, 30)];
        self.nameLabel.textColor = [self.sharedData colorWithHexString:@"5c5c5c"];
        self.nameLabel.font = [UIFont phBlond:15 + OffsetFontLargeDevice];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.cardOne addSubview:self.nameLabel];
        
        self.eventLabel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.eventLabel.frame = CGRectMake(0, 235 - OffSet + OffSetLargeDevice * 0.7, self.mainCon.bounds.size.width, 40);
        [self.eventLabel setTitleColor:[UIColor phBlueColor] forState:UIControlStateNormal];
        self.eventLabel.titleLabel.font = [UIFont phBold:16 + OffsetFontLargeDevice];
        self.eventLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.eventLabel.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.eventLabel.titleLabel.numberOfLines = 2;
//        self.eventLabel.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        [self.eventLabel setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 30)];
        [self.eventLabel addTarget:self action:@selector(eventInfoHandler) forControlEvents:UIControlEventTouchUpInside];
        [self.cardOne addSubview:self.eventLabel];
        
        self.recLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 255 - OffSet + OffSetLargeDevice * 0.7, self.mainCon.bounds.size.width, 30)];
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
    
    
    self.cardTwo.hidden = [self.mainData[@"type"] isEqualToString:@"approved"];
    
    NSString *usrImgURL = [self.sharedData profileImgLarge:self.mainData[@"from_fb_id"]];
    
    [self.btnUserImage setImage:[UIImage imageNamed:@"fbperson_blank_square"] forState:UIControlStateNormal];
    self.btnUserImage.contentMode = UIViewContentModeScaleToFill;
    self.btnUserImage.imageView.contentMode = UIViewContentModeScaleToFill;
    
    [self.btnUserImageTwo setImage:[UIImage imageNamed:@"fbperson_blank_square"] forState:UIControlStateNormal];
    
    
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
    
    
    
    CGSize eventSize = CGSizeMake(self.eventLabel.bounds.size.width - 60, self.eventLabel.bounds.size.height);
    CGRect stringFrame = [eventLabelText boundingRectWithSize:eventSize
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:self.eventLabel.titleLabel.font}
                                                      context:nil];
    
    int Offset = -8;
    if (self.sharedData.isIphone6 || self.sharedData.isIphone6plus) {
        Offset = 8;
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
    
    [self.sharedData trackMixPanelWithDict:@"Accept Feed Item" withDict:@{
                                                                        @"ABTestChat":val,
                                                                        @"feed_item_type":self.mainData[@"type"]
                                                                        }];
    
    
    //[self.sharedData trackMixPanelWithDict:@"Accept Feed Item" withDict:@{}];
    
    [self.sharedData trackMixPanelIncrementWithDict:@{@"feed_item_accept":@1}];
    [self.sharedData trackMixPanelIncrementWithDict:@{@"feed_item_response":@1}];
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSDictionary *params = @{
                             
                             };
    
    NSLog(@"FEEDITEM-SAVE Started :: %@",self.mainData);
    NSLog(@"FEEDITEM-SAVE Params Sent :: %@",params);
    
    NSString *url = [NSString stringWithFormat:@"%@/partyfeed/match/%@/%@/%@",PHBaseURL,self.sharedData.fb_id,self.mainData[@"from_fb_id"],@"approved"];
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
    [self.sharedData trackMixPanelWithDict:@"Passed Feed Item" withDict:@{
                                                                          @"ABTestChat":val,
                                                                          @"feed_item_type":self.mainData[@"type"]
                                                                          }];
    
    
    //[self.sharedData trackMixPanelWithDict:@"Passed Feed Item" withDict:@{}];
    
    [self.sharedData trackMixPanelIncrementWithDict:@{@"feed_item_passed":@1}];
    [self.sharedData trackMixPanelIncrementWithDict:@{@"feed_item_response":@1}];
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSDictionary *params = @{
                             
                             };
    
    NSLog(@"FEEDITEM-SAVE Started :: %@",self.mainData);
    NSLog(@"FEEDITEM-SAVE Params Sent :: %@",params);
    
    NSString *url = [NSString stringWithFormat:@"%@/partyfeed/match/%@/%@/%@",PHBaseURL,self.sharedData.fb_id,self.mainData[@"from_fb_id"],@"denied"];
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
    self.image.image = [UIImage imageNamed:@"nightclub_default"];
    [self.circle setImage:[UIImage imageNamed:@"fbperson_blank_square"] forState:UIControlStateNormal];
    self.textLine1.text = @"";
    self.textLine2.text = @"";
    self.textTime.text = @"";
}

//Show member profile by tapping the circle icon
-(void)circleTapHandler:(UIButton *)button
{
    self.sharedData.member_fb_id = self.mainData[@"user"][@"fb_id"];
    self.sharedData.member_user_id = self.mainData[@"user"][@"fb_id"];//self.mainData[@"id"];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_MEMBER_PROFILE"
     object:self];
}

//Send the button press
-(void)saveFeedItem:(NSString*)feedItemId apiChoice:(NSString*)apiChoice
{
    //Start spinner
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    //NSString *facebookId = [self.sharedData.userDict objectForKey:@"fb_id"];
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSDictionary *params = @{
                             @"from_fb_id" : self.sharedData.fb_id,
                             @"feed_item_id": feedItemId,
                             @"event_id": self.mainData[@"event"][@"_id"]
                             };
    
    NSLog(@"FEEDITEM-SAVE Started :: %@",self.mainData);
    NSLog(@"FEEDITEM-SAVE Params Sent :: %@",params);
    
    NSString *url = [NSString stringWithFormat:@"%@/user/hostings/%@/%@/%@",PHBaseURL,apiChoice,self.mainData[@"from_fb_id"],self.mainData[@"hosting_id"]];
    
    NSLog(@"FEEDITEM-SAVE URL :: %@",url);
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"FEEDITEM-SAVE responseObject :: %@",responseObject);
         
         NSLog(@"FEEDITEM-CHAT mainData :: %@",self.mainData);
         
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         NSString *typeCell = self.mainData[@"type"];
         
         [self.sharedData.mixPanelCEventDict removeAllObjects];
         
         
         [self.sharedData.mixPanelCEventDict setObject:self.mainData[@"event"][@"title"] forKey:@"Event Name"];
         [self.sharedData.mixPanelCEventDict setObject:self.mainData[@"event"][@"start_datetime_str"] forKey:@"Event Start Time"];
         [self.sharedData.mixPanelCEventDict setObject:self.mainData[@"event"][@"end_datetime_str"] forKey:@"Event End Time"];
         [self.sharedData.mixPanelCEventDict setObject:self.mainData[@"event"][@"description"] forKey:@"Event Description"];
         [self.sharedData.mixPanelCEventDict setObject:self.mainData[@"event"][@"venue_name"] forKey:@"Event Venue Name"];
         [self.sharedData.mixPanelCEventDict setObject:self.mainData[@"event"][@"venue"][@"neighborhood"] forKey:@"Event Venue Neighborhood"];
         [self.sharedData.mixPanelCEventDict setObject:self.mainData[@"event"][@"venue"][@"city"] forKey:@"Event Venue City"];
         //[self.sharedData.mixPanelCEventDict setObject:self.mainData[@"event"][@"venue"][@"state"] forKey:@"Event Venue State"];
         [self.sharedData.mixPanelCEventDict setObject:self.mainData[@"event"][@"venue"][@"description"] forKey:@"Event Venue Description"];
         [self.sharedData.mixPanelCEventDict setObject:self.mainData[@"event"][@"venue"][@"zip"] forKey:@"Event Venue Zip"];
         
         
         NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
         [tmpDict addEntriesFromDictionary:self.sharedData.mixPanelCEventDict];
         
         NSMutableDictionary *tmpUserHostDict = [[NSMutableDictionary alloc] init];
         NSMutableDictionary *tmpUserGuestDict = [[NSMutableDictionary alloc] init];
         
         
         
         if(self.sharedData.isHost)
         {
             [tmpUserHostDict addEntriesFromDictionary:self.sharedData.userDict];
             [tmpUserGuestDict addEntriesFromDictionary:self.mainData[@"user"]];
         }else{
             [tmpUserGuestDict addEntriesFromDictionary:self.sharedData.userDict];
             [tmpUserHostDict addEntriesFromDictionary:self.mainData[@"user"]];
         }
         
         NSLog(@"tmpUserHostDict :: %@",tmpUserHostDict);
         NSLog(@"tmpUserGuestDict :: %@",tmpUserGuestDict);
         [tmpDict setObject:tmpUserHostDict[@"first_name"] forKey:@"Hosting Host First Name"];
         //[tmpDict setObject:tmpUserHostDict[@"last_name"] forKey:@"Hosting Host Last Name"];
         //[tmpDict setObject:[NSString stringWithFormat:@"%@ %@",tmpUserHostDict[@"first_name"],tmpUserHostDict[@"last_name"]] forKey:@"Hosting Host Whole Name"];
         
         //[tmpDict setObject:tmpUserHostDict[@"email"] forKey:@"Hosting Host Email"];
         [tmpDict setObject:tmpUserHostDict[@"fb_id"] forKey:@"Hosting Host FB ID"];
         [tmpDict setObject:tmpUserHostDict[@"gender"] forKey:@"Hosting Host Gender"];
         //[tmpDict setObject:tmpUserHostDict[@"birthday"] forKey:@"Hosting Host Birthday"];
         
         
         
         [tmpDict setObject:tmpUserGuestDict[@"first_name"] forKey:@"Hosting Guest First Name"];
         //[tmpDict setObject:tmpUserGuestDict[@"last_name"] forKey:@"Hosting Guest Last Name"];
         //[tmpDict setObject:[NSString stringWithFormat:@"%@ %@",tmpUserGuestDict[@"first_name"],tmpUserGuestDict[@"last_name"]] forKey:@"Hosting Host Whole Name"];
         
         //[tmpDict setObject:tmpUserGuestDict[@"email"] forKey:@"Hosting Guest Email"];
         [tmpDict setObject:tmpUserGuestDict[@"fb_id"] forKey:@"Hosting Guest FB ID"];
         [tmpDict setObject:tmpUserGuestDict[@"gender"] forKey:@"Hosting Guest Gender"];
         //[tmpDict setObject:tmpUserGuestDict[@"birthday"] forKey:@"Hosting Guest Birthday"];
         
         
         
         
         
         
         [tmpDict setObject:self.mainData[@"hosting"][@"description"] forKey:@"Hosting Description"];
         
         [tmpDict setObject:self.mainData[@"hosting"][@"start_datetime_str"] forKey:@"Hosting Start Time"];
         [tmpDict setObject:self.mainData[@"hosting"][@"end_datetime_str"] forKey:@"Hosting End Time"];
         
         
         
         /*
          [mixpanel.people set:@{@"first_name": first_name}];
          [mixpanel.people set:@{@"last_name": last_name}];
          [mixpanel.people set:@{@"birthday": birthday}];
          [mixpanel.people set:@{@"age": age}];
          [mixpanel.people set:@{@"email": email}];
          [mixpanel.people set:@{@"fb_id": facebookId}];
          
          [mixpanel registerSuperProperties:@{@"account_type": self.account_type}];
          [mixpanel registerSuperProperties:@{@"gender": self.gender}];
          [mixpanel registerSuperProperties:@{@"gender_interest": self.gender_interest}];
          [mixpanel registerSuperProperties:@{@"os_version": [UIDevice currentDevice].systemVersion}];
          [mixpanel registerSuperProperties:@{@"device_type": self.deviceType}];
          [mixpanel registerSuperProperties:@{@"location": location}];
          */
         
         
         
         [tmpDict setObject:@"origin" forKey:@"Party Feed"];
         
         //[self.sharedData trackMixPanelWithDict:@"Ticket List View" withDict:tmpDict];
         
         
         if([apiChoice isEqualToString:@"invite"])
         {
             [self.sharedData trackMixPanelWithDict:@"Sent Event Invite" withDict:tmpDict];
             
             [self.sharedData trackMixPanelIncrementWithDict:@{@"send_invite":@1}];
         }
         
         if([apiChoice isEqualToString:@"accepted"])
         {
             [tmpDict setObject:@"type" forKey:typeCell];
             [self.sharedData trackMixPanelWithDict:@"Accept Feed Item" withDict:tmpDict];
             [self.sharedData trackMixPanelIncrementWithDict:@{@"accept_feed_item":@1}];
         }
         
         
         if([apiChoice isEqualToString:@"passed"])
         {
             [tmpDict setObject:@"type" forKey:typeCell];
             [self.sharedData trackMixPanelWithDict:@"Passed Feed Item" withDict:tmpDict];
             [self.sharedData trackMixPanelIncrementWithDict:@{@"pass_feed_item":@1}];
         }
         
         //[self.sharedData trackMixPanelIncrementWithDict:@{@"send_invite":@1}];
         
         if([apiChoice isEqualToString:@"rejected"])
         {
             [self.sharedData trackMixPanelWithDict:@"Invitation Rejection" withDict:tmpDict];
             [self.sharedData trackMixPanelIncrementWithDict:@{@"reject_invite":@1}];
         }

         
         //Check first time invite
         if(([typeCell isEqualToString:@"viewed"] || [typeCell isEqualToString:@"event_viewed"]) && [apiChoice isEqualToString:self.apiChoice1])
         {
             [defaults setValue:NULL forKey:@"SHOWED_INVITE_GUEST"]; //Testing
             if(![defaults objectForKey:@"SHOWED_INVITE_GUEST"])
             {
                 [defaults setValue:@"YES" forKey:@"SHOWED_INVITE_GUEST"];
                 [defaults synchronize];
                 /*
                 //Open chat
                 [self openChat];
                 
                 //One-time warning that we are sending you to the chat
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Guest Invited"
                                                                 message:@"You have just invited a guest to your hosting. Check your chat messages to see if they are interested."
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                 [alert show];
                 */
             }
         }
         else if(([typeCell isEqualToString:@"invitation"] || [typeCell isEqualToString:@"newhosting"]) && [apiChoice isEqualToString:self.apiChoice1])
         {
             if(![defaults objectForKey:@"SHOWED_ACCEPTED_CHAT"])
             {
                 [defaults setValue:@"YES" forKey:@"SHOWED_ACCEPTED_CHAT"];
                 [defaults synchronize];
                 
                 //One-time warning that we are sending you to the chat
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Host Chat"
                                                                 message:@"Chat with the host right here to get more information on this hosting!"
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                 [alert show];
                 
             }
             
             [self openChat];
             //return;
         }
         
         [self.sharedData.feedPage loadData];
         //[self.sharedData.feedPage forceReload];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR :: %@",error);
         
         //Reload anyway, the item might have changed
         [self.sharedData.feedPage loadData];
         //[self.sharedData.feedPage forceReload];
         
         //Hide spinner
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         /*
         //Alert error!
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Connection"
                                                         message:@"Feed item could not be set."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
         [alert show];
          */
     }];
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

//Button 1 tapped
-(void)button1Handler:(UITapGestureRecognizer *)sender
{
    UIView *tintView = [self viewWithTag:200];
    tintView.hidden = NO;
    tintView.alpha = 0.2;
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:BUTTON_TINT_DURATION delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        tintView.alpha = 0;
    } completion:^(BOOL finished) {
        NSString *feedItemId = self.mainData[@"_id"];
        [self saveFeedItem:feedItemId apiChoice:self.apiChoice1];
        
        tintView.hidden = YES;
        
        //Reenable presses to the view, but do it later
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            self.userInteractionEnabled = YES;
        });
    }];
}

//Button 2 tapped
-(void)button2Handler:(UITapGestureRecognizer *)sender
{
    UIView *tintView = [self viewWithTag:201];
    tintView.hidden = NO;
    tintView.alpha = 0.2;
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:BUTTON_TINT_DURATION delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        tintView.alpha = 0;
    } completion:^(BOOL finished) {
        NSString *feedItemId = self.mainData[@"_id"];
        [self saveFeedItem:feedItemId apiChoice:self.apiChoice2];
     
        tintView.hidden = YES;
        
        //Reenable presses to the view, but do it later
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            self.userInteractionEnabled = YES;
        });
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
