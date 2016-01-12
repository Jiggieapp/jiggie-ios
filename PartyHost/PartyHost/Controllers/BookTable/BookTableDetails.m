//
//  BookTableDetails.m
//  PartyHost
//
//  Created by Tony Suriyathep on 7/15/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//


//isIphone4

#import "BookTable.h"
#import "BookTableDetails.h"
#import "AnalyticManager.h"

#define CELL_HEIGHT 64

@implementation BookTableDetails
{
    NSMutableDictionary *mainDict;
    float deposit;
    float price;
    float total;
    float tax;
    float tip;
    float tax_amount;
    float tip_amount;
    float admin_fee;
    long cellsShown;
    long maxCellsShown;
    NSMutableArray *detailsArray;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor phPurpleColor];
    
    self.sharedData = [SharedData sharedInstance];
    detailsArray = [[NSMutableArray alloc] init];
    
    UIView *tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 60)];
    tabBar.backgroundColor = [UIColor clearColor];
    [self addSubview:tabBar];
    
    //Cancel button
    self.btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnCancel.frame = CGRectMake(8, 15, 80, 50);
    self.btnCancel.titleLabel.font = [UIFont phBold:14];
    self.btnCancel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.btnCancel setTitle:@"BACK" forState:UIControlStateNormal];
    [self.btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnCancel addTarget:self action:@selector(btnCancelClicked) forControlEvents:UIControlEventTouchUpInside];
    [tabBar addSubview:self.btnCancel];
    
    //Help button
    self.btnHelp = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnHelp.frame = CGRectMake(self.sharedData.screenWidth - 80 - 8, 15, 80, 50);
    self.btnHelp.titleLabel.font = [UIFont phBold:14];
    self.btnHelp.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.btnHelp setTitle:@"HELP" forState:UIControlStateNormal];
    [self.btnHelp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnHelp addTarget:self action:@selector(btnHelpClicked) forControlEvents:UIControlEventTouchUpInside];
    [tabBar addSubview:self.btnHelp];
    
    self.centerText = [[UIView alloc] init];
    self.centerText.backgroundColor = [UIColor clearColor];
    [self addSubview:self.centerText];
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, self.sharedData.screenWidth-32, 28)];
    self.title.text = @"Hey Sam, here’s your table details";
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.adjustsFontSizeToFitWidth = YES;
    self.title.textColor = [UIColor whiteColor];
    self.title.font = [UIFont phBlond:20];
    [self.centerText addSubview:self.title];
    
    self.subtitle = [[UILabel alloc] initWithFrame:CGRectMake(16, self.title.frame.origin.y + self.title.frame.size.height, self.sharedData.screenWidth-32, 32)];
    self.subtitle.text = @"...";
    self.subtitle.adjustsFontSizeToFitWidth = YES;
    self.subtitle.textAlignment = NSTextAlignmentCenter;
    self.subtitle.adjustsFontSizeToFitWidth = YES;
    self.subtitle.textColor = [UIColor whiteColor];
    self.subtitle.font = [UIFont phBlond:14];
    [self.centerText addSubview:self.subtitle];
    
    self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, self.subtitle.frame.origin.y + self.subtitle.frame.size.height, self.sharedData.screenWidth-32, 24)];
    self.descriptionLabel.text = @"...";
    self.descriptionLabel.adjustsFontSizeToFitWidth = NO;
    self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.descriptionLabel.adjustsFontSizeToFitWidth = NO;
    self.descriptionLabel.textColor = [UIColor whiteColor];
    self.descriptionLabel.font = [UIFont phBlond:14];
    self.descriptionLabel.numberOfLines = 1;
    [self.centerText addSubview:self.descriptionLabel];
    
    //Create list
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor phDarkGrayColor];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.allowsSelection = YES;
    [self addSubview:self.tableView];
    
    self.tableSeparator = [[UIView alloc] init];
    self.tableSeparator.backgroundColor = [UIColor colorWithWhite:1 alpha:0.05];
    [self addSubview:self.tableSeparator];
    
    //Create big HOST HERE button
    self.btnHost = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnHost.frame = CGRectMake(0, self.sharedData.screenHeight - PHButtonHeight, self.sharedData.screenWidth, PHButtonHeight);
    self.btnHost.titleLabel.font = [UIFont phBold:16];
    [self.btnHost setTitleEdgeInsets:UIEdgeInsetsMake(3,0,0,0)];
    [self.btnHost setTitle:@"PURCHASE TABLE" forState:UIControlStateNormal];
    [self.btnHost setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnHost setBackgroundColor:[UIColor phBlueColor]];
    [self.btnHost addTarget:self action:@selector(btnHostClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnHost];
    
    return self;
}

-(void)initClass
{
    if([self.sharedData.cFillType isEqualToString:@"reservation"])
    {
        [self.btnHost setTitle:@"RESERVE TABLE" forState:UIControlStateNormal];
    }else{
        [self.btnHost setTitle:@"PURCHASE TABLE" forState:UIControlStateNormal];
    }
    
    mainDict = self.sharedData.bookTable.selectedTicket;
    if(mainDict==nil) return;
    
    //Smaller screen less rows to show
    if(self.sharedData.isIphone4) maxCellsShown = 4;
    else maxCellsShown = 5;
    
    //NSString *eventName = self.sharedData.eventDict[@"title"];
    NSString *venueName = self.sharedData.eventDict[@"venue_name"];
    NSString *eventStartDate = [Constants toTitleDate:self.sharedData.eventDict[@"start_datetime_str"]];
    
    self.title.text = [NSString stringWithFormat:@"Hey %@, here’s your table details",self.sharedData.userDict[@"first_name"]];
    self.subtitle.text = [NSString stringWithFormat:@"on %@, at %@",eventStartDate,venueName];
    self.descriptionLabel.text = mainDict[@"description"];
    [self.tableView reloadData];
    
    [detailsArray removeAllObjects];
    
    deposit = [mainDict[@"deposit"] floatValue];
    price = [mainDict[@"price"] floatValue];
    total = [mainDict[@"total"] floatValue];
    tax = [mainDict[@"tax"] floatValue];
    tip = [mainDict[@"tip"] floatValue];
    tax_amount = [mainDict[@"tax_amount"] floatValue];
    tip_amount = [mainDict[@"tip_amount"] floatValue];
    admin_fee = [mainDict[@"admin_fee"] floatValue];
    
    if(price>0) [detailsArray addObject:@"price"];
    if(deposit>0) [detailsArray addObject:@"deposit"];
    if(admin_fee>0) [detailsArray addObject:@"admin_fee"];
    if(tax>0) [detailsArray addObject:@"tax"];
    if(tip>0) [detailsArray addObject:@"tip"];
    if(total>0) [detailsArray addObject:@"total"];
    
    cellsShown = MIN(maxCellsShown,[detailsArray count]);
    
    self.centerText.frame = CGRectMake(0, 50 + ((self.sharedData.screenHeight-PHButtonHeight-(CELL_HEIGHT*cellsShown)-50)/2)-((28+32+24)/2), self.sharedData.screenWidth, 28+32+24);
    
    self.tableView.frame = CGRectMake(0, self.sharedData.screenHeight - PHButtonHeight - (CELL_HEIGHT*cellsShown), self.sharedData.screenWidth, CELL_HEIGHT*cellsShown );
    
    self.tableSeparator.frame = CGRectMake(0,self.tableView.frame.origin.y-1,self.sharedData.screenWidth,1);
    
    [self.tableView reloadData];
    
    
    
    
    NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
    [tmpDict addEntriesFromDictionary:self.sharedData.mixPanelCEventDict];
    [tmpDict addEntriesFromDictionary:self.sharedData.bookTable.selectedTicket];
    
    [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Ticket Details View" withDict:tmpDict];
}

-(void)btnCancelClicked
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"GO_BOOKTABLE_MAIN"
     object:self];
}

-(void)btnHelpClicked
{
    [self.sharedData.bookTable helpSMS];
}

-(void)btnHostClicked:(UIButton *)button
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"GO_BOOKTABLE_CONFIRM"
     object:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     "_id" = 55ab24cf36f986030000000b;
     active = active;
     "add_guest" = 5;
     "admin_fee" = "";
     "chk_adminfee" = 0;
     "chk_tax" = 0;
     "chk_tip" = 0;
     "created_at" = "2015-07-19T04:17:19.805Z";
     deposit = "";
     description = "super cool table";
     "event_id" = 55ab20ff36f9860300000004;
     guest = 2;
     "is_recurring" = 0;
     name = "Golden Booth";
     price = 100;
     "purchase_confirmations" =         (
     );
     quantity = 10;
     tax = "";
     "ticket_status" = active;
     "ticket_type" = reservation;
     tip = "";
     total = 1000;
     */
    
    BookTableDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookTableDetailsCell"];
    if (cell == nil)
    {
        cell = [[BookTableDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BookTableDetailsCell"];
    }
    if([detailsArray count]==0) return cell;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    
    NSString *nm = detailsArray[indexPath.row];
    
    if([nm isEqualToString:@"price"])
    {
        cell.title.text = @"PRICE";
        //cell.cost.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:price]];
        cell.cost.text = [NSString stringWithFormat:@"$%0.0f", price];
        cell.note.text = mainDict[@"name"];
    }
    else if([nm isEqualToString:@"deposit"])
    {
        cell.title.text = @"DEPOSIT";
        //cell.cost.text = [NSString stringWithFormat:@"%i%%",(int)deposit];
        cell.cost.text = [NSString stringWithFormat:@"$%0.0f", deposit];
        cell.note.text = @"Charged immediately";
    }
    else if([nm isEqualToString:@"admin_fee"])
    {
        cell.title.text = @"ADMINISTRATIVE FEE";
        //cell.cost.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:admin_fee]];
        cell.cost.text = [NSString stringWithFormat:@"$%0.0f", admin_fee];
        cell.note.text = @"Service charge";
    }
    else if([nm isEqualToString:@"tax"])
    {
        cell.title.text = [NSString stringWithFormat: @"TAX (%0.2f%%)", tax];
        cell.cost.text = [NSString stringWithFormat:@"$%0.0f",tax_amount];
        cell.note.text = @"Estimated tax";
    }
    else if([nm isEqualToString:@"tip"])
    {
        cell.title.text = [NSString stringWithFormat: @"TIP (%0.2f%%)", tip];
        cell.cost.text = [NSString stringWithFormat:@"$%0.0f",tip_amount];
        cell.note.text = @"Tip generously";
    }
    else if([nm isEqualToString:@"total"])
    {
        cell.title.text = @"ESTIMATED TOTAL";
        //cell.cost.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:total]];
        cell.cost.text = [NSString stringWithFormat:@"$%0.0f", total];
        cell.note.text = @"Pay at venue";
    }
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [detailsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    /*
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"GO_BOOKTABLE_CONFIRM"
     object:self];
     */
}

@end
