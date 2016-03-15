//
//  VirtualAccountViewController.m
//  Jiggie
//
//  Created by Setiady Wiguna on 3/14/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "VirtualAccountViewController.h"

@interface VirtualAccountViewController ()

@end

@implementation VirtualAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 28, 200, 24)];
    [titleLabel setText:@"HOW TO PAY"];
    [titleLabel setTextColor:[UIColor phPurpleColor]];
    [titleLabel setFont:[UIFont phBlond:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:titleLabel];
    
    
    if (self.showCloseButton) {
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setFrame:CGRectMake(self.visibleSize.width - 80, 28, 60, 26)];
        [closeButton setTitle:@"CLOSE" forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
        [[closeButton titleLabel] setFont:[UIFont phBlond:12]];
        [closeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [closeButton setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:closeButton];
    }
    
    UIView *line1View = [[UIView alloc] initWithFrame:CGRectMake(0, 70, self.visibleSize.width, 1)];
    [line1View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.view addSubview:line1View];
    
    // SCROLL VIEW
    
    CGFloat orderButtonSize = 0;
    if (self.showOrderButton) {
        orderButtonSize = 44;
    }
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line1View.frame) + 4, self.visibleSize.width, self.visibleSize.height - CGRectGetMaxY(line1View.frame) - 4 - orderButtonSize)];
    self.scrollView.showsVerticalScrollIndicator    = NO;
    self.scrollView.showsHorizontalScrollIndicator  = NO;
    self.scrollView.scrollEnabled                   = YES;
    self.scrollView.userInteractionEnabled          = YES;
    self.scrollView.backgroundColor                 = [UIColor whiteColor];
    self.scrollView.contentSize                     = CGSizeMake(self.visibleSize.width, 500);
    [self.view addSubview:self.scrollView];
    
    UILabel *transferTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 6, 140, 24)];
    [transferTimeLabel setText:@"Transfer time limit"];
    [transferTimeLabel setTextColor:[UIColor blackColor]];
    [transferTimeLabel setFont:[UIFont phBlond:13]];
    [transferTimeLabel setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:transferTimeLabel];
    
    self.transferTime = [[UILabel alloc] initWithFrame:CGRectMake(14, 30, 200, 24)];
    [self.transferTime setText:@"Xh Xm"];
    [self.transferTime setTextColor:[UIColor phPurpleColor]];
    [self.transferTime setFont:[UIFont phBlond:16]];
    [self.transferTime setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:self.transferTime];
    
    UIView *lineVertical = [[UIView alloc] initWithFrame:CGRectMake(self.visibleSize.width/2, 10 , 1, 40)];
    [lineVertical setBackgroundColor:[UIColor phLightGrayColor]];
    [self.scrollView addSubview:lineVertical];
    
    UILabel *transferAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width/2 + 14, 6, 140, 24)];
    [transferAmountLabel setText:@"Transfer amount"];
    [transferAmountLabel setTextColor:[UIColor blackColor]];
    [transferAmountLabel setFont:[UIFont phBlond:13]];
    [transferAmountLabel setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:transferAmountLabel];
    
    self.transferAmount = [[UILabel alloc] initWithFrame:CGRectMake(self.visibleSize.width/2 + 14, 30, 140, 24)];
    [self.transferAmount setText:@"RpX.XXX K"];
    [self.transferAmount setTextColor:[UIColor phPurpleColor]];
    [self.transferAmount setFont:[UIFont phBlond:16]];
    [self.transferAmount setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:self.transferAmount];
    
    UILabel *transferToLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 30 + 30, 140, 24)];
    [transferToLabel setText:@"Transfer To"];
    [transferToLabel setTextColor:[UIColor blackColor]];
    [transferToLabel setFont:[UIFont phBlond:13]];
    [transferToLabel setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:transferToLabel];
    
    self.transferTo = [[UILabel alloc] initWithFrame:CGRectMake(14, 30 + 30 + 26, 200, 24)];
    [self.transferTo setText:@"XXXX-XXXX-XXXX-XXXX"];
    [self.transferTo setTextColor:[UIColor phPurpleColor]];
    [self.transferTo setFont:[UIFont phBlond:16]];
    [self.transferTo setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:self.transferTo];
    
    UILabel *jiggieLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 30 + 30 + 30 + 20, 200, 24)];
    [jiggieLabel setText:@"JIGGIE Teknologi Indonesia"];
    [jiggieLabel setTextColor:[UIColor blackColor]];
    [jiggieLabel setFont:[UIFont phBlond:13]];
    [jiggieLabel setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:jiggieLabel];
    
    UIView *line2View = [[UIView alloc] initWithFrame:CGRectMake(0, 30 + 30 + 30 + 20 + 30, self.visibleSize.width, 1)];
    [line2View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.scrollView addSubview:line2View];
    
    UILabel *stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line2View.frame) + 10, 200, 24)];
    [stepLabel setText:@"Step for virtual account transfer"];
    [stepLabel setTextColor:[UIColor blackColor]];
    [stepLabel setFont:[UIFont phBlond:13]];
    [stepLabel setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:stepLabel];
    
    UIView *line3View = [[UIView alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(line2View.frame) + 10 + 30, 60, 3)];
    [line3View setBackgroundColor:[UIColor phLightGrayColor]];
    [self.scrollView addSubview:line3View];
    
    if (self.showOrderButton) {
        UIButton *viewOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [viewOrderButton addTarget:self action:@selector(viewOrderButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
        [viewOrderButton setFrame:CGRectMake(0, self.visibleSize.height - orderButtonSize, self.visibleSize.width, orderButtonSize)];
        [viewOrderButton setBackgroundColor:[UIColor phBlueColor]];
        [viewOrderButton.titleLabel setFont:[UIFont phBold:15]];
        [viewOrderButton setTitle:@"VIEW ORDERS" forState:UIControlStateNormal];
        [viewOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:viewOrderButton];
    }
    
    CGFloat listY = CGRectGetMaxY(line3View.frame) + 18;
    
    UIView *line2Vertical = [[UIView alloc] initWithFrame:CGRectMake(26, listY, 1, 40)];
    [line2Vertical setBackgroundColor:[UIColor phLightGrayColor]];
    [self.scrollView addSubview:line2Vertical];
    
    if ([self.VAType isEqualToString:@"tutorial"]) {
        NSArray *steps = @[@"Go to ATM",
                           @"Choose \"Transfer\" from the menu",
                           @"Input the number provide above",
                           @"Choose \"Pay\"",
                           @"Open JIGGIE and go to \"more\" -> \"order\"",
                           @"Your order status will show \"Paid\""];
        
        NSInteger count = 1;
        for (NSString *step in steps) {
            UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [iconButton setBackgroundImage:[UIImage imageNamed:@"icon_purple"] forState:UIControlStateNormal];
            [iconButton setFrame:CGRectMake(14, listY, 24, 24)];
            [iconButton setEnabled:NO];
            [iconButton setTitle:[NSString stringWithFormat:@"%li", count] forState:UIControlStateNormal];
            [iconButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [[iconButton titleLabel] setFont:[UIFont phBlond:13]];
            [iconButton setAdjustsImageWhenDisabled:NO];
            [self.scrollView addSubview:iconButton];
            
            UILabel *termLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, listY, self.visibleSize.width - 60 - 14, 24)];
            [termLabel setText:step];
            [termLabel setFont:[UIFont phBlond:12]];
            [termLabel setTextColor:[UIColor blackColor]];
            [termLabel setAdjustsFontSizeToFitWidth:YES];
            [termLabel setBackgroundColor:[UIColor clearColor]];
            [self.scrollView addSubview:termLabel];
            
            listY += 42;
            count++;
        }
    }
    
    UILabel *starLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, listY + 8, 8, 20)];
    [starLabel setText:@"*"];
    [starLabel setNumberOfLines:2];
    [starLabel setTextColor:[UIColor purpleColor]];
    [starLabel setFont:[UIFont phBlond:15]];
    [starLabel setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:starLabel];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, listY + 6, self.visibleSize.width - 30, 40)];
    [infoLabel setText:@"We have also emailed you with these steps along with our Virtual Account number"];
    [infoLabel setNumberOfLines:2];
    [infoLabel setTextColor:[UIColor blackColor]];
    [infoLabel setFont:[UIFont phBlond:11]];
    [infoLabel setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:infoLabel];
    
    [line2Vertical setFrame:CGRectMake(line2Vertical.frame.origin.x,
                                       line2Vertical.frame.origin.y,
                                       1,
                                       listY - line2Vertical.frame.origin.y - 18)];
    
     self.scrollView.contentSize = CGSizeMake(self.visibleSize.width, listY + 8);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (void)closeButtonDidTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewOrderButtonDidTap:(id)sender {

}

@end
