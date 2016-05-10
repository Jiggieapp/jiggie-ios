//
//  PromotionsViewController.m
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 5/10/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "PromotionsViewController.h"

@interface PromotionsViewController ()

@end

@implementation PromotionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View
- (void)setupView {
    self.title = @"Promotions";
    
    CGFloat cornerRadius = 4.f;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(.0f, .0f, 60, 60)];
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"promo_code_icon"]];
    [iconImageView setContentMode:UIViewContentModeScaleAspectFit];
    [leftView addSubview:iconImageView];
    [iconImageView setCenter:leftView.center];
    
    [self.promoCodeField setLeftView:leftView];
    [self.promoCodeField setLeftViewMode:UITextFieldViewModeAlways];
    self.promoCodeField.layer.cornerRadius = cornerRadius;
    self.promoCodeField.layer.borderWidth = 1.f;
    self.promoCodeField.layer.borderColor = [UIColor phGrayColor].CGColor;
    
    self.applyCodeButton.layer.cornerRadius = cornerRadius;
    
    [self.inviteFriendsButton setTitleColor:[UIColor phBlueColor] forState:UIControlStateNormal];
    self.inviteFriendsButton.layer.cornerRadius = cornerRadius;
    self.inviteFriendsButton.backgroundColor = [UIColor whiteColor];
    self.inviteFriendsButton.layer.borderColor = [UIColor phBlueColor].CGColor;
    self.inviteFriendsButton.layer.borderWidth = 2.f;
}

#pragma mark - Action
- (IBAction)didTapApplyButton:(id)sender {
}

- (IBAction)didTapInviteFriendsButton:(id)sender {
}

@end
