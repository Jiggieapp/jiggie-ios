//
//  SuccessPromotionsView.h
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 5/10/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SuccessPromotionsView;

@protocol SuccessPromotionsViewDelegate <NSObject>

@required
- (void)successPromotionsView:(SuccessPromotionsView *)view didTapUseNowButton:(UIButton *)sender;
- (void)successPromotionsView:(SuccessPromotionsView *)view didTapRemindMeLaterButton:(UIButton *)sender;

@end

@interface SuccessPromotionsView : UIView

@property (weak, nonatomic) id<SuccessPromotionsViewDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *promoDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIButton *useNowButton;
@property (strong, nonatomic) IBOutlet UIButton *remindMeLaterButton;

+ (SuccessPromotionsView *)instanceFromNib;

@end
