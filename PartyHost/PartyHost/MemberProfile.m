//
//  MemberProfile.m
//  PartyHost
//
//  Created by Sunny Clark on 2/18/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "MemberProfile.h"

#define MAX_MUTUAL_FRIENDS 4
#define SPACE_BETWEEN_SECTIONS 20
#define DATE_SHORT_DISPLAY @"MMM d, yyyy h:mm a" 

@implementation MemberProfile {
    NSString *lastFbId;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    lastFbId = @"";
    
    self.sharedData = [SharedData sharedInstance];
    
    self.layer.masksToBounds = YES;
    
    self.mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, frame.size.height)];
    self.mainScroll.delegate = self;
    self.mainScroll.contentSize = CGSizeMake(self.sharedData.screenWidth, self.sharedData.screenHeight);
    self.mainScroll.backgroundColor = [UIColor whiteColor];
    self.mainScroll.showsVerticalScrollIndicator = NO;
    [self addSubview:self.mainScroll];
    
    self.tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 60)];
    self.tabBar.backgroundColor = [UIColor phPurpleColor];
    
    self.picScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, self.sharedData.screenWidth, 300)];
    self.picScroll.delegate = self;
    self.picScroll.pagingEnabled = YES;
    self.picScroll.backgroundColor = [UIColor whiteColor];
    [self.mainScroll addSubview:self.picScroll];
    
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.hidden = NO;
    [self.mainScroll addSubview:self.bgView];
    
    self.toLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, frame.size.width, 40)];
    self.toLabel.textColor = [UIColor whiteColor];
    self.toLabel.backgroundColor = [UIColor clearColor];
    self.toLabel.font = [UIFont phBold:18];
    self.toLabel.textAlignment = NSTextAlignmentCenter;
    [self.tabBar addSubview:self.toLabel];
    
    self.pControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.picScroll.frame.size.height, self.picScroll.frame.size.width, 50)];
    self.pControl.userInteractionEnabled = NO;
    self.pControl.currentPage = 0;
    self.pControl.numberOfPages = 4;
    [self.mainScroll addSubview:self.pControl];
    
    [self addSubview:self.tabBar];
    
    self.aboutPanel = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 100, frame.size.width, self.picScroll.frame.size.height)];
    self.aboutPanel.backgroundColor = [UIColor clearColor];
    self.aboutPanel.hidden = YES;
    [self.mainScroll addSubview:self.aboutPanel];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, frame.size.width - 40, 25)];
    self.nameLabel.text = @"";
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.font = [UIFont phBold:18];
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    [self.aboutPanel addSubview:self.nameLabel];
    
    self.cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, frame.size.width - 40, 25)];
    self.cityLabel.text = @"";
    self.cityLabel.textAlignment = NSTextAlignmentLeft;
    self.cityLabel.font = [UIFont phBold:13];
    self.cityLabel.textColor = [UIColor darkGrayColor];
    self.cityLabel.backgroundColor = [UIColor clearColor];
    [self.aboutPanel addSubview:self.cityLabel];
    
    //Star reviews
    self.reviewContainer = [[UIView alloc] init];
    self.reviewContainer.hidden = NO;
    self.reviewContainer.userInteractionEnabled = YES;
    //self.reviewContainer.backgroundColor = [UIColor greenColor];
    //[self.mainScroll addSubview:self.reviewContainer];
    
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
    
    //Review tap gesture for uiview
    UITapGestureRecognizer *reviewStarTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reviewClicked)];
    [self.reviewContainer addGestureRecognizer:reviewStarTap];
    
    [self.aboutPanel addSubview:self.reviewContainer];
    
    self.aboutLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, self.sharedData.screenHeight-40, 18)];
    self.aboutLabel.text = @"ABOUT";
    self.aboutLabel.hidden = YES;
    self.aboutLabel.textAlignment = NSTextAlignmentLeft;
    self.aboutLabel.font = [UIFont phBold:15];
    self.aboutLabel.textColor = [UIColor blackColor];
    self.aboutLabel.backgroundColor = [UIColor clearColor];
    [self.aboutPanel addSubview:self.aboutLabel];
    
    self.aboutBody = [[UITextView alloc] initWithFrame:CGRectMake(15, self.aboutLabel.frame.origin.y + self.aboutLabel.frame.size.height, frame.size.width - 40, 0)];
    self.aboutBody.font = [UIFont phBlond:17];
    self.aboutBody.textColor = [UIColor darkGrayColor];
    self.aboutBody.textAlignment = NSTextAlignmentLeft;
    self.aboutBody.userInteractionEnabled = NO;
    self.aboutBody.text = @"";
    self.aboutBody.hidden = YES;
    self.aboutBody.textContainerInset = UIEdgeInsetsMake(10, 5, 10, 5);
    self.aboutBody.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.aboutBody sizeToFit];
    [self.aboutPanel addSubview:self.aboutBody];
    
    self.hostingsLabel = [[UILabel alloc] init];
    self.hostingsLabel.frame = CGRectMake(20, self.aboutBody.frame.origin.y + self.aboutBody.frame.size.height + 8, self.sharedData.screenHeight-40, 18);
    self.hostingsLabel.text = @"UPCOMING HOSTINGS";
    self.hostingsLabel.textAlignment = NSTextAlignmentLeft;
    self.hostingsLabel.font = [UIFont phBold:13];
    self.hostingsLabel.textColor = [UIColor colorFromHexCode:@"BDBDBD"];
    self.hostingsLabel.backgroundColor = [UIColor clearColor];
    self.hostingsLabel.hidden = YES;
    //[self.aboutPanel addSubview:self.hostingsLabel];
    
    self.hostingsBody = [[UITextView alloc] init];
    self.hostingsBody.frame = CGRectMake(15, self.hostingsLabel.frame.origin.y + self.hostingsLabel.frame.size.height, frame.size.width - 40, 0);
    self.hostingsBody.font = [UIFont phBlond:15];
    self.hostingsBody.textColor = [UIColor blackColor];
    self.hostingsBody.textAlignment = NSTextAlignmentLeft;
    self.hostingsBody.userInteractionEnabled = NO;
    self.hostingsBody.text = @"";
    self.hostingsBody.backgroundColor = [UIColor clearColor];
    self.hostingsBody.textContainerInset = UIEdgeInsetsMake(10, 5, 10, 5);
    self.hostingsBody.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.hostingsBody.hidden = YES;
    //[self.aboutPanel addSubview:self.hostingsBody];
    
    self.btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnBack.frame = CGRectMake(self.sharedData.screenWidth - 44 + 2, 17, 44, 44);
    [self.btnBack setBackgroundImage:[UIImage imageNamed:@"nav_cancel"] forState:UIControlStateNormal];
    [self.btnBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:self.btnBack];
    
    self.mutualFriends = [[NSMutableArray alloc] init];
    
    self.mutualFriendsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.cityLabel.frame.size.height + self.cityLabel.frame.origin.y + 5, self.sharedData.screenWidth - 40, 14)];
    self.mutualFriendsLabel.text = @"MUTUAL FRIENDS";
    self.mutualFriendsLabel.textAlignment = NSTextAlignmentLeft;
    self.mutualFriendsLabel.textColor = [UIColor colorFromHexCode:@"BDBDBD"];
    self.mutualFriendsLabel.font = [UIFont phBold:13];
    self.mutualFriendsLabel.userInteractionEnabled = NO;
    self.mutualFriendsLabel.hidden = YES;
    
    self.mutualFriendsCon = [[UIScrollView alloc] init];
    self.mutualFriendsCon.frame = CGRectMake(0, 95, self.sharedData.screenWidth, 50);
    [self.aboutPanel addSubview:self.mutualFriendsCon];
    self.mutualFriendsCon.hidden = YES;
    
    [self.aboutPanel addSubview:self.mutualFriendsLabel];
    
    self.separator1 = [[UIView alloc] init];
    self.separator1.backgroundColor = [UIColor phLightGrayColor];
    [self.aboutPanel addSubview:self.separator1];
    
    self.separator2 = [[UIView alloc] init];
    self.separator2.backgroundColor = [UIColor phLightGrayColor];
    [self.aboutPanel addSubview:self.separator2];
    
    self.separator3 = [[UIView alloc] init];
    self.separator3.backgroundColor = [UIColor phLightGrayColor];
    [self.aboutPanel addSubview:self.separator3];
    
    self.separator4 = [[UIView alloc] init];
    self.separator4.backgroundColor = [UIColor phLightGrayColor];
    [self.aboutPanel addSubview:self.separator4];
    
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
        
        NSLog(@">>> MemberProfile member review submitted");
        
        [self loadData];
    }
}

-(void)updateAboutPanel
{
    int y1 = 24;
    
    self.aboutPanel.frame = CGRectMake(0, self.picScroll.frame.origin.y + self.picScroll.frame.size.height + 8, self.sharedData.screenWidth, 0);
    self.aboutPanel.backgroundColor = [UIColor clearColor];
    
    self.nameLabel.frame = CGRectMake(20, y1, self.sharedData.screenWidth - (20*2), 20);
    y1+=self.nameLabel.frame.size.height;
    
    self.cityLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, y1, self.nameLabel.frame.size.width, 25);
    y1+=self.cityLabel.frame.size.height+SPACE_BETWEEN_SECTIONS;
    
    /*
    //Reviews
    if([self.sharedData isGuest] && 1==2) {
        self.separator1.frame = CGRectMake(self.nameLabel.frame.origin.x,y1, self.nameLabel.frame.size.width, 1);
        self.separator1.hidden = NO;
        y1 += SPACE_BETWEEN_SECTIONS;
        
        self.reviewContainer.hidden = NO;
        self.reviewContainer.frame = CGRectMake(0,self.separator1.frame.origin.y+self.separator1.frame.size.height+20,self.sharedData.screenWidth, 24+8+12);
        y1 += self.reviewContainer.frame.size.height + SPACE_BETWEEN_SECTIONS;
    }
    else
    {
        self.separator1.hidden = YES;
        self.reviewContainer.hidden = YES;
    }
    */
    
    self.separator1.hidden = YES;
    self.reviewContainer.hidden = YES;
    
    //Check mutual friends
    long mutualCount = [self.mutualFriends count];
    if(mutualCount > 0)
    {
        mutualCount = MIN(MAX_MUTUAL_FRIENDS,mutualCount);
        
        self.separator2.frame = CGRectMake(self.nameLabel.frame.origin.x,y1, self.nameLabel.frame.size.width, 1);
        self.separator2.hidden = NO;
        y1 += SPACE_BETWEEN_SECTIONS;
        
        self.mutualFriendsLabel.hidden = NO;
        self.mutualFriendsLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, y1, self.nameLabel.frame.size.width, 25);
        y1+=self.mutualFriendsLabel.frame.size.height+4;
        
        self.mutualFriendsCon.hidden = NO;
        self.mutualFriendsCon.frame = CGRectMake(0, y1, self.sharedData.screenWidth, 50);
        for (int i = 0; i < mutualCount; i++)
        {
            UserBubble *friend = [[UserBubble alloc] initWithFrame:CGRectMake(20 + (i * 65), 0, 50, 50)];
            friend.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.50].CGColor;
            friend.userInteractionEnabled = NO;
            [friend loadFacebookImage:[self.mutualFriends objectAtIndex:i]];
            [self.mutualFriendsCon addSubview:friend];
        }
        
        int newWidth = ((int)mutualCount * 65) + 20 + 20;
        newWidth = (newWidth < self.sharedData.screenWidth + 1)?self.sharedData.screenWidth + 1:newWidth;
        self.mutualFriendsCon.contentSize = CGSizeMake(newWidth, 50);
        y1+=50+SPACE_BETWEEN_SECTIONS;
    }
    else
    {
        self.separator2.hidden = YES;
        self.mutualFriendsLabel.hidden = YES;
        self.mutualFriendsCon.hidden = YES;
    }
    
    
    //Check about
    if(self.aboutBody.text.length>0)
    {
        self.separator3.frame = CGRectMake(self.nameLabel.frame.origin.x,y1, self.nameLabel.frame.size.width, 1);
        self.separator3.hidden = NO;
        y1 += SPACE_BETWEEN_SECTIONS;
        
        self.aboutLabel.hidden = NO;
        self.aboutLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, y1, self.nameLabel.frame.size.width, 25);
        y1+=self.aboutLabel.frame.size.height+2;
        
        self.aboutBody.hidden = NO;
        self.aboutBody.frame = CGRectMake(self.nameLabel.frame.origin.x-10, y1, self.nameLabel.frame.size.width+20, 0);
        [self.aboutBody sizeToFit];
        self.aboutBody.frame = CGRectMake(self.nameLabel.frame.origin.x-10, y1, self.nameLabel.frame.size.width+20, self.aboutBody.frame.size.height);
        y1+=self.aboutBody.frame.size.height+SPACE_BETWEEN_SECTIONS;
    }
    else
    {
        self.separator3.hidden = YES;
        self.aboutLabel.hidden = YES;
        self.aboutBody.hidden = YES;
    }
    
    
    /*
    //Check hostings
    if(self.hostingsBody.text.length>0 && 1==2)
    {
        self.separator4.frame = CGRectMake(self.nameLabel.frame.origin.x,y1, self.nameLabel.frame.size.width, 1);
        self.separator4.hidden = NO;
        y1 += SPACE_BETWEEN_SECTIONS;
        
        self.hostingsLabel.hidden = NO;
        self.hostingsLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, y1, self.nameLabel.frame.size.width, 25);
        y1+=self.hostingsLabel.frame.size.height+2;
        
        self.hostingsBody.hidden = NO;
        self.hostingsBody.frame = CGRectMake(self.nameLabel.frame.origin.x - 10, y1, self.nameLabel.frame.size.width + 20, 0);
        [self.hostingsBody sizeToFit];
        self.hostingsBody.frame = CGRectMake(self.nameLabel.frame.origin.x - 10, y1, self.nameLabel.frame.size.width + 20, self.hostingsBody.frame.size.height);
        y1+=self.hostingsBody.frame.size.height+SPACE_BETWEEN_SECTIONS;
    }
    else
    {
        self.separator4.hidden = YES;
        self.hostingsLabel.hidden = YES;
        self.hostingsBody.hidden = YES;
    }
    */
    
    
    
    
    self.separator4.hidden = YES;
    self.hostingsLabel.hidden = YES;
    self.hostingsBody.hidden = YES;
    
    self.aboutPanel.frame = CGRectMake(0, self.aboutPanel.frame.origin.y, self.sharedData.screenWidth, y1);
    
    self.mainScroll.contentSize = CGSizeMake(self.sharedData.screenWidth, self.picScroll.frame.size.height + y1 + self.sharedData.screenHeight/2);
    
    self.bgView.frame = CGRectMake(0, self.picScroll.frame.origin.y + self.picScroll.frame.size.height, self.sharedData.screenWidth, self.mainScroll.contentSize.height);
    
    
    
    CGRect AboutFrame = self.aboutBody.frame;
    AboutFrame.origin.y -= 10;
    self.aboutBody.frame = AboutFrame;
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
    BOOL can_write_review = NO;//[self.sharedData.memberProfileDict[@"can_write_review"] boolValue];
    int review_count = 0;//[self.sharedData.memberProfileDict[@"review_count"] intValue];
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

-(void)goBack
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EXIT_MEMBER_PROFILE"
     object:self];
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
    [self reset];
    
    self.hidden = NO;
    [self.mainScroll setContentOffset:CGPointMake(0, 0) animated:NO];
    self.picScroll.contentOffset = CGPointMake(0, 0);
    
    self.frame = CGRectMake(0,self.sharedData.screenHeight,self.sharedData.screenWidth,self.sharedData.screenHeight);
    [UIView animateWithDuration:0.25 animations:^()
    {
        self.frame = CGRectMake(0,0,self.sharedData.screenWidth,self.sharedData.screenHeight);
    } completion:^(BOOL finished)
    {
        //self.pControl.hidden = NO;
        //self.mainScroll.backgroundColor = [UIColor blackColor];
    }];
}

-(void)loadData
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"" forKey:@"about"];
    [dict setObject:@"" forKey:@"location"];
    [dict setObject:[[NSMutableArray alloc] init] forKey:@"photos"];
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSString *url = [NSString stringWithFormat:@"%@/memberinfo/%@/%@/%@",PHBaseURL,self.sharedData.account_type,self.sharedData.member_fb_id,self.sharedData.fb_id];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"MEMBER_PROFILE :: %@",responseObject);
         
         [self.sharedData trackMixPanelWithDict:@"View Member Profile" withDict:@{}];
         
         [self loadMutualFriends];
         
         if(!responseObject[@"about"])
         {
             [self loadDataFromRuby];
             return;
         }
         
         //Store the dictionary for later use, like in writing reviews
         [self.sharedData.memberProfileDict removeAllObjects];
         [self.sharedData.memberProfileDict addEntriesFromDictionary:responseObject];
         
        self.pControl.currentPage = 0;
        for (int j = 0; j < [responseObject[@"photos"] count]; j++)
        {
            [dict[@"photos"] addObject:responseObject[@"photos"][j]];
        }
         self.pControl.numberOfPages = [responseObject[@"photos"] count];
         
         if([responseObject[@"photos"] count] == 0)
         {
             [dict[@"photos"] addObject:PHBlankImgURL];
             self.pControl.numberOfPages = 1;
         }
         
         self.toLabel.text = [responseObject[@"user_first_name"] uppercaseString];
         
         self.nameLabel.text = [responseObject[@"user_first_name"] uppercaseString];
         
         if([responseObject[@"location"] length]==0) //No location?
         {
             self.cityLabel.text = @"JIGGIE MEMBER";
         }
         else
         {
             self.cityLabel.text = [responseObject[@"location"] uppercaseString];
         }
         
         //self.aboutLabel.text = [NSString stringWithFormat:@"About %@:",self.nameLabel.text];
         
         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
         [formatter setDateFormat:@"MM/dd/yyyy"];
         NSDate *birthday_date = [formatter dateFromString:responseObject[@"birthday"]];
         
         if(birthday_date)
         {
             NSDate* now = [NSDate date];
             NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                                components:NSYearCalendarUnit
                                                fromDate:birthday_date
                                                toDate:now
                                                options:0];
             NSInteger age = [ageComponents year];
             
             
             NSLog(@"AGE :: %d",(int)age);
             
             if(age > 0)
             {
                 self.nameLabel.text = [NSString stringWithFormat:@"%@, %d",self.nameLabel.text,(int)age];
             }
         }
         
         self.pControl.hidden = ([responseObject[@"photos"] count] == 0);
         
         self.picScroll.contentOffset = CGPointMake(0, 0);
         for (int i = 0; i < [dict[@"photos"] count]; i++)
         {
             UIView *picCon = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.picScroll.frame.size.height)];
             picCon.layer.masksToBounds = YES;
             PHImage *pic = [[PHImage alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.picScroll.frame.size.height)];
             pic.showLoading = YES;
             pic.backgroundColor = [UIColor lightGrayColor];
             pic.contentMode = UIViewContentModeScaleAspectFill;
             pic.alignTop = true;
             [pic loadImage:[dict[@"photos"] objectAtIndex:i] defaultImageNamed:nil];
             [picCon addSubview:pic];
             [self.picScroll addSubview:picCon];
             self.picScroll.contentSize = CGSizeMake(self.frame.size.width * (i + 1), self.picScroll.frame.size.height);
         }
         
         self.aboutBody.text = [responseObject[@"about"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
         
         /*
         //Ratings & Reviews
         if([self.sharedData isGuest] && 1== 2) //Only guests can see reviews
         {
             int reviewCount = [responseObject[@"review_count"] intValue];
             if(reviewCount>0)
             {
                 self.reviewLabel.text = [NSString stringWithFormat:@"%i Review%@",reviewCount,(reviewCount==1)?@"":@"s"];
                 float rating = [responseObject[@"rating"] floatValue];
                 [self.reviewRatingView updateRating:nil stars:rating];
             }
             else
             {
                 self.reviewLabel.text = @"No Reviews";
                 [self.reviewRatingView updateRating:nil stars:0];
             }
         }
         
         self.aboutBody.text = [responseObject[@"about"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
         
         self.hostingsBody.text = @"";
         for (int i = 0; i < [responseObject[@"hostings"] count]; i++)
         {
             NSDictionary *hosting = responseObject[@"hostings"][i];
             NSString *dateString = [Constants toDisplayDate:hosting[@"start_datetime_str"]];
             NSString *ln = [NSString stringWithFormat:@"%@ at %@\n",dateString,hosting[@"event"][@"venue"][@"name"]];
             self.hostingsBody.text = [self.hostingsBody.text stringByAppendingString:ln];
         }
         self.hostingsBody.text = [self.hostingsBody.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
         */
         [self updateAboutPanel];
         
         self.aboutPanel.hidden = NO;
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"MEMBER_PROFILE_ERROR :: %@",error);
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error loading this member's profile, please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
         
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         [self goBack];
     }];
}

-(void)loadDataFromRuby
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"" forKey:@"about"];
    [dict setObject:@"" forKey:@"location"];
    [dict setObject:[[NSMutableArray alloc] init] forKey:@"photos"];
    
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    [manager.requestSerializer setValue:@"9513574862" forHTTPHeaderField:@"generic_token"];
    NSString *url = [NSString stringWithFormat:@"%@/users/%@",self.sharedData.baseAPIURL,self.sharedData.member_user_id];
    
    NSLog(@"MEMBER_PROFILE_URL :: %@",url);
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"MEMBER_RESPONSE :: %@",responseObject);
         responseObject = responseObject[@"user"];
         
         NSMutableArray *tmpA = [[NSMutableArray alloc] init];
         
         if(responseObject[@"profile_image_url"] && responseObject[@"profile_image_url"] != [NSNull null])
         {
             [tmpA addObject:responseObject[@"profile_image_url"]];
         }
         
         if(responseObject[@"profile_image_url_2"] && responseObject[@"profile_image_url_2"] != [NSNull null])
         {
             [tmpA addObject:responseObject[@"profile_image_url_2"]];
         }
         
         if(responseObject[@"profile_image_url_3"] && responseObject[@"profile_image_url_3"] != [NSNull null])
         {
             [tmpA addObject:responseObject[@"profile_image_url_3"]];
         }
         
         if(responseObject[@"profile_image_url_4"] && responseObject[@"profile_image_url_4"] != [NSNull null])
         {
             [tmpA addObject:responseObject[@"profile_image_url_4"]];
         }
         
         NSLog(@"tmpA :: %@",tmpA);
         
         self.pControl.currentPage = 0;
         for (int j = 0; j < [tmpA count]; j++)
         {
             [dict[@"photos"] addObject:tmpA[j]];
         }
         self.pControl.numberOfPages = [tmpA count];
         
         if(responseObject[@"about"] && responseObject[@"about"] != [NSNull null])
         {
             self.aboutBody.text = [self.sharedData clipSpace:responseObject[@"about"]];
         }
         
         if(responseObject[@"first_name"] && responseObject[@"first_name"] != [NSNull null])
         {
             self.nameLabel.text    = [self.sharedData capitalizeFirstLetter:responseObject[@"first_name"]];
             self.toLabel.text = [self.sharedData capitalizeFirstLetter:responseObject[@"first_name"]];
         }
         
         if(responseObject[@"location"] && responseObject[@"location"] != [NSNull null])
         {
            self.cityLabel.text     = responseObject[@"location"];
         }
         
         self.pControl.hidden = ([tmpA count] == 0);
         
         self.picScroll.contentOffset = CGPointMake(0, 0);
         for (int i = 0; i < [dict[@"photos"] count]; i++)
         {
             UIView *picCon = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.picScroll.frame.size.height)];
             picCon.layer.masksToBounds = YES;
             PHImage *pic = [[PHImage alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.picScroll.frame.size.height)];
             pic.showLoading = YES;
             pic.backgroundColor = [UIColor lightGrayColor];
             pic.contentMode = UIViewContentModeScaleAspectFill;
             [pic loadImage:[dict[@"photos"] objectAtIndex:i] defaultImageNamed:nil];
             [picCon addSubview:pic];
             [self.picScroll addSubview:picCon];
             self.picScroll.contentSize = CGSizeMake(self.frame.size.width * (i + 1), self.picScroll.frame.size.height);
         }
         
         if(responseObject[@"birthday"] && responseObject[@"birthday"] != [NSNull null])
         {
             NSDateFormatter *dateFormatter = [NSDateFormatter new];
             [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
             [dateFormatter setDateFormat: @"yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"];
             NSDate *birthday_date = [dateFormatter dateFromString:responseObject[@"birthday"]];
             if(birthday_date)
             {
                 NSDate* now = [NSDate date];
                 NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                                    components:NSYearCalendarUnit
                                                    fromDate:birthday_date
                                                    toDate:now
                                                    options:0];
                 NSInteger age = [ageComponents year];
                 if(age > 0)
                 {
                     self.nameLabel.text    = [NSString stringWithFormat:@"%@, %d",self.nameLabel.text,(int)age];
                 }
             }
         }
         
         /*
          birthday
          SET_IF_NOT_NULL(self.userId, input[@"id"]); //id
          SET_IF_NOT_NULL(self.facebookId, input[@"fb_id"]); //fb_id
          SET_IF_NOT_NULL(self.about, input[@"about"]);
          if (input[@"birthday"] && ! (input[@"birthday"] == [NSNull null])) {
          self.birthday = [NSDate dateTimeFromIsoDate:input[@"birthday"]];
          }
          SET_IF_NOT_NULL(self.created_at, input[@"create_at"]);
          SET_IF_NOT_NULL(self.email, input[@"email"]);
          SET_IF_NOT_NULL(self.first_name, input[@"first_name"]);
          SET_IF_NOT_NULL(self.gender, input[@"gender"]);
          SET_IF_NOT_NULL(self.invite_code, input[@"invite_code"]);
          SET_IF_NOT_NULL(self.invited_by, input[@"invited_by"]);
          SET_IF_NOT_NULL(self.last_name, input[@"last_name"]);
          SET_IF_NOT_NULL(self.location, input[@"location"]);
          SET_IF_NOT_NULL(self.nick_name, input[@"nick_name"]);
          SET_IF_NOT_NULL(self.oauth_expiry, input[@"oauth_expiry"]);
          SET_IF_NOT_NULL(self.oauth_token, input[@"oauth_token"]);
          SET_IF_NOT_NULL(self.ph_system_channel, input[@"ph_system_channel"]);
          SET_IF_NOT_NULL(self.ph_token, input[@"ph_token"]);
          SET_IF_NOT_NULL(self.ph_token_issue_date, input[@"ph_token_issue_date"]);
          SET_IF_NOT_NULL(self.profile_image_url, input[@"profile_image_url"]);
          SET_IF_NOT_NULL(self.profile_image_url_2, input[@"profile_image_url_2"]);
          SET_IF_NOT_NULL(self.profile_image_url_3, input[@"profile_image_url_3"]);
          SET_IF_NOT_NULL(self.profile_image_url_4, input[@"profile_image_url_4"]);
          SET_IF_NOT_NULL(self.phone, input[@"phone"]);
          //"profile_image_url" = "<null>";
          SET_IF_NOT_NULL(self.tagline, input[@"tagline"]);
          SET_IF_NOT_NULL(self.updated_at, input[@"updated_at"]);
          SET_IF_NOT_NULL(self.concierge_channel, input[@"concierge_channel"]);
          SET_IF_NOT_NULL(self.concierge_channel_id, input[@"concierge_channel_id"]);
          */
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR :: %@",error);
         
         NSLog(@"MEMBER_PROFILE_ERROR :: %@",error);
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error loading this member's profile, please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
     }];

}


-(void)reset
{
    if([lastFbId isEqualToString:self.sharedData.member_fb_id]) return;
    if(self.sharedData.member_fb_id!=nil) lastFbId = [NSString stringWithString:self.sharedData.member_fb_id];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    [self.picScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.picScroll.contentOffset = CGPointMake(0, 0);
    self.aboutPanel.hidden = YES;
    self.pControl.hidden = YES;
    
    
    
    
    
    self.mainScroll.backgroundColor = [UIColor clearColor];
    self.mainScroll.contentOffset = CGPointMake(0, 0);
    self.cityLabel.text = @"";
    self.nameLabel.text = @"";
    self.toLabel.text = @"";
    
    self.reviewContainer.hidden = YES;

    self.aboutLabel.hidden = YES;
    self.aboutBody.text = @"";
    self.hostingsBody.text = @"";
    self.hostingsLabel.hidden = YES;
    
    
    //Mutual friends
    self.mutualFriendsLabel.hidden = YES;
    self.mutualFriendsCon.hidden = YES;
    [self.mutualFriendsCon.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.mutualFriends removeAllObjects];
    
    self.aboutPanel.frame = CGRectMake(0, self.sharedData.screenHeight - 110, self.sharedData.screenWidth, 650);
    
    self.nameLabel.text = self.toLabel.text = self.sharedData.member_first_name;
    
    [self loadData];
}

-(void)exit
{
    self.pControl.hidden = YES;
    self.mainScroll.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.frame = CGRectMake(0,self.sharedData.screenHeight,self.sharedData.screenWidth,self.sharedData.screenHeight);
     } completion:^(BOOL finished)
    {
        self.hidden = YES;
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.picScroll)
    {
        int width = self.picScroll.frame.size.width;
        float xPos = scrollView.contentOffset.x+10;
        self.pControl.currentPage = (int)xPos/width;
    }
}

-(void)loadMutualFriends
{
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    NSString *url = [Constants memberMutualFriendsURL:self.sharedData.fb_id member_fb_id:self.sharedData.member_fb_id];
    
    NSLog(@"MUTUAL_URL :: %@",url);
    
    //Remove all now
    [self.mutualFriends removeAllObjects];
    
    //Load mutual friends
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"MUTUALS_FRIENDS_RESPONSE :: %@",responseObject);
         
         if([responseObject[@"success"] boolValue]) {
             [self.mutualFriends addObjectsFromArray:responseObject[@"friends"]];
             [self updateAboutPanel];
         }

     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"MUTUALS_ERROR");
         NSLog(@"%@",operation.responseString);
     }];
}

@end
