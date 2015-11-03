//
//  MyPurchases.m
//  PartyHost
//
//  Created by Tony Suriyathep on 7/22/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "MyPurchases.h"

@implementation MyPurchases

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    self.sharedData = [SharedData sharedInstance];
    self.mainCon = [[UIView alloc] initWithFrame:CGRectMake(0, 60, self.sharedData.screenWidth * 2, self.sharedData.screenHeight - 100)];
    [self addSubview:self.mainCon];
    
    self.tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 60)];
    self.tabBar.backgroundColor = [UIColor phLightTitleColor];
    [self addSubview:self.tabBar];
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, frame.size.width, 40)];
    self.title.text = @"PURCHASES";
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.textColor = [UIColor whiteColor];
    self.title.font = [UIFont phBold:21];
    [self.tabBar addSubview:self.title];
    
    self.btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnBack.frame = CGRectMake(0, 13, 50, 50);
    [self.btnBack setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [self.btnBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.btnBack.hidden = YES;
    [self.tabBar addSubview:self.btnBack];
    
    self.tableData = [[NSMutableArray alloc] init];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 60)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.hidden = YES;
    [self.mainCon addSubview:self.tableView];
    
    //Create empty label
    self.labelEmpty = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.screenHeight)];
    self.labelEmpty.text = @"No purchases yet.";
    self.labelEmpty.textAlignment = NSTextAlignmentCenter;
    self.labelEmpty.textColor = [UIColor lightGrayColor];
    self.labelEmpty.hidden = YES;
    self.labelEmpty.font = [UIFont phBlond:16];
    [self addSubview:self.labelEmpty];
    
    return self;
}

-(void)initClass
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    self.tableView.contentOffset = CGPointMake(0, 0);
    
    self.isLoaded = NO;
    self.tableView.hidden = YES;
    [self.tableData removeAllObjects];
    [self.tableView reloadData];
    
    //Start over
    self.labelEmpty.hidden = YES;
    
    [self loadData];
}

-(void)reset
{

}

-(void)loadData
{
    [self reset];
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    NSString *url = [Constants ordersAllURL:self.sharedData.fb_id];
    
    NSLog(@"ORDERS_ALL_URL :: %@",url);
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"ORDERS_ALL_RESPONSE :: %@",responseObject);

         self.isLoaded = YES;
         [self.tableData removeAllObjects];
         [self.tableData addObjectsFromArray:responseObject];
         [self.tableView reloadData];
         
         if([self.tableData count]>0)
         {
             self.labelEmpty.hidden = YES;
             self.tableView.hidden = NO;
         }
         else{
             self.labelEmpty.hidden = NO;
             self.tableView.hidden = YES;
         }
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"EVENTS_HOSTINGS_LIST_ERROR :: %@",error);
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
     }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MyConfirmationsCell";
    
    MyPurchasesCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[MyPurchasesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }

    NSDictionary *dict = [self.tableData objectAtIndex:indexPath.row];
    [cell loadData:dict];
    
    return cell;
}

//This is "My Hostings" and you can select a row to EDIT
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
}

@end
