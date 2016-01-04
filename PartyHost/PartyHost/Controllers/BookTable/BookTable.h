//
//  BookTable.h
//  PartyHost
//
//  Created by Tony Suriyathep on 7/15/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookTableCell.h"
#import "BookTableDetails.h"
#import "BookTableComplete.h"
#import "BookTableOffering.h"
#import "BookTableOfferingCell.h"
#import "BookTableAbout.h"
#import "BookTableConfirm.h"
#import "BookTableComplete.h"
#import "BookTableHostingComplete.h"

@interface BookTable : UIView <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (strong, nonatomic) SharedData *sharedData;
@property (assign, nonatomic) BOOL isLoaded;
@property (strong, nonatomic) NSMutableArray *mainArray;
@property (strong, nonatomic) NSMutableArray *offeringArray;
@property (strong, nonatomic) NSMutableDictionary *selectedTicket;
@property (strong, nonatomic) NSString *hostingDescription;
@property (strong, nonatomic) NSString *event_id;
@property (assign, nonatomic) int offeringPath; //0=FromBookTable 1=FromAfterBuyingBookTable

//Screens
@property (strong, nonatomic) UIView *mainCon;
@property (strong, nonatomic) BookTableDetails *bookTableDetails;
@property (strong, nonatomic) BookTableConfirm *bookTableConfirm;
@property (strong, nonatomic) BookTableComplete *bookTableComplete;
@property (strong, nonatomic) BookTableOffering *bookTableOffering;
@property (strong, nonatomic) BookTableAbout *bookTableAbout;
@property (strong, nonatomic) BookTableHostingComplete *bookTableHostingComplete;

@property (strong, nonatomic) UIButton *btnCancel;
@property (strong, nonatomic) UIButton *btnHelp;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *subtitle;
@property (strong, nonatomic) SelectionCheckmark *check1;
@property (strong, nonatomic) SelectionCheckmark *check2;

@property (strong, nonatomic) UITableView *tableView;

//When there are no entries to see
@property(nonatomic,strong) EmptyView *emptyView;

-(void)initClass;
-(void)exitHandler;
-(void)reset;
-(void)loadData:(NSString*)event_id;
-(void)populateData:(NSMutableArray *)arr;
-(void)helpSMS;

@end
