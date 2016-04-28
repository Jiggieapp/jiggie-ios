//
//  SocialFilterView.h
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 4/28/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SocialFilterView;
@protocol SocialFilterViewDelegate <NSObject>

@required
- (void)socialFilterView:(SocialFilterView *)view interestDidValueChanged:(NSString *)string;
- (void)socialFilterView:(SocialFilterView *)view discoverDidValueChanged:(UISwitch *)sender;
- (void)socialFilterView:(SocialFilterView *)view distanceDidValueChanged:(UISlider *)sender;

@end

@interface SocialFilterView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *discoverImageView;
@property (strong, nonatomic) IBOutlet UILabel *discoverLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UISwitch *discoverSwitch;

@property (weak, nonatomic) id<SocialFilterViewDelegate> delegate;

@property (strong, nonatomic, readonly) NSArray *filters;

+ (SocialFilterView *)instanceFromNib;

@end
