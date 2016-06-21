//
//  Messages.h
//  PartyHost
//
//  Created by Sunny Clark on 1/11/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "MessageCell.h"
#import "MemberProfile.h"

@interface Messages : UIView

@property (strong, nonatomic) SharedData *sharedData;

@property (nonatomic, strong) UITableView *messagesList;
@property (nonatomic, strong) UIImageView *toIcon;
@property (nonatomic, strong) UILabel *toLabel;
@property (nonatomic, strong) UIView *tabBar;
@property (nonatomic, strong) UIButton *btnBack;
@property (nonatomic, strong) UIButton *btnInfo;
@property (nonatomic, strong) UIView *btnSend;
@property (nonatomic, strong) UIView *btnSendDimView;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UILabel *sendTxt;
@property (nonatomic, strong) UITextView *input;

@property (nonatomic, strong) NSString *toId;
@property (nonatomic, assign) BOOL canCheckScrollDown;
@property (nonatomic, assign) int inputNumLines;

- (void)initClass;
- (void)initClassWithRoomId:(NSString *)roomId
              andEventName:(NSString *)eventName;
- (void)reset;

@end
