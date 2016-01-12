//
//  BookTableOfferingCell.m
//  PartyHost
//
//  Created by Tony Suriyathep on 7/17/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "BookTableOfferingCell.h"
#import "BookTableOffering.h"
#import "BookTable.h"

@implementation BookTableOfferingCell

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
        self.backgroundColor = [UIColor phDarkBodyColor];
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(20, 11, self.sharedData.screenWidth*0.75, 22)];
        self.title.text = @"Free Drinks";
        //self.title.backgroundColor = [UIColor greenColor];
        self.title.textAlignment = NSTextAlignmentLeft;
        self.title.textColor = [UIColor whiteColor];
        self.title.adjustsFontSizeToFitWidth = YES;
        self.title.lineBreakMode = NSLineBreakByTruncatingTail;
        self.title.font = [UIFont phBlond:20];
        [self addSubview:self.title];
        
        self.subtitle = [[UILabel alloc] initWithFrame:CGRectMake(20, self.title.frame.origin.y + self.title.frame.size.height+4, self.sharedData.screenWidth - 40 - 32 - 16, 14)];
        self.subtitle.text = @"up to 5 guests total ($200 each)";
        //self.subtitle.backgroundColor = [UIColor redColor];
        self.subtitle.textAlignment = NSTextAlignmentLeft;
        self.subtitle.textColor = [UIColor whiteColor];
        self.subtitle.adjustsFontSizeToFitWidth = YES;
        self.subtitle.lineBreakMode = NSLineBreakByTruncatingTail;
        self.subtitle.font = [UIFont phBlond:12];
        [self addSubview:self.subtitle];
        
        self.perk = [[PerkButton alloc] initWithFrame:CGRectMake(20,self.subtitle.frame.origin.y + self.subtitle.frame.size.height + 8,self.subtitle.frame.size.width+4,20)];
        self.perk.userInteractionEnabled = NO;
        [self addSubview:self.perk];
        
        self.check = [[SelectionCheckmark alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth - 32 - 20,(92/2) - (32/2),32,32)];
        self.check.innerColor = [UIColor phGreenColor];
        self.check.userInteractionEnabled = NO;
        [self addSubview:self.check];
    }
    return self;
}

-(void)populateData:(NSDictionary *)dict
{
    NSString *title = dict[@"title"];
    NSString *tag = dict[@"tag"];
    NSString *description = dict[@"description"];
    NSString *bg_color = dict[@"bg_color"];
    
    self.title.text = title;
    self.subtitle.text = description;
    
    [self.perk updateLeftFit:tag color:[UIColor colorFromHexCode:bg_color]];
    
    BOOL found = false;
    for(int i=0;i<[self.sharedData.bookTable.offeringArray count];i++)
    {
        if([self.sharedData.bookTable.offeringArray[i] isEqualToString:tag])
        {
            [self.check buttonSelect:YES animated:NO];
            found = true;
            break;
        }
    }
    if(!found)
    {
        [self.check buttonSelect:NO animated:NO];
    }
}




@end
