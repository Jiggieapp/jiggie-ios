//
//  EventsHostingsListCell.m
//  PartyHost
//
//  Created by Sunny Clark on 2/15/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "EventsHostingsListCell.h"

#define SET_IF_NOT_NULL(TARGET, VAL) if(VAL && VAL != [NSNull null]) { TARGET = VAL; }else {TARGET = @"";}

@implementation EventsHostingsListCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.sharedData = [SharedData sharedInstance];
        self.mainDict = [[NSMutableDictionary alloc] init];
        self.userDict = [[NSMutableDictionary alloc] init];
        self.layer.masksToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor phDarkBodyColor];
        
        self.nameTitle = [[UILabel alloc] initWithFrame:CGRectMake(70, 25 + 5, self.sharedData.screenWidth - 70, 20)];
        self.nameTitle.textColor = [UIColor whiteColor];
        self.nameTitle.backgroundColor = [UIColor clearColor];
        self.nameTitle.font = [UIFont phBold:18];
        [self addSubview:self.nameTitle];
        
        self.interestedLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth - 100 - 16, self.nameTitle.frame.origin.y, 100, 12)];
        self.interestedLabel.textColor = [UIColor whiteColor];
        self.interestedLabel.font = [UIFont phBold:10];
        self.interestedLabel.textAlignment = NSTextAlignmentRight;
        self.interestedLabel.text = @"99 INTERESTED";
        self.interestedLabel.userInteractionEnabled = NO;
        [self addSubview:self.interestedLabel];
        
        self.userImg = [[UserBubble alloc] initWithFrame:CGRectMake(10, 10 + 5, 50, 50)];
        [self.userImg addTarget:self action:@selector(userIconClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.userImg];
        
        self.offeringLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameTitle.frame.origin.x, self.nameTitle.frame.origin.y + self.nameTitle.frame.size.height + 5, self.sharedData.screenWidth - 110 - 16, 14)];
        self.offeringLabel.textColor = [UIColor darkGrayColor];
        self.offeringLabel.font = [UIFont phBold:10];
        self.offeringLabel.textAlignment = NSTextAlignmentLeft;
        self.offeringLabel.text = @"I'M OFFERING";
        self.offeringLabel.userInteractionEnabled = NO;
        [self addSubview:self.offeringLabel];
        
        self.offeringContainer = [[UIView alloc] initWithFrame:CGRectMake(self.offeringLabel.frame.origin.x, self.offeringLabel.frame.origin.y + self.offeringLabel.frame.size.height + 8, self.sharedData.screenWidth + 50, 15)];
        //self.offeringContainer.backgroundColor = [UIColor redColor];
        self.offeringContainer.layer.masksToBounds = YES;
        self.offeringContainer.userInteractionEnabled = NO;
        [self addSubview:self.offeringContainer];
        
        self.verifiedLabel = [[UILabel alloc] initWithFrame:CGRectMake(95 - 16, self.nameTitle.frame.origin.y, 200, 20)];
        self.verifiedLabel.font = [UIFont phBlond:12];
        self.verifiedLabel.textColor = [UIColor colorFromHexCode:@"16AA85"];;
        self.verifiedLabel.text = @"(verified promoter)";
        self.verifiedLabel.hidden = YES;
        [self addSubview:self.verifiedLabel];
    }
    return self;
}

-(void)loadData:(NSMutableDictionary *)mainDict userDict:(NSMutableDictionary *)userDict
{
    //Store dictionary for later use
    [self.mainDict removeAllObjects];
    [self.mainDict addEntriesFromDictionary:mainDict];
    [self.userDict removeAllObjects];
    [self.userDict addEntriesFromDictionary:userDict];
    
    //Get name
    NSString *firstName = userDict[@"first_name"];
    self.nameTitle.text = [firstName uppercaseString];
    
    //Get profile image
    [self.userImg setName:self.userDict[@"first_name"] lastName:nil];
    [self.userImg loadFacebookImage:self.userDict[@"fb_id"]];
    
    CGSize textSize = [[self.nameTitle text] sizeWithAttributes:@{NSFontAttributeName:[self.nameTitle font]}];
    CGFloat strikeWidth = textSize.width;
    
    //Check for verified promoter
    BOOL is_verified_host = [mainDict[@"is_verified_host"] boolValue];
    BOOL is_verified_table = [mainDict[@"hosting"][@"is_verified_table"] boolValue];
    self.verifiedLabel.text = (is_verified_table == YES)?@"(verified table)":@"(verified promoter)";
    if(is_verified_host || is_verified_table)
    {
        self.verifiedLabel.hidden = NO;
        self.verifiedLabel.frame = CGRectMake(70 + strikeWidth + 10 - 4, 11, 100, 20);
    } else {
        self.verifiedLabel.hidden = YES;
    }
    
    /*
     offerings =             (
     {
     "bg_color" = c79d2d;
     title = "VIP Table";
     },
     {
     "bg_color" = 50e3c2;
     title = "Skip The Line";
     },
     {
     "bg_color" = bd10e0;
     title = "Taxi Ride";
     }
     );
     */
    
    //Show offerings
    int x1 = 0;
    [self.offeringContainer.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    NSArray *offeringArray = userDict[@"hosting"][@"offerings"];
    
    NSLog(@"COUNT___ %lu",(unsigned long)[offeringArray count]);
    NSLog(@"OFFERINGS :: %@",offeringArray);
    for(int i=0;i<[offeringArray count];i++)
    {
        NSDictionary *offeringDict = offeringArray[i];
        PerkButton *perk = [[PerkButton alloc] initWithFrame:CGRectMake(x1,0, self.offeringContainer.frame.size.width, 15)];
        perk.userInteractionEnabled = NO;
        [perk updateLeftFit:[offeringDict[@"title"] uppercaseString] color:[UIColor colorFromHexCode:offeringDict[@"bg_color"]]];
        x1 += perk.frame.size.width+8;
        if(x1<=self.offeringContainer.frame.size.width)
        {
            [self.offeringContainer addSubview:perk];
        }
        else
        {
            break;
        }
    }
    
    //Get # interested
    long c = [userDict[@"hosting"][@"view_count"] integerValue];
    if(c==0)
    {
        self.interestedLabel.text = @"";
    }
    else{
        self.interestedLabel.text = [NSString stringWithFormat:@"%ld INTERESTED",c];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)userIconClicked:(UIButton *)button
{
    [self.sharedData.cHostDict removeAllObjects];
    [self.sharedData.cHostDict addEntriesFromDictionary:self.mainDict];
    self.sharedData.member_fb_id = self.userDict[@"fb_id"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_MEMBER_PROFILE"
                                                        object:self.userDict[@"fb_id"]];
}

@end
