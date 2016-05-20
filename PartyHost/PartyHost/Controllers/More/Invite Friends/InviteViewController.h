//
//  InviteViewController.h
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 5/10/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *promoCodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *promoDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIButton *shareFacebookButton;
@property (strong, nonatomic) IBOutlet UIButton *shareContactButton;
@property (strong, nonatomic) IBOutlet UIButton *shareMessageButton;
@property (strong, nonatomic) IBOutlet UIButton *shareCopyButton;

@end
