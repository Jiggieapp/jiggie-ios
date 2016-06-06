//
//  TicketListViewController.h
//  Jiggie
//
//  Created by Setiady Wiguna on 2/3/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "BaseViewController.h"
#import <MessageUI/MessageUI.h>
#import "Event.h"

@interface TicketListViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) UILabel *navTitle;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UILabel *eventTitle;
@property (nonatomic, strong) UILabel *eventVenue;
@property (nonatomic, strong) UILabel *eventDate;
@property (nonatomic, strong) UIImageView *eventImage;
@property (nonatomic, strong) EmptyView *emptyView;

@property (nonatomic, strong) NSString *eventID;
@property (nonatomic, strong) SharedData *sharedData;
@property (nonatomic, strong) NSDictionary *productList;
@property (nonatomic, strong) NSArray *purchases;
@property (nonatomic, strong) NSArray *reservations;
@property (nonatomic, assign) BOOL isNavBarShowing;

@end
