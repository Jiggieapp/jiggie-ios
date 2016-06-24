//
//  MessageCell.m
//  PartyHost
//
//  Created by Sunny Clark on 1/11/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "MessageCell.h"
#import "Message.h"
#import "User.h"

@interface MessageCell ()

@property (nonatomic, strong) SharedData *sharedData;
@property (nonatomic, copy) NSString *fbId;

@end

@implementation MessageCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.sharedData = [SharedData sharedInstance];
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
        self.toMessage.editable = NO;
        self.toMessage.font = [UIFont phBlond:self.sharedData.messageFontSize];
        self.toMessage.layer.borderWidth = 0;
        self.toMessage.layer.masksToBounds = YES;
        self.toMessage.layer.cornerRadius = 17;
        self.toMessage.textContainerInset = UIEdgeInsetsMake(7.0f, 8.0f, 20, 0.0);
        //self.toMessage.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 30, 0);
        [self addSubview:self.toMessage];
        
        self.fromMessage = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width - 30, 30)];
        //self.fromMessage.backgroundColor = [UIColor whiteColor];
        self.fromMessage.hidden = YES;
        self.fromMessage.editable = NO;
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

- (void)showMemberProfile {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_MEMBER_PROFILE"
                                                        object:self.fbId];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureMessage:(Message *)message {
    BOOL isMe = [self.sharedData.fb_id isEqualToString:message.fbId];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:message.createdAt / 1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [formatter setDateFormat:@"h:mm a"];
    
    self.toIconCon.hidden = self.toMessage.hidden = self.dateLabel.hidden = isMe;
    self.myDateLabel.hidden = self.fromMessage.hidden = !self.toMessage.hidden;
    
    if(isMe) {
        self.fromMessage.textColor = [UIColor whiteColor];
        self.fromMessage.backgroundColor = [UIColor phBlueColor];
        self.triangle.color = [UIColor phBlueColor];
        
        self.triangle.frame = CGRectMake(self.frame.size.width - 20, 17, 15, 15);
        self.triangle.isRightSide = YES;
        [self.triangle setNeedsDisplay];
        
        self.fromMessage.text = message.text;;
        self.fromMessage.frame = CGRectMake(10, 0, self.frame.size.width - 30, 30);
        [self.fromMessage sizeToFit];
        
        CGRect fromFrame = self.fromMessage.frame;
        fromFrame.origin.x = self.frame.size.width - fromFrame.size.width - 16 - 8;
        fromFrame.origin.y = 10;
        fromFrame.size.height -= 10;
        fromFrame.size.width += 8;
        self.fromMessage.frame = fromFrame;
        
        self.myDateLabel.numberOfLines = 2;
        self.myDateLabel.text = [formatter stringFromDate:date];
        self.myDateLabel.frame = CGRectMake(self.frame.size.width - 80, self.fromMessage.frame.size.height, 60, 45);
    } else {
        self.toMessage.backgroundColor = [UIColor phDarkGrayColor];
        self.toMessage.textColor = [UIColor whiteColor];
        self.triangle.color = [UIColor phGrayColor];
        
        self.triangle.frame = CGRectMake(58, 17, 15, 15);
        self.triangle.isRightSide = NO;
        [self.triangle setNeedsDisplay];
        
        self.toMessage.text = message.text;
        
        self.toMessage.frame = CGRectMake(70, 0, self.frame.size.width - 90, 30);
        [self.toMessage sizeToFit];
        
        CGRect toFrame = self.toMessage.frame;
        toFrame.origin.x = 70;
        toFrame.origin.y = 10;
        toFrame.size.height -= 10;
        toFrame.size.width += 8;
        self.toMessage.frame = toFrame;
        
        self.dateLabel.numberOfLines = 2;
        self.dateLabel.text = [formatter stringFromDate:date];
        self.dateLabel.frame = CGRectMake(self.dateLabel.frame.origin.x, self.toMessage.frame.size.height, 60, 45);
        
        [User retrieveUserInfoWithFbId:message.fbId andCompletionHandler:^(User *user, NSError *error) {
            if (user) {
                self.fbId = user.fbId;
                [self.toIcon loadPicture:user.avatarURL];
            }
        }];
    }
}

@end
