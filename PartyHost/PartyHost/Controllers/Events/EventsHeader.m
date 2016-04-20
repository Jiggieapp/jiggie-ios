//
//  EventsHeader.m
//  PartyHost
//
//  Created by Sunny Clark on 2/12/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "EventsHeader.h"

@implementation EventsHeader




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        self.sharedData = [SharedData sharedInstance];
        self.backgroundColor = [UIColor phDarkGrayColor];
        self.sectionHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, self.sharedData.screenWidth - 20, 20)];
        self.sectionHeaderLabel.textColor = [UIColor whiteColor];
        self.sectionHeaderLabel.textAlignment = NSTextAlignmentLeft;
        self.sectionHeaderLabel.font = [UIFont phBold:11];
        [self addSubview:self.sectionHeaderLabel];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
