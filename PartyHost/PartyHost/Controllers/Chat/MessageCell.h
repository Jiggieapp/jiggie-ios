//
//  MessageCell.h
//  PartyHost
//
//  Created by Sunny Clark on 1/11/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Messages.h"
#import "MessageBubbleTriangle.h"
#import "NSDate+Calculators.h"

@class Message;
@interface MessageCell : UITableViewCell

@property (nonatomic,strong) UIView *toIconCon;
@property (nonatomic,strong) UserBubble *toIcon;
@property (nonatomic,strong) MessageBubbleTriangle *triangle;
@property (nonatomic,strong) UITextView *toMessage;
@property (nonatomic,strong) UITextView *fromMessage;
@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UILabel *myDateLabel;

- (void)configureMessage:(Message *)message;

@end
