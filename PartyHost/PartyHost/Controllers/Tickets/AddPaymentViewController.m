//
//  AddPaymentViewController.m
//  Jiggie
//
//  Created by Setiady Wiguna on 3/10/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "AddPaymentViewController.h"

@interface AddPaymentViewController ()

@end

@implementation AddPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 28, 200, 24)];
    [titleLabel setText:@"ADD CREDIT CARD"];
    [titleLabel setTextColor:[UIColor phPurpleColor]];
    [titleLabel setFont:[UIFont phBlond:18]];
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
    [self.view addSubview:self.cardNumberTextField];
    
    UIView *line3View = [[UIView alloc] initWithFrame:CGRectMake(0, 70 + 50 + 50, self.visibleSize.width, 1)];
    [line3View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.view addSubview:line3View];
    
    self.dateTextField = [[UITextField alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(line3View.frame) + 10, 100 , 30)];
    [self.dateTextField setBackgroundColor:[UIColor clearColor]];
    [self.dateTextField setFont:[UIFont phBlond:13]];
    [self.dateTextField setKeyboardType:UIKeyboardTypePhonePad];
    [self.dateTextField setReturnKeyType:UIReturnKeyDone];
    [self.dateTextField setDelegate:self];
    [self.dateTextField setEnabled:NO];
    [self.dateTextField setText:@"MM/YYYY"];
    [self.view addSubview:self.dateTextField];
    
    UIView *lineVertical = [[UIView alloc] initWithFrame:CGRectMake(self.visibleSize.width/2, CGRectGetMaxY(line3View.frame) , 1, 50)];
    [lineVertical setBackgroundColor:[UIColor phLightGrayColor]];
    [self.view addSubview:lineVertical];
    
    self.cvvTextField = [[UITextField alloc] initWithFrame:CGRectMake(16 + 40 + 16, CGRectGetMaxY(line3View.frame) + 10, 100, 30)];
    [self.cvvTextField setBackgroundColor:[UIColor clearColor]];
    [self.cvvTextField setPlaceholder:@"CVV"];
    [self.cvvTextField setFont:[UIFont phBlond:13]];
    [self.cvvTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.cvvTextField setReturnKeyType:UIReturnKeyDone];
    [self.cvvTextField setDelegate:self];
    [self.view addSubview:self.cvvTextField];
    
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
    [self.saveButton setFrame:CGRectMake(0, self.visibleSize.height - 44 + 20, self.visibleSize.width, 44)];
    [self.saveButton setBackgroundColor:[UIColor colorFromHexCode:@"B6ECFF"]];
    [self.saveButton.titleLabel setFont:[UIFont phBold:15]];
    [self.saveButton setTitle:@"SAVE" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.saveButton setEnabled:NO];
    [self.view addSubview:self.saveButton];
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
    

}

@end
