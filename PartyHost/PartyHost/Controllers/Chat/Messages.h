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

@interface Messages : UIView<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIAlertViewDelegate,UIScrollViewDelegate,UITextViewDelegate>

@property (strong, nonatomic) SharedData    *sharedData;


@property(nonatomic,strong) NSMutableDictionary *mainDataA;

@property(nonatomic,strong) NSMutableDictionary *dataDict;


@property(nonatomic,strong) NSMutableArray  *sectionsA;

@property(nonatomic,strong) NSMutableArray  *messagesA;
@property(nonatomic,strong) UITableView     *messagesList;
@property(nonatomic,assign) CGRect          messagesListFrame;
@property(nonatomic,assign) BOOL            isMessagesLoaded;
@property(nonatomic,strong) NSString        *toId;
@property(nonatomic,strong) UIImageView     *toIcon;
@property(nonatomic,strong) UILabel         *toLabel;
@property(nonatomic,strong) UIView          *tabBar;
@property(nonatomic,strong) UIButton        *btnBack;
@property(nonatomic,strong) UIButton        *btnInfo;
@property(nonatomic,strong) UIView          *btnSend;
@property(nonatomic,strong) UIView          *btnSendDimView;
@property(nonatomic,strong) UIView          *loadingView;

@property(nonatomic,strong) UILabel         *sendTxt;

@property(nonatomic,assign) BOOL            startedPolling;
@property(nonatomic,assign) BOOL            canPoll;

@property(nonatomic,strong) UITextView     *input;

@property(nonatomic,assign) BOOL            isKeyBoardShowing;
@property(nonatomic,assign) CGFloat         contentOffSetYToCompare;
@property(nonatomic,assign) CGFloat         keyBoardHeight;
@property(nonatomic,assign) BOOL            canCheckScrollDown;

@property(nonatomic,assign) BOOL            isInBlockMode;

@property(nonatomic,assign) BOOL            isConfMode;

@property(nonatomic,strong) NSMutableArray  *hostingsConfA;

@property(nonatomic,assign) int            inputNumLines;


@property(nonatomic,assign) int confirmMode; //0=None 1=Confirm
@property(nonatomic,strong) UIView *confirmArea;
@property(nonatomic,strong) UIButton *confirmButton; //This could be cancel
@property(nonatomic,strong) UILabel *confirmLabel; //Description of what is going to be pressed?

-(void)initClass;
-(void)initClassWithRoomId:(NSString *)roomId
              andEventName:(NSString *)eventName;
-(void)reset;
-(void)addMessageFromAPN:(NSString *)message;
@end
