//
//  SignupView.m
//  PartyHost
//
//  Created by Tony Suriyathep on 6/30/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "SetupView.h"

@implementation SetupView

int pageIndex;
BOOL pageControlUsed;
NSMutableArray *pageViews;
int totalPages;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self = [[[NSBundle mainBundle] loadNibNamed:@"Setup" owner:self options:nil] objectAtIndex:0];
        [self setFrame:frame];
        self.isAnimating = NO;
        //Init
        pageControlUsed = NO;
        pageIndex = 0;
        
        [self.button setTitle:@"NEXT" forState:UIControlStateNormal];
        
        //Load all pages
        pageViews = [[NSMutableArray alloc] init];
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"SetupPages" owner:self options:nil];
        totalPages = (int)[nibs count];
        
        for(int i=0;i<totalPages;i++)
        {
            UIView *pageView = nibs[i];
            [pageView setFrame:CGRectMake(self.frame.origin.x+(self.frame.size.width*i),self.frame.origin.y,self.frame.size.width,self.frame.size.height)];
            pageView.backgroundColor = [UIColor clearColor];
            pageViews[i] = pageView;
            [self.scrollView addSubview:pageView];
        }
        
        //Fill in picks on page 2
        self.genderView = pageViews[0];
        self.pickView = pageViews[1];
        self.notificationView = pageViews[2];
        self.locationView = pageViews[3];
        
        //Setup paging
        self.scrollView.delegate = self;
        self.scrollView.contentScaleFactor = 1;
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width * totalPages, self.frame.size.height);
        self.scrollView.scrollEnabled = NO;
        self.scrollView.scrollsToTop = NO;
        
        self.pageControl.numberOfPages = totalPages;
        self.pageControl.hidden = YES;
        
        [self buttonClicked:nil];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(apnAskingDoneHandler)
         name:@"APN_ASKING_DONE"
         object:nil];
    }
    return self;
}

- (void)initClass {
    self.sharedData = [SharedData sharedInstance];
    
    //Set gender choice
    if([self.sharedData.gender isEqual:@"male"]) {[self.genderView maleSet];}
    else {[self.genderView femaleSet];}
    
    //Check location
    //[self.locationView.locationSwitch setOn:self.sharedData.location_on animated:NO];
    
    //Fix gradient
    [self performSelector:@selector(updatePickView) withObject:nil afterDelay:1.00];
    
    //Load picks
    [self loadPicks];
}

-(void)updatePickView {
    [self.pickView updateScrollGradients];
}

-(void)loadPicks {
    //Start spinner
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_LOADING" object:self];
    
    //Load picks
  
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    NSString *url = [Constants userTagListURL];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //Get choices and uppercase
         NSMutableArray *arr = [[NSMutableArray alloc] init];
         [self.sharedData.experiences removeAllObjects];
         for(int i=0;i<[responseObject count];i++) {
             NSString *str = responseObject[i];
             [arr addObject:str];
             [self.sharedData.experiences addObject:str];
         }
         
         
         
         //Select all those picks now if exists
         self.pickView.choiceArray = arr;
         [self.pickView.collectionView reloadData];
         for(int i=0;i<[self.pickView.choiceArray count];i++)
         {
             [self.pickView.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
             
             /*
             for(int j=0;j<[self.sharedData.experiences count];j++)
             {
                if([self.pickView.choiceArray[i] isEqualToString:self.sharedData.experiences[j]])
                {
                    [self.pickView.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                    NSLog(@"PICKED");
                    break;
                }
             }
             */
         }
         
         [[NSNotificationCenter defaultCenter] postNotificationName:@"HIDE_LOADING" object:self];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR :: %@",error);
     }];
}

-(void)changePage:(int)newPage {
    pageIndex = newPage;
}

- (IBAction)pageControlChanged:(id)sender {
    // Set the boolean used when scrolls originate from the page control.
    [self changePage:(int)self.pageControl.currentPage];
    pageControlUsed = YES;
    
    // Update the scroll view to the appropriate page
    CGFloat pageWidth  = self.scrollView.frame.size.width;
    CGFloat pageHeight = self.scrollView.frame.size.height;
    CGRect rect = CGRectMake(pageWidth * pageIndex, 0, pageWidth, pageHeight);
    [self.scrollView scrollRectToVisible:rect animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView*)sender {
    // If the scroll was initiated from the page control, do nothing.
    if (!pageControlUsed) {
        //Switch the page control when more than 50% of the previous/next
        CGFloat pageWidth = self.scrollView.frame.size.width;
        CGFloat xOffset = self.scrollView.contentOffset.x;
        int index = floor((xOffset - pageWidth/2) / pageWidth) + 1;
        if (index != pageIndex) {
            self.pageControl.currentPage = index;
            [self changePage:index];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView {
    pageControlUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView {
    pageControlUsed = NO;
}
//---------------------------------------------------------------------//
//BUTTON

//Fake click the fb login view
- (IBAction)buttonClicked:(id)sender {
    
    NSLog(@"buttonClicked!!!!");
    if(self.isAnimating)
    {
        return;
    }
    NSLog(@"DONE!!!!");
    
    self.isAnimating = YES;
    
    if(pageIndex == 0)
    {
        [self.sharedData trackMixPanelWithDict:@"Walkthrough Gender" withDict:@{}];
    }
    
    if(pageIndex == 1)
    {
        [self.sharedData trackMixPanelWithDict:@"Walkthrough Tags" withDict:@{}];
    }
    
    
    if(pageIndex == 2)
    {
        [self.sharedData trackMixPanelWithDict:@"Walkthrough Push Notifications" withDict:@{}];
    }
    
    
    if(pageIndex == 3)
    {
        [self.sharedData trackMixPanelWithDict:@"Walkthrough Location" withDict:@{}];
    }
    
    
    
    //Walkthrough ended
    if(pageIndex==2) { //Notifications
        if([self.notificationView.notificationSwitch isOn])
        {
            self.isAnimating = NO;
            [self.notificationView commitChanges];
            return;
        }
    }
    else if(pageIndex==3) { //Location
        if([self.locationView commitChanges]==YES) //Dont move on if there was an error
        {
            self.isAnimating = NO;
            [self saveAndExitWalkthrough];
        }
        return;
    }
    
    //Next page
    pageIndex++;
    if(pageIndex==totalPages-1) {
        [self.button setTitle:@"DONE" forState:UIControlStateNormal];
    }
    else {
        [self.button setTitle:@"NEXT" forState:UIControlStateNormal];
    }
    
    //Update the scroll view to the appropriate page
    CGFloat pageWidth  = self.scrollView.frame.size.width;
    CGFloat pageHeight = self.scrollView.frame.size.height;
    CGRect rect = CGRectMake(pageWidth * pageIndex, 0, pageWidth, pageHeight);
    //[self.scrollView scrollRectToVisible:rect animated:YES];
    
    [UIView animateWithDuration:0.25 animations:^()
    {
        [self.scrollView scrollRectToVisible:rect animated:NO];
    } completion:^(BOOL finished)
    {
        self.isAnimating = NO;
    }];
    
    
    
}

-(void)apnAskingDoneHandler
{
    //Next page
    pageIndex++;
    if(pageIndex==totalPages-1) {
        [self.button setTitle:@"DONE" forState:UIControlStateNormal];
    }
    else {
        [self.button setTitle:@"NEXT" forState:UIControlStateNormal];
    }
    
    //Update the scroll view to the appropriate page
    CGFloat pageWidth  = self.scrollView.frame.size.width;
    CGFloat pageHeight = self.scrollView.frame.size.height;
    CGRect rect = CGRectMake(pageWidth * pageIndex, 0, pageWidth, pageHeight);
    [self.scrollView scrollRectToVisible:rect animated:YES];
}
//---------------------------------------------------------------------//
//EXIT

-(void)saveAndExitWalkthrough
{
    //Start spinner
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_LOADING" object:self];
    
    //Set account type and interest automatically
    [self.sharedData calculateDefaultGenderSettings];
    
    //Save settings
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    //Save settings URL
    NSString *url = [Constants memberSettingsURL];
    [manager POST:url parameters:[self.sharedData createSaveSettingsParams] success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"WALKTHROUGH_SAVE_RESPONSE :: %@",responseObject);
         
         //Hide spinner
         [[NSNotificationCenter defaultCenter] postNotificationName:@"HIDE_LOADING" object:self];
         
         //Exit walkthrough
         [[NSNotificationCenter defaultCenter] postNotificationName:@"EXIT_WALKTHROUGH" object:self];
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         [defaults setObject:@"YES" forKey:@"SHOWED_WALKTHROUGH"];
         [defaults synchronize];
         
         
         [self.sharedData trackMixPanelWithDict:@"Completed Walkthrough" withDict:@{}];
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR :: %@",error);
     }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//---------------------------------------------------------------------//


@end
