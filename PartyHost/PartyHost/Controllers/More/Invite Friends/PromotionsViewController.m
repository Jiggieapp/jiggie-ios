//
//  PromotionsViewController.m
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 5/10/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "PromotionsViewController.h"
#import "SuccessPromotionsView.h"
#import "InviteFriendsViewController.h"
#import "UIView+Animation.h"

@interface PromotionsViewController () <UITextFieldDelegate, SuccessPromotionsViewDelegate>

@property (strong, nonatomic) SuccessPromotionsView *successPromotionView;

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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Lazy Instantiation
- (SuccessPromotionsView *)successPromotionView {
    if (!_successPromotionView) {
        _successPromotionView = [SuccessPromotionsView instanceFromNib];
        _successPromotionView.frame = CGRectMake(.0f,
                                                 .0f,
                                                 CGRectGetWidth([UIScreen mainScreen].bounds) - 40,
                                                 400.f);
        _successPromotionView.layer.cornerRadius = 2.0f;
        _successPromotionView.delegate = self;
    }
    
    return _successPromotionView;
}

#pragma mark - View
- (void)setupView {
    [self.navigationController.navigationBar setBarTintColor:[UIColor phPurpleColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
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
- (IBAction)didTapRootView:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)didTapApplyButton:(id)sender {
    [self.view presentView:self.successPromotionView animated:YES completion:nil];
}

- (IBAction)didTapInviteFriendsButton:(id)sender {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    
    [self.navigationController pushViewController:[InviteFriendsViewController new]
                                         animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    
    return YES;
}

#pragma mark - SuccessPromotionsViewDelegate
- (void)successPromotionsView:(SuccessPromotionsView *)view didTapUseNowButton:(UIButton *)sender {
    [view dismissViewAnimated:YES completion:nil];
}

- (void)successPromotionsView:(SuccessPromotionsView *)view didTapRemindMeLaterButton:(UIButton *)sender {
    [view dismissViewAnimated:YES completion:nil];
}

@end
