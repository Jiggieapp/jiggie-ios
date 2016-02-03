//
//  Profile.m
//  PartyHost
//
//  Created by Sunny Clark on 12/26/14.
//  Copyright (c) 2014 Sunny Clark. All rights reserved.
//

#import "AppDelegate.h"
#import "AnalyticManager.h"
#import "Profile.h"
#import "More.h"

#define SPACE_BETWEEN_SECTIONS 12

@implementation Profile

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    self.isPanelOpen = NO;
    self.sharedData = [SharedData sharedInstance];
    self.layer.masksToBounds = YES;
    
    self.startPhotosLoad = NO;
    
    
    self.tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 60)];
    self.tabBar.backgroundColor = [UIColor phPurpleColor];
    
    self.mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.tabBar.frame.size.height, self.sharedData.screenWidth, self.sharedData.screenHeight - PHTabHeight - self.tabBar.frame.size.height)];
    self.mainScroll.backgroundColor = [UIColor whiteColor];
    self.mainScroll.delegate = self;
    self.mainScroll.contentSize = CGSizeMake(self.sharedData.screenWidth, 900);
    
    [self addSubview:self.mainScroll];
    
    self.picScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 300)];
    self.picScroll.delegate = self;
    self.picScroll.pagingEnabled = YES;
    self.picScroll.backgroundColor = [UIColor blackColor];
    [self.mainScroll addSubview:self.picScroll];
    
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.hidden = NO;
    [self.mainScroll addSubview:self.bgView];
    
    self.toLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.sharedData.screenWidth, 40)];
    self.toLabel.textColor = [UIColor whiteColor];
    self.toLabel.backgroundColor = [UIColor clearColor];
    self.toLabel.font = [UIFont phBold:18];
    self.toLabel.textAlignment = NSTextAlignmentCenter;
    [self.tabBar addSubview:self.toLabel];
    
    self.btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
    self.btnEdit.titleLabel.font  = [UIFont phBlond:16];
    self.btnEdit.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.btnEdit.frame = CGRectMake(frame.size.width - 50 - 8, 20, 50, 40);
    self.btnEdit.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.btnEdit addTarget:self action:@selector(editHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:self.btnEdit];
    
    self.pControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.picScroll.frame.size.height - 55, self.picScroll.frame.size.width, 50)];
    self.pControl.userInteractionEnabled = NO;
    self.pControl.currentPage = 0;
    self.pControl.numberOfPages = 4;
    self.pControl.hidden = YES;
    [self.mainScroll addSubview:self.pControl];
    
    [self addSubview:self.tabBar];
    
    self.aboutPanel = [[UIView alloc] init];
    self.aboutPanel.backgroundColor = [UIColor clearColor];
    [self.mainScroll addSubview:self.aboutPanel];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = @"";
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.font = [UIFont phBold:18];
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    [self.aboutPanel addSubview:self.nameLabel];
    
    self.cityLabel = [[UILabel alloc] init];
    self.cityLabel.text = @"";
    self.cityLabel.textAlignment = NSTextAlignmentLeft;
    self.cityLabel.font = [UIFont phBold:13];
    self.cityLabel.textColor = [UIColor darkGrayColor];
    self.cityLabel.backgroundColor = [UIColor clearColor];
    [self.aboutPanel addSubview:self.cityLabel];
    
    self.aboutLabel = [[UILabel alloc] init];
    self.aboutLabel.text = @"ABOUT";
    self.aboutLabel.textAlignment = NSTextAlignmentLeft;
    self.aboutLabel.font = [UIFont phBold:13];
    self.aboutLabel.textColor = [UIColor blackColor];
    self.aboutLabel.backgroundColor = [UIColor clearColor];
    [self.aboutPanel addSubview:self.aboutLabel];
    
    self.separator1 = [[UIView alloc] init];
    self.separator1.backgroundColor = [UIColor phGrayColor];
    [self.aboutPanel addSubview:self.separator1];
    
    self.aboutBody = [[UITextView alloc] init];
    self.aboutBody.font = [UIFont phBlond:16];
    self.aboutBody.textColor = [UIColor darkGrayColor];
    self.aboutBody.textAlignment = NSTextAlignmentLeft;
    self.aboutBody.userInteractionEnabled = NO;
    self.aboutBody.backgroundColor = [UIColor whiteColor];
    self.aboutBody.textContainerInset = UIEdgeInsetsMake(10, 5, 10, 5);
    self.aboutBody.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.aboutBody.text = @"";
    [self.sharedData.keyboardsA addObject:self.aboutBody];
    
    [self.aboutPanel addSubview:self.aboutBody];
    
    /*
     [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(loadProfilePhotos)
     name:@"LOAD_PROFILE_PHOTOS"
     object:nil];
     */
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(loadProfile)
     name:@"APP_LOADED"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(resetApp)
     name:@"APP_UNLOADED"
     object:nil];
    
    return self;
}

-(void)updateAboutPanel
{
    int y1 = 24;

    self.aboutPanel.frame = CGRectMake(0, self.picScroll.frame.origin.y + self.picScroll.frame.size.height + 8, self.sharedData.screenWidth, 0);
    self.aboutPanel.backgroundColor = [UIColor clearColor];
    
    self.nameLabel.frame = CGRectMake(20, y1, self.sharedData.screenWidth - (20*2), 20);
    y1+=self.nameLabel.frame.size.height;
    
    self.cityLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, y1, self.nameLabel.frame.size.width, 25);
    y1+=self.cityLabel.frame.size.height+24;
    
    self.separator1.frame = CGRectMake(self.nameLabel.frame.origin.x,y1, self.nameLabel.frame.size.width, 1);
    y1 += 24;
    
    if(self.aboutBody.text.length>0)
    {
        self.aboutLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, y1, self.nameLabel.frame.size.width, 20);
        y1+=self.aboutLabel.frame.size.height+2;
        
        self.aboutBody.frame = CGRectMake(self.nameLabel.frame.origin.x - 10, y1, self.nameLabel.frame.size.width + 20, 0);
        [self.aboutBody sizeToFit];
        self.aboutBody.frame = CGRectMake(self.nameLabel.frame.origin.x - 10, y1, self.nameLabel.frame.size.width + 20, self.aboutBody.frame.size.height);
        y1+=self.aboutBody.frame.size.height+SPACE_BETWEEN_SECTIONS;
    }
    else
    {
        self.aboutLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, y1, self.nameLabel.frame.size.width, 20);
        y1+=self.aboutLabel.frame.size.height+2;
        
        self.aboutBody.frame = CGRectMake(self.nameLabel.frame.origin.x - 10, y1, self.nameLabel.frame.size.width + 20, 120);
        y1+=self.aboutBody.frame.size.height+SPACE_BETWEEN_SECTIONS;
    }
    
    self.aboutPanel.frame = CGRectMake(0, self.aboutPanel.frame.origin.y, self.sharedData.screenWidth, y1);
    
    self.mainScroll.contentSize = CGSizeMake(self.sharedData.screenWidth, CGRectGetMaxY(self.aboutPanel.frame) + 20);
    
    self.bgView.frame = CGRectMake(0, self.picScroll.frame.origin.y + self.picScroll.frame.size.height, self.sharedData.screenWidth, self.mainScroll.contentSize.height);
}

-(void)initClass
{
    //[self.sharedData trackMixPanel:@"display_profile"];
    
    [self.mainScroll setContentOffset:CGPointMake(0, 0) animated:NO];
    self.picScroll.contentOffset = CGPointMake(0, 0);
    self.isPanelOpen = NO;
    self.pControl.currentPage = 0;
    
    if(!self.startPhotosLoad) self.startPhotosLoad = YES;
    [self loadProfilePhotos];
    
    self.aboutBody.text = [self.sharedData.userDict[@"about"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [self getAboutInfo];
    [self.btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
    [self.aboutBody resignFirstResponder];
    self.aboutBody.userInteractionEnabled = NO;
    self.aboutBody.editable = NO;
    
    //[self updateAboutPanel];
}

-(void)editHandler
{
    if([self.btnEdit.titleLabel.text isEqualToString:@"Edit"]) //Edit clicked
    {
        //[self.sharedData trackMixPanel:@"display_profile_edit"];
        
        [self.btnEdit setTitle:@"Done" forState:UIControlStateNormal];
        self.aboutBody.userInteractionEnabled = YES;
        self.aboutBody.editable = YES;
        self.aboutBody.backgroundColor = [UIColor colorFromHexCode:@"E0E0E0"];
        
        self.sharedData.morePage.btnBack.hidden = YES;
        
        [self.aboutBody becomeFirstResponder];
        [self.mainScroll setContentOffset:CGPointMake(0, self.picScroll.frame.size.height) animated:YES];
    }else{ //Done clicked
        
        /*
        //You must enter something about yourself!
        if([self.aboutBody.text length]==0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"About" message:@"Please enter something about yourself." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
            [alert show];
            return;
        }
        */
        
        self.sharedData.morePage.btnBack.hidden = NO;
        
        [self.btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
        [self.aboutBody resignFirstResponder];
        
        self.aboutBody.userInteractionEnabled = NO;
        self.aboutBody.editable = NO;
        self.aboutBody.backgroundColor = [UIColor whiteColor];
        
        [self.mainScroll setContentOffset:CGPointMake(0, 0) animated:NO];
        
        [self updateAboutInfo];
    }
}

-(void)resetApp
{
    self.nameLabel.text   = @"";
    self.toLabel.text     = @"";
    self.aboutBody.text = @"";
    self.picScroll.contentOffset = CGPointMake(0, 0);
    [self updateAboutPanel];
    
    self.isPanelOpen = NO;
    [self.picScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.pControl.hidden = YES;
    self.startPhotosLoad = NO;
    [self.mainScroll setContentOffset:CGPointMake(0, 0) animated:NO];
}

-(void)loadProfile
{
    self.aboutBody.text     =  [self.sharedData clipSpace:[self.sharedData.userDict objectForKey:@"about"]];
    NSString *birthDate = [self.sharedData.userDict objectForKey:@"birthday"];
    NSDate *todayDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    int time = [todayDate timeIntervalSinceDate:[dateFormatter dateFromString:birthDate]];
    int allDays = (((time/60)/60)/24);
    int days = allDays%365;
    int years = (allDays-days)/365;
    
    NSLog(@"FIRST_NAME :: %@",[self.sharedData.userDict objectForKey:@"first_name"]);
    
    self.toLabel.text = [self.sharedData.userDict[@"first_name"] uppercaseString];
    self.nameLabel.text = [NSString stringWithFormat:@"%@, %d",[self.sharedData.userDict[@"first_name"] uppercaseString],years];
    
    //Location is empty?
    if([self.sharedData.userDict[@"location"] length]==0)
    {
        self.cityLabel.text = @"JIGGIE MEMBER";
    }
    else
    {
        self.cityLabel.text = [self.sharedData.userDict[@"location"] uppercaseString];
    }
    
    [self updateAboutPanel];
    //NSLog(@"You live since %i years and %i days",years,days);
}

-(void)loadProfilePhotos
{
    [self.picScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.picScroll.contentOffset = CGPointMake(0, 0);
    self.pControl.numberOfPages = [[self.sharedData.photosDict objectForKey:@"photos"] count];
    
    
    if(self.pControl.numberOfPages == 0)
    {
        self.pControl.numberOfPages = 1;
        [[self.sharedData.photosDict objectForKey:@"photos"] addObject:[self.sharedData profileImgLarge:self.sharedData.fb_id]];
    }
    NSLog(@"%@", [self.sharedData.photosDict objectForKey:@"photos"]);
    for (int i = 0; i < [[self.sharedData.photosDict objectForKey:@"photos"] count]; i++)
    {
        UIView *picCon = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.picScroll.frame.size.height)];
        picCon.layer.masksToBounds = YES;
        PHImage *pic = [[PHImage alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.picScroll.frame.size.height)];
        pic.contentMode = UIViewContentModeScaleAspectFill;
        pic.alignTop = true;
        pic.showLoading = YES;
        [pic loadImage:[[self.sharedData.photosDict objectForKey:@"photos"] objectAtIndex:i] defaultImageNamed:nil];
        /*
         dispatch_async(dispatch_get_global_queue(0,0), ^{
         NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [[self.sharedData.photosDict objectForKey:@"photos"] objectAtIndex:i]]];
         if ( data == nil )
         return;
         dispatch_async(dispatch_get_main_queue(), ^{
         pic.image = [UIImage imageWithData: data];
         });
         });
         */
        [picCon addSubview:pic];
        [self.picScroll addSubview:picCon];
        self.picScroll.contentSize = CGSizeMake(self.frame.size.width * (i + 1), self.picScroll.frame.size.height);
    }
    
    self.pControl.hidden = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.picScroll)
    {
        int width = self.picScroll.frame.size.width;
        float xPos = scrollView.contentOffset.x+10;
        //Calculate the page we are on based on x coordinate position and width of scroll view
        self.pControl.currentPage = (int)xPos/width;
    }
    
    if(scrollView == self.mainScroll)
    {
        if(scrollView.contentOffset.y < self.picScroll.frame.size.height - 50 )
        {
            //[self.aboutBody resignFirstResponder];
        }
    }
}

-(void)updateAboutInfo
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    NSString *url = [NSString stringWithFormat:@"%@/updateuserabout",PHBaseNewURL];
    [manager POST:url parameters:@{
                                   //@"time" : dateWithNewFormat,
                                   @"fb_id" : self.sharedData.fb_id,
                                   @"about" : self.aboutBody.text
                                   } success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"UPDATE_ABOUT_RESPONSE :: %@",responseObject);
         
         [[AnalyticManager sharedManager] trackMixPanelWithDict:@"MyProfile Update" withDict:@{}];
         
         [self.sharedData.userDict setValue:self.aboutBody.text forKey:@"about"];
         
         [self updateAboutPanel];
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR_UPDATE_ABOUT :: %@",operation.response);
         NSLog(@"error: %@",  operation.responseString);
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error updating your about info. Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
     }];
}

-(void)getAboutInfo
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *urlToLoad = [NSString stringWithFormat:@"%@/memberinfo/%@/%@/%@",PHBaseURL,self.sharedData.account_type,self.sharedData.fb_id,self.sharedData.fb_id];
    [manager GET:urlToLoad parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         self.aboutBody.text = [self.sharedData clipSpace:responseObject[@"about"]];
         [self.sharedData.userDict setValue:responseObject[@"about"] forKey:@"about"];
         
         [self updateAboutPanel];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"MEMBER_PROFILE_ERROR :: %@",error.localizedDescription);
     }];
}

@end
