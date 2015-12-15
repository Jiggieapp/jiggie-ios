//
//  VenueListCell.m
//  PartyHost
//
//  Created by Sunny Clark on 2/4/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "VenueListCell.h"

@implementation VenueListCell

- (void)awakeFromNib
{
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.sharedData = [SharedData sharedInstance];
        self.layer.masksToBounds = YES;
        
        self.bkImage = [[PHImage alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 74.5)];
        self.bkImage.layer.masksToBounds = YES;
        self.bkImage.image = [UIImage imageNamed:@"nightclub_default"];
        self.bkImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.bkImage];
        
        self.date = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.frame.size.width - 20, 25)];
        self.date.textColor = [UIColor whiteColor];
        self.date.textAlignment = NSTextAlignmentLeft;
        self.date.font = [UIFont phBlond:20];
        self.date.backgroundColor = [UIColor clearColor];
        self.date.text = @"";
        [self addSubview:self.date];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, self.frame.size.width - 20, 25)];
        self.title.textColor = [UIColor whiteColor];
        self.title.textAlignment = NSTextAlignmentLeft;
        self.title.font = [UIFont phBold:20];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.text = @"";
        self.title.shadowColor = [UIColor blackColor];
        self.title.shadowOffset = CGSizeMake(0.5,0.5);
        [self addSubview:self.title];
        
        self.subtitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, self.frame.size.width - 20, 20)];
        self.subtitle.textColor = [UIColor whiteColor];
        self.subtitle.textAlignment = NSTextAlignmentLeft;
        self.subtitle.font = [UIFont phBlond:14];
        self.subtitle.backgroundColor = [UIColor clearColor];
        self.subtitle.text = @"";
        self.subtitle.shadowColor = [UIColor blackColor];
        self.subtitle.shadowOffset = CGSizeMake(0.5,0.5);
        [self addSubview:self.subtitle];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
