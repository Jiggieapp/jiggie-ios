//
//  CreditCard.m
//  PartyHost
//
//  Created by Tony Suriyathep on 7/29/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "More.h"
#import "CreditCard.h"

#define SCREEN_LEVELS 2

@implementation CreditCard
{
    NSArray *placeholderTexts;
    UIColor *placeholderColor;
}

- (id)initWithFrame:(CGRect)frame
{
    placeholderTexts = @[@"John Smith",@"1234 5678 9012 3456",@"MM/YYYY",@"CVV"];
    placeholderColor = [UIColor colorFromHexCode:@"282828"];
    
    self = [super initWithFrame:frame];
    self.layer.masksToBounds = YES;
    self.sharedData = [SharedData sharedInstance];
    
    self.mainCon = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.sharedData.screenWidth*SCREEN_LEVELS, self.sharedData.screenHeight)];
    self.mainCon.backgroundColor = [UIColor phDarkBodyColor];
    [self addSubview:self.mainCon];
    
    //Add complete screen
    self.creditCardComplete = [[CreditCardComplete alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth*1,0,self.sharedData.screenWidth,self.sharedData.screenHeight)];
    [self.mainCon addSubview:self.creditCardComplete];
    
    UIView *tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 60)];
    tabBar.backgroundColor = [UIColor phLightTitleColor];
    
    //Cancel button
    self.btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnCancel.frame = CGRectMake(8, 15, 80, 50);
    self.btnCancel.titleLabel.font = [UIFont phBold:14];
    self.btnCancel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.btnCancel setTitle:@"CANCEL" forState:UIControlStateNormal];
    [self.btnCancel setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.btnCancel addTarget:self action:@selector(btnCancelClicked) forControlEvents:UIControlEventTouchUpInside];
    [tabBar addSubview:self.btnCancel];
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.sharedData.screenWidth, 40)];
    self.title.text = @"ADD CARD";
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.textColor = [UIColor whiteColor];
    self.title.font = [UIFont phBold:18];
    [tabBar addSubview:self.title];
    
    UIView *separator1 = [[UIView alloc] initWithFrame:CGRectMake(0,tabBar.frame.origin.y-1,self.sharedData.screenWidth,1)];
    separator1.backgroundColor = [UIColor colorWithWhite:1 alpha:0.05];
    [tabBar addSubview:separator1];
    
    //Create list
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.title.frame.origin.y + self.title.frame.size.height, self.sharedData.screenWidth, self.sharedData.screenHeight - PHButtonHeight - (self.title.frame.origin.y + self.title.frame.size.height)) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor phDarkTitleColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor phDarkBodyInactiveColor];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.allowsSelection = YES;
    [self.mainCon addSubview:self.tableView];
    [self.mainCon addSubview:tabBar];
    
    //Create big HOST HERE button
    self.btnContinue = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnContinue.frame = CGRectMake(0, self.sharedData.screenHeight - PHButtonHeight, self.sharedData.screenWidth, PHButtonHeight);
    self.btnContinue.titleLabel.font = [UIFont phBold:18];
    self.btnContinue.userInteractionEnabled = YES;
    [self.btnContinue setTitleEdgeInsets:UIEdgeInsetsMake(3,0,0,0)];
    [self.btnContinue setTitle:@"CONTINUE" forState:UIControlStateNormal];
    [self.btnContinue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnContinue setBackgroundColor:[UIColor phCyanColor]];
    [self.btnContinue addTarget:self action:@selector(btnContinueClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.mainCon addSubview:self.btnContinue];
    
    //Resign first responder when tapped away
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAwayFromKeyboard)];
    [self addGestureRecognizer:tap];
    
    //Confirm screen
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(goToCreditCardComplete)
     name:@"GO_CREDIT_CARD_COMPLETE"
     object:nil];
    
    return self;
}

-(void)goToCreditCardComplete
{
    [self.creditCardComplete initClass];
    [UIView animateWithDuration:0.25 animations:^()
     {
         self.mainCon.frame = CGRectMake(-self.sharedData.screenWidth * 1, 0, self.sharedData.screenWidth * SCREEN_LEVELS, self.sharedData.screenHeight);
     } completion:^(BOOL finished)
     {
         [self.creditCardComplete.check1 buttonSelect:YES animated:YES];
     }];
}

-(void)clickAwayFromKeyboard
{
    [self endEditing:YES];
}

-(void)btnCancelClicked
{
    [self exitHandler];
}

-(void)btnContinueClicked
{
    [self endEditing:YES];
    [self sendRequest];
}

-(void)initClass
{
    self.fieldName.text = placeholderTexts[0];
    self.fieldName.textColor = placeholderColor;
    self.fieldNumber.text = placeholderTexts[1];
    self.fieldNumber.textColor = placeholderColor;
    self.fieldExpiry.text = placeholderTexts[2];
    self.fieldExpiry.textColor = placeholderColor;
    self.fieldCVV.text = placeholderTexts[3];
    self.fieldCVV.textColor = placeholderColor;
    
    [self.tableView setContentOffset:CGPointZero animated:NO];
    [self.tableView reloadData];
    [self endEditing:YES];
    self.hidden = NO;
    
    self.mainCon.frame = CGRectMake(0, self.sharedData.screenHeight, self.sharedData.screenWidth * SCREEN_LEVELS, self.sharedData.screenHeight);
    self.btnContinue.frame = CGRectMake(0, self.sharedData.screenHeight - PHButtonHeight, self.sharedData.screenWidth, PHButtonHeight);
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^
     {
         self.mainCon.frame = CGRectMake(0, 0, self.sharedData.screenWidth * SCREEN_LEVELS, self.sharedData.screenHeight);
     }
                     completion:^(BOOL finished)
     {
             [self keyboardOn];
     }];
    
    [self.sharedData trackMixPanelWithDict:@"Credit Card List" withDict:@{}];
}

-(void)exitHandler
{
    [self endEditing:YES];
    [self keyboardOff];
    [UIView animateWithDuration:0.15
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^
     {
         self.mainCon.frame = CGRectMake(self.mainCon.frame.origin.x, self.sharedData.screenHeight, self.sharedData.screenWidth * SCREEN_LEVELS, self.sharedData.screenHeight);
     }
                     completion:^(BOOL finished)
     {
         self.hidden = YES;
     }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuse = [NSString stringWithFormat:@"CreditCardCell"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    //if (cell == nil)
    //{
        if(indexPath.section==0)
        {
            if(indexPath.row==0)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
                cell.backgroundColor = [UIColor colorFromHexCode:@"141414"];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(14,12,self.sharedData.screenWidth-28,16)];
                title.font = [UIFont phBlond:12];
                title.textColor = [UIColor colorFromHexCode:@"5C5C5C"];
                title.text = @"Full Name";
                [cell addSubview:title];
                
                self.fieldName = [[UITextField alloc] initWithFrame:CGRectMake(title.frame.origin.x,title.frame.origin.y + title.frame.size.height + 4,title.frame.size.width,21)];
                self.fieldName.keyboardType = UIKeyboardTypeDefault;
                self.fieldName.delegate = self;
                self.fieldName.tag = 0;
                self.fieldName.font = [UIFont phBlond:19];
                self.fieldName.textColor = [UIColor whiteColor];
                self.fieldName.text = [NSString stringWithFormat:@"%@ %@",self.sharedData.userDict[@"first_name"],self.sharedData.userDict[@"last_name"]];
                
                self.fieldName.autocapitalizationType = UITextAutocapitalizationTypeWords;
                [cell addSubview:self.fieldName];
            }
            else if(indexPath.row==1)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
                cell.backgroundColor = [UIColor colorFromHexCode:@"141414"];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(14,12,self.sharedData.screenWidth-28,16)];
                title.font = [UIFont phBlond:12];
                title.textColor = [UIColor colorFromHexCode:@"5C5C5C"];
                title.text = @"Card Number";
                [cell addSubview:title];
                
                self.fieldNumber = [[UITextField alloc] initWithFrame:CGRectMake(title.frame.origin.x,title.frame.origin.y + title.frame.size.height + 4,title.frame.size.width,21)];
                self.fieldNumber.keyboardType = UIKeyboardTypeNumberPad;
                self.fieldNumber.delegate = self;
                self.fieldNumber.tag = 1;
                self.fieldNumber.font = [UIFont phBlond:19];
                self.fieldNumber.text = placeholderTexts[1];
                self.fieldNumber.textColor = placeholderColor;
                
                [cell addSubview:self.fieldNumber];
            }
            else if(indexPath.row==2)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
                cell.backgroundColor = [UIColor colorFromHexCode:@"141414"];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(14,12,self.sharedData.screenWidth-28,16)];
                title1.font = [UIFont phBlond:12];
                title1.textColor = [UIColor colorFromHexCode:@"5C5C5C"];
                title1.text = @"Expiration Date";
                [cell addSubview:title1];
                
                self.fieldExpiry = [[UITextField alloc] initWithFrame:CGRectMake(title1.frame.origin.x,title1.frame.origin.y + title1.frame.size.height + 4,title1.frame.size.width,21)];
                self.fieldExpiry.keyboardType = UIKeyboardTypeNumberPad;
                self.fieldExpiry.tag=2; //Row
                self.fieldExpiry.delegate = self;
                self.fieldExpiry.font = [UIFont phBlond:19];
                self.fieldExpiry.text = placeholderTexts[2];
                self.fieldExpiry.textColor = placeholderColor;
                [cell addSubview:self.fieldExpiry];
                
                UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth/2,12,self.sharedData.screenWidth-28,16)];
                title2.font = [UIFont phBlond:12];
                title2.textColor = [UIColor colorFromHexCode:@"5C5C5C"];
                title2.text = @"CVV";
                [cell addSubview:title2];
                
                self.fieldCVV = [[UITextField alloc] initWithFrame:CGRectMake(title2.frame.origin.x,title2.frame.origin.y + title2.frame.size.height + 4,title2.frame.size.width,21)];
                self.fieldCVV.font = [UIFont phBlond:19];
                self.fieldCVV.tag=3; //Row
                self.fieldCVV.delegate = self;
                self.fieldCVV.keyboardType = UIKeyboardTypeNumberPad;
                self.fieldCVV.text = placeholderTexts[3];
                self.fieldCVV.textColor = placeholderColor;
                [cell addSubview:self.fieldCVV];
            }
        }
    //}
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.sharedData.screenHeight * 0.75;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    /*
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"GO_BOOKTABLE_CONFIRM"
     object:self];
     */
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = [UIFont phBlond:12];
    header.backgroundView.backgroundColor = [UIColor phDarkTitleColor];
    [header.textLabel setTextColor:[UIColor colorFromHexCode:@"5C5C5C"]];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([textField.text isEqualToString:placeholderTexts[textField.tag]])
    {
        textField.text = @"";
        textField.textColor = [UIColor whiteColor];
    }
    
    [textField becomeFirstResponder];
    
    self.currentFirstResponder = textField;
    
    //Scroll to top
    if(self.sharedData.isIphone4) {
        int row = 0;
        if(textField == self.fieldName) row = 0;
        else if(textField == self.fieldNumber) row = 1;
        else if(textField == self.fieldCVV || textField == self.fieldExpiry) row = 2;
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    if([textField.text length]==0)
    {
        textField.text = placeholderTexts[textField.tag];
        textField.textColor = placeholderColor;
    }
    
    [textField resignFirstResponder];
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
    
    [self endEditing:YES];
}

-(void)onKeyboardShow:(NSNotification *)notification
{
    //NSLog(@">>> onKeyboardShow");
    
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [keyboardFrameBegin CGRectValue];
    
    CGFloat keyY = keyboardFrame.origin.y;
    if(keyY > self.sharedData.screenHeight) {keyY = self.sharedData.screenHeight;}
    self.btnContinue.frame = CGRectMake(0, keyY - PHButtonHeight, self.sharedData.screenWidth, PHButtonHeight);
}

-(void)onKeyboardHide:(NSNotification *)notification
{
    //NSLog(@">>> onKeyboardHide");
    
    [self.tableView setContentOffset:CGPointZero animated:YES];
    self.btnContinue.frame = CGRectMake(0, self.sharedData.screenHeight - PHButtonHeight, self.sharedData.screenWidth, PHButtonHeight);
}

NSMutableString *filteredCreditCardStringFromStringWithFilter(NSString *string, NSString *filter)
{
    NSUInteger onOriginal = 0, onFilter = 0, onOutput = 0;
    char outputString[([filter length])];
    BOOL done = NO;
    
    while(onFilter < [filter length] && !done)
    {
        char filterChar = [filter characterAtIndex:onFilter];
        char originalChar = onOriginal >= string.length ? '\0' : [string characterAtIndex:onOriginal];
        switch (filterChar) {
            case '#':
                if(originalChar=='\0')
                {
                    // We have no more input numbers for the filter.  We're done.
                    done = YES;
                    break;
                }
                if(isdigit(originalChar))
                {
                    outputString[onOutput] = originalChar;
                    onOriginal++;
                    onFilter++;
                    onOutput++;
                }
                else
                {
                    onOriginal++;
                }
                break;
            default:
                // Any other character will automatically be inserted for the user as they type (spaces, - etc..) or deleted as they delete if there are more numbers to come.
                outputString[onOutput] = filterChar;
                onOutput++;
                onFilter++;
                if(originalChar == filterChar)
                    onOriginal++;
                break;
        }
    }
    outputString[onOutput] = '\0'; // Cap the output string
    return [NSMutableString stringWithUTF8String:outputString];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *filter = nil;
    
    if(textField == self.fieldExpiry)
    {
        filter = @"##/####";
    }
    else if(textField == self.fieldCVV)
    {
        filter = @"####";
    }
    else if(textField == self.fieldNumber) //Check format of credit while u type
    {
        NSString *first4 = nil;
        NSString *first2 = nil;
        int first4Num = 0;
        int first2Num = 0;
        
        //Get first 4 numbers
        if ([self.fieldNumber.text length]>=4) {
            first4 = [self.fieldNumber.text substringToIndex:4];
            first4Num = [first4 intValue];
        }
        
        //Get first 2 numbers
        if ([self.fieldNumber.text length]>=2) {
            first2 = [self.fieldNumber.text substringToIndex:2];
            first2Num = [first2 intValue];
        }
        
        //http://cuinl.tripod.com/Tips/o-1.htm
        //https://en.wikipedia.org/wiki/Bank_card_number
        if (first4Num == 4111 || first4Num == 6011) { //TEST CARD and DISCOVER
            filter = @"####-####-####-####";
        }
        else if (first2Num == 37 || first2Num == 34) { //AMEX
            filter = @"####-######-#####";
        }
        else if (first2Num >= 51 && first2Num <= 55) { //MASTERCARD
            filter = @"####-####-####-####";
        }
        else if (first4Num >= 3528 && first4Num <= 3589) { //JCB
            filter = @"####-####-####-####";
        }
        else {
            filter = @"################";
        }
    }
    
    if(!filter) return YES; // No filter provided, allow anything
    
    NSString *changedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if(range.length == 1 && // Only do for single deletes
       string.length < range.length &&
       [[textField.text substringWithRange:range] rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]].location == NSNotFound)
    {
        // Something was deleted.  Delete past the previous number
        NSInteger location = changedString.length-1;
        if(location > 0)
        {
            for(; location > 0; location--)
            {
                if(isdigit([changedString characterAtIndex:location]))
                {
                    break;
                }
            }
            changedString = [changedString substringToIndex:location];
        }
    }
    
    textField.text = filteredCreditCardStringFromStringWithFilter(changedString, filter);
    return NO;
}

-(void)sendRequest
{
    NSString *cardNumber = self.fieldNumber.text;
    NSString *cardName = self.fieldName.text;
    NSString *cardExpiry = self.fieldExpiry.text;
    NSString *cardCVV = self.fieldCVV.text;
    
    //Remove formatter dashes
    cardNumber = [cardNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    //Do basic checks
    if([cardName length]<=3 || [cardName isEqualToString:placeholderTexts[0]])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Name" message:@"Double check the name on your credit card." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if([cardNumber length]<14 || [cardNumber isEqualToString:placeholderTexts[1]])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Number" message:@"Double check your credit card number." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if([cardExpiry length]<7 || [cardExpiry isEqualToString:placeholderTexts[2]])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Expiration" message:@"Double check the expiration on your credit card." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if([cardCVV length]<=2 || [cardCVV isEqualToString:placeholderTexts[3]])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid CVV" message:@"Double check the CVV on your credit card." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSString *url = [Constants userPaymentURL:self.sharedData.fb_id];
    
    NSDictionary *params = @{
                              @"card_number" : cardNumber,
                              @"card_name" : cardName,
                              @"card_date" : cardExpiry,
                              @"cvv" : cardCVV
                              };
    
    NSLog(@"USER_PAYMENT_URL :: %@",url);
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"USER_PAYMENT_RESPONSE :: %@",responseObject);
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         if(![responseObject[@"success"] boolValue]) {
             
             [self.sharedData trackMixPanelWithDict:@"Credit Card Add Fail" withDict:@{}];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Credit Card Invalid" message:responseObject[@"reason"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             alert.tag = 1;
             [alert show];
             
             return;
         }
         else {
             [self.sharedData trackMixPanelWithDict:@"Credit Card Add Success" withDict:@{}];
             
             self.sharedData.ccLast4 = responseObject[@"data"][@"creditCard"][@"last4"];
             self.sharedData.ccName = responseObject[@"data"][@"creditCard"][@"cardholderName"];
             self.sharedData.ccType = responseObject[@"data"][@"creditCard"][@"cardType"];
             
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"GO_CREDIT_CARD_COMPLETE"
              object:self];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"USER_PAYMENT_ERROR :: %@",error);
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
     }];
    
}

@end

