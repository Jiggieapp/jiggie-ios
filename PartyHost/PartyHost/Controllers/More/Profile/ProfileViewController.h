//
//  ProfileViewController.h
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 4/29/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *mainPhotoImageView;
@property (strong, nonatomic) IBOutlet UITableView *sidePhotoTableView;
@property (strong, nonatomic) IBOutlet UITextView *aboutTextView;

@end
