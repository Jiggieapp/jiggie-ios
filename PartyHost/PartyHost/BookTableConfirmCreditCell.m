//
//  BookTableDetailsCreditCell.m
//  PartyHost
//
//  Created by Tony Suriyathep on 8/24/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "BookTableConfirmCreditCell.h"

#define CELL_HEIGHT 64

@implementation BookTableConfirmCreditCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.sharedData = [SharedData sharedInstance];
        self.backgroundColor = [UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth-54, CELL_HEIGHT/2 - 24/2, 24, 24)];
        self.icon.image = [UIImage imageNamed:@"icon_cc"];
        self.icon.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.icon];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, self.sharedData.screenWidth/2, 12)];
        self.title.text = @"CREDIT CARD";
        self.title.textAlignment = NSTextAlignmentLeft;
        self.title.textColor = [UIColor darkGrayColor];
        self.title.adjustsFontSizeToFitWidth = YES;
        self.title.lineBreakMode = NSLineBreakByTruncatingTail;
        self.title.font = [UIFont phBlond:12];
        [self addSubview:self.title];
        
        self.note = [[UILabel alloc] initWithFrame:CGRectMake(20, self.title.frame.origin.y + self.title.frame.size.height+7, self.sharedData.screenWidth/2, 18)];
        self.note.text = @"4111";
        self.note.textAlignment = NSTextAlignmentLeft;
        self.note.textColor = [UIColor whiteColor];
        self.note.adjustsFontSizeToFitWidth = YES;
        self.note.lineBreakMode = NSLineBreakByTruncatingTail;
        self.note.font = [UIFont phBlond:16];
        [self addSubview:self.note];
    }
    return self;
}

@end
