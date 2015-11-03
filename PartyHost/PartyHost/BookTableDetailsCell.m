//
//  BookTableDetailsCell.m
//  PartyHost
//
//  Created by Tony Suriyathep on 7/18/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "BookTableDetailsCell.h"

#define CELL_HEIGHT 64

@implementation BookTableDetailsCell

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
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.cost = [[UILabel alloc] initWithFrame:CGRectMake((self.sharedData.screenWidth/2), 2, (self.sharedData.screenWidth/2)-16, CELL_HEIGHT)];
        self.cost.text = @"$99,999";
        self.cost.textAlignment = NSTextAlignmentRight;
        self.cost.textColor = [UIColor phDarkGrayColor];;
        //self.cost.backgroundColor = [UIColor redColor];
        self.cost.adjustsFontSizeToFitWidth = YES;
        self.cost.lineBreakMode = NSLineBreakByTruncatingTail;
        self.cost.font = [UIFont phBold:24];
        [self addSubview:self.cost];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(20, 16, self.sharedData.screenWidth/2, 12)];
        self.title.text = @"RESERVATION";
        //self.title.backgroundColor = [UIColor greenColor];
        self.title.textAlignment = NSTextAlignmentLeft;
        self.title.textColor = [UIColor phDarkGrayColor];
        self.title.adjustsFontSizeToFitWidth = YES;
        self.title.lineBreakMode = NSLineBreakByTruncatingTail;
        self.title.font = [UIFont phBlond:12];
        [self addSubview:self.title];
        
        self.note = [[UILabel alloc] initWithFrame:CGRectMake(20, self.title.frame.origin.y + self.title.frame.size.height+8, self.sharedData.screenWidth/2, 14)];
        self.note.text = @"up to 5 guests total ($200 each)";
        self.note.textAlignment = NSTextAlignmentLeft;
        self.note.textColor = [UIColor whiteColor];
        self.note.adjustsFontSizeToFitWidth = YES;
        self.note.lineBreakMode = NSLineBreakByTruncatingTail;
        self.note.font = [UIFont phBlond:12];
        [self addSubview:self.note];
    }
    return self;
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
    
    float price = [dict[@"price"] floatValue];
    int guest = [dict[@"guest"] intValue];
    int add_guest = [dict[@"add_guest"] intValue];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *priceAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:price]];
    NSString *perPersonAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:price/guest]];
    NSString *addGuestAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:add_guest]];
    
    self.cost.text = priceAsString;
    self.note.text = [NSString stringWithFormat:@"up to %i guests total (%@ each)",guest,perPersonAsString];
}

@end
