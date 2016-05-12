//
//  InviteViewController.m
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 5/10/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "InviteViewController.h"
#import "PromotionsViewController.h"
#import "InviteFriendsViewController.h"
#import "SVProgressHUD.h"
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
    [self getInvitationCode];
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
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    
    [self.navigationController pushViewController:[InviteFriendsViewController new]
                                         animated:YES];
}

- (IBAction)didTapShareMessageButton:(id)sender {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    
    [self.navigationController pushViewController:[PromotionsViewController new]
                                         animated:YES];
}

- (IBAction)didTapShareCopyButton:(id)sender {
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    [pasteBoard setString:self.promoCodeLabel.text];
}

#pragma mark - API Calls
- (void)getInvitationCode {
    [self.promoCodeLabel setText:@""];
    [self.promoDescriptionLabel setText:@""];
    
    NSString *inviteCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"INVITE_CODE"];
    
    if (inviteCode) {
        [self.promoCodeLabel setText:inviteCode];
    } else {
        SharedData *sharedData = [SharedData sharedInstance];
        AFHTTPRequestOperationManager *manager = [sharedData getOperationManager];
        NSString *url = [NSString stringWithFormat:@"%@/credit/invite_code/%@", PHBaseNewURL, sharedData.fb_id];
        
        [SVProgressHUD show];
        [manager GET:url parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            
            NSInteger responseStatusCode = operation.response.statusCode;
            if (responseStatusCode != 200) {
                return;
            }
            
            NSString *responseString = operation.responseString;
            NSError *error;
            NSDictionary *json = (NSDictionary *)[NSJSONSerialization
                                                  JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]
                                                  options:kNilOptions
                                                  error:&error];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (json && json != nil) {
                    NSDictionary *data = [json objectForKey:@"data"];
                    if (data && data != nil) {
                        NSDictionary *inviteCode = [data objectForKey:@"invite_code"];
                        NSString *code = inviteCode[@"code"];
                        
                        [self.promoCodeLabel setText:code];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:code forKey:@"INVITE_CODE"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            
            [self.promoCodeLabel setText:@""];
            [self.promoDescriptionLabel setText:@""];
        }];
    }
}

@end
