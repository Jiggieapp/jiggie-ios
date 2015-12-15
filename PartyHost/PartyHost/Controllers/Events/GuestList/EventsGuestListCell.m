//
//  EventsGuestListCell.m
//  PartyHost
//
//  Created by Sunny Clark on 2/15/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "EventsGuestListCell.h"

#define SET_IF_NOT_NULL(TARGET, VAL) if(VAL && VAL != [NSNull null]) { TARGET = VAL; }else {TARGET = @"";}

@implementation EventsGuestListCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.sharedData = [SharedData sharedInstance];
        self.mainDict = [[NSMutableDictionary alloc] init];
        self.userDict = [[NSMutableDictionary alloc] init];
        self.layer.masksToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        self.nameTitle = [[UILabel alloc] initWithFrame:CGRectMake(70, 32, self.sharedData.screenWidth - 100 - 90, 20)];
        self.nameTitle.adjustsFontSizeToFitWidth = YES;
        self.nameTitle.textColor = [UIColor blackColor];
        //self.nameTitle.backgroundColor = [UIColor redColor];
        self.nameTitle.font = [UIFont phBold:15];
        [self addSubview:self.nameTitle];
        
        self.userImg = [[UserBubble alloc] initWithFrame:CGRectMake(10, 10 + 5, 50, 50)];
        [self.userImg addTarget:self action:@selector(userIconClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.userImg];
        
        self.btnInvite = [[SelectionButton alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth-100-11, 24, 100, 32)];
        [self.btnInvite.button setTitle:@"" forState:UIControlStateNormal];
        [self.btnInvite.button addTarget:self action:@selector(inviteGuestButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnInvite];
        self.btnInvite.userInteractionEnabled = NO;
        self.btnInvite.onBackgroundColor = [UIColor phPurpleColor];
        self.btnInvite.offBackgroundColor = [UIColor clearColor];
        self.btnInvite.offBorderColor = [UIColor phPurpleColor];
        self.btnInvite.hidden = YES;
        
//        self.infoBody = [[UILabel alloc] init];
//        self.infoBody.textColor = [UIColor phDarkGrayColor];
//        self.infoBody.numberOfLines = 2;
//        self.infoBody.adjustsFontSizeToFitWidth = NO;
//        self.infoBody.lineBreakMode = NSLineBreakByTruncatingTail;
//        self.infoBody.font = [UIFont phBlond:12];
//        self.infoBody.textAlignment = NSTextAlignmentLeft;
//        self.infoBody.userInteractionEnabled = NO;
        
//        [self addSubview:self.infoBody];
    }
    return self;
}

-(void)loadData:(NSMutableDictionary *)mainDict userDict:(NSMutableDictionary *)userDict
{
    //Store dictionary for later use
    [self.mainDict removeAllObjects];
    [self.mainDict addEntriesFromDictionary:mainDict];
    [self.userDict removeAllObjects];
    [self.userDict addEntriesFromDictionary:userDict];
    
    //Get name
    NSString *firstName = self.userDict[@"first_name"];
    self.nameTitle.text = [firstName uppercaseString];
    
    //Get the ABOUT for the user
//    NSString *aboutText = self.userDict[@"about"];
//    if(aboutText==NULL) aboutText = @"";
//    else if ([aboutText length]==0) aboutText = @"";
//    self.infoBody.frame = CGRectMake(self.nameTitle.frame.origin.x, self.nameTitle.frame.origin.y + self.nameTitle.frame.size.height + 15, self.sharedData.screenWidth - 110 - 16 + 28, 28);
//    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:aboutText];
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//    [style setLineSpacing:4];
//    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [aboutText length])];
//    self.infoBody.attributedText = attrString;
//    [self.infoBody sizeToFit];
    
    //self.infoBody.text = @"At very least, using the .contentInset property allows you to place your fields with the positions, and accommodate the deviations without offsetting your UITextViews.  At very least, using the .contentInset property allows you to place your fields with the positions, and accommodate the deviations without offsetting your UITextViews.";
    
    //Get profile image
    [self.userImg setName:self.userDict[@"first_name"] lastName:nil];
    [self.userImg loadFacebookImage:self.userDict[@"fb_id"]];
    
    //Show invite button?
    if([self.userDict[@"fb_id"] isEqualToString:self.sharedData.fb_id])
    {
        //Not hosting but allow this invite anyway
        [self.btnInvite.button setTitle:@"YOU" forState:UIControlStateNormal];
        [self.btnInvite buttonSelect:NO checkmark:NO animated:NO];
        //[self.btnInvite setBackgroundColor:[UIColor lightGrayColor]];
        self.btnInvite.hidden = NO;
        self.btnInvite.userInteractionEnabled = NO;
    }
    else if ([self.userDict[@"is_connected"] boolValue]==YES) //Already invited, button is gray
    {
        [self.btnInvite.button setTitle:@"CONNECTED" forState:UIControlStateNormal];
        [self.btnInvite buttonSelect:YES checkmark:NO animated:NO];
        //[self.btnInvite setBackgroundColor:[UIColor lightGrayColor]];
        self.btnInvite.hidden = NO;
        self.btnInvite.userInteractionEnabled = NO;
    }
    else if([self.userDict[@"is_invited"] boolValue]==NO) //Not hosting show no button
    {
        //self.btnInvite.hidden = YES;
        //self.btnInvite.userInteractionEnabled = NO;
        //[self.mainDict[@"has_hostings"] boolValue]==NO
        
        //Not hosting but allow this invite anyway
        [self.btnInvite.button setTitle:@"CONNECT" forState:UIControlStateNormal];
        [self.btnInvite buttonSelect:NO checkmark:NO animated:NO];
        //[self.btnInvite setBackgroundColor:[UIColor phPurpleColor]];
        self.btnInvite.hidden = NO;
        self.btnInvite.userInteractionEnabled = YES;
    }
    else if ([self.userDict[@"is_invited"] boolValue]==YES) //Already invited, button is gray
    {
        [self.btnInvite.button setTitle:@"SENT" forState:UIControlStateNormal];
        [self.btnInvite buttonSelect:YES checkmark:YES animated:NO];
        //[self.btnInvite setBackgroundColor:[UIColor lightGrayColor]];
        self.btnInvite.hidden = NO;
        self.btnInvite.userInteractionEnabled = NO;
    }
    else //Allow invite this guest
    {
        [self.btnInvite.button setTitle:@"INVITE" forState:UIControlStateNormal];
        [self.btnInvite buttonSelect:NO checkmark:NO animated:NO];
        //[self.btnInvite setBackgroundColor:[UIColor phPurpleColor]];
        self.btnInvite.hidden = NO;
        self.btnInvite.userInteractionEnabled = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)userIconClicked:(UIButton *)button
{
    [self.sharedData.cHostDict removeAllObjects];
    [self.sharedData.cHostDict addEntriesFromDictionary:self.mainDict];
    self.sharedData.member_fb_id = self.userDict[@"fb_id"];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_MEMBER_PROFILE"
     object:self];
}

-(void)inviteGuestButtonClicked:(UIButton *)button
{
    //Stored the main and guest dictionary to get ready to send IDs back to server
    //NSLog(@">>> inviteGuestButtonClicked MAIN %@",self.mainDict);
    //NSLog(@">>> inviteGuestButtonClicked GUEST %@",self.guestDict);
    
    self.sharedData.cInviteName = self.userDict[@"first_name"];
    
    
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSDictionary *params = @{
                             
                             };
    
    NSLog(@"FEEDITEM-SAVE Started :: %@",self.userDict);
    NSLog(@"FEEDITEM-SAVE Params Sent :: %@",params);
    
    NSString *url = [NSString stringWithFormat:@"%@/partyfeed/match/%@/%@/%@",PHBaseURL,self.sharedData.fb_id,self.userDict[@"fb_id"],@"approved"];
    NSLog(@"FEEDITEM-SAVE URL :: %@",url);
    
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self.btnInvite buttonSelect:YES checkmark:YES animated:NO];
         [self.btnInvite.button setTitle:@"SENT" forState:UIControlStateNormal];
         self.btnInvite.hidden = NO;
         self.btnInvite.userInteractionEnabled = NO;
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         //[self.sharedData.feedPage loadData];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
     }];
    
    
    /*
    if([self.mainDict[@"has_hostings"] boolValue]==NO)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Invite Guest"
                                                       message:@"Before inviting a guest, you must create a hosting at this event.  Would you like to create a hosting here?"
                                                      delegate:self
                                             cancelButtonTitle:@"No"
                                             otherButtonTitles:@"Yes",nil];
        alert.tag = 127;
        [alert show];
    }
    else
    {
        [self sendInviteGuest];
    }
    */
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([alertView tag] == 127)
    {
        if (buttonIndex == 1)
        {
            self.sharedData.cameFromEventsTab = YES;
            self.sharedData.cEventId_toLoad = self.mainDict[@"_id"];
            self.sharedData.cGuestId = self.userDict[@"fb_id"];
            
            self.sharedData.cHostingIdFromInvite = self.mainDict[@"hosting_id"];
            //NSLog(@"cHostingIdFromInvite set :: %@",self.sharedData.cHostingIdFromInvite);
            
            [self.sharedData.cAddEventDict removeAllObjects];
            [self.sharedData.cAddEventDict addEntriesFromDictionary:self.mainDict];
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"SHOW_BOOKTABLE"
             object:self];
            
            /*
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"CREATE_HOSTING"
             object:self];
             */
        }
    }
}

-(void)sendInviteGuest
{
    //Start spinner
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSDictionary *params = @{
                             @"from_fb_id": self.sharedData.fb_id,
                             @"event_id": self.mainDict[@"_id"]
                             };
    
    NSLog(@"INVITE_PARAMS = %@",params);
    
    NSString *url = [NSString stringWithFormat:@"%@/user/hostings/invited/%@/%@",PHBaseURL,self.userDict[@"fb_id"],self.mainDict[@"hosting_id"]];
    NSLog(@"INVITE_GUEST_URL :: %@",url);
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"INVITE_GUEST_RESPONSE responseObject :: %@",responseObject);
         [self.sharedData trackMixPanelWithDict:@"Sent Event invite" withDict:@{@"origin":@"guestlisting"}];
         
         //Set object to yes
         //self.userDict[@"is_invited"] = @YES;
         //[self.sharedData.eventsPage.eventsGuestList refreshFeed];
         
         /*
         //Change button to invited
         [self.btnInvite.button setTitle:@"INVITED" forState:UIControlStateNormal];
         self.btnInvite.hidden = NO;
         self.btnInvite.userInteractionEnabled = NO;
         
         [self loadData:self.mainDict userDict:self.userDict];
                  */
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"REFRESH_GUEST_LISTINGS"
          object:self];
         
         //Alert error!
         NSString *message = [NSString stringWithFormat:@"You have invited %@ to your hosting.",[self.sharedData.cInviteName capitalizedString]];
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invite Sent"
                                                         message:message
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
         [alert show];
         

         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"INVITE_GUEST_ERROR :: %@",error);
         
         //Hide spinner
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         //Alert error!
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Connected"
                                                         message:@"Please try again later."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
         [alert show];
     }];
}

@end
