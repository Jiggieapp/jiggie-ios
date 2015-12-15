//
//  EventsHostMessage.m
//  PartyHost
//
//  Created by Tony Suriyathep on 8/1/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "Events.h"
#import "EventsHostDetail.h"
#import "EventsHostMessage.h"

@implementation EventsHostMessage
{
    NSString *placeholderText;
    NSString *defaultText;
    UIColor *placeholderColor;
}

-(void)awakeFromNib
{
    self.sharedData = [SharedData sharedInstance];

    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    
    NSString *hostName = self.sharedData.selectedHost[@"first_name"];
    placeholderText = [NSString stringWithFormat:@"Message %@ and arrange the details …",[hostName capitalizedString]];
    placeholderColor = [UIColor colorFromHexCode:@"BDBDBD"];
    
    self.messageText.text = @"I'm interested.";
    [self.messageText setTextContainerInset:UIEdgeInsetsMake(20, 16, 20, 16)];
    self.messageText.delegate = self;
    self.messageText.textColor = [UIColor blackColor];
    
    self.userName.text = [hostName uppercaseString];
    self.venueName.text = [self.sharedData.eventDict[@"title"] uppercaseString];
    self.eventDate.text = [[Constants toTitleDateRange:self.sharedData.eventDict[@"start_datetime_str"] dbEndDateString:self.sharedData.eventDict[@"end_datetime_str"]] uppercaseString];
    
    [self performSelector:@selector(initClass) withObject:nil afterDelay:0.50];
}

-(void)initClass {
    
    //Resign first responder when tapped away
    self.tapAway = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAwayFromKeyboard)];
    [self.sharedData.popupView addGestureRecognizer:self.tapAway];
    
    [self keyboardOn];
    [self.messageText becomeFirstResponder];
}

-(void)clickAwayFromKeyboard
{
    [self endEditing:YES];
}

- (IBAction)cancelClicked:(id)sender {
    [self keyboardOff];
    [self.messageText resignFirstResponder];
    [self.sharedData.popupView removeGestureRecognizer:self.tapAway];
    [self.sharedData.popupView popout:YES];
}

- (IBAction)sendClicked:(id)sender {
    [self.messageText resignFirstResponder];
    
    NSString *msg = [self.messageText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([msg length]<=1 || [msg isEqualToString:placeholderText])
    {
        [self keyboardOff];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Host Message" message:@"Please enter a message for this host." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag = 1;
        [alert show];
        return;
    }
    else
    {
        [self sendMessage];
    }
}

-(void)onKeyboardShow:(NSNotification *)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [keyboardFrameBegin CGRectValue];
    
    int w = self.sharedData.screenWidth * 0.85;
    self.frame = CGRectMake(self.sharedData.screenWidth/2 - w/2,  16, w, keyboardFrame.origin.y-32);
}

-(void)onKeyboardHide:(NSNotification *)notification
{
    [self.sharedData.popupView resetFrame];
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
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:placeholderText])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    //[textView becomeFirstResponder];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if([textView.text length]==0)
    {
        textView.text = placeholderText;
        textView.textColor = placeholderColor;
    }
    
    //[textView resignFirstResponder];
}

-(void)sendMessage
{
    //Start spinner
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSDictionary *params = @{
                             @"message" : self.messageText.text,
                             @"from_fb_id" : self.sharedData.fb_id,
                             @"event_id": self.sharedData.selectedHost[@"hosting"][@"event_id"]
                             };
    
    NSLog(@"EVENTHOSTDETAIL_FORCEACCEPT Params :: %@",params);
    
    NSString *url = [NSString stringWithFormat:@"%@/user/hostings/forceaccepted/%@/%@",PHBaseURL,self.sharedData.selectedHost[@"fb_id"],self.sharedData.selectedHost[@"hosting"][@"_id"]];
    
    NSLog(@"EVENTHOSTMESSAGE_FORCEACCEPT URL :: %@",url);
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"EVENTHOSTMESSAGE_FORCEACCEPT SAVE responseObject :: %@",responseObject);
         
         //Hide spinner
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         if(responseObject[@"success"])
         {
             if(![responseObject[@"success"] boolValue])
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Connection"
                                                                 message:@"Please try again in a few minutes."
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                 alert.tag = 0;
                 [alert show];
                 
                 return;
             }
         }
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"REFRESH_HOST_LISTINGS"
          object:self];
         
         //Must set these now
         self.sharedData.eventsPage.eventsHostDetail.isAccepted = YES;
         [self.sharedData.eventsPage.eventsHostDetail.button1 setTitle:@"CHAT" forState:UIControlStateNormal];
         
         //Mix panel
         [self.sharedData trackMixPanelWithDict:@"Accept Invite" withDict:@{@"origin":@"Host Details"}];
         [self.sharedData trackMixPanelIncrementWithDict:@{@"send_message":@1}];
         [self.sharedData trackMixPanelIncrementWithDict:@{@"contact_host":@1}];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your message was sent to the host. Share hosting with friends for a quicker response." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
         alert.tag = 0;
         [alert show];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"EVENTHOSTMESSAGE_FORCEACCEPT ERROR :: %@",error);
         
         //Hide spinner
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         //Alert error!
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Connection"
                                                         message:@"Accept could not be set. Please try again."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
         alert.tag = 0;
         [alert show];
     }];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 0)
    {
        [self cancelClicked:nil];
    }
    else if(alertView.tag == 1)
    {
        [self performSelector:@selector(getFocusBack) withObject:nil afterDelay:0.25];
    }
}

-(void)getFocusBack {
    [self keyboardOn];
    [self.messageText becomeFirstResponder];
}

@end
