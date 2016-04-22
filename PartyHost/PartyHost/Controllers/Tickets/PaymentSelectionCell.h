//
//  AddPaymentCell.h
//  Jiggie
//
//  Created by Setiady Wiguna on 4/14/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentSelectionCell : UITableViewCell

@property (nonatomic, strong) UIImageView *paymentCard;
@property (nonatomic, strong) UIImageView *paymentImage;
@property (nonatomic, strong) UILabel *paymentTitle;
@property (nonatomic, assign) CGFloat cellWidth;

- (void)setTitle:(NSString *)title andImage:(UIImage *)image;

@end
