//
//  Hostings.m
//  PartyHost
//
//  Created by Sunny Clark on 1/1/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "MyHostings.h"

#define PICKER_PADDING (60*60*24*3) //Allow 1 days just so the picker isnt so restrictive
#define DATE_DISPLAY @"EEE, MMM d, yyyy h:mm a" //This is shown to the user
#define DATE_SHORT_DISPLAY @"MMM d, yyyy h:mm a" //This comes from the server when reading
#define DATE_STORE @"yyyy-MM-dd'T'HH:mm:ss.SSSZ" //This also comes from the server
#define MESSAGE_PLACEHOLDER @"Drinks and a great time!"
#define ONE_HOUR_TIME (60*60)

@implementation MyHostings

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    self.sharedData = [SharedData sharedInstance];
    
    self.isHostingsLoaded = NO;
    self.isLoading = NO;
    self.isVenuesListLoaded = NO;
    self.isInEditMode       = NO;
    self.cEditId            = 0;
    self.hasHostings        = NO;
    self.cameFromEvents     = NO;
    
    self.mainCon = [[UIView alloc] initWithFrame:CGRectMake(0, 60, self.sharedData.screenWidth * 2, self.sharedData.screenHeight - 100)];
    
    [self addSubview:self.mainCon];
    
    self.tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 60)];
    self.tabBar.backgroundColor = [UIColor phLightTitleColor];
    [self addSubview:self.tabBar];
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, frame.size.width, 40)];
    self.title.text = @"Hostings";
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.textColor = [UIColor whiteColor];
    self.title.font = [UIFont phBold:18];
    [self.tabBar addSubview:self.title];
    
    self.btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnBack.frame = CGRectMake(0, 20, 40, 40);
    [self.btnBack setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [self.btnBack setImageEdgeInsets:UIEdgeInsetsMake(8, 14, 8, 14)];
    //[self.btnBack setTitle:@"Back" forState:UIControlStateNormal];
    
    [self.btnBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.btnBack.hidden = YES;
    [self.tabBar addSubview:self.btnBack];
    
    self.btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnAdd.frame = CGRectMake(self.frame.size.width - 50-8, 20, 50, 40);
    [self.btnAdd setTitle:@"New" forState:UIControlStateNormal];
    self.btnAdd.titleLabel.font  = [UIFont phBlond:18];
    self.btnAdd.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.btnAdd setTintColor:[UIColor whiteColor]];
    [self.btnAdd addTarget:self action:@selector(newButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.tabBar addSubview:self.btnAdd];
    
    self.hostingsA = [[NSMutableArray alloc] init];
    self.hostingsList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 60)];
    self.hostingsList.delegate = self;
    self.hostingsList.dataSource = self;
    self.hostingsList.allowsMultipleSelectionDuringEditing = NO;
    //self.hostingsList.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self.mainCon addSubview:self.hostingsList];
    
    [self createAddEdit];
    
    self.venueList = [[VenuesList alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth, -44, self.sharedData.screenWidth, self.sharedData.screenHeight - 60)];
    [self.mainCon addSubview:self.venueList];
    
    //[self getVenuesList];
    
    self.venueList.layer.masksToBounds = YES;
    
    self.cDeleteId = 0;
    
    self.existingEventDict = [[NSMutableDictionary alloc] init];
    
    [self.hostingsList beginUpdates];
    [self.hostingsList endUpdates];
    
    //Create empty label
    self.labelEmpty = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.screenHeight)];
    self.labelEmpty.text = @"No hostings yet.";
    self.labelEmpty.textAlignment = NSTextAlignmentCenter;
    self.labelEmpty.textColor = [UIColor lightGrayColor];
    self.labelEmpty.hidden = YES;
    self.labelEmpty.font = [UIFont phBlond:16];
    [self addSubview:self.labelEmpty];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(resetApp)
     name:@"APP_UNLOADED"
     object:nil];
    
    return self;
}


-(void)resetApp
{
    self.isHostingsLoaded = NO;
    self.isLoading = NO;
    self.isVenuesListLoaded = NO;
    self.isInEditMode       = NO;
    self.cEditId            = 0;
    self.hasHostings        = NO;
    [self.hostingsA removeAllObjects];
    [self.hostingsList reloadData];
    [self goBack];
    
    [self.hostingsList beginUpdates];
    [self.hostingsList endUpdates];
}


-(void)createAddEdit
{
    self.addEditCon = [[UIScrollView alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth, 0, self.sharedData.screenWidth, self.frame.size.height - 60)];
    self.addEditCon.backgroundColor = [UIColor whiteColor];
    self.addEditCon.delegate = self;
    [self.mainCon addSubview:self.addEditCon];
    
    self.addEditImg = [[PHImage alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 75)];
    self.addEditImg.contentMode = UIViewContentModeScaleAspectFill;
    self.addEditImg.backgroundColor = [UIColor blackColor];
    self.addEditImg.layer.masksToBounds = YES;
    [self.addEditCon addSubview:self.addEditImg];
    
    self.addEditEditImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth - 30, 10, 20, 20)];
    self.addEditEditImg.image = [UIImage imageNamed:@"btn_pencil_edit"];
    [self.addEditCon addSubview:self.addEditEditImg];
    
    self.addEditInivisi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 75)];
    self.addEditInivisi.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    [self.addEditCon addSubview:self.addEditInivisi];
    
    self.addEditTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.sharedData.screenWidth - 20, 24)];
    self.addEditTitle.font = [UIFont phBold:20];
    self.addEditTitle.textColor = [UIColor whiteColor];
    self.addEditTitle.backgroundColor = [UIColor clearColor];
    self.addEditTitle.userInteractionEnabled = NO;
    self.addEditTitle.shadowColor = [UIColor blackColor];
    self.addEditTitle.shadowOffset = CGSizeMake(0.5,0.5);
    [self.addEditCon addSubview:self.addEditTitle];
    
    self.addEditSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 32, self.sharedData.screenWidth - 20, 20)];
    self.addEditSubtitle.font = [UIFont phBlond:14];
    self.addEditSubtitle.textColor = [UIColor whiteColor];
    self.addEditSubtitle.userInteractionEnabled = NO;
    self.addEditSubtitle.backgroundColor = [UIColor clearColor];
    self.addEditSubtitle.shadowColor = [UIColor blackColor];
    self.addEditSubtitle.shadowOffset = CGSizeMake(0.5,0.5);
    [self.addEditCon addSubview:self.addEditSubtitle];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(hostingLocTapHandler:)];
    longPress.minimumPressDuration = 0.01;
    [self.addEditInivisi addGestureRecognizer:longPress];
    
    UILabel *whenLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 85, self.frame.size.width - 20, 20)];
    whenLabel.text = @"Hosting Start Time";
    whenLabel.textColor = [UIColor blackColor];
    whenLabel.font = [UIFont phBold:16];
    [self.addEditCon addSubview:whenLabel];
    
    self.addEditTitleInput = [[UITextField alloc] initWithFrame:CGRectMake(10, 110, self.frame.size.width - 20, 30)];
    self.addEditTitleInput.font = [UIFont phBlond:18];
    self.addEditTitleInput.borderStyle = UITextBorderStyleRoundedRect;
    self.addEditTitleInput.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.addEditTitleInput.layer.borderWidth = 1.0;
    self.addEditTitleInput.layer.masksToBounds = YES;
    self.addEditTitleInput.layer.cornerRadius = 10.0;
    self.addEditTitleInput.userInteractionEnabled = NO;
    self.addEditTitleInput.delegate = self;
    [self.addEditCon addSubview:self.addEditTitleInput];
    
    UILabel *whenLabelTwo = [[UILabel alloc] initWithFrame:CGRectMake(10, self.addEditTitleInput.frame.origin.y + self.addEditTitleInput.frame.size.height + 12, self.frame.size.width - 20, 20)];
    whenLabelTwo.text = @"Hosting End Time";
    whenLabelTwo.textColor = [UIColor blackColor];
    whenLabelTwo.font = [UIFont phBold:16];
    [self.addEditCon addSubview:whenLabelTwo];
    
    self.addEditTitleTwoInput = [[UITextField alloc] initWithFrame:CGRectMake(10, whenLabelTwo.frame.origin.y + whenLabelTwo.frame.size.height + 8, self.frame.size.width - 20, 30)];
    self.addEditTitleTwoInput.font = [UIFont phBlond:18];
    self.addEditTitleTwoInput.borderStyle = UITextBorderStyleRoundedRect;
    self.addEditTitleTwoInput.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.addEditTitleTwoInput.layer.borderWidth = 1.0;
    self.addEditTitleTwoInput.layer.masksToBounds = YES;
    self.addEditTitleTwoInput.layer.cornerRadius = 10.0;
    self.addEditTitleTwoInput.delegate = self;
    self.addEditTitleTwoInput.userInteractionEnabled = NO;
    [self.addEditCon addSubview:self.addEditTitleTwoInput];
    
    //Create date picker
    self.datePicker = [[UIDatePicker alloc]init];
    [self.datePicker setDate:[NSDate date]];
    self.datePicker.minimumDate = [NSDate date];
    self.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [self.datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.addEditTitleInput setInputView:self.datePicker];
    [self.addEditTitleTwoInput setInputView:self.datePicker];
    self.datePicker.minuteInterval = 30;
    
    UILabel *whatLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.addEditTitleTwoInput.frame.origin.y + self.addEditTitleTwoInput.frame.size.height + 12, self.frame.size.width - 20, 20)];
    whatLabel.text = @"What Are You Offering?";
    whatLabel.textColor = [UIColor blackColor];
    whatLabel.font = [UIFont phBold:16];
    [self.addEditCon addSubview:whatLabel];
    
    self.addEditSubtitleTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, whatLabel.frame.origin.y + whatLabel.frame.size.height + 8, self.frame.size.width - 20, 110)];
    self.addEditSubtitleTextView.editable = YES;
    self.addEditSubtitleTextView.font = [UIFont phBlond:18];
    self.addEditSubtitleTextView.textColor = [UIColor blackColor];
    self.addEditSubtitleTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.addEditSubtitleTextView.layer.borderWidth = 1.0;
    self.addEditSubtitleTextView.layer.masksToBounds = YES;
    self.addEditSubtitleTextView.layer.cornerRadius = 10.0;
    self.addEditSubtitleTextView.returnKeyType = UIReturnKeyDefault;
    self.addEditSubtitleTextView.delegate = self;
    [self.addEditCon addSubview:self.addEditSubtitleTextView];
    
    self.addEditBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.addEditBtn.frame = CGRectMake(self.sharedData.screenWidth - 50-8, 10, 50, 50);
    self.addEditBtn.titleEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    [self.addEditBtn setTitle:@"Save" forState:UIControlStateNormal];
    self.addEditBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.addEditBtn.titleLabel.font  = [UIFont phBlond:20];
    [self.addEditBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[self.addEditBtn setBackgroundColor:[UIColor grayColor]];
    [self.addEditBtn addTarget:self action:@selector(addEditTapHandler) forControlEvents:UIControlEventTouchUpInside];
    self.addEditBtn.layer.masksToBounds = YES;
    self.addEditBtn.layer.cornerRadius = 10.0;
    self.addEditBtn.hidden = YES;
    self.addEditBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.tabBar addSubview:self.addEditBtn];
    //[self.addEditCon addSubview:self.addEditBtn];
    
    self.addEditShareBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.addEditShareBtn.frame = CGRectMake( 10, self.addEditSubtitleTextView.frame.size.height + self.addEditSubtitleTextView.frame.origin.y + 10, self.sharedData.screenWidth - 20, 40);
    //self.addEditShareBtn.titleEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    [self.addEditShareBtn setTitle:@"Share Hosting" forState:UIControlStateNormal];
    self.addEditShareBtn.titleLabel.font  = [UIFont phBold:16.0];
    [self.addEditShareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addEditShareBtn setBackgroundColor:[UIColor grayColor]];
    [self.addEditShareBtn addTarget:self action:@selector(shareHostingHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.addEditCon addSubview:self.addEditShareBtn];
    
    self.addEditCon.contentSize = CGSizeMake(self.sharedData.screenWidth, 800);
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(updateAddLoc)
     name:@"VENUELIST_SELECTED"
     object:nil];
}

-(void)hostingLocTapHandler:(UILongPressGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        self.addEditInivisi.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    }
    else if(sender.state == UIGestureRecognizerStateEnded)
    {
        self.addEditInivisi.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
        
        //Check if we are allowed to edit venue?
        if(self.addEditEditImg.hidden == YES)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Edit Venue" message:@"If you would like to change the venue delete this hosting and create a hosting at a different venue." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        [self.addEditTitleInput resignFirstResponder];
        [self.addEditTitleTwoInput resignFirstResponder];
        [self.addEditSubtitleTextView resignFirstResponder];
        [self.venueList.searchBar resignFirstResponder];
        
        [self.venueList initClass];
        self.venueList.hidden = NO;
        self.title.text = @"Choose Event";
    }
}

-(void)updateAddLoc
{
    self.addEditBtn.hidden = NO;
    
    NSDictionary *venueSelected;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    if(self.isInEditMode)
    {
        venueSelected = [self.sharedData.venuesNameList objectAtIndex:self.sharedData.cVenueListIndex];
        
        self.title.text = @"EDIT HOSTING";
        
        //Enable venue picker?
        self.addEditEditImg.hidden = NO;
        self.addEditInivisi.userInteractionEnabled = YES;
    }
    else
    {
        self.title.text = @"ADD HOSTING";
        
        //Start and end dates are from
        if([self.sharedData.cAddEventDict count]>0)
        { //Based on existing event
            
            
            NSLog(@"self.sharedData.cAddEventDict :: %@",self.sharedData.cAddEventDict);
            //Use a previously selected event
            venueSelected = self.sharedData.cAddEventDict[@"venue"];
            
            //Select venue now
            for (int i = 0; i < [self.sharedData.venuesNameList count]; i++)
            {
                NSDictionary *dict = [self.sharedData.venuesNameList objectAtIndex:i];
                if([dict[@"_id"] isEqualToString:venueSelected[@"_id"]])
                {
                    self.sharedData.cVenueListIndex = i;
                }
            }
            
            //Disable venue picker?
            self.addEditEditImg.hidden = YES;
            self.addEditInivisi.userInteractionEnabled = NO;
            
            //Get start and end from existing event
            [dateFormatter setDateFormat:DATE_SHORT_DISPLAY];
            
            //Set to event time
            self.startDate = [dateFormatter dateFromString:self.sharedData.cAddEventDict[@"start_datetime_str"]];
            self.endDate = [dateFormatter dateFromString:self.sharedData.cAddEventDict[@"end_datetime_str"]];
            
            /*
            //Allow wiggle room
            self.startMin = [self.startDate dateByAddingTimeInterval:-PICKER_PADDING];
            self.startMax = self.endDate;
            
            //Allow wiggle room
            self.endMin = self.startDate; //1 hour away
            self.endMax = [self.endDate dateByAddingTimeInterval:PICKER_PADDING];
             */
            
            //Allow wiggle room
            self.startMin = [self.startDate dateByAddingTimeInterval:-PICKER_PADDING];
            self.startMax = [self.startDate dateByAddingTimeInterval:(ONE_HOUR_TIME * 24 * 7 * 2)]; //2 weeks away
            
            //Allow wiggle room
            self.endMin = self.startMin; //1 hour away
            self.endMax = self.startMax;
        }
        else
        { //Brand new
            
            //Use whatever venue was picked
            venueSelected = [self.sharedData.venuesNameList objectAtIndex:self.sharedData.cVenueListIndex];
            self.sharedData.cEventId_toLoad = venueSelected[@"_id"];
            
            //Enable venue picker?
            self.addEditEditImg.hidden = NO;
            self.addEditInivisi.userInteractionEnabled = YES;
            
            //Start minimum, date is next hour rounded
            NSDate *startDate = [[NSDate date] dateByAddingTimeInterval:ONE_HOUR_TIME];
            NSCalendar *startCalendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
            NSDateComponents *startComponents = [startCalendar components: NSUIntegerMax fromDate: startDate];
            [startComponents setMinute: 0];
            [startComponents setSecond: 0];
            self.startDate = [startCalendar dateFromComponents: startComponents];
            self.endDate = [self.startDate dateByAddingTimeInterval:ONE_HOUR_TIME]; //1 hour away
            
            /*
            //Allow wiggle room, and max to 2 weeks
            self.startMin = [self.startDate dateByAddingTimeInterval:-PICKER_PADDING]; //Add day forward to ease entry
            self.startMax = [self.startDate dateByAddingTimeInterval:(ONE_HOUR_TIME * 24 * 7 * 2)]; //2 weeks away
            
            //Limit end
            self.endMin = self.startDate;
            self.endMax = self.startMax;
            */
            
            //Allow wiggle room, and max to 2 weeks
            self.startMin = [self.startDate dateByAddingTimeInterval:-PICKER_PADDING]; //Add day forward to ease entry
            self.startMax = [self.startDate dateByAddingTimeInterval:(ONE_HOUR_TIME * 24 * 7 * 2)]; //2 weeks away
            
            //Limit end
            self.endMin = self.startMin;
            self.endMax = self.startMax;
        }
        
        //Set date picker
        self.datePicker.minimumDate = self.startMin;
        self.datePicker.maximumDate = self.startMax;
        self.datePicker.date = self.startDate;
        
        //Set text date
        [dateFormatter setDateFormat:DATE_DISPLAY];
        self.addEditTitleInput.text = [dateFormatter stringFromDate:self.startDate];
        self.addEditTitleTwoInput.text = [dateFormatter stringFromDate:self.endDate];
        
        //Set placeholder
        self.addEditSubtitleTextView.text = MESSAGE_PLACEHOLDER;
        self.addEditSubtitleTextView.textColor = [UIColor lightGrayColor];
        
        //First date gets picker control
        [self.addEditTitleInput becomeFirstResponder];
    }
    
    //Set venue info
    self.addEditTitle.text = [venueSelected[@"name"] capitalizedString];
    self.addEditSubtitle.text = [venueSelected[@"neighborhood"] capitalizedString];
    
    //Set venue pic
    NSString *picURL = [venueSelected[@"photos"] objectAtIndex:0];
    [self.addEditImg loadImage:[self.sharedData picURL:picURL] defaultImageNamed:@"nightclub_default"];
}

-(void)shareHostingHandler
{
    self.sharedData.member_first_name = [self.sharedData capitalizeFirstLetter:[self.sharedData.userDict objectForKey:@"first_name"]];
    self.sharedData.member_fb_id = self.sharedData.fb_id;
    NSMutableDictionary *dict = [self.hostingsA objectAtIndex:self.cEditId];
    
    //Everything needed for share link
    self.sharedData.shareHostingId = dict[@"_id"];
    self.sharedData.shareHostingVenueName = dict[@"venue"][@"name"];
    self.sharedData.shareHostingHostName = dict[@"host"][@"first_name"];
    self.sharedData.shareHostingHostFbId = dict[@"host"][@"fb_id"];
    self.sharedData.shareHostingHostDate = dict[@"start_datetime_str"];
    self.sharedData.cHostVenuePicURL = [Constants eventImageURL:dict[@"event"][@"_id"]]; //Need for SHARE HOSTING
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_HOSTING_INVITE" object:self];
    
    //Mixpanel
    [self.sharedData trackMixPanelWithDict:@"Share Hosting" withDict:@{@"origin":@"MyHostings"}];
}

-(void)addEditTapHandler
{
    [self.addEditTitleInput resignFirstResponder];
    [self.addEditTitleTwoInput resignFirstResponder];
    [self.addEditSubtitleTextView resignFirstResponder];
    
    //Must fill out offering
    if([self.addEditSubtitleTextView.text isEqualToString:MESSAGE_PLACEHOLDER] || self.addEditSubtitleTextView.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Hosting" message:@"What you are offering?" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    if(self.isInEditMode)
    {
        NSLog(@"UPDATING_HOSTING");
        
        [self updateHosting];
        
    }else{
        NSLog(@"ADD_HOSTING");
        
        //This should be called if they are adding to an existing event
        //[self addHostingToExistingEvent];
        
        //This will check for conflicts
        [self addHosting];
    }
    
}

-(void)updateTextField:(id)sender
{
    //Update text for last touched text field
    UIDatePicker *picker = sender;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [formatter setDateFormat:DATE_DISPLAY];
    self.eEditInput.text = [formatter stringFromDate:picker.date];
    
    //Update start or end date
    if(self.eEditInput == self.addEditTitleInput)
    {
        //Start date picker
        self.startDate = picker.date;
        //[self recalculateEndDate];
    }else{ //End date picker
        self.endDate = picker.date;
    }
}

/*
-(void)recalculateEndDate
{
    //End minimum
    self.endMin = self.startDate;
    if(self.endDate<self.endMin) self.endDate = self.endMin;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [formatter setDateFormat:DATE_DISPLAY];
    self.addEditTitleTwoInput.text = [formatter stringFromDate:self.endDate];
}
*/

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(self.startDate==nil) return NO;
    
    //Switch picker control to start or end date
    self.eEditInput = textField;
    if(self.eEditInput == self.addEditTitleInput) //Start date
    {
        self.datePicker.minimumDate = self.startMin;
        self.datePicker.maximumDate = self.startMax;
        self.datePicker.date = self.startDate;
    }else{ //End date
        self.datePicker.minimumDate = self.endMin;
        self.datePicker.maximumDate = self.endMax;
        self.datePicker.date = self.endDate;
    }
    
    return YES;
}

-(void)initClass
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
        
    self.labelEmpty.hidden = YES;
    self.hostingsList.hidden = YES;
    self.hostingsList.contentOffset = CGPointMake(0, 0);
    
    [self.venueList initClass];
    
    self.sharedData.morePageBtnBack.hidden = NO;
    
    [self loadData];
}


-(void)loadData
{
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSString *url = [NSString stringWithFormat:@"%@/user/hostings/all/%@",PHBaseURL,self.sharedData.fb_id];
    NSLog(@"MY_HOSTINGS_URL :: %@",url);
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"MY_HOSTINGS :: %@",responseObject);
         
         [self.sharedData trackMixPanelWithDict:@"View MyHostings" withDict:@{}];
         
         self.hasHostings = ([responseObject count] > 0);
         self.isHostingsLoaded = YES;
         [self.hostingsA removeAllObjects];
         [self.hostingsA addObjectsFromArray:responseObject];
         [self.hostingsList reloadData];
         
         //Show empty
         if([self.hostingsA count]==0)
         {
             self.labelEmpty.hidden = NO;
             self.hostingsList.hidden = YES;
         }
         else
         {
             self.labelEmpty.hidden = YES;
             self.hostingsList.hidden = NO;
         }
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         /*
         if(!self.cameFromEvents)
         {
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"HIDE_LOADING"
              object:self];
         }
         */
         
         self.cameFromEvents = NO;
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR :: %@",error);
     }];
}


-(void)loadHostingFromEvents
{
    
    [self goNew];
    self.venueList.hidden = YES;
    for (int i = 0; i < [self.sharedData.venuesNameList count]; i++)
    {
        NSDictionary *dict = [self.sharedData.venuesNameList objectAtIndex:i];
        if([dict[@"_id"] isEqualToString:self.sharedData.cEventId_toLoad])
        {
            self.sharedData.cVenueListIndex = i;
        }
    }
    self.btnAdd.hidden = YES;
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"VENUELIST_SELECTED"
     object:self];
    
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.26);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void)
                   {
                       self.btnAdd.hidden = YES;
                   });
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //add code here for when you hit delete
        NSLog(@"YES!!!!!!");
        
        self.cDeleteId = (int)indexPath.row;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Hosting?" message:@"Are you sure you want to delete this hosting?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        alert.tag = 12;
        alert.delegate = self;
        [alert addButtonWithTitle:@"Yes"];
        [alert show];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.isHostingsLoaded == NO)?1:([self.hostingsA count] > 0)?[self.hostingsA count]:1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *buttonDelete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                          {
                                              self.cDeleteId = (int)indexPath.row;
                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Hosting?" message:@"Are you sure you want to delete this hosting?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                                              alert.tag = 12;
                                              alert.delegate = self;
                                              [alert addButtonWithTitle:@"Yes"];
                                              [alert show];
                                              
                                              
                                          }];
    buttonDelete.backgroundColor = [UIColor redColor];
    
    if(self.isHostingsLoaded && [self.hostingsA count] > 0)
    {
        return @[buttonDelete];
    }else
    {
        return @[];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([alertView tag] == 12) //Delete hosting
    {
        if (buttonIndex == 1)
        {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"SHOW_LOADING"
             object:self];
            
            NSDictionary *dict = [self.hostingsA objectAtIndex:self.cDeleteId];
            
            [self deleteHosting:[dict objectForKey:@"_id"]];
        }
    }
    else if ([alertView tag] == 13) //Add hosting conflict
    {
        if (buttonIndex == 0) //Change dates (do nothing)
        {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"HIDE_LOADING"
             object:self];
        }
        else if (buttonIndex == 1) //Use existing
        {
            [self addHostingToExistingEvent];
        }
    }
}

//This is "My Hostings" and you can select a row to EDIT
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    if(!self.isHostingsLoaded || [self.hostingsA count] == 0)
    {
        return;
    }
    
    self.cEditId = (int)indexPath.row;
    NSDictionary *dict = [self.hostingsA objectAtIndex:self.cEditId];
    
    //Venue info
    self.addEditTitle.text = dict[@"event"][@"title"];
    self.addEditSubtitle.text = dict[@"venue"][@"name"];
    
    if([dict[@"venue"][@"address"] isEqualToString:dict[@"venue"][@"name"]])
    {
        self.addEditSubtitle.text = dict[@"venue"][@"neighborhood"];
    }
    else
    {
        self.addEditSubtitle.text = dict[@"venue"][@"address"];
    }
    
    NSString *picURL = @"";
    if([dict[@"venue"][@"photos"] count] > 0)
    {
        picURL = [dict[@"venue"][@"photos"] objectAtIndex:0];
    }
    
    picURL = [self.sharedData picURL:picURL];
    self.sharedData.cHostVenuePicURL = picURL;
    [self.addEditImg loadImage:picURL defaultImageNamed:@"nightclub_default"];
    
    //Without day of week
    NSDateFormatter *shortFormat = [[NSDateFormatter alloc] init];
    [shortFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [shortFormat setDateFormat:DATE_SHORT_DISPLAY];
    
    //With day of week
    NSDateFormatter *longFormat = [[NSDateFormatter alloc] init];
    [longFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [longFormat setDateFormat:DATE_DISPLAY];
    
    //Get dates from database
    NSDate *eventStart = [shortFormat dateFromString:dict[@"start_datetime_str"]];
    NSDate *eventEnd = [shortFormat dateFromString:dict[@"end_datetime_str"]];
    self.startDate = eventStart;
    self.endDate = eventEnd;
    
    self.startMin = [eventStart dateByAddingTimeInterval:-PICKER_PADDING]; //Add day backward to ease entry
    self.startMax = [eventEnd dateByAddingTimeInterval:(ONE_HOUR_TIME * 24 * 7 * 2)];
    
    self.endMin = self.startMin;
    self.endMax = self.startMax;
    
    //Set text
    self.addEditTitleInput.text = [longFormat stringFromDate:self.startDate];
    self.addEditTitleTwoInput.text = [longFormat stringFromDate:self.endDate];
    self.addEditSubtitleTextView.text = dict[@"description"];
    
    //[self.sharedData trackMixPanel:@"edit_hosting_tapped"];
    
    [self goEdit];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MyHostingsCell";
    
    MyHostingsCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[MyHostingsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if(self.isHostingsLoaded && [self.hostingsA count] > 0)
    {
        NSDictionary *dict = [self.hostingsA objectAtIndex:indexPath.row];
        [cell loadData:dict];
        [cell hideLoading];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }else if(self.isHostingsLoaded && [self.hostingsA count] == 0){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell showNone];
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell showLoading];
    }
    
    return cell;
}


-(void)goEdit
{
    self.sharedData.morePageBtnBack.hidden = YES;
    self.addEditShareBtn.hidden = NO;
    [self.addEditCon setContentOffset:CGPointMake(0, 0)];
    self.isInEditMode = YES;
    [self.addEditBtn setTitle:@"Save" forState:UIControlStateNormal];
    self.venueList.hidden = YES;
    self.btnAdd.hidden = YES;
    self.addEditBtn.hidden = NO;
    self.title.text = @"EDIT HOSTING";
    
    //Disable dates
    /*
    self.addEditTitleInput.userInteractionEnabled = NO;
    self.addEditTitleInput.textColor = [UIColor lightGrayColor];
    self.addEditTitleTwoInput.userInteractionEnabled = NO;
    self.addEditTitleTwoInput.textColor = [UIColor lightGrayColor];
    */
    
    //Allow edit message body
    self.addEditSubtitleTextView.textColor = [UIColor blackColor];
    
    //Disable venue picker
    self.addEditEditImg.hidden = YES;
    //self.addEditInivisi.userInteractionEnabled = NO;
    
    //Action button
    self.btnAdd.hidden = YES;
    self.addEditBtn.hidden = NO;
    
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.mainCon.frame = CGRectMake(-self.frame.size.width, 60, self.frame.size.width * 2, self.frame.size.height - 60);
     } completion:^(BOOL fin)
     {
         self.btnBack.hidden = NO;
     }];
}

-(void)newButtonClicked
{
    //Clear out add event dictionary because we didnt come from an event selection
    self.btnAdd.hidden = YES;
    [self.sharedData.cAddEventDict removeAllObjects];
    
    [self goNew];
}


-(void)goNew
{
    [self getVenuesList];
    self.sharedData.morePageBtnBack.hidden = YES;
    //[self.sharedData trackMixPanel:@"create_hosting_tapped"];
    self.addEditShareBtn.hidden = YES;
    [self.addEditCon setContentOffset:CGPointMake(0, 0)];
    self.title.text = @"Choose Venue";
    //[self.datePicker setDate:[NSDate date]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormat setDateFormat:DATE_DISPLAY];
    NSString *dateWithNewFormat = [dateFormat stringFromDate:[NSDate date]];
    
    self.isInEditMode = NO;
    [self.addEditBtn setTitle:@"Save" forState:UIControlStateNormal];
    
    self.venueList.hidden = NO;
    self.btnAdd.hidden = YES;
    self.addEditTitleInput.text = dateWithNewFormat;
    
    //Enable dates
    self.addEditTitleInput.userInteractionEnabled = YES;
    self.addEditTitleInput.textColor = [UIColor blackColor];
    self.addEditTitleTwoInput.userInteractionEnabled = YES;
    self.addEditTitleTwoInput.textColor = [UIColor blackColor];
    self.addEditSubtitleTextView.text = MESSAGE_PLACEHOLDER;
    self.addEditSubtitleTextView.textColor = [UIColor lightGrayColor];
    
    //Enable venue picker
    self.addEditEditImg.hidden = NO;
    self.addEditInivisi.userInteractionEnabled = YES;
    
    //Action button
    self.btnAdd.hidden = YES;
    //self.addEditBtn.hidden = YES;
    
    //Clear out add event dictionary because we didnt come from an event selection
    //[self.sharedData.cAddEventDict removeAllObjects];
    
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.mainCon.frame = CGRectMake(-self.frame.size.width, 60, self.frame.size.width * 2, self.frame.size.height - 60);
     } completion:^(BOOL fin)
     {
         self.btnBack.hidden = NO;
     }];
}


-(void)goBack
{
    [self.addEditTitleInput resignFirstResponder];
    [self.addEditTitleTwoInput resignFirstResponder];
    [self.addEditSubtitleTextView resignFirstResponder];
    [self.venueList.searchBar resignFirstResponder];
    
    self.btnBack.hidden = YES;
    self.addEditBtn.hidden = YES;
    self.title.text = @"HOSTINGS";
    self.sharedData.morePageBtnBack.hidden = NO;
    
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.mainCon.frame = CGRectMake(0, 60, self.frame.size.width * 2, self.frame.size.height - 60);
     } completion:^(BOOL fin)
     {
         self.btnAdd.hidden = NO;
         self.venueList.hidden = YES;
     }];
}

-(void)goQuickBack
{
    [self.addEditTitleInput resignFirstResponder];
    [self.addEditTitleTwoInput resignFirstResponder];
    [self.addEditSubtitleTextView resignFirstResponder];
    [self.venueList.searchBar resignFirstResponder];
    
    self.btnBack.hidden = YES;
    self.addEditBtn.hidden = YES;
    self.title.text = @"HOSTINGS";
    self.sharedData.morePageBtnBack.hidden = NO;
    
    [UIView animateWithDuration:0 animations:^()
     {
         self.mainCon.frame = CGRectMake(0, 60, self.frame.size.width * 2, self.frame.size.height - 60);
     } completion:^(BOOL fin)
     {
         self.btnAdd.hidden = NO;
         self.venueList.hidden = YES;
     }];
}


-(void)getVenuesList
{
    [self.venueList initClass];
    /*
     AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
     [manager.requestSerializer setValue:self.sharedData.ph_token forHTTPHeaderField:@"ph_token"];
     [manager GET:@"https://api.partyhostapp.com/venues" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
     self.isVenuesListLoaded = YES;
     NSLog(@"VENUE_LIST");
     NSLog(@"%@",responseObject);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     NSLog(@"ERROR :: %@",error);
     }];
     */
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        //[self.addEditSubtitleTextView resignFirstResponder];
        return YES;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)aTextView
{
    [UIView animateWithDuration:0.25 animations:^()
     {
         [self.addEditCon setContentOffset:CGPointMake(0, 150)];
     }];
    
    return YES;
}

//Placeholder
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:MESSAGE_PLACEHOLDER]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

//Placeholder
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = MESSAGE_PLACEHOLDER;
        textView.textColor = [UIColor grayColor]; //optional
    }
    [textView resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"COMPARE :: %f :: %f",scrollView.contentOffset.y,self.contentOffSetYToCompare);
    
    if(scrollView.contentOffset.y < 50)
    {
        [self.addEditSubtitleTextView resignFirstResponder];
    }
    
    //CGPoint location = [scrollView.panGestureRecognizer locationInView:self.window.rootViewController.view];
}

-(void)deleteHosting:(NSString *)hostingId
{
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];

    NSString *url = [NSString stringWithFormat:@"%@/user/hostings/delete/%@",PHBaseURL,hostingId];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"DELETE_HOSTING :: %@",responseObject);
         
         [self.sharedData trackMixPanelWithDict:@"Delete Hosting" withDict:@{}];
         
         [self.sharedData trackMixPanelIncrementWithDict:@{@"delete_hosting":@1}];
         
         [self loadData];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR :: %@",error);
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error deleting hosting, please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
     }];
}

-(void)addHosting
{
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSDictionary *params;
    
    NSString *origin;
    
    NSString *url;
    if([self.sharedData.cAddEventDict count]==0)
    { //Check for existing event at this venue and warn user first
        //NSLog(@">>> ADDING NEW HOSTING TO VENUE and CREATE NEW EVENT");
        origin = @"MyHostings New Event";
        url = [NSString stringWithFormat:@"%@/user/hostings/event/add/%@",PHBaseURL,self.sharedData.fb_id];
        
        params = @{
                   @"venue_id" : [self.sharedData.venuesNameList[self.sharedData.cVenueListIndex] objectForKey:@"_id"],
                   @"start_datetime_str": [self.addEditTitleInput.text substringFromIndex:5],
                   @"end_datetime_str": [self.addEditTitleTwoInput.text substringFromIndex:5],
                   @"description": self.addEditSubtitleTextView.text
                   };
    }
    else
    { //This was picked from INVITE or HOST HERE, so dont check for conflicts
        //NSLog(@">>> ADDED NEW HOSTING TO EXISTING EVENT");
        url = [NSString stringWithFormat:@"%@/user/hostings/add/%@",PHBaseURL,self.sharedData.fb_id];
        origin = @"Browse Events";
        params = @{
                   @"event_id" : self.sharedData.cAddEventDict[@"_id"],
                   @"start_datetime_str": [self.addEditTitleInput.text substringFromIndex:5],
                   @"end_datetime_str": [self.addEditTitleTwoInput.text substringFromIndex:5],
                   @"description": self.addEditSubtitleTextView.text
                   };
    }
    
    
    NSLog(@"ADD_HOSTING_PARAMS :: %@",params);
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"ADD_HOSTING_RESPONSE :: %@",responseObject);
         
         if(![responseObject[@"success"] boolValue]) {
             if(responseObject[@"event"])
             { //Hosting conflict
                 [self.existingEventDict removeAllObjects];
                 [self.existingEventDict addEntriesFromDictionary:responseObject[@"event"]];
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hosting Conflict" message:@"Do you want to host at the existing event or change your dates?" delegate:self cancelButtonTitle:@"Change Dates" otherButtonTitles:@"Use Existing",nil];
                 alert.tag = 13;
                 alert.delegate = self;
                 [alert show];
                 return;
             }
             else
             { //Standard error
                 [[NSNotificationCenter defaultCenter]
                  postNotificationName:@"HIDE_LOADING"
                  object:self];
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Hosting" message:responseObject[@"reason"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
                 return;
             }
         }
         
         
         [self.sharedData trackMixPanelWithDict:@"Add Hosting" withDict:@{@"origin":origin}];
         
         [self.sharedData trackMixPanelIncrementWithDict:@{@"create_hosting":@1}];
         
         //[self.sharedData trackMixPanel:@"create_hosting_saved"];
         [self goBack];
         
         self.sharedData.cHostingIdFromInvite = responseObject[@"hosting"][@"_id"];
         
         if(self.sharedData.cameFromEventsTab == YES)
         {
             [self loadInvite];
             self.cameFromEvents = YES;
         }
         self.sharedData.cameFromEventsTab = NO;
         
         [self loadData];
         
         if(!self.cameFromEvents)
         {
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"REFRESH_EVENTS_FEED"
              object:nil];
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR_ADDING_HOSTING :: %@",operation.response);
         NSLog(@"error: %@",  operation.responseString);
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
     }];
}

-(void)addHostingToExistingEvent
{
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSDictionary *params = @{
                             @"event_id" : self.existingEventDict[@"_id"],
                             @"start_datetime_str": [self.addEditTitleInput.text substringFromIndex:5],
                             @"end_datetime_str": [self.addEditTitleTwoInput.text substringFromIndex:5],
                             @"description": self.addEditSubtitleTextView.text
                             };
    
    NSLog(@"ADD_EXISTING_HOSTING_PARAMS :: %@",params);
    
    NSString *url = [NSString stringWithFormat:@"%@/user/hostings/add/%@",PHBaseURL,self.sharedData.fb_id];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if(![responseObject[@"success"] boolValue]) {
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"HIDE_LOADING"
              object:self];
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Hosting" message:responseObject[@"reason"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
             return;
         }
         
         
         [self.sharedData trackMixPanelWithDict:@"Add Hosting" withDict:@{@"origin":@"MyHostings Admin Event"}];
         [self.sharedData trackMixPanelIncrementWithDict:@{@"create_hosting":@1}];
         
         NSLog(@"ADD_EXISTING_HOSTING_RESPONSE :: %@",responseObject);
         //[self.sharedData trackMixPanel:@"create_hosting_saved"];
         [self goBack];
         
         if(self.sharedData.cameFromEventsTab == YES)
         {
             [self loadInvite];
             self.cameFromEvents = YES;
         }
         self.sharedData.cameFromEventsTab = NO;
         [self loadData];
         
         /*
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"REFRESH_EVENTS_FEED"
          object:nil];
         */
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR_ADDING_EXISTING_HOSTING :: %@",operation.response);
         NSLog(@"error: %@",  operation.responseString);
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
     }];
}


-(void)loadInvite
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    [self goBack];
    [self performSelector:@selector(showLoadInivite) withObject:nil afterDelay:0.5];
    
}

-(void)showLoadInivite
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_EVENTS_TO_INVITE"
     object:self];
}


-(void)updateHosting
{
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];

    NSDictionary *dict = [self.hostingsA objectAtIndex:self.cEditId];
    NSDictionary *params = @{
                             @"hosting_id" : dict[@"_id"],
                             @"event_id" : dict[@"event"][@"_id"],
                             @"start_datetime_str": [self.addEditTitleInput.text substringFromIndex:5],
                             @"end_datetime_str": [self.addEditTitleTwoInput.text substringFromIndex:5],
                             @"description": self.addEditSubtitleTextView.text
                             };
    
    NSLog(@"EDIT_HOSTING_PARAMS :: %@",params);
    
    NSString *url = [NSString stringWithFormat:@"%@/user/hostings/update/%@",PHBaseURL,self.sharedData.fb_id];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"EDIT_HOSTING_RESPONSE :: %@",responseObject);
         
         if(![responseObject[@"success"] boolValue]) {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Hosting" message:responseObject[@"reason"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"HIDE_LOADING"
              object:self];
             return;
         }
         
         
         [self.sharedData trackMixPanelWithDict:@"Update Hosting" withDict:@{}];
         [self.sharedData trackMixPanelIncrementWithDict:@{@"update_hosting":@1}];
         
         //[self.sharedData trackMixPanel:@"edit_hosting_updated"];
         [self goBack];
         [self loadData];
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"REFRESH_EVENTS_FEED"
          object:nil];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR :: %@",error);
         NSLog(@"%@",operation.responseString);
         NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
         id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         
         if([operation.response statusCode] == 409)
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:json[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
             
             
         }
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
     }];
}

@end
