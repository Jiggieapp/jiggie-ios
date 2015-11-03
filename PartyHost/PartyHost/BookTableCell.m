//
//  BookTableCell.m
//  PartyHost
//
//  Created by Tony Suriyathep on 7/16/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "BookTableCell.h"

@implementation BookTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.sharedData = [SharedData sharedInstance];
        self.backgroundColor = [UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.cost = [[UILabel alloc] initWithFrame:CGRectMake(20, 24, self.sharedData.screenWidth/2, 29)];
        self.cost.text = @"$99,999";
        self.cost.textAlignment = NSTextAlignmentLeft;
        self.cost.textColor = [UIColor phDarkGrayColor];
        self.cost.adjustsFontSizeToFitWidth = YES;
        self.cost.lineBreakMode = NSLineBreakByTruncatingTail;
        self.cost.font = [UIFont phBold:24];
        [self addSubview:self.cost];
        
        self.perk = [[PerkButton alloc] initWithFrame:CGRectMake((self.sharedData.screenWidth/2) - 40, 24, (self.sharedData.screenWidth/2), 20)];
        [self.perk setTitle:@"VIP TABLE" forState:UIControlStateNormal];
        self.perk.backgroundColor = [UIColor phLightGrayColor];
        self.perk.userInteractionEnabled = NO;
        [self addSubview:self.perk];
        
        self.perPerson = [[UILabel alloc] initWithFrame:CGRectMake(20, self.cost.frame.origin.y + self.cost.frame.size.height+4, self.sharedData.screenWidth - 40 - 32, 12)];
        self.perPerson.text = @"$200 PER PERSON, UP TO 4 GUESTS";
        self.perPerson.textAlignment = NSTextAlignmentLeft;
        self.perPerson.textColor = [UIColor phDarkGrayColor];
        self.perPerson.adjustsFontSizeToFitWidth = YES;
        self.perPerson.lineBreakMode = NSLineBreakByTruncatingTail;
        self.perPerson.font = [UIFont phBlond:10];
        [self addSubview:self.perPerson];
        
        self.note = [[UILabel alloc] initWithFrame:CGRectMake(20, self.perPerson.frame.origin.y + self.perPerson.frame.size.height+5, self.perPerson.frame.size.width, 14)];
        self.note.text = @"minimum increased by $200 per extra guest";
        self.note.textAlignment = NSTextAlignmentLeft;
        self.note.textColor = [UIColor phGrayColor];
        self.note.adjustsFontSizeToFitWidth = YES;
        self.note.lineBreakMode = NSLineBreakByTruncatingTail;
        self.note.font = [UIFont phBlond:12];
        [self addSubview:self.note];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected){
        self.perk.backgroundColor = [UIColor colorFromHexCode:@"3D3D3D"];
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted){
        self.perk.backgroundColor = [UIColor colorFromHexCode:@"3D3D3D"];
    }
}

-(void)populateData:(NSMutableDictionary *)dict
{
    /*
     "_id" = 55ab24cf36f986030000000b;
     active = active;
     "add_guest" = 5;
     "admin_fee" = "";
     "chk_adminfee" = 0;
     "chk_tax" = 0;
     "chk_tip" = 0;
     "created_at" = "2015-07-19T04:17:19.805Z";
     deposit = "";
     description = "super cool table";
     "event_id" = 55ab20ff36f9860300000004;
     guest = 2;
     "is_recurring" = 0;
     name = "Golden Booth";
     price = 100;
     "purchase_confirmations" =         (
     );
     quantity = 10;
     tax = "";
     "ticket_status" = active;
     "ticket_type" = reservation;
     tip = "";
     total = 1000;
     */
    
    int price = [dict[@"price"] intValue];
    int guest = [dict[@"guest"] intValue];
    int add_guest = [dict[@"add_guest"] intValue];
    
    //NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    //[numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *priceAsString = [NSString stringWithFormat:@"$%i",price];
    NSString *perPersonAsString = [NSString stringWithFormat:@"$%i",(price/guest)];
    NSString *addGuestAsString = [NSString stringWithFormat:@"$%i",add_guest];
    
    self.cost.text = priceAsString;
    [self.perk updateRightFit:[dict[@"name"] uppercaseString] color:[UIColor colorFromHexCode:@"3D3D3D"]];
    if([dict[@"status"] isEqualToString:@"sold out"])
    {
       [self.perk updateRightFit:[@"sold out" uppercaseString] color:[UIColor colorFromHexCode:@"3D3D3D"]];
    }
    
    self.perPerson.text = [NSString stringWithFormat:@"%@ PER PERSON, UP TO %i GUESTS",perPersonAsString,guest];
    self.note.text = [NSString stringWithFormat:@"minimum increased by %@ per extra guest",addGuestAsString];
}

@end
