//
//  InviteViewController.m
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 5/10/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "InviteViewController.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#define kCornerRadius 3.f

@interface InviteViewController () <FBSDKSharingDelegate> {
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
                                                  cornerRadius:kCornerRadius].CGPath;
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
    
    self.shareFacebookButton.layer.cornerRadius = kCornerRadius;
    self.shareContactButton.layer.cornerRadius = kCornerRadius;
    self.shareMessageButton.layer.cornerRadius = kCornerRadius;
    self.shareCopyButton.layer.cornerRadius = kCornerRadius;
}

#pragma mark - Action
- (IBAction)didTapShareFacebookButton:(id)sender {
    if ([self checkFacebookPermissions:[FBSDKAccessToken currentAccessToken]]) {
        [self sharePromoCodeToFacebook];
    }
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

#pragma mark - Facebook
- (void)sharePromoCodeToFacebook {
    FBSDKShareLinkContent *shareContent = [[FBSDKShareLinkContent alloc] init];
    shareContent.contentTitle = @"title";
    shareContent.contentDescription = @"description";
    shareContent.contentURL = [NSURL URLWithString:@"https://www.jiggieapp.com"];
    
    FBSDKShareAPI *shareAPI = [[FBSDKShareAPI alloc] init];
    shareAPI.message = self.promoCodeLabel.text;
    shareAPI.shareContent = shareContent;
    shareAPI.delegate = self;
    
    [shareAPI share];
}

- (BOOL)checkFacebookPermissions:(FBSDKAccessToken *)currentAccessToken {
    NSSet *permissions = [currentAccessToken permissions];
    NSArray *requiredPermissions = @[@"publish_actions"];
    
    for (NSString *permission in requiredPermissions) {
        if (![permissions containsObject:permission]) {
            FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
            [loginManager logInWithPublishPermissions:requiredPermissions
                                   fromViewController:self
                                              handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                                  if (error) {
                                                      NSLog(@"FB Process error :: %@",error);
                                                      [[NSNotificationCenter defaultCenter]
                                                       postNotificationName:@"HIDE_LOADING"
                                                       object:self];
                                                  } else if (result.isCancelled) {
                                                      NSLog(@"FB Cancelled");
                                                      [[NSNotificationCenter defaultCenter]
                                                       postNotificationName:@"HIDE_LOADING"
                                                       object:self];
                                                  } else {
                                                      [self sharePromoCodeToFacebook];
                                                  }
                                              }];
            
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - FBSDKSharingDelegate
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    NSLog(@"%@", results);
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    NSLog(@"cancel");
}

@end
