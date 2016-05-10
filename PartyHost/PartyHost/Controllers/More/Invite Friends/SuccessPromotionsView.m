//
//  SuccessPromotionsView.m
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 5/10/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "SuccessPromotionsView.h"

@interface SuccessPromotionsView ()

@end

@implementation SuccessPromotionsView

+ (SuccessPromotionsView *)instanceFromNib {
    return (SuccessPromotionsView *)[[UINib nibWithNibName:@"SuccessPromotionsView" bundle:nil]
                                     instantiateWithOwner:self options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.useNowButton.layer.cornerRadius = 3.f;
}

#pragma mark - Action
- (IBAction)didTapUseNowButton:(id)sender {
    if (self.delegate) {
        [self.delegate successPromotionsView:self didTapUseNowButton:sender];
    }
}

- (IBAction)didTapRemindMeLaterButton:(id)sender {
    if (self.delegate) {
        [self.delegate successPromotionsView:self didTapRemindMeLaterButton:sender];
    }
}

@end
