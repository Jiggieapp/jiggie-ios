//
//  MessageCell.m
//  PartyHost
//
//  Created by Sunny Clark on 1/11/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell


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
        self.isMe = NO;
        self.layer.masksToBounds = YES;
        
        CGRect myframe = self.frame;
        
        myframe.size.width = self.sharedData.screenWidth;
        self.frame = myframe;
        
        //NSLog(@"RECT :: %@",NSStringFromCGRect(screenBounds));
        
        self.toIconCon = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
        self.toIconCon.layer.masksToBounds = YES;
        self.toIconCon.hidden = YES;
        [self addSubview:self.toIconCon];
        
        self.toIcon = [[UserBubble alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        self.toIcon.userInteractionEnabled = YES;
        [self.toIcon addTarget:self action:@selector(showMemberProfile) forControlEvents:UIControlEventTouchUpInside];
        [self.toIconCon addSubview:self.toIcon];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, 35, 60, 45)];
        self.dateLabel.font = [UIFont phBlond:9];
        self.dateLabel.textColor = [UIColor phDarkGrayColor];
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        
        self.myDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 70, 35, 60, 45)];
        self.myDateLabel.font = [UIFont phBlond:9];
        self.myDateLabel.textColor = [UIColor phDarkGrayColor];
        self.myDateLabel.textAlignment = NSTextAlignmentRight;
        
        self.toMessage = [[UITextView alloc] initWithFrame:CGRectMake(70, 0, self.frame.size.width - 90, 30)];
        //self.toMessage.backgroundColor = [self.sharedData colorWithHexString:@"292929"];
        self.toMessage.hidden = YES;
        self.toMessage.userInteractionEnabled = YES;
        self.toMessage.font = [UIFont phBlond:self.sharedData.messageFontSize];
        self.toMessage.layer.borderWidth = 0;
        self.toMessage.layer.masksToBounds = YES;
        self.toMessage.layer.cornerRadius = 17;
        self.toMessage.textContainerInset = UIEdgeInsetsMake(7.0f, 8.0f, 20, 0.0);
        self.toMessage.editable = NO;
        self.toMessage.selectable = NO;
        self.toMessage.userInteractionEnabled = NO;
        //self.toMessage.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 30, 0);
        [self addSubview:self.toMessage];
        
        self.fromMessage = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width - 30, 30)];
        //self.fromMessage.backgroundColor = [UIColor whiteColor];
        self.fromMessage.hidden = YES;
        self.fromMessage.userInteractionEnabled = NO;
        self.fromMessage.font = [UIFont phBlond:self.sharedData.messageFontSize];
        self.fromMessage.layer.borderWidth = 0;
        self.fromMessage.layer.masksToBounds = YES;
        self.fromMessage.layer.cornerRadius = 17;
        self.fromMessage.textContainerInset = UIEdgeInsetsMake(7.0f, 8.0f, 20, 0.0);
        //self.fromMessage.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 30, 0);
        [self addSubview:self.fromMessage];
        
        
        self.triangle = [[MessageBubbleTriangle alloc] initWithFrame:CGRectMake(10, 40, 20, 20)];
        self.triangle.hidden = YES;
//        [self addSubview:self.triangle];
        
        
        [self addSubview:self.dateLabel];
        [self addSubview:self.myDateLabel];
        
        CALayer *topBorder = [CALayer layer];
        topBorder.borderColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.05].CGColor;
        topBorder.borderWidth = 1;
        topBorder.frame = CGRectMake(-1, 1, CGRectGetWidth(self.frame) + 1, 1);
        
        //[self.layer addSublayer:topBorder];
    }
    return self;
}


-(void)loadData:(NSMutableDictionary *)dict andMainData:(NSDictionary *)mainDict
{
    self.toIconCon.hidden = self.toMessage.hidden = self.dateLabel.hidden = (self.isMe);
    self.myDateLabel.hidden = self.fromMessage.hidden = !self.toMessage.hidden;
    
    //NSString *text = [dict objectForKey:@"message"];
    
    NSString *dateTime = [[dict objectForKey:@"created_at"] substringToIndex:19];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormat setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss'"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDate *dte = [dateFormat dateFromString:dateTime];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    //[formatter setDateFormat:@"h:mm a dd/MM/yyyy"];
    [formatter setDateFormat:@"h:mm a"];
    
    if(self.isMe)
    {
        NSString *msgText = [dict objectForKey:@"message"];
        int headerOffset = 0;
        if(![[dict objectForKey:@"header"] isEqualToString:@""])
        { //System message
            NSRange findCancel = [msgText rangeOfString:@"has cancelled"];
            if(findCancel.length>0)
            {
                self.fromMessage.textColor = [UIColor whiteColor];
                self.fromMessage.backgroundColor = [UIColor phBlueColor];
            }
            else
            {
                self.fromMessage.textColor = [UIColor whiteColor];
                self.fromMessage.backgroundColor = [UIColor phBlueColor];
            }
            
            self.triangle.color = self.fromMessage.backgroundColor;
            msgText = [NSString stringWithFormat:@"%@\n%@",[dict objectForKey:@"header"],msgText];
            headerOffset = 0;
        }
        else
        { //Regular message
            self.fromMessage.backgroundColor = [UIColor phBlueColor];
            self.fromMessage.textColor = [UIColor whiteColor];
            self.triangle.color = [UIColor phBlueColor];
        }
        
        self.triangle.frame = CGRectMake(self.frame.size.width - 20, 17, 15, 15);
        self.triangle.isRightSide = YES;
        [self.triangle setNeedsDisplay];
        
        self.fromMessage.text = msgText;
        
        //CGFloat wrappingWidth = self.fromMessage.bounds.size.width - (self.fromMessage.textContainerInset.left + self.fromMessage.textContainerInset.right + 2 * self.fromMessage.textContainer.lineFragmentPadding);
        
        
        //CGRect boundingRect = [msgText boundingRectWithSize:CGSizeMake(wrappingWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin                                               attributes:@{ NSFontAttributeName: self.fromMessage.font } context:nil];
        
        self.fromMessage.frame = CGRectMake(10, 0, self.frame.size.width - 30, 30);
        [self.fromMessage sizeToFit];
        //[self.subtitle sizeToFit];
        
        CGRect fromFrame = self.fromMessage.frame;
        fromFrame.origin.x = self.frame.size.width - fromFrame.size.width - 16 - 8;
        fromFrame.origin.y = 10;
        fromFrame.size.height -= 10;
        fromFrame.size.width += 8;
        self.fromMessage.frame = fromFrame;
        
        
        //self.fromMessage.frame = CGRectMake(10, 10, self.frame.size.width - 28, boundingRect.size.height + 15 + headerOffset + 15);
        self.myDateLabel.numberOfLines = 2;
        self.myDateLabel.text = [formatter stringFromDate:dte];
        self.myDateLabel.frame = CGRectMake(self.frame.size.width - 80, self.fromMessage.frame.size.height, 60, 45);
    }else{
        int headerOffset = 0;
        
        NSString *msgText = [dict objectForKey:@"message"];
        if(![[dict objectForKey:@"header"] isEqualToString:@""])
        { //System message
            NSRange findCancel = [msgText rangeOfString:@"has cancelled"];
            if(findCancel.length>0)
            {
                self.toMessage.textColor = [UIColor whiteColor];
                self.toMessage.backgroundColor = [UIColor phDarkGrayColor];
            }
            else
            {
                self.toMessage.textColor = [UIColor whiteColor];
                self.toMessage.backgroundColor = [UIColor phDarkGrayColor];
            }
            
            self.triangle.color = self.toMessage.backgroundColor;
            msgText = [NSString stringWithFormat:@"%@\n%@",[dict objectForKey:@"header"],msgText];
            headerOffset = 0;
        }
        else
        { //Regular message
            self.toMessage.backgroundColor = [UIColor phDarkGrayColor];
            self.toMessage.textColor = [UIColor whiteColor];
            self.triangle.color = [UIColor phGrayColor];
        }
        
        self.triangle.frame = CGRectMake(58, 17, 15, 15);
        self.triangle.isRightSide = NO;
        [self.triangle setNeedsDisplay];
        
        self.toMessage.text = msgText;
        
        //CGFloat wrappingWidth = self.toMessage.bounds.size.width - (self.toMessage.textContainerInset.left + self.toMessage.textContainerInset.right + 2 * self.toMessage.textContainer.lineFragmentPadding);
        //CGRect boundingRect = [msgText boundingRectWithSize:CGSizeMake(wrappingWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin                                               attributes:@{ NSFontAttributeName: self.toMessage.font } context:nil];
        
        self.toMessage.frame = CGRectMake(70, 0, self.frame.size.width - 90, 30);
        [self.toMessage sizeToFit];
        
        CGRect toFrame = self.toMessage.frame;
        toFrame.origin.x = 70;
        toFrame.origin.y = 10;
        toFrame.size.height -= 10;
        toFrame.size.width += 8;
        self.toMessage.frame = toFrame;
        
        self.dateLabel.numberOfLines = 2;
        self.dateLabel.text = [formatter stringFromDate:dte];
        self.dateLabel.frame = CGRectMake(self.dateLabel.frame.origin.x, self.toMessage.frame.size.height, 60, 45);

        [self.toIcon loadPicture:mainDict[@"to_profile_image"]];
    }
}

/*
-(void)layoutSubviews
{
    CGRect newCellSubViewsFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    CGRect newCellViewFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    self.contentView.frame = self.contentView.bounds = self.backgroundView.frame = self.accessoryView.frame = newCellSubViewsFrame;
    self.frame = newCellViewFrame;
    [super layoutSubviews];
}
*/

-(void)showMemberProfile
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_MEMBER_PROFILE"
                                                        object:self.sharedData.member_fb_id];
}

-(void)showLoading:(BOOL)loading
{
    self.triangle.hidden = loading;
    if(loading)
    {
        self.toMessage.hidden = loading;
        self.fromMessage.hidden = loading;
        self.toIconCon.hidden = loading;
        self.dateLabel.hidden = loading;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
