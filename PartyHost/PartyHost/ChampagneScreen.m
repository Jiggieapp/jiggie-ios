//
//  ReviewScreen.m
//  PartyHost
//
//  Created by Tony Suriyathep on 5/12/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "ChampagneScreen.h"

@implementation ChampagneScreen

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.sharedData = [SharedData sharedInstance];
    
    self.mainCon = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.sharedData.screenWidth, self.sharedData.screenHeight)];
    self.mainCon.backgroundColor = [UIColor phDarkBodyColor];
    [self addSubview:self.mainCon];
    
    UIView *tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 60)];
    tabBar.backgroundColor = [UIColor phLightTitleColor];
    [self.mainCon addSubview:tabBar];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.sharedData.screenWidth, 40)];
    title.text = @"Book & Host Table?";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont phBold:21];
    [tabBar addSubview:title];
    
    //Cancel button
    self.btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnCancel.frame = CGRectMake(self.sharedData.screenWidth - 50 + 4, 12, 50, 50);
    [self.btnCancel setBackgroundImage:[UIImage imageNamed:@"nav_cancel"] forState:UIControlStateNormal];
    [self.btnCancel addTarget:self action:@selector(btnCancelClicked) forControlEvents:UIControlEventTouchUpInside];
    [tabBar addSubview:self.btnCancel];
    
    /*
    self.btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnCancel.frame = CGRectMake(self.sharedData.screenWidth - 80 - 8, 15, 80, 50);
    self.btnCancel.titleLabel.font = [UIFont phBlond:18];
    self.btnCancel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnCancel addTarget:self action:@selector(btnCancelClicked) forControlEvents:UIControlEventTouchUpInside];
    [tabBar addSubview:self.btnCancel];
    */
    
    //This view will have the contents of the bottle icon and text, it will be centered vertically
    UIView *centerView = [[UIView alloc] init];
    //centerView.backgroundColor = [UIColor redColor];
    [self.mainCon addSubview:centerView];
    
    //Some text
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 60)];
    line1.text = @"You will need a VIP table\nto host this event";
    line1.textAlignment = NSTextAlignmentCenter;
    line1.textColor = [UIColor darkGrayColor];
    line1.font = [UIFont phBlond:20];
    line1.numberOfLines = 2;
    [centerView addSubview:line1];
    
    //Champagne image
    UIImageView *champagneImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,line1.frame.origin.y + line1.frame.size.height + 20,self.sharedData.screenWidth,100)];
    champagneImage.contentMode = UIViewContentModeScaleAspectFit;
    champagneImage.image = [UIImage imageNamed:@"icon_bottle"];
    //champagneImage.image = [champagneImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //champagneImage.tintColor = [UIColor darkGrayColor];
    [centerView addSubview:champagneImage];
    
    //Some text
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, champagneImage.frame.origin.y + champagneImage.frame.size.height + 16, self.sharedData.screenWidth, 60)];
    line2.text = @"Would you like to get a table?";
    line2.textAlignment = NSTextAlignmentCenter;
    line2.textColor = [UIColor darkGrayColor];
    line2.font = [UIFont phBlond:20];
    line2.numberOfLines = 2;
    [centerView addSubview:line2];
    
    //Create last button
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, self.sharedData.screenHeight-44, self.sharedData.screenWidth, 44)];
    [button1 setTitle:@"No, Continue Add Hosting" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    button1.backgroundColor = [UIColor colorWithWhite:1 alpha:0.15];
    [button1 addTarget:self action:@selector(btnNoClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.mainCon addSubview:button1];
    
    //Create first button
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, button1.frame.origin.y - 64, self.sharedData.screenWidth, 64)];
    [button2 setTitle:@"Yes, Email me a Quote" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button2.backgroundColor = [UIColor phPurpleColor];
    [button2 addTarget:self action:@selector(btnYesClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.mainCon addSubview:button2];
    
    int centerViewHeight = 60+100+20+60;
    int bottomButtonsHeight = button1.frame.size.height + 8 + button2.frame.size.height +8;
    int spaceVertical = self.sharedData.screenHeight - bottomButtonsHeight - 60;
    centerView.frame = CGRectMake(0, 60 + (spaceVertical/2) - (centerViewHeight/2), self.sharedData.screenWidth, centerViewHeight);
    
    return self;
}


-(void)btnYesClicked
{
    //Mixpanel
    //[self.sharedData trackMixPanel:@"quote_requested"];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *url = [NSString stringWithFormat:@"%@/quote/%@/%@",self.sharedData.baseHerokuAPIURL,self.sharedData.cEventId_toLoad,self.sharedData.fb_id];
    
    NSLog(@"QUOTE_URL :: %@",url);
    
    [manager GET:url parameters:NULL success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"QUOTE_RESPONSE :: %@",responseObject);
         
         if(![responseObject[@"success"] boolValue]) {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Hosting" message:responseObject[@"reason"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
             return;
         }
         
         //When they click YES show a message
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Quote Request" message:@"We are processing your quote request. In the meantime you may continue with your hosting creation." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
         
         [self.sharedData trackMixPanelWithDict:@"Tap Email Quote" withDict:@{}];
         
         [self.sharedData trackMixPanelIncrementWithDict:@{@"quote_request":@1}];
         
         [self exitHandler];
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         //Call with delay
         [self performSelector:@selector(createHosting) withObject:self afterDelay:0.20];
         
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
         
         [self exitHandler];
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
     }];
}

-(void)btnNoClicked
{
    [self exitHandler];
    
    //Call with delay
    [self performSelector:@selector(createHosting) withObject:self afterDelay:0.20];
}

-(void)btnCancelClicked
{
    [self exitHandler];
}

-(void)initClass
{
    self.hidden = NO;
    
    self.mainCon.alpha = 0;
    self.mainCon.transform = CGAffineTransformMakeScale(.75, .75);
    self.mainCon.hidden = NO;
    
    [UIView animateWithDuration:0.15
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^
     {
         self.mainCon.alpha = 1;
         self.mainCon.transform = CGAffineTransformMakeScale(1, 1);
     }
                     completion:^(BOOL finished)
     {
         
     }];
}

-(void)exitHandler
{
    //self.hidden = YES;
    
     //This is too slow??
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^
     {
         self.mainCon.alpha = .25;
         self.mainCon.transform = CGAffineTransformMakeScale(.75, .75);
     }
                     completion:^(BOOL finished)
     {
         self.hidden = YES;
     }];
}


//This needed a delay because it was too slow?
-(void)createHosting
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"CREATE_HOSTING"
     object:self];
}

@end



