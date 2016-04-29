//
//  FeedViewController.h
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 4/25/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedView : UIView

@property (strong, nonatomic) IBOutlet UIView *navigationBarView;
@property (strong, nonatomic) IBOutlet UILabel *navigationBarTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *discoverImageView;
@property (strong, nonatomic) IBOutlet UILabel *discoverLabel;
@property (strong, nonatomic) IBOutlet UISwitch *discoverSwitch;
@property (strong, nonatomic) IBOutlet UIButton *filterButton;

+ (FeedView *)instanceFromNib;

- (void)loadDataAndShowHUD:(BOOL)show withCompletionHandler:(PartyFeedCompletionHandler)completion;

@end
