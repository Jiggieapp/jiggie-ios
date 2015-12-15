//
//  BookTableAbout.m
//  PartyHost
//
//  Created by Tony Suriyathep on 7/17/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "BookTable.h"
#import "BookTableAbout.h"

@implementation BookTableAbout

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor phDarkBodyColor];
    
    self.sharedData = [SharedData sharedInstance];
    self.mainArray = [[NSMutableArray alloc] init];
    
    UIView *tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 60)];
    tabBar.backgroundColor = [UIColor clearColor];
    [self addSubview:tabBar];
    
    //Cancel button
    self.btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnCancel.frame = CGRectMake(8, 15, 80, 50);
    self.btnCancel.titleLabel.font = [UIFont phBold:14];
    self.btnCancel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.btnCancel setTitle:@"BACK" forState:UIControlStateNormal];
    [self.btnCancel setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btnCancel addTarget:self action:@selector(btnCancelClicked) forControlEvents:UIControlEventTouchUpInside];
    [tabBar addSubview:self.btnCancel];
    
    //Help button
    self.btnHelp = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnHelp.frame = CGRectMake(self.sharedData.screenWidth - 80 - 8, 15, 80, 50);
    self.btnHelp.titleLabel.font = [UIFont phBold:14];
    self.btnHelp.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.btnHelp setTitle:@"HELP" forState:UIControlStateNormal];
    [self.btnHelp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnHelp addTarget:self action:@selector(btnHelpClicked) forControlEvents:UIControlEventTouchUpInside];
    [tabBar addSubview:self.btnHelp];
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 76, self.sharedData.screenWidth, 40)];
    self.title.text = @"HOSTING DETAILS";
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.textColor = [UIColor whiteColor];
    self.title.font = [UIFont phBold:18];
    [self addSubview:self.title];
    
    self.subtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 105, self.sharedData.screenWidth, 40)];
    self.subtitle.text = @"Get your guests excited and describe your hosting";
    self.subtitle.textAlignment = NSTextAlignmentCenter;
    self.subtitle.adjustsFontSizeToFitWidth = YES;
    self.subtitle.textColor = [UIColor colorWithWhite:1 alpha:0.50];
    self.subtitle.font = [UIFont phBlond:13];
    [self addSubview:self.subtitle];
    
    self.separator = [[UIView alloc] initWithFrame:CGRectMake(0,self.subtitle.frame.origin.y + self.subtitle.frame.size.height + 16,self.sharedData.screenWidth,1)];
    self.separator.backgroundColor = [UIColor colorWithWhite:1 alpha:0.05];
    [self addSubview:self.separator];
    
    self.txtAbout = [[UITextView alloc] initWithFrame:CGRectMake(16,self.separator.frame.origin.y + 16, self.sharedData.screenWidth - 32,100)];
    self.txtAbout.backgroundColor = [UIColor phDarkBodyColor];
    self.txtAbout.text = @"";
    self.txtAbout.delegate = self;
    self.txtAbout.textAlignment = NSTextAlignmentLeft;
    self.txtAbout.textColor = [UIColor whiteColor];
    self.txtAbout.font = [UIFont phBlond:19];
    self.txtAbout.keyboardType = UIKeyboardTypeDefault;
    self.txtAbout.textContainerInset = UIEdgeInsetsMake(8, 16, 8, 16);
    [self addSubview:self.txtAbout];
    
    //Create big HOST HERE button
    self.btnContinue = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnContinue.frame = CGRectMake(0, self.sharedData.screenHeight - PHButtonHeight, self.sharedData.screenWidth, PHButtonHeight);
    self.btnContinue.titleLabel.font = [UIFont phBold:16];
    [self.btnContinue setTitleEdgeInsets:UIEdgeInsetsMake(3,0,0,0)];
    [self.btnContinue setTitle:@"CREATE HOSTING" forState:UIControlStateNormal];
    [self.btnContinue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnContinue setBackgroundColor:[UIColor phCyanColor]];
    [self.btnContinue addTarget:self action:@selector(btnContinueClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnContinue];
    
    //Resign first responder when tapped away
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAwayFromKeyboard)];
    [self addGestureRecognizer:tap];
    
    return self;
}

-(void)clickAwayFromKeyboard
{
    [self endEditing:YES];
}

-(void)reset {
    self.txtAbout.text = @"";
}

-(void)btnCancelClicked
{
    [self keyboardOff];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"GO_BOOKTABLE_OFFERING"
     object:self];
}

-(void)btnContinueClicked
{
    [self goComplete];
}

-(void)btnHelpClicked
{
    [self.sharedData.bookTable helpSMS];
}

-(void)initClass
{
    self.btnContinue.frame = CGRectMake(0, self.sharedData.screenHeight - PHButtonHeight, self.sharedData.screenWidth, PHButtonHeight);
    [self keyboardOn];
    
    NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
    [tmpDict addEntriesFromDictionary:self.sharedData.mixPanelCEventDict];
    //[tmpDict addEntriesFromDictionary:self.sharedData.bookTable.selectedTicket];
    
    [self.sharedData trackMixPanelWithDict:@"Add Hosting Details View" withDict:tmpDict];
}

-(void)exitHandler
{
    [self keyboardOff];
}

-(void)onKeyboardShow:(NSNotification *)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [keyboardFrameBegin CGRectValue];
    self.btnContinue.frame = CGRectMake(0, keyboardFrame.origin.y - PHButtonHeight, self.sharedData.screenWidth, PHButtonHeight);
    self.txtAbout.frame = CGRectMake(0,self.separator.frame.origin.y + 16, self.sharedData.screenWidth,keyboardFrame.origin.y - PHButtonHeight - 16 - self.separator.frame.origin.y - 16);
}

-(void)onKeyboardHide:(NSNotification *)notification
{
    self.txtAbout.frame = CGRectMake(0, self.separator.frame.origin.y + 16, self.sharedData.screenWidth, self.sharedData.screenHeight - self.separator.frame.origin.y - PHButtonHeight - 16);
    self.btnContinue.frame = CGRectMake(0, self.sharedData.screenHeight - PHButtonHeight, self.sharedData.screenWidth, PHButtonHeight);
}

-(void)keyboardOn
{
    //Remove keyboard observer
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillShowNotification
     object:nil];
    
    //Remove keyboard observer
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillHideNotification
     object:nil];
    
    //Add keyboard observer
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onKeyboardShow:)
     name:UIKeyboardWillShowNotification
     object:nil];
    
    //Add keyboard observer
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onKeyboardHide:)
     name:UIKeyboardWillHideNotification
     object:nil];
    
    [self.txtAbout becomeFirstResponder];
}

-(void)keyboardOff
{
    //Remove keyboard observer
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillShowNotification
     object:nil];
    
    //Remove keyboard observer
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillHideNotification
     object:nil];
    
    [self.txtAbout resignFirstResponder];
}

-(void)goComplete
{
    self.sharedData.bookTable.hostingDescription = [self.txtAbout.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //Check agreement checkmark
    if([self.sharedData.bookTable.hostingDescription length]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Details Required" message:@"Please get your guests excited and describe the details about you and your hosting." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
        [alert show];
        return;
    }
    
    [self saveHosting];
}

-(void)saveHosting
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSString *url = [Constants hostingsAddURL:self.sharedData.fb_id event_id:self.sharedData.eventDict[@"_id"]];
    
    NSDictionary *params = @{
                             @"description": self.sharedData.bookTable.hostingDescription,
                             @"offerings": [self.sharedData.bookTable.offeringArray componentsJoinedByString:@","]
                             };
    
    NSLog(@"HOSTING_ADD_PARAMS :: %@",params);
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"HOSTING_ADD_RESPONSE :: %@",responseObject);
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         if(![responseObject[@"success"] boolValue]) {
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Hosting" message:responseObject[@"reason"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             alert.tag = 1;
             [alert show];
             
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"HIDE_LOADING"
              object:self];
             
             return;
         }
         else {
             [self keyboardOff];
             
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"GO_BOOKTABLE_HOSTING_COMPLETE"
              object:self];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR :: %@",error);
         NSLog(@"%@",operation.responseString);
         NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
         id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         if([operation.response statusCode] == 409)
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:json[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             alert.tag = 0;
             [alert show];
         }
         else{
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unknown error." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             alert.tag = 0;
             [alert show];
         }
     }];
    
}

@end
