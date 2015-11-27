//
//  EventsHostDetail.m
//  PartyHost
//
//  Created by Sunny Clark on 2/14/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "EventsHostDetail.h"

@implementation EventsHostDetail {
    NSString *lastFbId;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.memberProfileDict = [[NSMutableDictionary alloc] init];
    self.sharedData = [SharedData sharedInstance];
    lastFbId = @"";
    
    self.tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 77)];
    self.tabBar.backgroundColor = [UIColor phLightTitleColor];
    [self addSubview:self.tabBar];
    
    self.btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnBack.frame = CGRectMake(0, 20, 40, 40);
    [self.btnBack setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [self.btnBack setImageEdgeInsets:UIEdgeInsetsMake(8, 14, 8, 14)];
    [self.btnBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:self.btnBack];
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(40, 32, self.sharedData.screenWidth - 80, 22)];
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.textColor = [UIColor whiteColor];
    self.title.adjustsFontSizeToFitWidth = YES;
    self.title.font = [UIFont phBold:18];
    [self.tabBar addSubview:self.title];
    
    //BUTTON 1
    self.button1 = [[UIButton alloc] init];
    self.button1.frame = CGRectMake(0,self.sharedData.screenHeight - PHTabHeight -44,(int)(self.sharedData.screenWidth/2),44);
    self.button1.backgroundColor = [UIColor phPurpleColor];
    self.button1.titleLabel.font = [UIFont phBold:17];
    [self.button1 setTitleEdgeInsets:UIEdgeInsetsMake(3,0,0,0)];
    [self.button1 setTitle:@"INTERESTED" forState:UIControlStateNormal];
    [self.button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.button1 addTarget:self action:@selector(button1Handler:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.button1];
    
    //BUTTON 2
    self.button2 = [[UIButton alloc] init];
    self.button2.frame = CGRectMake(self.button1.frame.size.width,self.button1.frame.origin.y,((int)self.sharedData.screenWidth/2)+2,44);
    self.button2.backgroundColor = [UIColor phPurpleColor];
    self.button2.titleLabel.font = [UIFont phBold:17];
    [self.button2 setTitleEdgeInsets:UIEdgeInsetsMake(3,0,0,0)];
    [self.button2 setTitle:@"SHARE" forState:UIControlStateNormal];
    [self.button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.button2 addTarget:self action:@selector(button2Handler:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.button2];
    
    //Separator for buttons
    self.buttonSeparator = [[UIImageView alloc] init];
    self.buttonSeparator.frame = CGRectMake(self.button1.frame.size.width+1,self.button1.frame.origin.y+8,1,44-16);
    self.buttonSeparator.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    [self addSubview:self.buttonSeparator];
    
    self.subtitle = [[UILabel alloc] initWithFrame:CGRectMake(30, self.title.frame.origin.y + self.title.frame.size.height -2, self.sharedData.screenWidth - 60, 20)];
    self.subtitle.font = [UIFont phBold:9];
    self.subtitle.textAlignment = NSTextAlignmentCenter;
    self.subtitle.textColor = [UIColor colorWithWhite:1 alpha:0.75];
    self.subtitle.userInteractionEnabled = NO;
    self.subtitle.backgroundColor = [UIColor clearColor];
    [self.tabBar addSubview:self.subtitle];
    
    self.mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.tabBar.frame.size.height + self.tabBar.frame.origin.y, self.sharedData.screenWidth,self.sharedData.screenHeight - self.tabBar.frame.size.height - PHTabHeight -44)];
    self.mainScroll.showsVerticalScrollIndicator    = NO;
    self.mainScroll.showsHorizontalScrollIndicator  = NO;
    self.mainScroll.scrollEnabled                   = YES;
    self.mainScroll.userInteractionEnabled          = YES;
    self.mainScroll.delegate                        = self;
    self.mainScroll.backgroundColor                 = [UIColor phDarkBodyColor];
    self.mainScroll.contentSize                     = CGSizeMake(self.sharedData.screenWidth, 800);
    self.mainScroll.layer.masksToBounds             = YES;
    [self addSubview:self.mainScroll];
    
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, self.sharedData.screenWidth, self.sharedData.screenHeight)];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    [self.mainScroll addSubview:self.backgroundView];
    
    self.userImage = [[PHImage alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 300)];
    self.userImage.contentMode = UIViewContentModeScaleAspectFill;
    self.userImage.backgroundColor = [UIColor blackColor];
    self.userImage.alignTop = true;
    self.userImage.layer.masksToBounds = YES;
    [self.mainScroll addSubview:self.userImage];
    
    //Resign first responder when tapped away
    UITapGestureRecognizer *userTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapHandler)];
    self.userImage.userInteractionEnabled = YES;
    [self.userImage addGestureRecognizer:userTapGesture];
    
    //Create member name
    self.memberName = [[UILabel alloc] initWithFrame:CGRectMake(20,self.userImage.frame.origin.y+self.userImage.frame.size.height+24+8,self.sharedData.screenWidth-40,16)];
    self.memberName.font = [UIFont phBold:18];
    self.memberName.textAlignment = NSTextAlignmentLeft;
    self.memberName.textColor = [UIColor blackColor];
    [self.mainScroll addSubview:self.memberName];
    
    //Create interest
    self.interestCount = [[UILabel alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth-20-100,self.memberName.frame.origin.y,100,12)];
    self.interestCount.font = [UIFont phBold:10];
    self.interestCount.textAlignment = NSTextAlignmentRight;
    self.interestCount.textColor = [UIColor colorFromHexCode:@"BDBDBD"];
    [self.mainScroll addSubview:self.interestCount];
    
    self.separator1 = [[UIView alloc] initWithFrame:CGRectMake(20,self.memberName.frame.size.height + self.memberName.frame.origin.y + 20, self.sharedData.screenWidth - 40, 1)];
    self.separator1.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05];
    [self.mainScroll addSubview:self.separator1];
    
    //Star reviews
    self.reviewContainer = [[UIView alloc] initWithFrame:CGRectMake(0,self.separator1.frame.origin.y+self.separator1.frame.size.height+20,self.sharedData.screenWidth, 24+8+12)];
    self.reviewContainer.hidden = NO;
    //self.reviewContainer.backgroundColor = [UIColor greenColor];
    [self.mainScroll addSubview:self.reviewContainer];
    
    //Review tap gesture for uiview
    UITapGestureRecognizer *reviewStarTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reviewClicked)];
    [self.reviewContainer addGestureRecognizer:reviewStarTap];
    
    //Create star images
    self.reviewRatingView = [[RatingView alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth/2 - (30*5)/2,0,(30*5), 24)];
    //self.reviewRatingView.backgroundColor = [UIColor redColor];
    [self.reviewRatingView updateRating:nil stars:4.5];
    [self.reviewContainer addSubview:self.reviewRatingView];
    
    //Review count
    self.reviewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 24 + 6, self.sharedData.screenWidth, 24)];
    self.reviewLabel.text = @"4.0 Jiggie Rating, 10 Reviews";
    self.reviewLabel.textAlignment = NSTextAlignmentCenter;
    self.reviewLabel.font = [UIFont phBlond:10];
    self.reviewLabel.textColor = [UIColor colorFromHexCode:@"5C5C5C"];
    //self.reviewLabel.backgroundColor = [UIColor redColor];
    [self.reviewContainer addSubview:self.reviewLabel];
    
    self.separator2 = [[UIView alloc] initWithFrame:CGRectMake(20,self.reviewContainer.frame.size.height + self.reviewContainer.frame.origin.y + 20, self.sharedData.screenWidth - 40, 1)];
    self.separator2.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05];
    [self.mainScroll addSubview:self.separator2];
    
    self.descriptionText = [[UITextView alloc] init];
    self.descriptionText.font = [UIFont phBlond:17];
    self.descriptionText.textColor = [UIColor blackColor];
    self.descriptionText.textAlignment = NSTextAlignmentLeft;
    self.descriptionText.userInteractionEnabled = NO;
    self.descriptionText.textContainerInset = UIEdgeInsetsMake(6, 0, 4, 0);
    self.descriptionText.text = @"";
    [self.mainScroll addSubview:self.descriptionText];
    
    self.separator3 = [[UIView alloc] init];
    self.separator3.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05];
    [self.mainScroll addSubview:self.separator3];
    
    self.offeringsContainer = [[UIView alloc] init];
    //self.offeringsContainer.backgroundColor = [UIColor redColor];
    [self.mainScroll addSubview:self.offeringsContainer];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(memberReviewSubmitted:)
     name:@"MEMBER_REVIEW_SUBMITTED"
     object:nil];
    
    return self;
}

-(void)memberReviewSubmitted:(NSNotification *)notification {
    NSString *member_fb_id = notification.userInfo[@"member_fb_id"]; //Who got reviewd?
    
    if(self.hidden == NO && [member_fb_id isEqualToString:lastFbId]) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"SHOW_LOADING"
         object:self];
        
        NSLog(@">>> EventHostDetail member review submitted");
        
        [self loadMemberProfile];
    }
}

/*
-(void)forceReload
{
    lastFbId = @"";
    [self initClass];
}
 */


-(void)initClass
{
    //Title
    self.title.text = [self.sharedData.eventDict[@"title"] uppercaseString];
    
    //Date
    //self.subtitle.text = [[Constants toTitleDate:self.sharedData.eventDict[@"start_datetime_str"]] uppercaseString];
    self.subtitle.text = [[Constants toTitleDateRange:self.sharedData.eventDict[@"start_datetime_str"] dbEndDateString:self.sharedData.eventDict[@"end_datetime_str"]] uppercaseString];
    
    //Is accepted
    self.isAccepted = [self.sharedData.selectedHost[@"hosting"][@"is_accepted"] boolValue];
    
    //Load host user image
    NSString *pic_url = [self.sharedData profileImgLarge:self.sharedData.selectedHost[@"fb_id"]];
    self.userImage.showLoading = YES;
    [self.userImage loadImage:pic_url defaultImageNamed:nil];
    
    //Load host user entire profile
    [self loadMemberProfile];
}

//This handles the logic for host/guest whether they "can_write_review" and depending on how reviews are already there
-(void)reviewClicked
{
    //Hosts can NEVER see or write reviews
    if([self.sharedData isHost])
    {
        NSLog(@"REVIEW_LOGIC :: Host cannot see reviews");
        return;
    }
    
    //Check reviews
    BOOL can_write_review = [self.sharedData.memberProfileDict[@"can_write_review"] boolValue];
    int review_count = [self.sharedData.memberProfileDict[@"review_count"] intValue];
    if(review_count<=0) //There are no reviews so write one now
    {
        if(can_write_review) //No reviews to read, so just start writing one
        {
            NSLog(@"REVIEW_LOGIC :: can_write_review=true and no reviews to read");
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"SHOW_MEMBER_WRITE_REVIEW"
             object:self];
            return;
        }
        else //We are not allowed to write, so do NOTHING
        {
            NSLog(@"REVIEW_LOGIC :: can_write_review=false and no reviews to read");
            return;
        }
    }
    else //Give a choice to write a review or see reviews
    {
        if(can_write_review) //No reviews to read, so just start writing one
        {
            NSLog(@"REVIEW_LOGIC :: can_write_review=true and can read, so show action sheet");
            
            UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                    @"See Reviews",
                                    @"Write Review",
                                    nil];
            popup.tag = 1;
            [popup showInView:[UIApplication sharedApplication].keyWindow];
            return;
        }
        else //Has reviews but cannot write any, so go straight to READ REVIEWS
        {
            NSLog(@"REVIEW_LOGIC :: can_write_review=false and can read, so show reviews only");
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"SHOW_MEMBER_REVIEWS"
             object:self];
            
            return;
        }
    }
}


- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"SHOW_MEMBER_REVIEWS"
                     object:self];
                    break;
                case 1:
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"SHOW_MEMBER_WRITE_REVIEW"
                     object:self];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

-(void)userTapHandler
{
    self.sharedData.member_fb_id = self.sharedData.selectedHost[@"fb_id"];
    self.sharedData.member_user_id = self.sharedData.selectedHost[@"fb_id"];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_MEMBER_PROFILE"
     object:self];
}

-(void)button1Handler:(UITapGestureRecognizer *)sender
{
    //Self!
    if(self.isSelf) {
        //Alert error!
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Chat Error"
                                                        message:@"You are chatting with yourself."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //NSLog(@">>> HOST %@",self.sharedData.selectedHost);
    
    //Chat or send message
    if(self.isAccepted)
    {
        //Open chat now
        self.sharedData.toImgURL = [self.sharedData profileImg:self.sharedData.selectedHost[@"fb_id"]];
        self.sharedData.messagesPage.toId = self.sharedData.selectedHost[@"fb_id"];
        self.sharedData.messagesPage.toLabel.text = [self.sharedData.selectedHost[@"first_name"] uppercaseString];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"SHOW_MESSAGES"
         object:self];
    }
    else
    { //Write message to host
        //[self.sharedData.popupView popup:@"EventsHostMessage" animated:YES];
    }

}

-(void)button2Handler:(UITapGestureRecognizer *)sender
{
    if(self.isSelf) return;
    
    [self.sharedData trackMixPanelWithDict:@"Share Hosting" withDict:@{@"origin":@"HostDetails"}];
    
    NSLog(@">>> %@",self.sharedData.selectedHost);
    
    //Everything needed for share link
    self.sharedData.shareHostingId = self.sharedData.selectedHost[@"hosting"][@"_id"];
    self.sharedData.shareHostingVenueName = self.sharedData.selectedEvent[@"venue_name"];
    self.sharedData.shareHostingHostName = self.sharedData.selectedHost[@"first_name"];
    self.sharedData.shareHostingHostFbId = self.sharedData.selectedHost[@"fb_id"];
    self.sharedData.shareHostingHostDate = self.sharedData.selectedHost[@"hosting"][@"start_datetime_str"];
    self.sharedData.cHostVenuePicURL = [Constants eventImageURL:self.sharedData.selectedEvent[@"_id"]]; //Need for SHARE HOSTING
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_HOSTING_INVITE" object:self];
}

-(void)reset
{
    if([lastFbId isEqualToString:self.sharedData.selectedHost[@"fb_id"]]) return;
    if(self.sharedData.selectedHost[@"fb_id"]!=nil) lastFbId = [NSString stringWithString:self.sharedData.selectedHost[@"fb_id"]];
    
    self.isSelf = NO;
    self.memberName.text = @"";
    self.interestCount.text = @"";
    self.reviewLabel.text = @"";
    [self.reviewRatingView updateRating:nil stars:0];
    self.descriptionText.text = @"";
    [self.offeringsContainer.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    self.mainScroll.contentOffset = CGPointZero;
    [self.button1 setTitle:@"" forState:UIControlStateNormal];
    [self.button2 setTitle:@"" forState:UIControlStateNormal];
}

-(void)goBack
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EVENTS_GO_HOST_LIST"
     object:self];
}

-(void)addViewCount
{
    self.sharedData.cHosting_id = self.sharedData.selectedHost[@"_id"];
    
    NSLog(@"ADDING_HOSTING_VIEW_COUNT :: %@",self.sharedData.selectedHost);
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSDictionary *params = @{
                             @"from_fb_id" : self.sharedData.fb_id,
                             @"event_id" : self.sharedData.cEventId
                             };
    NSString *urlToLoad = [NSString stringWithFormat:@"%@/user/hostings/viewed/%@/%@",PHBaseURL,self.sharedData.selectedHost[@"fb_id"],self.sharedData.selectedHost[@"hosting"][@"_id"]];
    //55ccc9f2fcbb6b0300b4b703
    NSLog(@"hosting_id :: %@",self.sharedData.selectedHost[@"hosting"][@"_id"]);
    NSLog(@"URL_hosting_viewed :: %@",urlToLoad);
    [manager POST:urlToLoad parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"HOSTING_VIEW_COUNT_UPDATED %@", responseObject);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"HOSTING_VIEW_COUNT_ERROR :: %@",error);
     }];
    
}

-(void)loadMemberProfile
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    [self reset];
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSString *url = [Constants memberInfoURL:self.sharedData.account_type member_fb_id:self.sharedData.selectedHost[@"fb_id"] fb_id:self.sharedData.fb_id];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"MEMBER_PROFILE :: %@",responseObject);
         
         [self populateMemberProfile:responseObject];
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"MEMBER_PROFILE_ERROR :: %@",error);
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
     }];
}

-(void)populateMemberProfile:(NSDictionary*)data
{
    [self addViewCount];
    
    NSLog(@"HOSTING :: %@",self.sharedData.selectedHost[@"hosting"]);
    
    //Store the dictionary for later use, like in writing reviews
    if(data!=nil)
    {
        [self.sharedData.memberProfileDict removeAllObjects];
        [self.sharedData.memberProfileDict addEntriesFromDictionary:data];
        
        //Store the dictionary for later use, like in writing reviews
        [self.memberProfileDict removeAllObjects];
        [self.memberProfileDict addEntriesFromDictionary:data];
    }
    
    self.memberName.text = [self.memberProfileDict[@"first_name"] uppercaseString];
    
    //Show interested count
    long view_count = [self.sharedData.selectedHost[@"hosting"][@"view_count"] intValue];
    if (view_count>0)
    {
        self.interestCount.text = [NSString stringWithFormat:@"%ld INTERESTED",view_count];
    }
    else {
        self.interestCount.text = @"";
    }
    
    int reviewCount = [self.memberProfileDict[@"review_count"] intValue];
    if(reviewCount>0)
    {
        float rating = [self.memberProfileDict[@"rating"] floatValue];
        self.reviewLabel.text = [NSString stringWithFormat:@"%.02f Jiggie score, %i review%@",rating,reviewCount,(reviewCount==1)?@"":@"s"];
        [self.reviewRatingView updateRating:nil stars:rating];
    }
    else
    {
        self.reviewLabel.text = @"No reviews yet";
        [self.reviewRatingView updateRating:nil stars:0];
    }
    
    self.descriptionText.frame = CGRectMake(20,self.separator2.frame.size.height + self.separator2.frame.origin.y + 24, self.sharedData.screenWidth - 40, 1000);
    self.descriptionText.text = [self.sharedData.selectedHost[@"description"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //self.descriptionText.text = @"For many years it seemed unlikely that Lisp would be more widely used by the working programmer. So it's with a constant sense of wonder that I look around at a rapidly expanding ClojureScript community that shares the same love for simpler yet more expressive systems. It seems fair to attribute this quickening pace of adoption to ClojureScript's steadfast dedication to pragmatism.";
    [self.descriptionText sizeToFit];
    
    self.separator3.frame = CGRectMake(20,self.descriptionText.frame.size.height + self.descriptionText.frame.origin.y + 24, self.sharedData.screenWidth - 40, 1);
    
    //Offering
    NSMutableArray *offeringsArray = [[NSMutableArray alloc] init];
    [offeringsArray removeAllObjects];
    [offeringsArray addObjectsFromArray:self.sharedData.selectedHost[@"hosting"][@"offerings"]];
    
     /*
    [offeringsArray addObject:@{@"title":@"Drinks",@"tag":@"DRINKS",@"description":@"I've got you covered.  Drinks on me.",@"bg_color":@"50E3C2"}];
    [offeringsArray addObject:@{@"title":@"VIP Table",@"tag":@"VIP TABLE",@"description":@"Living the high life.",@"bg_color":@"C79D2D"}];
    [offeringsArray addObject:@{@"title":@"Skip the Line",@"tag":@"SKIP THE LINE",@"description":@"No waiting, I'll get you in first.",@"bg_color":@"BD10E0"}];
    [offeringsArray addObject:@{@"title":@"Dinner",@"tag":@"DINNER",@"description":@"It's on me.",@"bg_color":@"4A90E2"}];
    [offeringsArray addObject:@{@"title":@"Taxi",@"tag":@"TAXI",@"description":@"Transport?  Yup.",@"bg_color":@"F5A623"}];
    */
     
    //Fill in offerings
    [self.offeringsContainer.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    int y1 = 0;
    for(int i=0;i<[offeringsArray count];i++)
    {
        NSDictionary *dict = offeringsArray[i];
        NSString *title = [dict[@"title"] uppercaseString];
        NSString *description = [dict[@"description"] uppercaseString];
        NSString *bg_color = dict[@"bg_color"];

        PerkButton *offeringTag = [[PerkButton alloc] initWithFrame:CGRectMake(0,y1,self.sharedData.screenWidth-40,20)];
        offeringTag.userInteractionEnabled = NO;
        [offeringTag updateLeftFit:title color:[UIColor colorFromHexCode:bg_color]];
        [self.offeringsContainer addSubview:offeringTag];
        y1 += 20 + 8;
        
        UILabel *offeringDescription = [[UILabel alloc] initWithFrame:CGRectMake(0, y1, self.sharedData.screenWidth-40, 12)];
        offeringDescription.text = description;
        offeringDescription.textAlignment = NSTextAlignmentLeft;
        offeringDescription.textColor = [UIColor colorFromHexCode:@"717171"];
        offeringDescription.adjustsFontSizeToFitWidth = YES;
        offeringDescription.lineBreakMode = NSLineBreakByTruncatingTail;
        offeringDescription.font = [UIFont phBold:10];
        [self.offeringsContainer addSubview:offeringDescription];
        y1 += 14 + 16;
    }
    self.offeringsContainer.frame = CGRectMake(20,self.separator3.frame.origin.y + 24, self.sharedData.screenWidth - 40, y1);
    
    self.mainScroll.contentSize = CGSizeMake(self.sharedData.screenWidth, self.offeringsContainer.frame.origin.y + self.offeringsContainer.frame.size.height + 16);
    
    self.backgroundView.frame = CGRectMake(0, self.userImage.frame.origin.y+self.userImage.frame.size.height, self.sharedData.screenWidth, self.mainScroll.contentSize.height);
    
    //Check if we are looking at ourselves
    NSString *fbId = [NSString stringWithFormat:@"%@",self.sharedData.selectedHost[@"fb_id"]];
    if([fbId isEqualToString:self.sharedData.fb_id])
    { //Yourself
        self.isSelf = YES;
    }
    else
    { //Someone else
        self.isSelf = NO;
        
        //Check if accepted
        if([self.sharedData.selectedHost[@"hosting"][@"is_accepted"] boolValue])
        {
            [self.button1 setTitle:@"CHAT" forState:UIControlStateNormal];
        }
        else
        {
            [self.button1 setTitle:@"INTERESTED" forState:UIControlStateNormal];
        }
    }
    
    [self.button2 setTitle:@"SHARE" forState:UIControlStateNormal];
}

@end
