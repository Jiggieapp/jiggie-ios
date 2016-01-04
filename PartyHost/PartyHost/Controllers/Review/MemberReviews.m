//
//  ReviewScreen.m
//  PartyHost
//
//  Created by Tony Suriyathep on 5/12/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "MemberReviews.h"
#import "MemberReviewCell.h"
#import "AnalyticManager.h"

@implementation MemberReviews

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    self.sharedData = [SharedData sharedInstance];
    
    self.mainCon = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.sharedData.screenWidth, self.sharedData.screenHeight)];
    self.mainCon.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.90];
    self.mainCon.hidden = YES;
    [self addSubview:self.mainCon];
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(0,50,self.sharedData.screenWidth,30)];
    self.title.textColor = [UIColor whiteColor];
    self.title.font = [UIFont phBlond:20];
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.text = @"223 Reviews";
    [self.mainCon addSubview:self.title];
    
    self.btnExit = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnExit.frame = CGRectMake(0,self.sharedData.screenHeight - 50,self.sharedData.screenWidth,30);
    [self.btnExit.titleLabel setFont:[UIFont phBlond:20]];
    [self.btnExit setTitle:@"Exit" forState:UIControlStateNormal];
    [self.btnExit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnExit addTarget:self action:@selector(exitHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.mainCon addSubview:self.btnExit];
    
    //Create table
    self.reviewTable = [[UITableView alloc] initWithFrame:CGRectMake(self.sharedData.memberReviewSidePadding, self.title.frame.origin.x + self.title.frame.size.height + 60, self.sharedData.screenWidth - (self.sharedData.memberReviewSidePadding*2), self.sharedData.screenHeight - 150)];
    self.reviewTable.delegate = self;
    self.reviewTable.dataSource = self;
    self.reviewTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.reviewTable.allowsMultipleSelectionDuringEditing = NO;
    self.reviewTable.showsVerticalScrollIndicator = NO;
    self.reviewTable.allowsSelection = NO;
    self.reviewTable.backgroundColor = [UIColor clearColor];
    [self.mainCon addSubview:self.reviewTable];
    
    self.reviewData = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    dict1[@"message"] = @"Amtrak's Northeast Corridor, which runs between Washington and Boston, is North America's busiest railroad, with 11.6 million riders in fiscal year 2014. Every day, trains reaching speeds between 125 mph and 150 mph carry government officials, college students, people getting away for the weekend and corporate commuters along 363 miles of track.  Using sizeToFit resizes the textview but cuts some text from the bottom. Any idea how to resolve this?";
    dict1[@"first_name"] = @"Juan";
    dict1[@"review_date"] = @"May 2015";
    dict1[@"rating"] = [NSNumber numberWithFloat:arc4random() % 5];
    [self.reviewData addObject:dict1];
    
    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] init];
    dict2[@"message"] = @"To address this exact problem I made an auto-layout based light-weight UITextView subclass which automatically grows and shrinks based on the size of user input and can be constrained by maximal and minimal height - all without a single line of code.";
    dict2[@"first_name"] = @"Mary";
    dict2[@"review_date"] = @"August 2015";
    dict2[@"rating"] = [NSNumber numberWithFloat:arc4random() % 5];
    [self.reviewData addObject:dict2];
    
    NSMutableDictionary *dict3 = [[NSMutableDictionary alloc] init];
    dict3[@"message"] = @"Damn this review is short!";
    dict3[@"first_name"] = @"Scott";
    dict3[@"review_date"] = @"January 2015";
    dict3[@"rating"] = [NSNumber numberWithFloat:arc4random() % 5];
    [self.reviewData addObject:dict3];
    
    
    
    self.isLoaded = NO;
    
    
    //mainCon
    return self;
}

-(void)initClass
{
    
    [self reset];
    [self loadData];
    self.hidden = NO;
    [UIView animateWithDuration:0.15
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^
                    {
                        self.mainCon.alpha = 1;
                        self.mainCon.transform = CGAffineTransformMakeScale(1, 1);
                    }
                    completion:^(BOOL finished)
                    {
                        
                    }];
    
}

-(void)loadData
{
    ///host/reviews/list/
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    //@"%@/users/%@/hostings"
    //[manager.requestSerializer setValue:self.sharedData.ph_token forHTTPHeaderField:@"ph_token"];
    NSString *url = [NSString stringWithFormat:@"%@/%@/reviews/list/%@",PHBaseURL,self.sharedData.account_type,self.sharedData.member_fb_id];
    NSLog(@"MEMBER_REVIEWS URL :: %@",url);
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"MEMBER_REVIEWS RESPONSE :: %@",responseObject);
         
         [[AnalyticManager sharedManager] trackMixPanelWithDict:@"View Reviews" withDict:@{}];
         self.isLoaded = YES;
         if([responseObject count] > 0)
         {
             self.title.text = [NSString stringWithFormat:@"%d Review%@",(int)[responseObject count],([responseObject count] == 1)?@"":@"s"];
         }else
         {
             self.title.text = @"This person has no reviews";
         }
         [self.reviewData removeAllObjects];
         [self.reviewData addObjectsFromArray:responseObject];
         [self.reviewTable reloadData];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR :: %@",error);
     }];
}

-(void)reset
{
    self.title.text = @"loading...";
    self.isLoaded = NO;
    [self.reviewData removeAllObjects];
    [self.reviewTable reloadData];
    self.mainCon.hidden = YES;
    self.mainCon.alpha = 0;
    self.mainCon.transform = CGAffineTransformMakeScale(.75, .75);
    self.mainCon.hidden = NO;
}

-(void)exitHandler
{
    [UIView animateWithDuration:0.15
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^
     {
         self.mainCon.alpha = .25;
         self.mainCon.transform = CGAffineTransformMakeScale(.75, .75);
     }
                     completion:^(BOOL finished)
     {
         self.hidden = YES;
     }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* reuse = @"MemberReviewCell";
    NSMutableDictionary *data = [self.reviewData objectAtIndex:indexPath.row];
    MemberReviewCell *cell = [self.reviewTable dequeueReusableCellWithIdentifier:reuse];
    if (cell == nil) {cell = [[MemberReviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];}
    
    if(self.isLoaded)
    {
        [cell setReview:data];
    }else{
        [cell clearData];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reviewData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = 0;
    
    NSMutableDictionary *dict = [self.reviewData objectAtIndex:indexPath.row];
    
    UITextView *calculationView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth - (self.sharedData.memberReviewSidePadding*2), 0)];
    calculationView.font = [UIFont phBlond:self.sharedData.memberReviewFontSize];
    
    
    [calculationView setText:[dict objectForKey:@"message"]];
    [calculationView sizeToFit];
    /*
    NSString *text = [dict objectForKey:@"message"];
    
    
    CGFloat wrappingWidth = calculationView.bounds.size.width - (calculationView.textContainerInset.left + calculationView.textContainerInset.right + 2 * calculationView.textContainer.lineFragmentPadding);
    
    CGRect boundingRect = [text boundingRectWithSize:CGSizeMake(wrappingWidth, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{ NSFontAttributeName: calculationView.font }                                              context:nil];
    */
    
    h = calculationView.frame.size.height;
    
    //NSLog(@" __HEIGHT__ :: %f",h);
          
    
    return h + 60;
}


@end



