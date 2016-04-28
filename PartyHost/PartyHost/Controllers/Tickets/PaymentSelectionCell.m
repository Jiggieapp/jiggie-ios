//
//  AddPaymentCell.m
//  Jiggie
//
//  Created by Setiady Wiguna on 4/14/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "PaymentSelectionCell.h"

@implementation PaymentSelectionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [[self contentView] setBackgroundColor:[UIColor clearColor]];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.paymentCard = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.paymentCard setImage:[[UIImage imageNamed:@"bg_rectangle"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
        [[self contentView] addSubview:self.paymentCard];
        
        self.paymentImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.paymentImage setBackgroundColor:[UIColor clearColor]];
        [[self contentView] addSubview:self.paymentImage];
        
        self.paymentTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.paymentTitle setFont:[UIFont phBlond:13]];
        [self.paymentTitle setTextColor:[UIColor blackColor]];
        [self.paymentTitle setBackgroundColor:[UIColor clearColor]];
        [[self contentView] addSubview:self.paymentTitle];
    }
    
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)title andImage:(UIImage *)image {
    
    [self.paymentCard setFrame:CGRectMake(8, 1, self.cellWidth - 16, 68)];
    
    if (image != nil) {
        [self.paymentImage setFrame:CGRectMake(24, (70 - image.size.height) /2, image.size.width, image.size.height)];
        [self.paymentImage setImage:image];
        
        [self.paymentTitle setFrame:CGRectMake(CGRectGetMaxX(self.paymentImage.frame) + 12, 24, 200, 20)];
        [self.paymentTitle setText:title];
    } else {
        [self.paymentImage setFrame:CGRectZero];
        [self.paymentImage setImage:nil];
        
        [self.paymentTitle setFrame:CGRectMake(24, 24, 200, 20)];
        [self.paymentTitle setText:title];
    }
}

@end
