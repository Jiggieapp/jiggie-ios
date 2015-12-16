//
//  WriteReview.m
//  PartyHost
//
//  Created by Tony Suriyathep on 5/15/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "Events.h"
#import "EventsHostDetail.h"
#import "WriteReview.h"
#import "MemberProfile.h"
#import "AnalyticManager.h"

#define REVIEW_PLACEHOLDER @"Write your review here ..."

@implementation WriteReview

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds = YES;
    
    self.sharedData = [SharedData sharedInstance];
    
    self.mainCon = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.sharedData.screenWidth, self.sharedData.screenHeight)];
    self.mainCon.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.mainCon];
    
    self.tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 65)];
    self.tabBar.backgroundColor = [UIColor phDarkTitleColor];
    [self.mainCon addSubview:self.tabBar];
    
    self.mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 65, self.sharedData.screenWidth,self.sharedData.screenHeight-65)];
    self.mainScroll.showsVerticalScrollIndicator    = NO;
    self.mainScroll.showsHorizontalScrollIndicator  = NO;
    self.mainScroll.scrollEnabled                   = YES;
    self.mainScroll.userInteractionEnabled          = YES;
    self.mainScroll.delegate                        = self;
    self.mainScroll.backgroundColor                 = [UIColor whiteColor];
    self.mainScroll.contentSize                     = CGSizeMake(self.sharedData.screenWidth, self.sharedData.screenHeight*2);
    self.mainScroll.layer.masksToBounds             = YES;
    [self.mainCon addSubview:self.mainScroll];

    //Top title
    self.tabTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, self.sharedData.screenWidth, 50)];
    self.tabTitle.textColor = [UIColor whiteColor];
    self.tabTitle.font = [UIFont phBold:24];
    self.tabTitle.textAlignment = NSTextAlignmentCenter;
    self.tabTitle.text = @"";
    [self.tabBar addSubview:self.tabTitle];
    
    //Post button
    self.btnPost = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnPost.frame = CGRectMake(self.sharedData.screenWidth - 50 - 8, 15, 50, 50);
    [self.btnPost setTitle:@"Post" forState:UIControlStateNormal];
    self.btnPost.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.btnPost.titleLabel.font  = [UIFont phBlond:18];
    [self.btnPost setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnPost addTarget:self action:@selector(btnPostClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:self.btnPost];
    
    //Cancel button
    self.btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnCancel.frame = CGRectMake(8, 15, 60, 50);
    [self.btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    self.btnCancel.titleLabel.font  = [UIFont phBlond:18];
    [self.btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnCancel addTarget:self action:@selector(btnCancelClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:self.btnCancel];
    
    //Message text label
    UILabel *ratingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, self.frame.size.width - 20, 20)];
    ratingLabel.text = @"Swipe star to rate";
    ratingLabel.textColor = [UIColor blackColor];
    ratingLabel.font = [UIFont phBold:16];
    [self.mainScroll addSubview:ratingLabel];
    
    //Frame rating
    UIView *ratingBox = [[UIView alloc] initWithFrame:CGRectMake(10, ratingLabel.frame.origin.y + ratingLabel.frame.size.height+6, self.sharedData.screenWidth - 20, 120-30-4)];
    ratingBox.layer.borderColor = [UIColor lightGrayColor].CGColor;
    ratingBox.layer.borderWidth = 1.0;
    ratingBox.layer.masksToBounds = YES;
    ratingBox.layer.cornerRadius = 10.0;
    [self.mainScroll addSubview:ratingBox];
    
    //Create star images
    self.ratingView = [[RatingView alloc] initWithFrame:CGRectMake(30,20,ratingBox.frame.size.width-60, 44)];
    [self.ratingView updateRating:nil stars:0];
    [ratingBox addSubview:self.ratingView];
    
    UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(starPanHandler:)];
    [self.ratingView addGestureRecognizer:panGest];
    
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(starPanHandler:)];
    [self.ratingView addGestureRecognizer:tapGest];
    
    //Message text label
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, ratingBox.frame.origin.y + ratingBox.frame.size.height + 16, self.sharedData.screenWidth - 20, 20)];
    messageLabel.text = @"Please write a review";
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.font = [UIFont phBold:16];
    [self.mainScroll addSubview:messageLabel];
    
    //Message text
    self.messageText = [[UITextView alloc] initWithFrame:CGRectMake(10, messageLabel.frame.origin.y + messageLabel.frame.size.height + 6, self.frame.size.width - 20, self.sharedData.screenHeight - messageLabel.frame.origin.y - messageLabel.frame.size.height - self.tabBar.frame.size.height - 24)];
    self.messageText.editable = YES;
    self.messageText.font = [UIFont phBlond:18];
    self.messageText.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.messageText.layer.borderWidth = 1.0;
    self.messageText.layer.masksToBounds = YES;
    self.messageText.layer.cornerRadius = 10.0;
    self.messageText.returnKeyType = UIReturnKeyDefault;
    self.messageText.delegate = self;
    [self.messageText setTextContainerInset:UIEdgeInsetsMake(12,8,12,8)];
    [self.mainScroll addSubview:self.messageText];
    
    self.numStars = 1;
    
    return self;
}

-(void)starPanHandler:(UIPanGestureRecognizer *)sender
{
    CGPoint location = [sender locationInView:self.ratingView];
    int num = ((location.x/self.ratingView.frame.size.width)*5) + 1;
    num = (num > 5)?5:num;
    num = (num < 0)?0:num;
    [self.ratingView updateRating:nil stars:num];
    
    /*
    //Used to be text under the stars
    if(num==0) {self.ratingText.text = @"No Stars";}
    else if(num>1) self.ratingText.text = [NSString stringWithFormat:@"%d Stars",(int)num];
    else self.ratingText.text =  @"1 Star";
    self.ratingText.textColor = [UIColor blackColor];
    */
    
    self.numStars = num;
}

-(void)btnPostClicked
{
    //NSLog(@"btnPostClicked");
    
    if ([self.messageText.text isEqualToString:REVIEW_PLACEHOLDER] || [self.messageText.text length]<=0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Review" message:@"Please enter a brief review." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self.messageText resignFirstResponder];
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
   
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    
    NSDictionary *dict = @{
                           @"first_name":[self.sharedData.userDict[@"first_name"] lowercaseString],
                           @"from_fb_id":self.sharedData.fb_id,
                           @"fb_id":self.sharedData.member_fb_id,
                           @"message":self.messageText.text,
                           @"rating":[NSString stringWithFormat:@"%d",self.numStars]
                           };
    
    NSString *url = [NSString stringWithFormat:@"%@/reviews/%@/add/%@",PHBaseURL,self.sharedData.account_type,self.sharedData.member_fb_id];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"ADD_REVIEW_RESPONSE :: %@",responseObject);
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Reviews Write" withDict:@{}];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your review has been submitted!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"MEMBER_REVIEW_SUBMITTED"
          object:self userInfo:@{@"member_fb_id":self.sharedData.member_fb_id}];
         
         //Refresh member profiles
         //[self.sharedData.memberProfile forceReload];
         //[self.sharedData.eventsPage.eventsHostDetail forceReload];
         
         [self exitHandler];
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR_ADDING_REVIEW :: %@",operation.response);
         NSLog(@"error: %@",  operation.responseString);
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an issue posting your review, please try again..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
         
         
     }];
}

-(void)btnCancelClicked
{
    //NSLog(@"btnCancelClicked");
    [self exitHandler];
}

//Slide write review upwards
-(void)initClass
{
    self.hidden = NO;
    self.numStars = 0;
    //Get their name for the title
    self.tabTitle.text = [self.sharedData.memberProfileDict[@"first_name"] capitalizedString];
    
    //Update rating
    [self.ratingView updateRating:nil stars:0];
    //self.ratingText.text = @"No Stars";
    
    //Show placeholder
    self.messageText.text = REVIEW_PLACEHOLDER;
    self.messageText.textColor = [UIColor lightGrayColor];
    
    [self.mainScroll setContentOffset:CGPointMake(0,0) animated:NO];
    
    self.mainCon.frame = CGRectMake(0, self.sharedData.screenHeight, self.sharedData.screenWidth, self.sharedData.screenHeight);
    
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.mainCon.frame = CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.screenHeight);
     } completion:^(BOOL finished)
     {
     }];
}

//Slide write review upwards
-(void)exitHandler
{
    [self.messageText resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.mainCon.frame = CGRectMake(0, self.sharedData.screenHeight, self.sharedData.screenWidth, self.sharedData.screenHeight);
     } completion:^(BOOL finished)
     {
         self.hidden = YES;
     }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == self.messageText) {
        if ([self.messageText.text isEqualToString:REVIEW_PLACEHOLDER]) {
            self.messageText.text = @"";
            self.messageText.textColor = [UIColor blackColor]; //optional
        }
        [self.mainScroll setContentOffset:CGPointMake(0,142) animated:YES];
        
        //This lost focus if done too quickly?
        [self performSelector:@selector(messageTextFirstResponder) withObject:nil afterDelay:0.35];
    }
}

-(void)messageTextFirstResponder
{
    [self.messageText becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y < 100)
    {
        [self.messageText resignFirstResponder];
    }
}

@end
