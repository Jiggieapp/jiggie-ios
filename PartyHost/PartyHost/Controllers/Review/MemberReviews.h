//
//  ReviewScreen.h
//  PartyHost
//
//  Created by Tony Suriyathep on 5/12/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberReviews : UIView<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (strong, nonatomic) SharedData    *sharedData;

@property (strong, nonatomic) UIView        *mainCon;

@property (strong, nonatomic) UIButton      *btnExit;

@property (strong, nonatomic) UILabel       *title;

@property(nonatomic,strong) UITableView         *reviewTable;
@property(nonatomic,strong) NSMutableArray      *reviewData;


@property(nonatomic,assign) BOOL            isLoaded;


-(void)initClass;
-(void)reset;
-(void)loadData;
-(void)exitHandler;

@end
