//
//  Events.h
//  PartyHost
//
//  Created by Sunny Clark on 12/26/14.
//  Copyright (c) 2014 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventsHeader.h"
#import "EventsRowCell.h"
#import "EventsHostingsList.h"
#import "EventsGuestList.h"
#import "EventsVenueDetail.h"
#import "EventsHostDetail.h"
#import "EventsSummary.h"
#import "PHImage.h"

@interface Events : UIView<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) SharedData    *sharedData;


@property(nonatomic,strong) UIView              *tabBar;
@property(nonatomic,strong) UILabel             *title;
@property(nonatomic,strong) UIView              *mainCon;
@property(nonatomic,strong) NSMutableArray      *eventsA;
@property(nonatomic,strong) UITableView         *eventsList;
@property(nonatomic,assign) BOOL                isEventsLoaded;
@property(nonatomic,assign) BOOL                isLoading;
@property(nonatomic,assign) BOOL                didLoadFromHostings;
@property(nonatomic,assign) BOOL                didLoadFromInvite;
@property(nonatomic,strong) EventsSummary       *eventsSummary;
@property(nonatomic,strong) EventsHostingsList  *eventsHostingsList;
@property(nonatomic,strong) EventsGuestList     *eventsGuestList;
@property(nonatomic,strong) EventsVenueDetail   *eventsVenueDetail;
@property(nonatomic,strong) EventsHostDetail    *eventsHostDetail;
@property(nonatomic,strong) NSString            *cName;


@property(nonatomic,strong) UIView              *whiteBK;

@property(nonatomic,strong) NSIndexPath         *cGuestListingIndexPath;

//When there are no entries to see
@property(nonatomic,strong) EmptyView *emptyView;

@property (strong, nonatomic) UIButton *btnCity;

-(void)initClass;
-(void)resetApp;
-(void)eventsPreSelectHandler;
-(void)askAboutInvite;
@end
