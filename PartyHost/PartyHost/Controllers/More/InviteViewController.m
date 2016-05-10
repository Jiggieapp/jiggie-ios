//
//  InviteViewController.m
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 5/10/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "InviteViewController.h"
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface InviteViewController () {
    CAShapeLayer *borderLayer;
}

@end

@implementation InviteViewController

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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.promoCodeLabel.bounds
                                                  cornerRadius:2.f].CGPath;
    borderLayer.frame = self.promoCodeLabel.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View
- (void)setupView {
    [self.navigationController.navigationBar setBarTintColor:[UIColor phPurpleColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
    self.title = @"Invite Friends";
    borderLayer = [CAShapeLayer layer];
    borderLayer.strokeColor = [UIColor phGrayColor].CGColor;
    borderLayer.fillColor = nil;
    borderLayer.lineDashPattern = @[@5, @5.5];
    borderLayer.lineWidth = 1.5f;
    
    [self.promoCodeLabel.layer addSublayer:borderLayer];
    
    CGFloat cornerRadius = 4.f;
    
    self.shareFacebookButton.layer.cornerRadius = cornerRadius;
    self.shareContactButton.layer.cornerRadius = cornerRadius;
    self.shareMessageButton.layer.cornerRadius = cornerRadius;
    self.shareCopyButton.layer.cornerRadius = cornerRadius;
}

#pragma mark - Action
- (IBAction)didTapShareFacebookButton:(id)sender {
    FBSDKShareLinkContent *shareContent = [[FBSDKShareLinkContent alloc] init];
    shareContent.contentTitle = @"title";
    shareContent.contentDescription = @"description";
    shareContent.contentURL = [NSURL URLWithString:@"https://www.jiggieapp.com"];
    
    [FBSDKShareDialog showFromViewController:self
                                 withContent:shareContent
                                    delegate:nil];
}

- (IBAction)didTapShareContactButton:(id)sender {
}

- (IBAction)didTapShareMessageButton:(id)sender {
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                        initWithActivityItems:@[self.promoCodeLabel.text]
                                                        applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToFacebook,
                                                     UIActivityTypeCopyToPasteboard,
                                                     UIActivityTypeOpenInIBooks,
                                                     UIActivityTypePrint];
    
    [self.navigationController presentViewController:activityViewController
                                            animated:YES
                                          completion:nil];
}

- (IBAction)didTapShareCopyButton:(id)sender {
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    [pasteBoard setString:self.promoCodeLabel.text];
}

@end
