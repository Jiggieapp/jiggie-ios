//
//  Messages.m
//  PartyHost
//
//  Created by Sunny Clark on 1/11/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "Messages.h"
#import "AnalyticManager.h"
#import "Message.h"
#import "Mantle.h"
#import "User.h"
#import "RoomPrivateInfo.h"
#import "Room.h"
#import "Firebase.h"
#import "SVProgressHUD.h"

#define MESSAGE_PLACEHOLDER @"Type your message here ..."

@interface Messages () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIAlertViewDelegate,UIScrollViewDelegate, UITextViewDelegate>

@property (strong, nonatomic) FIRDatabaseReference *membersReference;
@property (strong, nonatomic) FIRDatabaseReference *roomInfoReference;
@property (strong, nonatomic) FIRDatabaseReference *messagesReference;

@property (nonatomic, assign) BOOL isKeyBoardShowing;
@property (nonatomic, assign) CGFloat contentOffSetYToCompare;
@property (nonatomic, assign) CGFloat keyBoardHeight;

@property (nonatomic, assign) CGRect messagesListFrame;

@property (copy, nonatomic) NSString *roomId;
@property (strong, nonatomic) NSDictionary *members;
@property (strong, nonatomic) NSDictionary *unreads;
@property (copy, nonatomic) NSString *eventName;
@property (strong, nonatomic) NSMutableArray *messages;
@property (copy, nonatomic) User *user;

@end

@implementation Messages

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.canCheckScrollDown = NO;
    self.backgroundColor = [UIColor whiteColor];
    self.sharedData = [SharedData sharedInstance];
    
    self.tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 60)];
    self.tabBar.backgroundColor = [UIColor phPurpleColor];
    
    self.messages = [NSMutableArray array];
    self.messagesListFrame = CGRectMake(0, 60, frame.size.width, frame.size.height - 60 - 40);
    self.messagesList = [[UITableView alloc] initWithFrame:self.messagesListFrame style:UITableViewStyleGrouped];
    self.messagesList.backgroundColor = [UIColor greenColor];
    self.messagesList.delegate = self;
    self.messagesList.dataSource = self;
    self.messagesList.allowsMultipleSelectionDuringEditing = NO;
    self.messagesList.backgroundColor = [UIColor clearColor];
    self.messagesList.separatorColor = [UIColor clearColor];
    [self.messagesList setTableFooterView:[UIView new]];
    
    [self addSubview:self.messagesList];
    
    self.toLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, frame.size.width-85, 40)];
    self.toLabel.textColor = [UIColor whiteColor];
    self.toLabel.backgroundColor = [UIColor clearColor];
    self.toLabel.font = [UIFont phBold:18];
    self.toLabel.textAlignment = NSTextAlignmentCenter;
    [self.tabBar addSubview:self.toLabel];
    
    self.btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnBack.frame = CGRectMake(0, 20, 40, 40);
    [self.btnBack setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [self.btnBack setImageEdgeInsets:UIEdgeInsetsMake(8, 14, 8, 14)];
    [self.btnBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:self.btnBack];
    
    self.btnInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnInfo.frame = CGRectMake(frame.size.width - 50 + 4, 20, 40, 40);
    [self.btnInfo setImage:[UIImage imageNamed:@"nav_dots"] forState:UIControlStateNormal];
    [self.btnInfo setImageEdgeInsets:UIEdgeInsetsMake(16, 10, 16, 10)];
    self.btnInfo.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.btnInfo addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:self.btnInfo];
    
    self.input = [[UITextView alloc] initWithFrame:CGRectMake(0, frame.size.height - 40, frame.size.width - 60, 40)];
    self.input.font = [UIFont phBlond:13];
    self.input.delegate = self;
    self.input.backgroundColor = [UIColor whiteColor];
    self.input.textColor = [UIColor blackColor];
    self.input.returnKeyType = UIReturnKeyDefault;
    self.input.textContainerInset = UIEdgeInsetsMake(12, 10, 10, 10);
    self.input.text = MESSAGE_PLACEHOLDER;
    self.input.textColor = [UIColor grayColor];
    [self addSubview:self.input];
    
    CALayer *rightBorder = [CALayer layer];
    rightBorder.borderColor = [UIColor phLightGrayColor].CGColor;
    rightBorder.borderWidth = 1;
    rightBorder.frame = CGRectMake(-1,0,self.sharedData.screenWidth+2,1);
    [self.input.layer addSublayer:rightBorder];
    
    self.inputNumLines = 1;
    
    [self.sharedData.keyboardsA addObject:self.input];
    
    self.btnSend = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width - 60, frame.size.height - 40, 60, 40)];
    self.btnSend.backgroundColor = [UIColor whiteColor];
    self.btnSend.layer.masksToBounds = YES;
    [self addSubview:self.btnSend];
    
    self.sendTxt = [[UILabel alloc] initWithFrame:self.btnSend.bounds];
    self.sendTxt.font = [UIFont phBold:13];
    self.sendTxt.textColor = [UIColor phBlueColor];
    self.sendTxt.textAlignment = NSTextAlignmentCenter;
    self.sendTxt.text = @"SEND";
    self.sendTxt.backgroundColor = [UIColor clearColor];
    self.sendTxt.userInteractionEnabled = NO;
    [self.btnSend addSubview:self.sendTxt];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.borderColor = [UIColor phLightGrayColor].CGColor;
    topBorder.borderWidth = 1;
    topBorder.frame = CGRectMake(-1,0,self.btnSend.frame.size.width+2,1);
    [self.btnSend.layer addSublayer:topBorder];
    
    self.btnSendDimView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 380)];
    self.btnSendDimView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.25];
    self.btnSendDimView.hidden = YES;
    [self.btnSend addSubview:self.btnSendDimView];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnSendTapHandler:)];
    longPress.minimumPressDuration = 0.01;
    [self.btnSend addGestureRecognizer:longPress];
    
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, frame.size.width, frame.size.height - 60)];
    self.loadingView.backgroundColor = self.backgroundColor;
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    spinner.frame = CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.screenHeight);
    [self.loadingView addSubview:spinner];
    
    [self addSubview:self.loadingView];
    [self addSubview:self.tabBar];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadMessages)
                                                 name:@"UPDATE_CURRENT_CONVERSATION"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goBack)
                                                 name:@"MESSAGES_GO_BACK"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reLoadApp)
                                                 name:@"RELOAD_CURRENT_CONVERSATION"
                                               object:nil];
    
    //Resign first responder when tapped away
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAwayFromKeyboard)];
    [self addGestureRecognizer:tap];
    
    [self keyboardOn];
    
    return self;
}

- (void)initClassWithRoomId:(NSString *)roomId {
    self.roomId = roomId;
    
    [self.btnInfo setEnabled:NO];
    
    self.roomInfoReference = [[Room reference] child:self.roomId];
    
    [self.roomInfoReference observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (![snapshot.value isEqual:[NSNull null]]) {
            [self initClassWithRoomId:self.roomId
                              members:snapshot.value[@"members"]
                         andEventName:snapshot.value[@"event"]];
        }
        
    }];
}

- (void)initClassWithRoomId:(NSString *)roomId members:(NSDictionary *)members andEventName:(NSString *)eventName {
    self.roomId = roomId;
    self.eventName = eventName;
    
    [self.btnInfo setEnabled:NO];
    [self.loadingView setHidden:YES];
    
    self.members = members;
    self.membersReference = [[Room membersReference] child:self.roomId];
    
    [self.membersReference observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (![snapshot.value isEqual:[NSNull null]]) {
            self.members = snapshot.value;
        }
        
        [self scrollToBottom:NO];
        [self initClass];
    }];
}

- (void)initClass {
    self.sharedData.memberProfile.hidden = YES;
    self.sharedData.isInConversation = YES;
    self.keyBoardHeight = 0;
    
    //Restart placeholder
    self.input.text = MESSAGE_PLACEHOLDER;
    self.input.textColor = [UIColor grayColor];
    
    [self adjustFrames];
    [self loadMessages];
}

#pragma mark - Data

- (void)loadMessages {
    [self.loadingView setHidden:NO];
    
    if (self.eventName.length > 0 &&
        [self.roomId rangeOfString:@"_"].location != NSNotFound &&
        ![[self.eventName lowercaseString] isEqualToString:@"generic"] &&
        ![[self.eventName lowercaseString] isEqualToString:@"friendlist"]) {
        UIView *view = [self headerViewWithText:self.eventName];
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(.0f, .0f, CGRectGetWidth(self.messagesList.bounds), CGRectGetHeight(view.bounds) + 20.0f)];
        [headerView addSubview:view];
        [view setCenter:headerView.center];
        
        [self.messagesList setTableHeaderView:headerView];
    } else {
        [self.messagesList setTableHeaderView:nil];
    }
    
    NSLog(@"shared data fb id: %@", self.sharedData.fb_id);
    
    if (!self.sharedData.fb_id) {
        self.sharedData.fb_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_FB_ID"];
    }
    
    NSLog(@"roomId: %@", self.roomId);
    
    if ([self.roomId rangeOfString:@"_"].location != NSNotFound) {
        NSString *fbId = [RoomPrivateInfo getFriendFbIdFromIdentifier:self.roomId fbId:self.sharedData.fb_id];
        
        NSLog(@"friend fb id: %@", fbId);
        
        [User retrieveUserInfoWithFbId:fbId andCompletionHandler:^(User *user, NSError *error) {
            if (user) {
                self.user = user;
                [self.toLabel setText:user.name];
                [self.btnInfo setEnabled:YES];
            } else {
                [self.btnInfo setEnabled:NO];
            }
            
            self.messagesReference = [Message retrieveMessagesWithRoomId:self.roomId andCompletionHandler:^(NSArray *messages, NSError *error) {
                self.messages = [NSMutableArray arrayWithArray:messages];
                [self.loadingView setHidden:YES];
                [self.messagesList reloadData];
                [self scrollToBottom:YES];
            }];
        }];
    } else {
        [self.btnInfo setEnabled:YES];
        [self.toLabel setText:self.eventName];
        self.messagesReference = [Message retrieveMessagesWithRoomId:self.roomId andCompletionHandler:^(NSArray *messages, NSError *error) {
            self.messages = [NSMutableArray arrayWithArray:messages];
            [self.loadingView setHidden:YES];
            [self.messagesList reloadData];
            [self scrollToBottom:YES];
        }];
    }
}

- (void)sendMessageWithText:(NSString *)text {
    NSDictionary *dictionary = @{@"created_at" : [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]],
                                 @"fb_id" : self.sharedData.fb_id,
                                 @"message" : text};
    
    Message *message = [MTLJSONAdapter modelOfClass:[Message class]
                                 fromJSONDictionary:dictionary
                                              error:nil];
    
    [self.messages addObject:message];
    [self.messagesList beginUpdates];
    [self.messagesList insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.messages.count-1
                                                                   inSection:0]]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.messagesList endUpdates];

    self.sendTxt.frame = CGRectMake(0,self.btnSend.bounds.size.height - 29,self.btnSend.bounds.size.width,20);
    self.input.text = @"";
    
    self.inputNumLines = 1;
    self.canCheckScrollDown = NO;
    [self scrollToBottom:YES];
    
    if (self.isKeyBoardShowing) {
        self.btnSend.frame = CGRectMake(self.frame.size.width - 60, self.frame.size.height - 40 - self.keyBoardHeight, 60, 40);
        self.input.frame = CGRectMake(0, self.frame.size.height - 40 - self.keyBoardHeight, self.frame.size.width - 60, 40);
    } else {
        self.btnSend.frame = CGRectMake(self.frame.size.width - 60, self.frame.size.height - 40, 60, 40);
        self.input.frame = CGRectMake(0, self.frame.size.height - 40, self.frame.size.width - 60, 40);
    }
    
    NSString *receiverId = [self.roomId rangeOfString:@"_"].location != NSNotFound ? [RoomPrivateInfo getFriendFbIdFromIdentifier:self.roomId fbId:self.sharedData.fb_id] : @"";
    
    [Message sendMessageToRoomId:self.roomId
                    withSenderId:self.sharedData.fb_id
                      receiverId:receiverId
                            text:text
               completionHandler:^(NSError *error) {
                   if (!error) {
                       [[AnalyticManager sharedManager] trackMixPanelIncrementWithDict:@{@"send_message" : @1}];
                   }
               }];
}

#pragma mark - Action

- (void)goBack {
    self.sharedData.isInConversation = NO;
    self.user = nil;
    self.messages = nil;
    [self.messagesList reloadData];
    
    [self.toLabel setText:nil];
    [self endEditing:YES];
    
    if (![self.eventName isEqualToString:@"friendlist"]) {
        [Message hasReadMessagesInRoom:self.roomId];
    }
    
    [self.membersReference removeAllObservers];
    [self.roomInfoReference removeAllObservers];
    [self.messagesReference removeAllObservers];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EXIT_MESSAGES"
                                                        object:self];
}

- (void)btnSendTapHandler:(UILongPressGestureRecognizer *)sender {
    if([self.input.text isEqualToString:@""] || [self.input.text isEqual:MESSAGE_PLACEHOLDER]) {
        return;
    }
    
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [self.input.text stringByTrimmingCharactersInSet:whitespace];
    
    if ([trimmed length] == 0) {
        return;
    }
    
    if(sender.state == UIGestureRecognizerStateBegan) {
        self.btnSendDimView.hidden = NO;
    }
    
    if(sender.state == UIGestureRecognizerStateEnded) {
        self.btnSendDimView.hidden = YES;

        [self sendMessageWithText:[self.sharedData clipSpace:self.input.text]];
        
    }
}

#pragma mark - Helper

- (void)scrollToBottom:(BOOL )animated {
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.15);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        // do work in the UI thread here
        int num = (int)self.messagesList.numberOfSections;
        num = (num < 1)?1:num;
        NSUInteger row_count = [self.messagesList numberOfRowsInSection:num - 1];
        row_count = (row_count < 1)?1:row_count;
        
        if([self.messages count] < 1) {
            return;
        }
        
        @try {
            [self.messagesList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row_count - 1  inSection:num - 1] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
        }
        @catch ( NSException *e )
        {
            NSLog(@"bummer: %@",e);
        }
    });
}

- (void)adjustFrames {
    float rows = (self.input.contentSize.height - self.input.textContainerInset.top - self.input.textContainerInset.bottom) / self.input.font.lineHeight;
    NSLog(@"text_rows :: %f",rows);
    self.inputNumLines = (int)floor(rows);
    self.inputNumLines = (self.inputNumLines > 10)?10:self.inputNumLines;
    CGRect textFrame = CGRectMake(0, self.frame.size.height - 40 - self.keyBoardHeight, self.frame.size.width - 60, 40);
    textFrame.size.height += 20 * (self.inputNumLines - 1);
    textFrame.origin.y -= 20 * (self.inputNumLines - 1);
    self.input.frame = textFrame;
    
    CGRect btnFrame = CGRectMake(self.frame.size.width - 60, self.frame.size.height - 40 - self.keyBoardHeight, 60, 40);
    btnFrame.size.height += 20 * (self.inputNumLines - 1);
    btnFrame.origin.y -= 20 * (self.inputNumLines - 1);
    self.btnSend.frame = btnFrame;
    
    self.sendTxt.frame = CGRectMake(0,self.btnSend.bounds.size.height - 29,self.btnSend.bounds.size.width,20);
    
    int length = (self.input.text.length < 1)?1:(int)self.input.text.length;
    NSRange range = NSMakeRange(length - 1, 1);
    [self.input scrollRangeToVisible:range];
}

//- (void)sanitizeData {
//    [self.mainDataA removeAllObjects];
//    [self.sectionsA removeAllObjects];
//    for (int i = 0; i < [self.messagesA count]; i++)
//    {
//        NSDictionary *dict = [self.messagesA objectAtIndex:i];
//        NSString *dateTime = [[dict objectForKey:@"created_at"] substringToIndex:19];
//        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//        [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
//        [dateFormat setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss'"];
//        [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
//        NSDate *dte = [dateFormat dateFromString:dateTime];
//
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
//        [formatter setDateFormat:@"EE, MMM d"];
//        NSString *day = [formatter stringFromDate:dte];
//
//        if(![self.mainDataA objectForKey:day])
//        {
//            NSMutableArray *tmpA = [[NSMutableArray alloc] init];
//            [self.mainDataA setObject:tmpA forKey:day];
//            [self.sectionsA addObject:day];
//        }
//
//        [[self.mainDataA objectForKey:day] addObject:dict];
//    }
//
//    NSLog(@"SANITIZED_DATA_BEGIN");
//    NSLog(@"%@",self.mainDataA);
//    NSLog(@"SANITIZED_DATA_END");
//}

- (BOOL)isSameDate:(NSDate *)compareDate {
    BOOL isSame = NO;
    
    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:compareDate];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    
    if([today day] == [otherDay day] &&
       [today month] == [otherDay month] &&
       [today year] == [otherDay year] &&
       [today era] == [otherDay era]) {
        //do stuff
        isSame = YES;
    }
    
    return isSame;
}

- (void)reLoadApp {
    [self.sharedData clearKeyBoards];
    [self reset];
    [self initClass];
}

- (void)reset {
    self.canCheckScrollDown = NO;
    self.loadingView.alpha = 1.0;
    self.loadingView.hidden = NO;
    self.input.frame = CGRectMake(0, self.frame.size.height - 40, self.frame.size.width - 60, 40);
    self.btnSend.frame = CGRectMake(self.frame.size.width - 60, self.frame.size.height - 40, 60, 40);
    self.messagesList.frame = self.messagesListFrame;
    self.inputNumLines = 1;
}

- (void)showInfo {
    [self dismissKeyBoardDown];
    
    NSString *toName = @"";
    
    if (self.user) {
        toName = [self.user.name capitalizedString];
    } else {
        toName = [self.eventName capitalizedString];
    }
    
    NSString *blockTitle = self.user ? [NSString stringWithFormat:@"Block %@?",toName] : [NSString stringWithFormat:@"Exit %@?",toName];
    
    if (self.sharedData.osVersion >= 8) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:NULL
                                              message:NULL
                                              preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleCancel
                                       handler:nil];
        
        NSString *blockAlertTitle = self.user ? @"Block" : @"Exit";
        NSString *blockAlertMessage = self.user ? @"Are you sure you want to block this user?" : @"Are you sure you want to exit from this group?";
        UIAlertAction *blockAction = [UIAlertAction
                                      actionWithTitle:blockTitle
                                      style:UIAlertActionStyleDestructive
                                      handler:^(UIAlertAction *action) {
                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:blockAlertTitle
                                                                                          message:blockAlertMessage
                                                                                         delegate:self
                                                                                cancelButtonTitle:@"Cancel"
                                                                                otherButtonTitles:@"OK", nil];
                                          [alert show];
                                      }];
        
        UIAlertAction *profileAction = [UIAlertAction
                                        actionWithTitle:self.user ? [NSString stringWithFormat:@"%@'s Profile", toName] : [NSString stringWithFormat:@"View %@", toName]
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction *action) {
                                            if (self.user) {
                                                [self performSelector:@selector(showMemberProfile) withObject:nil afterDelay:0.1];
                                            } else {
                                                [self performSelector:@selector(showEventDetail) withObject:nil afterDelay:0.1];
                                            }
                                        }];
        
        [alertController addAction:profileAction];
        [alertController addAction:blockAction];
        [alertController addAction:cancelAction];
        
        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    } else {
        NSString *profileName = self.user ? [NSString stringWithFormat:@"%@'s Profile", toName] : [NSString stringWithFormat:@"View %@", toName];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:profileName, blockTitle ,nil];
        
        [actionSheet showInView:self];
    }
}

- (void)showMemberProfile {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_MEMBER_PROFILE"
                                                        object:self.user.fbId];
}

- (void)showEventDetail {
    self.sharedData.selectedEvent[@"_id"] = self.roomId;
    self.sharedData.selectedEvent[@"venue_name"] = self.eventName;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_EVENT_MODAL"
                                                        object:[NSNumber numberWithInt:YES]];
}

- (void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Header View
- (UIView *)headerViewWithText:(NSString *)text {
    UILabel *label = [UILabel new];
    [label setNumberOfLines:0];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    [label setText:text];
    [label setFont:[UIFont phBlond:12]];
    
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 80, 60)
                                         options:NSStringDrawingUsesFontLeading
                                      attributes:@{ NSFontAttributeName : label.font }
                                         context:nil].size;
    [label setFrame:CGRectMake(.0f,
                               .0f,
                               textSize.width,
                               textSize.height)];
    [label sizeToFit];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(.0,
                                                            .0f,
                                                            CGRectGetWidth(label.bounds) + 10,
                                                            CGRectGetHeight(label.bounds) + 10)];
    
    [label setCenter:view.center];
    
    [view setBackgroundColor:[UIColor phPurpleColor]];
    [view.layer setCornerRadius:5.0f];
    
    [view addSubview:label];
    
    return view;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *secCon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 15)];
//    secCon.backgroundColor = [UIColor whiteColor];
//    
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, self.frame.size.width, 12)];
//    title.font = [UIFont phBlond:12];
//    title.textColor = [UIColor phDarkGrayColor];
//    title.textAlignment = NSTextAlignmentCenter;
//    title.text = [self.sectionsA objectAtIndex:section];
//    [secCon addSubview:title];
//    
//    return secCon;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 15;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.messages.count > 0) {
        NSString *text = ((Message *)self.messages[indexPath.row]).text;
        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        UITextView *calculationView = [[UITextView alloc] initWithFrame:CGRectMake(70,
                                                                                   0,
                                                                                   self.frame.size.width - 20 - 70,
                                                                                   30)];
        calculationView.font = [UIFont phBlond:self.sharedData.messageFontSize];
        [calculationView setText:text];
        [calculationView sizeToFit];
        
        CGRect boundingRect = calculationView.frame;
        
        int newHeight = (boundingRect.size.height + 44 < 70)?70:boundingRect.size.height + 44;
        
        return newHeight;
    }
    
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.messages.count > 0) {
        Message *message = self.messages[indexPath.row];
        [cell configureMessage:message];
    }
    
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    if(self.canCheckScrollDown && scrollView == self.messagesList) {
        CGPoint location = [scrollView.panGestureRecognizer locationInView:self.window.rootViewController.view];
        
        NSLog(@"LOCATION SCROLL :: %f > %f", location.y, self.tabBar.frame.size.height + self.messagesList.frame.size.height + 90 - (self.inputNumLines * 20));
        if(location.y > self.tabBar.frame.size.height + self.messagesList.frame.size.height + 90 - (self.inputNumLines * 20))
        {
            NSLog(@"POINT ::  %@",NSStringFromCGPoint(location));
            [self dismissKeyBoardDown];
        }
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)aTextView {
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:MESSAGE_PLACEHOLDER]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    
    [textView becomeFirstResponder];
}


- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text length]==0) {
        textView.text = MESSAGE_PLACEHOLDER;
        textView.textColor = [UIColor grayColor];
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self performSelector:@selector(adjustFrames) withObject:nil afterDelay:0.1];
        
        return YES;
    }
    
    [self adjustFrames];
    
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView {
    [self adjustFrames];
}


- (BOOL) textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (self.user) {
            [self performSelector:@selector(showMemberProfile) withObject:nil afterDelay:0.1];
        } else {
            [self performSelector:@selector(showEventDetail) withObject:nil afterDelay:0.1];
        }
    } else if (buttonIndex == 1) {
        NSString *blockAlertTitle = self.user ? @"Block" : @"Exit";
        NSString *blockAlertMessage = self.user ? @"Are you sure you want to block this user?" : @"Are you sure you want to exit from this group?";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:blockAlertTitle
                                                        message:blockAlertMessage
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [SVProgressHUD show];
        [Room blockRoomWithRoomId:self.roomId withFbId:self.sharedData.fb_id andCompletionHandler:^(NSError *error) {
            if (error) {
                if (self.user) {
                    [self showAlertViewWithTitle:@"Blocked User"
                                      andMessage:@"Fail."];
                } else {
                    [self showAlertViewWithTitle:@"Exit Group"
                                      andMessage:@"Fail."];
                }
            } else {
                [self goBack];
                
                if (self.user) {
                    [self showAlertViewWithTitle:@"Blocked User"
                                      andMessage:[NSString stringWithFormat:@"%@ has been blocked",
                                                  self.user.name]];
                    
                    [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Block User"
                                                                  withDict:@{@"origin" : @"Chat"}];
                } else {
                    [self showAlertViewWithTitle:@"Exit Group"
                                      andMessage:[NSString stringWithFormat:@"You have exited %@ group",
                                                  self.eventName]];
                    
                    [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Exit Group"
                                                                  withDict:@{@"origin" : @"Chat"}];
                }
            }
            
            [SVProgressHUD dismiss];
        }];
    }
}

#pragma mark - UIKeyboard

- (void)dismissKeyBoardDown {
    self.canCheckScrollDown = NO;
    
    [self.messagesList setContentOffset:self.messagesList.contentOffset animated:NO];
    [self.input resignFirstResponder];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    CGRect tableFrame = self.messagesList.frame;
    tableFrame.size.height = screenHeight - 105;
    
    [UIView animateWithDuration:0.25 animations:^(void) {
        self.messagesList.frame = tableFrame;
        self.input.frame = CGRectMake(0, self.frame.size.height - self.input.frame.size.height, self.frame.size.width - 60, self.input.frame.size.height);
        self.btnSend.frame = CGRectMake(self.frame.size.width - 60, self.frame.size.height - self.btnSend.frame.size.height, 60, self.btnSend.frame.size.height);
    }];
}

- (void)keyboardPostUpdateDismiss {
    [UIView animateWithDuration:0.25 animations:^() {
        self.input.frame = CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 50);
        self.messagesList.frame = CGRectMake(0, 60, self.frame.size.width, self.frame.size.height - 60 - 40);
    } completion:^(BOOL finished) {
        [self scrollToBottom:YES];
    }];
}

#pragma mark - UIKeyboard Notification
- (void)keyboardOn {
    //Remove keyboard observer
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    //Remove keyboard observer
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
    //Add keyboard observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onKeyboardShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //Add keyboard observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onKeyboardHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)clickAwayFromKeyboard {
    [self endEditing:YES];
}


- (void)onKeyboardShow:(NSNotification *)notification {
    if(!self.sharedData.isInConversation) {
        return;
    }
    
    self.isKeyBoardShowing = YES;
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [keyboardFrameBegin CGRectValue];
    self.keyBoardHeight = keyboardFrame.size.height;
    
    self.input.frame = CGRectMake(0, self.frame.size.height - 40 - self.keyBoardHeight - ((self.inputNumLines - 1) * 20), self.frame.size.width - 60, 40 + ((self.inputNumLines - 1) * 20));
    self.btnSend.frame = CGRectMake(self.frame.size.width - 60, self.frame.size.height - 40 - self.keyBoardHeight - ((self.inputNumLines - 1) * 20), 60, 40 + ((self.inputNumLines - 1) * 20));
    self.messagesList.frame = CGRectMake(0, 60, self.frame.size.width, self.frame.size.height - 60 - 40 - self.keyBoardHeight);
    
    [self scrollToBottom:NO];
    
    self.contentOffSetYToCompare = self.messagesList.contentOffset.y + self.keyBoardHeight;
    
    [self performSelector:@selector(updateKeyBoard) withObject:nil afterDelay:0.5];
}


- (void)updateKeyBoard {
    self.canCheckScrollDown = YES;
}


- (void)onKeyboardHide:(NSNotification *)notification {
    if(!self.sharedData.isInConversation) {
        return;
    }
    
    self.isKeyBoardShowing = NO;
    self.input.frame = CGRectMake(0, self.frame.size.height - 40, self.frame.size.width - 60, 40);
    self.btnSend.frame = CGRectMake(self.frame.size.width - 60, self.frame.size.height - 40, 60, 40);
    self.messagesList.frame = CGRectMake(0, 60, self.frame.size.width, self.frame.size.height - 60 - 40);
}

@end



