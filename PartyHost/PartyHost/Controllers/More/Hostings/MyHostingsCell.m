//
//  MyHostingsCell.m
//  PartyHost
//
//  Created by Sunny Clark on 2/4/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "MyHostingsCell.h"

#define DATE_SHORT_DISPLAY @"MMM d, yyyy h:mm a" //This comes from the server when reading

@implementation MyHostingsCell

- (void)awakeFromNib
{
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.sharedData = [SharedData sharedInstance];
        
        self.imgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        self.imgIcon.image = [UIImage imageNamed:@"daycalendar"];
        [self addSubview:self.imgIcon];
        
        self.month = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 50, 20)];
        self.month.textColor = [UIColor blackColor];
        self.month.textAlignment = NSTextAlignmentCenter;
        self.month.font = [UIFont phBold:12];
        self.month.backgroundColor = [UIColor clearColor];
        self.month.text = @"";
        [self addSubview:self.month];
        
        self.day = [[UILabel alloc] initWithFrame:CGRectMake(10, 37, 50, 20)];
        self.day.textColor = [UIColor blackColor];
        self.day.textAlignment = NSTextAlignmentCenter;
        self.day.font = [UIFont phBold:12];
        self.day.backgroundColor = [UIColor clearColor];
        self.day.text = @"";
        [self addSubview:self.day];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(70, 16, self.frame.size.width - 100, 20)];
        self.title.textColor = [UIColor blackColor];
        self.title.textAlignment = NSTextAlignmentLeft;
        self.title.font = [UIFont phBold:18];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.text = @"";
        [self addSubview:self.title];
        
        self.subtitle = [[UILabel alloc] initWithFrame:CGRectMake(70, 38, self.frame.size.width - 100, 20)];
        self.subtitle.textColor = [UIColor grayColor];
        self.subtitle.textAlignment = NSTextAlignmentLeft;
        self.subtitle.font = [UIFont phBlond:14];
        self.subtitle.backgroundColor = [UIColor clearColor];
        self.subtitle.text = @"";
        [self addSubview:self.subtitle];
        
        
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.spinner.frame = CGRectMake(0, 0, self.sharedData.screenWidth, 70);
    }
    return self;
}

-(void)showLoading
{
    self.day.hidden = self.month.hidden = self.imgIcon.hidden = self.subtitle.hidden = self.title.hidden = YES;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.text = @"";
    self.accessoryType = UITableViewCellAccessoryNone;
    [self.spinner startAnimating];
    [self addSubview:self.spinner];
}

-(void)showNone
{
    self.day.hidden = self.month.hidden = self.imgIcon.hidden = self.subtitle.hidden = self.title.hidden = YES;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.text = @"You have no hostings";
    self.accessoryType = UITableViewCellAccessoryNone;
}

-(void)hideLoading
{
    self.day.hidden = self.month.hidden = self.imgIcon.hidden = self.subtitle.hidden = self.title.hidden = NO;
    self.textLabel.text = @"";
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.tintColor = [UIColor blackColor];
    //self.accessoryType = UITableviewcell
    [self.spinner stopAnimating];
    [self.spinner removeFromSuperview];
}

-(void)loadData:(NSDictionary *)dict
{
    self.data = dict;
    
    //Get start date from string
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [format setDateFormat:DATE_SHORT_DISPLAY];
    NSDate *startDate = [format dateFromString:dict[@"start_datetime_str"]];
    
    self.title.text = dict[@"event"][@"title"];
    self.subtitle.text = dict[@"description"];

    //Show month on icon as MMM
    NSDateFormatter *monthFormat = [[NSDateFormatter alloc] init];
    [monthFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [monthFormat setDateFormat:@"MMM"];
    self.month.text = [[monthFormat stringFromDate:startDate] uppercaseString];
    
    //Show day on icon as ##
    NSDateFormatter *dayFormat = [[NSDateFormatter alloc] init];
    [dayFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dayFormat setDateFormat:@"dd"];
    self.day.text = [dayFormat stringFromDate:startDate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
