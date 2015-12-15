//
//  MemberReviewCell.m
//  PartyHost
//
//  Created by Tony Suriyathep on 5/13/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "MemberReviewCell.h"

@implementation MemberReviewCell

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
        self.backgroundColor = [UIColor clearColor];
        
        //Create text view
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0,0,self.sharedData.screenWidth - (self.sharedData.memberReviewSidePadding*2),0)];
        self.textView.text = @"";
        self.textView.textColor = [UIColor whiteColor];
        self.textView.backgroundColor = [UIColor clearColor];
        self.textView.editable = NO;
        self.textView.selectable = NO;
        self.textView.scrollEnabled = NO;
        self.textView.font = [UIFont phBlond:self.sharedData.memberReviewFontSize];
        [self addSubview:self.textView];
        
        //User circular image
        //self.memberIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        self.memberIcon = [[PHImage alloc] init];
        self.memberIcon.frame = CGRectMake(0, self.textView.frame.origin.y + self.textView.frame.size.height + 4, 32, 32);
        self.memberIcon.backgroundColor = [UIColor blackColor];
        self.memberIcon.layer.cornerRadius = 16;
        self.memberIcon.layer.masksToBounds = YES;
        self.memberIcon.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.memberIcon.layer.borderWidth = 1.0;
        self.memberIcon.contentMode = UIViewContentModeScaleAspectFill;
        self.memberIcon.image = [UIImage imageNamed:@"fbperson_blank_square"];
        //[self.memberIcon setImage:[UIImage imageNamed:@"fbperson_blank_square"] forState:UIControlStateNormal];
        [self addSubview:self.memberIcon];
        
        //Member name
        self.memberName = [[UILabel alloc] initWithFrame:CGRectMake(32+8,self.memberIcon.frame.origin.y+1,self.sharedData.screenWidth - (self.sharedData.memberReviewSidePadding*2) - 32 - 8,16)];
        self.memberName.font = [UIFont phBlond:self.sharedData.memberReviewFontSize];
        self.memberName.text = @"";
        self.memberName.textColor = [UIColor whiteColor];
        [self addSubview:self.memberName];
        
        //Review Date
        self.reviewDate = [[UILabel alloc] initWithFrame:CGRectMake(32+8,self.memberName.frame.origin.y + self.memberName.frame.size.height-2,self.memberName.frame.size.width,16)];
        self.reviewDate.font = [UIFont phBlond:self.sharedData.memberReviewFontSize-2];
        self.reviewDate.text = @"";
        self.reviewDate.textColor = [UIColor lightGrayColor];
        [self addSubview:self.reviewDate];
        
        //Stars
        self.ratingView = [[RatingView alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth-(16*5) - (self.sharedData.memberReviewSidePadding*2),self.memberIcon.frame.origin.y+1,(16*5),14)];
        [self addSubview:self.ratingView];
        
        //Separator white
        self.separator = [[UIView alloc] initWithFrame:CGRectMake(0,self.memberIcon.frame.origin.y+32+16,self.sharedData.screenWidth - (self.sharedData.memberReviewSidePadding*2),1)];
        self.separator.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.separator];
    }
    return self;
}

-(void)clearData
{
    self.separator.hidden = YES;
    self.textView.text = @"";
    self.memberName.text = @"";
    self.reviewDate.text = @"";
    self.memberIcon.image = [UIImage imageNamed:@"fbperson_blank_square"];
}

-(void)setReview:(NSMutableDictionary*)data
{
    //Resize text view
    self.textView.frame = CGRectMake(0,0,self.sharedData.screenWidth - (self.sharedData.memberReviewSidePadding*2),0);
    self.textView.text = data[@"message"];
    [self.textView sizeToFit];
    
    //Update icon
    self.memberIcon.frame = CGRectMake(0, self.textView.frame.origin.y + self.textView.frame.size.height + 4, 32, 32);
    [self.memberIcon loadImage:[self.sharedData profileImg:data[@"from_fb_id"]] defaultImageNamed:@"fbperson_blank_square"];
    
    //Update name
    self.memberName.text = [data[@"first_name"] capitalizedString];
    self.memberName.frame = CGRectMake(32+8,self.memberIcon.frame.origin.y+1,self.sharedData.screenWidth - (self.sharedData.memberReviewSidePadding*2) - 32 - 8,16);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSDate *date = [dateFormatter dateFromString:data[@"created_at"]];
    
    //Update date
    self.reviewDate.text =[date timeAgo];
    self.reviewDate.frame = CGRectMake(32+8,self.memberName.frame.origin.y + self.memberName.frame.size.height-2,self.memberName.frame.size.width,16);
    
    //Update stars
    self.ratingView.frame = CGRectMake(self.sharedData.screenWidth-(16*5) - (self.sharedData.memberReviewSidePadding*2),self.memberIcon.frame.origin.y+1,(16*5),16);
    [self.ratingView updateRating:[UIColor whiteColor] stars:[data[@"rating"] floatValue]];
    
    //Separator
    self.separator.frame = CGRectMake(0,self.memberIcon.frame.origin.y + self.memberIcon.frame.size.height + 14,self.sharedData.screenWidth - (self.sharedData.memberReviewSidePadding*2),1);
    self.separator.hidden = NO;
}

@end
