//
//  BookTableOffering.m
//  PartyHost
//
//  Created by Tony Suriyathep on 7/17/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "BookTable.h"
#import "BookTableOffering.h"

@implementation BookTableOffering

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor phDarkBodyColor];
    
    self.sharedData = [SharedData sharedInstance];
    
    //Offerings
    self.mainArray = [[NSMutableArray alloc] init];
    [self.mainArray addObject:@{@"title":@"Drinks",@"tag":@"DRINKS",@"description":@"I've got you covered.  Drinks on me.",@"bg_color":@"50E3C2"}];
    [self.mainArray addObject:@{@"title":@"VIP Table",@"tag":@"VIP TABLE",@"description":@"Living the high life.",@"bg_color":@"C79D2D"}];
    [self.mainArray addObject:@{@"title":@"Skip Line",@"tag":@"SKIP LINE",@"description":@"We'll skip the line and walk in together.",@"bg_color":@"BD10E0"}];
    [self.mainArray addObject:@{@"title":@"Dinner",@"tag":@"DINNER",@"description":@"It's on me.",@"bg_color":@"4A90E2"}];
    [self.mainArray addObject:@{@"title":@"Taxi",@"tag":@"TAXI",@"description":@"Transport?  Yup.",@"bg_color":@"F5A623"}];
    
    UIView *tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 60)];
    tabBar.backgroundColor = [UIColor clearColor];
    [self addSubview:tabBar];
    
    //Cancel button
    self.btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnCancel.frame = CGRectMake(8, 15, 80, 50);
    self.btnCancel.titleLabel.font = [UIFont phBold:14];
    self.btnCancel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.btnCancel setTitle:@"BACK" forState:UIControlStateNormal];
    [self.btnCancel setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
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
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 76, self.sharedData.screenWidth, 40)];
    self.title.text = @"WHAT ARE YOU OFFERING?";
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.textColor = [UIColor whiteColor];
    self.title.font = [UIFont phBold:18];
    [self addSubview:self.title];
    
    self.subtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 105, self.sharedData.screenWidth, 40)];
    self.subtitle.text = @"Choose what you will be offering guests";
    self.subtitle.adjustsFontSizeToFitWidth = YES;
    self.subtitle.textAlignment = NSTextAlignmentCenter;
    self.subtitle.textColor = [UIColor colorWithWhite:1 alpha:0.50];
    self.subtitle.font = [UIFont phBlond:13];
    [self addSubview:self.subtitle];
    
    //Create list
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.subtitle.frame.size.height + self.subtitle.frame.origin.y + 16, self.sharedData.screenWidth, self.sharedData.screenHeight - (self.subtitle.frame.size.height + self.subtitle.frame.origin.y + 16) - PHButtonHeight )];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor phDarkBodyInactiveColor];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.allowsSelection = YES;
    self.tableView.hidden = NO;
    self.tableView.backgroundColor = [UIColor phDarkBodyColor];
    [self addSubview:self.tableView];
    
    UIView *separator1 = [[UIView alloc] initWithFrame:CGRectMake(0,self.tableView.frame.origin.y-1,self.sharedData.screenWidth,1)];
    separator1.backgroundColor = [UIColor colorWithWhite:1 alpha:0.05];
    [self addSubview:separator1];
    
    //Create big HOST HERE button
    self.btnContinue = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnContinue.frame = CGRectMake(0, self.sharedData.screenHeight - PHButtonHeight, self.sharedData.screenWidth, PHButtonHeight);
    self.btnContinue.titleLabel.font = [UIFont phBold:16];
    [self.btnContinue setTitleEdgeInsets:UIEdgeInsetsMake(3,0,0,0)];
    [self.btnContinue setTitle:@"CONTINUE TO DETAILS" forState:UIControlStateNormal];
    [self.btnContinue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnContinue setBackgroundColor:[UIColor phCyanColor]];
    [self.btnContinue addTarget:self action:@selector(btnContinueClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnContinue];
    
    return self;
}

-(void)btnCancelClicked
{
    if(self.sharedData.bookTable.offeringPath==0) { //Already has hosting
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"GO_BOOKTABLE_MAIN"
         object:self];
    }
    else if(self.sharedData.bookTable.offeringPath==1) { //After completing a booking
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"EXIT_BOOKTABLE"
         object:self];
    }
}

-(void)btnContinueClicked
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"GO_BOOKTABLE_ABOUT"
     object:self];
}

-(void)btnHelpClicked
{
    [self.sharedData.bookTable helpSMS];
}

-(void)initClass
{
    if(self.sharedData.bookTable.offeringPath==0) { //Already has hosting
        [self.btnCancel setTitle:@"BACK" forState:UIControlStateNormal];
    }
    else if(self.sharedData.bookTable.offeringPath==1) { //After completing a booking
        [self.btnCancel setTitle:@"CANCEL" forState:UIControlStateNormal];
    }
    
    NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
    [tmpDict addEntriesFromDictionary:self.sharedData.mixPanelCEventDict];
    //[tmpDict addEntriesFromDictionary:self.sharedData.bookTable.selectedTicket];
    
    [self.sharedData trackMixPanelWithDict:@"Add Hostings Offerings View" withDict:tmpDict];
}

-(void)reset
{
    [self.sharedData.bookTable.offeringArray removeAllObjects];
    self.tableView.contentOffset = CGPointZero;
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *reuse = [NSString stringWithFormat:@"BookTableOfferingCell%ld",indexPath.row];
    BookTableOfferingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (cell == nil)
    {
        cell = [[BookTableOfferingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    
    NSMutableDictionary *data = self.mainArray[indexPath.row];
    [cell populateData:data];
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mainArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    BookTableOfferingCell *cell = (BookTableOfferingCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    BOOL isSelected = !cell.check.isSelected;
    cell.check.isSelected = isSelected;
    [cell.check buttonSelect:isSelected animated:YES];
    
    NSString *n = cell.perk.titleLabel.text;
    if(isSelected) //Insert
    {
        BOOL found = false;
        for(int i=0;i<[self.sharedData.bookTable.offeringArray count];i++)
        {
            if([self.sharedData.bookTable.offeringArray[i] isEqualToString:n])
            {
                found = true;
                break;
            }
        }
        if(!found)
        {
            [self.sharedData.bookTable.offeringArray addObject:n];
        }
    }
    else //Delete
    {
        for(int i=0;i<[self.sharedData.bookTable.offeringArray count];i++)
        {
            if([self.sharedData.bookTable.offeringArray[i] isEqualToString:n])
            {
                [self.sharedData.bookTable.offeringArray removeObjectAtIndex:i];
                break;
            }
        }
    }
    
    NSLog(@"OFFERINGS: %@",[self.sharedData.bookTable.offeringArray componentsJoinedByString:@","]);
}

@end
