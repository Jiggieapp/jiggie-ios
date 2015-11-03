//
//  BookTableConfirm.m
//  PartyHost
//
//  Created by Tony Suriyathep on 7/15/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "BookTable.h"
#import "BookTableConfirm.h"
#import "BookTableDetailsCell.h"
#import "BookTableConfirmCreditCell.h"

#define CELL_HEIGHT 64
#define CELLS_SHOWN 2

@implementation BookTableConfirm
{
    long maxCellsShown;
    long cellsShown;
    NSMutableArray *purchaseConfirmations;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor phPurpleColor];
    
    self.sharedData = [SharedData sharedInstance];
    
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
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, self.sharedData.screenWidth-32, 32)];
    self.title.text = @"Confirm your table details";
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.adjustsFontSizeToFitWidth = YES;
    self.title.textColor = [UIColor whiteColor];
    self.title.font = [UIFont phBlond:20];
    [self.centerText addSubview:self.title];
    
    self.subtitle = [[UILabel alloc] initWithFrame:CGRectMake(16, self.title.frame.origin.y + self.title.frame.size.height + 4, self.sharedData.screenWidth-32, 16)];
    self.subtitle.text = @"...";
    self.subtitle.adjustsFontSizeToFitWidth = YES;
    self.subtitle.textAlignment = NSTextAlignmentCenter;
    self.subtitle.adjustsFontSizeToFitWidth = YES;
    self.subtitle.textColor = [UIColor whiteColor];
    self.subtitle.font = [UIFont phBlond:14];
    [self.centerText addSubview:self.subtitle];
    
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
    
    self.agreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.tableView.frame.origin.y  - 24, self.sharedData.screenWidth/2, 12)];
    self.agreeLabel.text = @"I AGREE THAT";
    self.agreeLabel.textAlignment = NSTextAlignmentLeft;
    self.agreeLabel.textColor = [UIColor whiteColor];
    self.agreeLabel.adjustsFontSizeToFitWidth = YES;
    self.agreeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.agreeLabel.font = [UIFont phBlond:12];
    [self addSubview:self.agreeLabel];
    
    self.tableSeparator = [[UIView alloc] initWithFrame:CGRectMake(0,self.tableView.frame.origin.y-1,self.sharedData.screenWidth,1)];
    self.tableSeparator.backgroundColor = [UIColor colorWithWhite:1 alpha:0.05];
    [self addSubview:self.tableSeparator];
    
    //Create big HOST HERE button
    self.btnPurchase = [UIButton buttonWithType:UIButtonTypeCustom];
    //[self.btnPurchase setImage:[UIImage imageNamed:@"gray_arrow_right"] forState:UIControlStateNormal];
    //[self.btnPurchase setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    //[self.btnPurchase.imageView setContentMode:UIViewContentModeScaleAspectFit];
    self.btnPurchase.frame = CGRectMake(0, self.sharedData.screenHeight - PHButtonHeight, self.sharedData.screenWidth, PHButtonHeight);
    self.btnPurchase.titleLabel.font = [UIFont phBold:16];
    [self.btnPurchase setTitleEdgeInsets:UIEdgeInsetsMake(3,0,0,0)];
    [self.btnPurchase setTitle:@"CLICK HERE TO PURCHASE" forState:UIControlStateNormal];
    [self.btnPurchase setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnPurchase setBackgroundColor:[UIColor phBlueColor]];
    [self.btnPurchase addTarget:self action:@selector(btnPurchaseClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnPurchase];
    
    purchaseConfirmations = [[NSMutableArray alloc] init]; //Array of all the types of purchases
    self.checkmarkPurchases = [[NSMutableArray alloc] init]; //Array of UI checkmarks
    self.checkmarkValues = [[NSMutableArray alloc] init]; //Values of those UI checkmarks
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(creditCardComplete)
     name:@"GO_CREDIT_CARD_COMPLETE"
     object:nil];
    
    return self;
}

//They changed their credit card
-(void)creditCardComplete {
    [self.tableView reloadData];
}

-(void)initClass
{
    if([self.sharedData.cFillType isEqualToString:@"reservation"])
    {
        [self.btnPurchase setTitle:@"CLICK HERE TO RESERVE" forState:UIControlStateNormal];
    }else
    {
        [self.btnPurchase setTitle:@"CLICK HERE TO PURCHASE" forState:UIControlStateNormal];
    }
    
    
    //Smaller screen less rows to show
    if(self.sharedData.isIphone4) maxCellsShown = 4;
    else maxCellsShown = 5;
    
    //NSString *eventName = self.sharedData.eventDict[@"title"];
    NSString *venueName = self.sharedData.eventDict[@"venue_name"];
    NSString *eventStartDate = [Constants toTitleDate:self.sharedData.eventDict[@"start_datetime_str"]];
    
    purchaseConfirmations = self.sharedData.bookTable.selectedTicket[@"purchase_confirmations"];
    cellsShown = MIN(maxCellsShown,[purchaseConfirmations count] + 3);
    
    //Create a new array of bools for the checkmarks
    [self.checkmarkValues removeAllObjects];
    for(int i=0;i<[purchaseConfirmations count];i++) {
        [self.checkmarkValues addObject: [NSNumber numberWithBool:NO] ];
    }
    
    self.centerText.frame = CGRectMake(0, 50 + ((self.sharedData.screenHeight-PHButtonHeight-(CELL_HEIGHT*cellsShown)-50)/2)-((32+16+8)/2)-16, self.sharedData.screenWidth, 32+16+8);
    
    self.tableView.frame = CGRectMake(0, self.sharedData.screenHeight - PHButtonHeight - (CELL_HEIGHT*cellsShown), self.sharedData.screenWidth, CELL_HEIGHT*cellsShown );
    
    self.agreeLabel.frame = CGRectMake(20, self.tableView.frame.origin.y  - 24, self.sharedData.screenWidth/2, 12);
    
    self.tableSeparator.frame = CGRectMake(0,self.tableView.frame.origin.y-1,self.sharedData.screenWidth,1);
    
    self.subtitle.text = [NSString stringWithFormat:@"on %@, at %@",eventStartDate,venueName];
    [self.tableView reloadData];
    
    
    NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
    [tmpDict addEntriesFromDictionary:self.sharedData.mixPanelCEventDict];
    [tmpDict addEntriesFromDictionary:self.sharedData.bookTable.selectedTicket];
    
    [self.sharedData trackMixPanelWithDict:@"Ticket Details Purchase Confirmation View" withDict:tmpDict];
    
    

}

-(void)btnCancelClicked
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"GO_BOOKTABLE_DETAILS"
     object:self];
}

-(void)btnHelpClicked
{
    [self.sharedData.bookTable helpSMS];
}

-(void)btnPurchaseClicked:(UIButton *)button
{
    [self goComplete];
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
    
    if(indexPath.row==0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookTableConfirm0"];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BookTableConfirm0"];
            
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            self.checkmarkAgree = [[SelectionCheckmark alloc] initWithFrame:CGRectMake(20,CELL_HEIGHT/2 - 32/2,32,32)];
            self.checkmarkAgree.inactiveColor = [UIColor darkGrayColor];
            self.checkmarkAgree.innerColor = [UIColor phGreenColor];
            self.checkmarkAgree.userInteractionEnabled = NO;
            [self.checkmarkAgree buttonSelect:NO animated:NO];
            [cell addSubview:self.checkmarkAgree];
            
            UILabel *checklabel = [[UILabel alloc] initWithFrame:CGRectMake(20+32+16, 2, self.sharedData.screenWidth - 20-32-16, CELL_HEIGHT)];
            checklabel.text = @"All bookings are final.";
            checklabel.textAlignment = NSTextAlignmentLeft;
            checklabel.textColor = [UIColor darkGrayColor];
            checklabel.adjustsFontSizeToFitWidth = YES;
            checklabel.lineBreakMode = NSLineBreakByTruncatingTail;
            checklabel.font = [UIFont phBlond:13];
            [cell addSubview:checklabel];
        }
        
        return cell;
    }
    else if(indexPath.row < (1+[purchaseConfirmations count]) )
    {
        long index = indexPath.row - 1;
        NSString *reuse = [NSString stringWithFormat:@"BookTableConfirmPurchase%ld",index];
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        
        cell.backgroundColor = [UIColor phDarkBodyColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        SelectionCheckmark *checkmark = [[SelectionCheckmark alloc] initWithFrame:CGRectMake(20,CELL_HEIGHT/2 - 32/2,32,32)];
        checkmark.inactiveColor = [UIColor darkGrayColor];
        checkmark.innerColor = [UIColor phGreenColor];
        checkmark.userInteractionEnabled = NO;
        [checkmark buttonSelect:[self.checkmarkValues[index] boolValue] animated:NO];
        [cell addSubview:checkmark];
        self.checkmarkPurchases[index] = checkmark;
        
        UILabel *checklabel = [[UILabel alloc] initWithFrame:CGRectMake(20+32+16, 2, self.sharedData.screenWidth - 20-32-16, CELL_HEIGHT)];
        checklabel.text = purchaseConfirmations[index][@"body"];
        checklabel.textAlignment = NSTextAlignmentLeft;
        checklabel.textColor = [UIColor darkGrayColor];
        checklabel.adjustsFontSizeToFitWidth = YES;
        checklabel.lineBreakMode = NSLineBreakByTruncatingTail;
        checklabel.numberOfLines = 2;
        checklabel.font = [UIFont phBlond:13];
        [cell addSubview:checklabel];
        
        return cell;
    }
    else if(indexPath.row == ([purchaseConfirmations count]+1) )
    {
        BookTableConfirmCreditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookTableConfirm2"];
        if (cell == nil)
        {
            cell = [[BookTableConfirmCreditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BookTableConfirm2"];
        }

        if([self.sharedData.ccLast4 length]>0) cell.note.text = [NSString stringWithFormat:@"•••• %@",self.sharedData.ccLast4];
        else cell.note.text = @"N/A";
        
        if([self.sharedData.cFillType isEqualToString:@"reservation"])
        {
            cell.hidden = YES;
        }
        
        return cell;
    }
    else if(indexPath.row == ([purchaseConfirmations count]+2) )
    {
        BookTableDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookTableConfirm1"];
        if (cell == nil)
        {
            cell = [[BookTableDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BookTableConfirm1"];
        }
        
        NSMutableDictionary *dict = self.sharedData.bookTable.selectedTicket;
        float price = [dict[@"total"] floatValue];
        
        //NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        //[numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
        //NSString *priceAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:price]];
        
        cell.title.text = @"ESTIMATED TOTAL";
        //cell.cost.text = priceAsString;
        cell.cost.text = [NSString stringWithFormat:@"$%0.0f",price];
        cell.note.text = @"Pay at venue";
        if([self.sharedData.cFillType isEqualToString:@"reservation"])
        {
            cell.note.text = @"Pay at venue";
        }
        
        return cell;
    }
    
    return nil;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [purchaseConfirmations count] + 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    if(indexPath.row==0)
    {
        [self.checkmarkAgree buttonSelect:!self.checkmarkAgree.isSelected animated:YES];
    }
    else if(indexPath.row < (1 + [purchaseConfirmations count]))
    {
        long index = indexPath.row - 1;
        SelectionCheckmark *checkmark = self.checkmarkPurchases[index];
        
        BOOL b = ![self.checkmarkValues[index] boolValue];
        self.checkmarkValues[index] = [NSNumber numberWithBool:b];
        
        [checkmark buttonSelect:b animated:YES];
    }
    else if(indexPath.row == (1 + [purchaseConfirmations count]))
    {
        if([self.sharedData.ccLast4 length]>0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Credit Card" message:@"Change your credit card?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Change",nil];
            alert.tag = 0;
            [alert show];
            return;
        }
        else
        {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"SHOW_CREDIT_CARD"
             object:self];
        }
    }
    else
    {
        [self goComplete];
    }
}

-(void)goComplete
{
    //Check agreement checkmark
    if(self.checkmarkAgree.isSelected==NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"All Bookings Are Final" message:@"You must agree to continue." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
        [alert show];
        return;
    }
    
    //Check purchases checkmark
    if([purchaseConfirmations count]>0)
    {
        for(int i=0;i<[self.checkmarkValues count];i++)
        {
            if([self.checkmarkValues[i] boolValue] ==NO)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase Agreement" message:@"You must agree to all purchase agreements to continue." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
                [alert show];
                return;
            }
        }
    }
    
    //Check credit card if([self.sharedData.cFillType isEqualToString:@"reservation"])
    if([self.sharedData.ccLast4 length]<=0 && ![self.sharedData.cFillType isEqualToString:@"reservation"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Credit Card" message:@"Enter a new credit card?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Enter",nil];
        alert.tag = 0;
        [alert show];
        return;
    }
    
    [self saveBookTable];
}

-(void)saveBookTable
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"SHOW_LOADING"
     object:self];
    
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
    [tmpDict addEntriesFromDictionary:self.sharedData.mixPanelCEventDict];
    [tmpDict addEntriesFromDictionary:self.sharedData.bookTable.selectedTicket];
    
    NSString *url = [Constants ticketAddURL:self.sharedData.fb_id event_id:self.sharedData.eventDict[@"_id"]];
    NSDictionary *params = @{@"ticket_type_id": self.sharedData.bookTable.selectedTicket[@"_id"]};
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"EVENT_PRODUCT_BUY_RESPONSE :: %@",responseObject);
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         
         
         if(![responseObject[@"success"] boolValue]) {

            [self.sharedData trackMixPanelWithDict:@"Ticket Purchase Fail" withDict:tmpDict];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Booking" message:responseObject[@"reason"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
             
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"HIDE_LOADING"
              object:self];
             
             return;
         }
         else {
             
             
             
             [self.sharedData trackMixPanelWithDict:@"Ticket Purchase Success" withDict:tmpDict];
             
             
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"GO_BOOKTABLE_COMPLETE"
              object:self];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR :: %@",error);
         NSLog(@"%@",operation.responseString);
         NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
         id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         
         [self.sharedData trackMixPanelWithDict:@"Ticket Purchase Fail" withDict:tmpDict];
         
         [[NSNotificationCenter defaultCenter]
          postNotificationName:@"HIDE_LOADING"
          object:self];
         
         if([operation.response statusCode] == 409)
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:json[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
         else{
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unknown error." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
     }];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 0 && buttonIndex == 1)
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"SHOW_CREDIT_CARD"
         object:self];
    }
}


@end
