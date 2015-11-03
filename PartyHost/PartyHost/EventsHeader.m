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
        
        self.btnDown = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnDown.frame = CGRectMake(self.sharedData.screenWidth - 35, 6, 32, 32);
        [self.btnDown addTarget:self action:@selector(goDown) forControlEvents:UIControlEventTouchUpInside];
        //self.btnDown.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.btnDown setBackgroundImage:[UIImage imageNamed:@"down-only-arrow-icon-white"] forState:UIControlStateNormal];
        //[self addSubview:self.btnDown];
        
        /*
        self.btnUp = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnUp.frame = CGRectMake(self.sharedData.screenWidth/2 - 15, 5, 30, 30);
        [self.btnUp addTarget:self action:@selector(goUp) forControlEvents:UIControlEventTouchUpInside];
        self.btnUp.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.btnUp setBackgroundImage:[UIImage imageNamed:@"up-only-arrow-icon-white"] forState:UIControlStateNormal];
        [self addSubview:self.btnUp];
         */
    }
    
    return self;
}

-(void)goDown
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EVENTS_GO_DOWN"
     object:self];
}

-(void)goUp
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EVENTS_GO_UP"
     object:self];
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
