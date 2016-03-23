//
//  TicketSuccessViewController.h
//  Jiggie
//
//  Created by Setiady Wiguna on 3/14/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "BaseViewController.h"

@interface TicketSuccessViewController : BaseViewController

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *congratsLabel;
@property (nonatomic, strong) UILabel *eventName;
@property (nonatomic, strong) UILabel *eventDate;
@property (nonatomic, strong) UILabel *orderNumber;
@property (nonatomic, strong) UILabel *guestName;
@property (nonatomic, strong) UILabel *status;
@property (nonatomic, strong) UILabel *paymentMethod;
@property (nonatomic, strong) UILabel *orderDate;
@property (nonatomic, strong) UILabel *ticketName;
@property (nonatomic, strong) UILabel *ticketPrice;
@property (nonatomic, strong) UILabel *adminPrice;
@property (nonatomic, strong) UILabel *taxPrice;
@property (nonatomic, strong) UILabel *totalPrice;
@property (nonatomic, strong) UILabel *instruction;
@property (nonatomic, strong) UILabel *eventNameBottom;
@property (nonatomic, strong) UILabel *eventTimeBottom;
@property (nonatomic, strong) UILabel *eventPlaceBottom;
@property (nonatomic, strong) UILabel *eventDateBottom;
@property (nonatomic, strong) EmptyView *emptyView;

@property (nonatomic, assign) BOOL showCloseButton;
@property (nonatomic, assign) BOOL showViewButton;
@property (nonatomic, assign) BOOL isModalScreen;
@property (nonatomic, strong) NSString *ticketType;
@property (nonatomic, strong) NSString *orderID;
@property (nonatomic, strong) NSDictionary *successData;

@end
