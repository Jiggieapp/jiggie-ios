//
//  EventsHostMessage.h
//  PartyHost
//
//  Created by Tony Suriyathep on 8/1/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsHostMessage : UIView <UITextViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) SharedData *sharedData;
@property (strong, nonatomic) UITapGestureRecognizer *tapAway;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *venueName;
@property (weak, nonatomic) IBOutlet UILabel *eventDate;
@property (weak, nonatomic) IBOutlet UITextView *messageText;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end
