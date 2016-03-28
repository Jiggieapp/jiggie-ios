//
//  AddPaymentViewController.m
//  Jiggie
//
//  Created by Setiady Wiguna on 3/10/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "AddPaymentViewController.h"
#import "VTConfig.h"
#import "VTDirect.h"
#import "NTMonthYearPicker.h"
#import "SVProgressHUD.h"

@interface AddPaymentViewController () {
    NSString *previousTextFieldContent;
    UITextRange *previousSelection;
    
    NTMonthYearPicker *picker;
}

@end

@implementation AddPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 28, 200, 24)];
    [titleLabel setText:@"ADD CREDIT CARD"];
    [titleLabel setTextColor:[UIColor phPurpleColor]];
    [titleLabel setFont:[UIFont phBlond:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:titleLabel];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CGRectMake(self.visibleSize.width - 80, 28, 60, 26)];
    [cancelButton setTitle:@"CANCEL" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [[cancelButton titleLabel] setFont:[UIFont phBlond:12]];
    [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:cancelButton];
    
    UIView *line1View = [[UIView alloc] initWithFrame:CGRectMake(0, 70, self.visibleSize.width, 1)];
    [line1View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.view addSubview:line1View];
    
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(line1View.frame) + 10, self.visibleSize.width - 32, 30)];
    [self.nameTextField setBackgroundColor:[UIColor clearColor]];
    [self.nameTextField setPlaceholder:@"Card holder name"];
    [self.nameTextField setFont:[UIFont phBlond:13]];
    [self.nameTextField setReturnKeyType:UIReturnKeyNext];
    [self.nameTextField setDelegate:self];
    [self.view addSubview:self.nameTextField];
    
    UIView *line2View = [[UIView alloc] initWithFrame:CGRectMake(0, 70 + 50, self.visibleSize.width, 1)];
    [line2View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.view addSubview:line2View];
    
    self.cardNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(line2View.frame) + 10, self.visibleSize.width - 32, 30)];
    [self.cardNumberTextField setBackgroundColor:[UIColor clearColor]];
    [self.cardNumberTextField setPlaceholder:@"Credit card number"];
    [self.cardNumberTextField setFont:[UIFont phBlond:13]];
    [self.cardNumberTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.cardNumberTextField setReturnKeyType:UIReturnKeyDone];
    [self.cardNumberTextField setDelegate:self];
    [self.cardNumberTextField addTarget:self action:@selector(reformatAsCardNumber:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.cardNumberTextField];
    
    UIToolbar *nextToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.visibleSize.width, 50)];
    nextToolbar.barStyle = UIBarStyleDefault;
    nextToolbar.items = @[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                          [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(nextWithNumberPad)]];
    [nextToolbar sizeToFit];
    self.cardNumberTextField.inputAccessoryView = nextToolbar;
    
    self.cardNumberAlert = [[UIImageView alloc] initWithFrame:CGRectMake(self.visibleSize.width - 36, CGRectGetMaxY(line2View.frame) + 14, 20, 20)];
    [self.cardNumberAlert setImage:[UIImage imageNamed:@"icon_alert"]];
    [self.cardNumberAlert setBackgroundColor:[UIColor clearColor]];
    [self.cardNumberAlert setHidden:YES];
    [self.view addSubview:self.cardNumberAlert];
    
    UIView *line3View = [[UIView alloc] initWithFrame:CGRectMake(0, 70 + 50 + 50, self.visibleSize.width, 1)];
    [line3View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.view addSubview:line3View];
    
    self.dateTextField = [[UITextField alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(line3View.frame) + 10, 100 , 30)];
    [self.dateTextField setBackgroundColor:[UIColor clearColor]];
    [self.dateTextField setFont:[UIFont phBlond:13]];
    [self.dateTextField setKeyboardType:UIKeyboardTypePhonePad];
    [self.dateTextField setReturnKeyType:UIReturnKeyDone];
    [self.dateTextField setDelegate:self];
    [self.dateTextField setPlaceholder:@"MM/YYYY"];
    [self.view addSubview:self.dateTextField];
    
    UIView *lineVertical = [[UIView alloc] initWithFrame:CGRectMake(self.visibleSize.width/2, CGRectGetMaxY(line3View.frame) , 1, 50)];
    [lineVertical setBackgroundColor:[UIColor phLightGrayColor]];
    [self.view addSubview:lineVertical];
    
    self.cvvTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.visibleSize.width/2 + 16, CGRectGetMaxY(line3View.frame) + 10, 100, 30)];
    [self.cvvTextField setBackgroundColor:[UIColor clearColor]];
    [self.cvvTextField setPlaceholder:@"CVV"];
    [self.cvvTextField setFont:[UIFont phBlond:13]];
    [self.cvvTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.cvvTextField setReturnKeyType:UIReturnKeyDone];
    [self.cvvTextField setDelegate:self];
    [self.cvvTextField setSecureTextEntry:YES];
    [self.view addSubview:self.cvvTextField];
    
    self.cvvAlert = [[UIImageView alloc] initWithFrame:CGRectMake(self.visibleSize.width - 36, CGRectGetMaxY(line3View.frame) + 14, 20, 20)];
    [self.cvvAlert setImage:[UIImage imageNamed:@"icon_alert"]];
    [self.cvvAlert setBackgroundColor:[UIColor clearColor]];
    [self.cvvAlert setHidden:YES];
    [self.view addSubview:self.cvvAlert];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.visibleSize.width, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    self.cvvTextField.inputAccessoryView = numberToolbar;
    
    UIView *line4View = [[UIView alloc] initWithFrame:CGRectMake(0, 70 + 50 + 50 + 50, self.visibleSize.width, 1)];
    [line4View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.view addSubview:line4View];
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveButton addTarget:self action:@selector(saveButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton setFrame:CGRectMake(0, self.view.bounds.size.height - 44, self.visibleSize.width, 44)];
    [self.saveButton setBackgroundColor:[UIColor colorFromHexCode:@"B6ECFF"]];
    [self.saveButton.titleLabel setFont:[UIFont phBold:15]];
    [self.saveButton setTitle:@"SAVE" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.saveButton setEnabled:YES];
    [self.view addSubview:self.saveButton];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:5];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
    
    // Initialize the picker
    picker = [[NTMonthYearPicker alloc] init];
    picker.datePickerMode = NTMonthYearPickerModeMonthAndYear;
    [picker setMinimumDate:[NSDate date]];
    [picker setMaximumDate:newDate];
    [picker setBackgroundColor:[UIColor whiteColor]];
    [picker addTarget:self action:@selector(onDatePicked:) forControlEvents:UIControlEventValueChanged];
    
    CGSize pickerSize = [picker sizeThatFits:CGSizeZero];
    picker.frame = CGRectMake(0, self.view.bounds.size.height - pickerSize.height, pickerSize.width, pickerSize.height);
    [picker setAlpha:0.0];
    [self.view addSubview:picker];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.visibleSize.width, 44)];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                      style:UIBarButtonItemStyleDone target:self action:@selector(doneDateFromToolbar)];
    toolBar.items = @[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      barButtonDone];
    [picker addSubview:toolBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (void)cancelButtonDidTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveButtonDidTap:(id)sender {
    NSString *cardNumber = [self.cardNumberTextField.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    BOOL isValid = YES;
    if (cardNumber.length < 16) {
        [self.cardNumberTextField setTextColor:[UIColor redColor]];
        [self.cardNumberAlert setHidden:NO];
        isValid = NO;
    } else if (self.cvvTextField.text.length < 3) {
        [self.cvvTextField setTextColor:[UIColor redColor]];
        [self.cvvAlert setHidden:NO];
        isValid = NO;
    }
    
    if (!isValid) {
        return;
    }
    
    VTDirect *vtDirect = [[VTDirect alloc] init];

    VTCardDetails *cardDetails = [[VTCardDetails alloc] init];
    
    @try {
        NSArray *dateArr = [self.dateTextField.text componentsSeparatedByString:@"/"];
        
        cardDetails.card_number = cardNumber;
        cardDetails.card_cvv = self.cvvTextField.text;
        cardDetails.card_exp_month = [dateArr objectAtIndex:0];
        cardDetails.card_exp_year = [[dateArr objectAtIndex:1] integerValue];
        cardDetails.gross_amount = @"10000";
        cardDetails.secure = YES;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
//    cardDetails.card_number = @"4811111111111114";
//    cardDetails.card_cvv = @"123";
//    cardDetails.card_exp_month = @"01";
//    cardDetails.card_exp_year = 2020;
//    cardDetails.gross_amount = @"10000";
//    cardDetails.secure = YES;
    
    vtDirect.card_details = cardDetails;

    [SVProgressHUD show];
    [vtDirect getToken:^(VTToken *token, NSException *exception) {
        [SVProgressHUD dismiss];
        
        NSData *newToken = (NSData *)token;
        
        NSError *error;
        NSDictionary *json = (NSDictionary *)[NSJSONSerialization
                                              JSONObjectWithData:newToken
                                              options:kNilOptions
                                              error:&error];
        if(exception == nil){
            if ([[json objectForKey:@"status_code"] isEqualToString:@"200"]) {
                NSDictionary *cardDetail = @{@"card_number":cardDetails.card_number,
                                             @"card_cvv":cardDetails.card_cvv,
                                             @"card_exp_month":cardDetails.card_exp_month,
                                             @"card_exp_year":[NSNumber numberWithInteger:cardDetails.card_exp_year],
                                             @"gross_amount":cardDetails.gross_amount,
                                             @"name_cc":self.nameTextField.text};
                
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                [prefs setObject:cardDetail forKey:@"temp_da"];
                [prefs synchronize];
                
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self.cardNumberTextField setTextColor:[UIColor redColor]];
                [self.cardNumberAlert setHidden:NO];
            }
        } else {
            NSLog(@"Reason: %@",exception.reason);
            
            [self.cardNumberTextField setTextColor:[UIColor redColor]];
            [self.cardNumberAlert setHidden:NO];
        }
    }];
}

- (void)doneWithNumberPad {
    [self.cvvTextField resignFirstResponder];
}

- (void)nextWithNumberPad {
    [self.dateTextField becomeFirstResponder];
}

- (void)doneDateFromToolbar {
    [UIView animateWithDuration:0.25 animations:^()
     {
         [picker setAlpha:0.0];
     } completion:^(BOOL finished){
         
     }];
}

- (void)onDatePicked:(UITapGestureRecognizer *)gestureRecognizer {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/yyyy"];
    
    NSString *dateStr = [df stringFromDate:picker.date];
    self.dateTextField.text = dateStr;
}

#pragma mark - Validate
- (void)checkButtonActivate {
    if (self.nameTextField.text.length > 0 && self.cardNumberTextField.text.length > 0 && self.dateTextField.text.length > 0 && self.cvvTextField.text.length > 0) {
        [self.saveButton setEnabled:YES];
        [self.saveButton setBackgroundColor:[UIColor phBlueColor]];
    } else {
        [self.saveButton setEnabled:NO];
        [self.saveButton setBackgroundColor:[UIColor colorFromHexCode:@"B6ECFF"]];
    }
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([webView.request.URL.absoluteString rangeOfString:@"callback"].location == NSNotFound) {
        [webView removeFromSuperview];
        NSLog(@"SUCCESS!!");
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.dateTextField) {
        [self.nameTextField resignFirstResponder];
        [self.cvvTextField resignFirstResponder];
        [self.cardNumberTextField resignFirstResponder];
        
        [UIView animateWithDuration:0.25 animations:^()
         {
             [picker setAlpha:1.0];
         } completion:^(BOOL finished){
             
         }];
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self checkButtonActivate];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.nameTextField]) {
        [self.cardNumberTextField becomeFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.cardNumberTextField) {
        previousTextFieldContent = textField.text;
        previousSelection = textField.selectedTextRange;
        
        [self.cardNumberTextField setTextColor:[UIColor blackColor]];
        [self.cardNumberAlert setHidden:YES];
        
    } else if (textField == self.cvvTextField) {
        [self.cvvTextField setTextColor:[UIColor blackColor]];
        [self.cvvAlert setHidden:YES];
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 3) ? NO : YES;
    }
    return YES;
}

- (void)reformatAsCardNumber:(UITextField *)textField
{
    // In order to make the cursor end up positioned correctly, we need to
    // explicitly reposition it after we inject spaces into the text.
    // targetCursorPosition keeps track of where the cursor needs to end up as
    // we modify the string, and at the end we set the cursor position to it.
    NSUInteger targetCursorPosition =
    [textField offsetFromPosition:textField.beginningOfDocument
                       toPosition:textField.selectedTextRange.start];
    
    NSString *cardNumberWithoutSpaces =
    [self removeNonDigits:textField.text
andPreserveCursorPosition:&targetCursorPosition];
    
    if ([cardNumberWithoutSpaces length] > 16) {
        // If the user is trying to enter more than 19 digits, we prevent
        // their change, leaving the text field in  its previous state.
        // While 16 digits is usual, credit card numbers have a hard
        // maximum of 19 digits defined by ISO standard 7812-1 in section
        // 3.8 and elsewhere. Applying this hard maximum here rather than
        // a maximum of 16 ensures that users with unusual card numbers
        // will still be able to enter their card number even if the
        // resultant formatting is odd.
        [textField setText:previousTextFieldContent];
        textField.selectedTextRange = previousSelection;
        return;
    }
    
    NSString *cardNumberWithSpaces =
    [self insertSpacesEveryFourDigitsIntoString:cardNumberWithoutSpaces
                      andPreserveCursorPosition:&targetCursorPosition];
    
    textField.text = cardNumberWithSpaces;
    UITextPosition *targetPosition =
    [textField positionFromPosition:[textField beginningOfDocument]
                             offset:targetCursorPosition];
    
    [textField setSelectedTextRange:
     [textField textRangeFromPosition:targetPosition
                           toPosition:targetPosition]
     ];
}

- (NSString *)removeNonDigits:(NSString *)string
    andPreserveCursorPosition:(NSUInteger *)cursorPosition
{
    NSUInteger originalCursorPosition = *cursorPosition;
    NSMutableString *digitsOnlyString = [NSMutableString new];
    for (NSUInteger i=0; i<[string length]; i++) {
        unichar characterToAdd = [string characterAtIndex:i];
        if (isdigit(characterToAdd)) {
            NSString *stringToAdd =
            [NSString stringWithCharacters:&characterToAdd
                                    length:1];
            
            [digitsOnlyString appendString:stringToAdd];
        }
        else {
            if (i < originalCursorPosition) {
                (*cursorPosition)--;
            }
        }
    }
    
    return digitsOnlyString;
}

- (NSString *)insertSpacesEveryFourDigitsIntoString:(NSString *)string
                          andPreserveCursorPosition:(NSUInteger *)cursorPosition
{
    NSMutableString *stringWithAddedSpaces = [NSMutableString new];
    NSUInteger cursorPositionInSpacelessString = *cursorPosition;
    for (NSUInteger i=0; i<[string length]; i++) {
        if ((i>0) && ((i % 4) == 0)) {
            [stringWithAddedSpaces appendString:@"-"];
            if (i < cursorPositionInSpacelessString) {
                (*cursorPosition)++;
            }
        }
        unichar characterToAdd = [string characterAtIndex:i];
        NSString *stringToAdd =
        [NSString stringWithCharacters:&characterToAdd length:1];
        
        [stringWithAddedSpaces appendString:stringToAdd];
    }
    
    return stringWithAddedSpaces;
}

@end
