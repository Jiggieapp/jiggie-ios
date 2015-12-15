//
//  Walkthrough.m
//  PartyHost
//
//  Created by Tony Suriyathep on 6/20/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "Walkthrough.h"
#import "WalkthroughIntro.h"
#import "WalkthroughController.h"
#import "WalkthroughPage.h"

@implementation Walkthrough

int pageIndex;
BOOL pageControlUsed;
NSString *currentAccountType;
WalkthroughController *controllerView;
WalkthroughIntro *introView;
NSMutableArray *pageViews;
int totalPages;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.sharedData = [SharedData sharedInstance];
    totalPages = 6;
    pageControlUsed = NO;
    
    //Load Controller
    NSArray *controllerNib = [[NSBundle mainBundle] loadNibNamed:@"WalkthroughController" owner:self options:nil];
    controllerView = [controllerNib lastObject];
    controllerView.scrollView.delegate = self;
    controllerView.scrollView.contentScaleFactor = 1;
    controllerView.scrollView.contentSize = CGSizeMake(frame.size.width * totalPages, frame.size.height);
    controllerView.scrollView.scrollsToTop = NO;
    controllerView.scrollView.delaysContentTouches = NO;
    controllerView.pageControl.numberOfPages = totalPages;
    controllerView.walkthrough = self;
    [controllerView setFrame:frame];
    [self addSubview:controllerView];
    
    //Load Intro
    NSArray *introNib = [[NSBundle mainBundle] loadNibNamed:@"WalkthroughIntro" owner:self options:nil];
    introView = [introNib lastObject];
    introView.walkthrough = self;
    [introView setFrame:frame];
    [controllerView.scrollView addSubview:introView];
    
    //Load 5 pages
    pageViews = [[NSMutableArray alloc] init];
    for(int i=0;i<5;i++)
    {
        NSArray *pageNib = [[NSBundle mainBundle] loadNibNamed:@"WalkthroughPage" owner:self options:nil];
        WalkthroughPage *pageView = [pageNib lastObject];
        [pageView setFrame:CGRectMake(frame.origin.x+(frame.size.width*(i+1)),frame.origin.y,frame.size.width,frame.size.height)];
        pageView.walkthrough = self;
        pageViews[i] = pageView;
        [controllerView.scrollView addSubview:pageView];
    }
    
    //Put blank purple for far right bounce
    UIView *bgRightOverflow = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x+(frame.size.width*totalPages),frame.origin.y,frame.size.width,frame.size.height)];
    bgRightOverflow.backgroundColor = [UIColor colorFromHexCode:@"351C43"];
    [controllerView.scrollView addSubview:bgRightOverflow];
    
    //Set initial button 
    [controllerView.buttonContinue setTitle:@"Let's Get Started" forState:UIControlStateNormal];
    
    return self;
}

- (void)initClass
{
    //Calc account_type and gender_interest based on gender
    [self.sharedData calculateDefaultGenderSettings];
    currentAccountType = @"";
    
    //Init graphics
    [introView updateGender:YES]; //Gender option
    [self changePage:0]; //Change page control
    [self loadHelpImages]; //Get images now
    
    NSLog(@"WALKTHROUGH_READY");
}

- (void)pageControlChanged
{
    [self changePage:(int)controllerView.pageControl.currentPage];
    
    // Set the boolean used when scrolls originate from the page control.
    pageControlUsed = YES;
    
    // Update the scroll view to the appropriate page
    CGFloat pageWidth  = controllerView.scrollView.frame.size.width;
    CGFloat pageHeight = controllerView.scrollView.frame.size.height;
    CGRect rect = CGRectMake(pageWidth * pageIndex, 0, pageWidth, pageHeight);
    [controllerView.scrollView scrollRectToVisible:rect animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView*)sender
{
    // If the scroll was initiated from the page control, do nothing.
    if (!pageControlUsed)
    {
        //Switch the page control when more than 50% of the previous/next
        CGFloat pageWidth = controllerView.scrollView.frame.size.width;
        CGFloat xOffset = controllerView.scrollView.contentOffset.x;
        int index = floor((xOffset - pageWidth/2) / pageWidth) + 1;
        if (index != pageIndex)
        {
            [self changePage:index];
            controllerView.pageControl.currentPage = index;
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView
{
    pageControlUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    pageControlUsed = NO;
}

- (void)loadHelpImages
{
    //Same don't change the next images
    if([self.sharedData.account_type isEqualToString:currentAccountType]) {
        return;
    }
    
    currentAccountType = self.sharedData.account_type;
    
    for(int i=0;i<5;i++)
    {
        WalkthroughPage *pageView = pageViews[i];
        NSString *imageName = [NSString stringWithFormat:@"wk_%@_%i.png",currentAccountType,(i+1)];
        pageView.backgroundImage.image = [UIImage imageNamed:imageName];
    }
}

-(void)buttonClick {
    int pg = (int)controllerView.pageControl.currentPage + 1;
    
    //Walkthrough ended
    if(pg>=totalPages) {
        [self saveAndExitWalkthrough];
        return;
    }
    
    //Scroll to next page
    pageControlUsed = YES;
    controllerView.pageControl.currentPage = pg;
    [self changePage:pg];
    
    // Update the scroll view to the appropriate page
    CGFloat pageWidth  = controllerView.scrollView.frame.size.width;
    //CGFloat pageHeight = controllerView.scrollView.frame.size.height;
    //CGRect rect = CGRectMake(pageWidth * pg, 0, pageWidth, pageHeight);
    [UIView animateWithDuration:0.25 animations:^(void)
    {
        controllerView.scrollView.contentOffset = CGPointMake(pageWidth * pg, 0);
    }];
    
    //[controllerView.scrollView setContentOffset:CGPointMake(pageWidth * pg, 0) animated:YES];
    //[controllerView.scrollView scrollRectToVisible:rect animated:YES];
}

- (void)buttonBackward {
    int pg = (int)controllerView.pageControl.currentPage - 1;
    
    //Walkthrough ended
    if(pg<0) {
        return;
    }
    
    //Scroll to next page
    pageControlUsed = YES;
    controllerView.pageControl.currentPage = pg;
    [self changePage:pg];
    
    // Update the scroll view to the appropriate page
    CGFloat pageWidth  = controllerView.scrollView.frame.size.width;
    //CGFloat pageHeight = controllerView.scrollView.frame.size.height;
    //CGRect rect = CGRectMake(pageWidth * pg, 0, pageWidth, pageHeight);
    //[controllerView.scrollView scrollRectToVisible:rect animated:YES];
    
    [UIView animateWithDuration:0.25 animations:^(void)
     {
         controllerView.scrollView.contentOffset = CGPointMake(pageWidth * pg, 0);
     }];
}

- (void)changePage:(int)index {
    pageIndex = index;
    
    if(index==0)
    {
        controllerView.buttonBackward.hidden = YES;
        [controllerView.buttonContinue setTitle:@"Let's Get Started" forState:UIControlStateNormal];
    }
    else if(index==1)
    {
        controllerView.buttonBackward.hidden = NO;
        [controllerView.buttonContinue setTitle:@"Continue" forState:UIControlStateNormal];
    }
    else if(index==2)
    {
        [controllerView.buttonContinue setTitle:@"Continue" forState:UIControlStateNormal];
    }
    else if(index==3)
    {
        [controllerView.buttonContinue setTitle:@"Continue" forState:UIControlStateNormal];
    }
    else if(index==4)
    {
        controllerView.buttonForward.hidden = NO;
        [controllerView.buttonContinue setTitle:@"Continue" forState:UIControlStateNormal];
    }
    else if(index==5)
    {
        controllerView.buttonForward.hidden = YES;
        [controllerView.buttonContinue setTitle:@"Okay Let's Party!" forState:UIControlStateNormal];
    }
}

-(void)saveAndExitWalkthrough
{
    //Start spinner
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_LOADING" object:self];
    
    //Save settings
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //Save settings params
    NSDictionary *params = @{
                             @"fb_id" : self.sharedData.fb_id,
                             @"account_type": self.sharedData.account_type,
                             @"gender": self.sharedData.gender,
                             @"gender_interest": self.sharedData.gender_interest,
                             @"feed": [NSNumber numberWithInt:(self.sharedData.notification_feed)?1:0],
                             @"chat": [NSNumber numberWithInt:(self.sharedData.notification_messages)?1:0]
                             };
    
    //Save settings URL
    NSString *url = [NSString stringWithFormat:@"%@/membersettings",self.sharedData.baseHerokuAPIURL];
    
    NSLog(@"WALKTHROUGH_SAVE_PARAMS :: %@",params);
    NSLog(@"WALKTHROUGH_SAVE_URL :: %@",url);
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"WALKTHROUGH_SAVE_RESPONSE :: %@",responseObject);
         
         //Hide spinner
         [[NSNotificationCenter defaultCenter] postNotificationName:@"HIDE_LOADING" object:self];
         
         //Exit walkthrough
         [[NSNotificationCenter defaultCenter] postNotificationName:@"EXIT_WALKTHROUGH" object:self];
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         [defaults setObject:@"YES" forKey:@"SHOWED_WALKTHROUGH"];
         [defaults synchronize];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR :: %@",error);
     }];
}

@end
