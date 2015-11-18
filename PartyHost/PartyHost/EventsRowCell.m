//
//  EventsRowCell.m
//  PartyHost
//
//  Created by Sunny Clark on 2/12/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "EventsRowCell.h"

@implementation EventsRowCell

#define PROFILE_PICS 4 //If more than 4 then last is +MORE
#define PROFILE_SIZE 40
#define PROFILE_PADDING 8
//#define triHeight 10
//#define triWidth 20

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.sharedData = [SharedData sharedInstance];
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.visiblePopTipViews = [[NSMutableArray alloc] init];
        
        self.infoA = [[NSMutableArray alloc] init];
        self.btnsA = [[NSMutableArray alloc] init];
        self.cancelImagesA = [[NSMutableArray alloc] init];
        self.cPicIndex = -1;
        
        CGFloat heightRatio = 3.0 / 4.0;
        self.mainImg = [[PHImage alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.screenWidth * heightRatio)];
        self.mainImg.contentMode = UIViewContentModeScaleAspectFill;
        self.mainImg.layer.masksToBounds = YES;
        [self addSubview:self.mainImg];
        
        self.dimView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mainImg.bounds.size.width, self.mainImg.bounds.size.height)];
        self.dimView.backgroundColor = [UIColor blackColor];
        self.dimView.alpha = 0.5;
        self.dimView.hidden = YES;
        [self addSubview:self.dimView];
        
        self.date = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.mainImg.frame) + 10, self.sharedData.screenWidth - 20, 18)];
        self.date.textColor = [UIColor blackColor];
        self.date.adjustsFontSizeToFitWidth = YES;
        self.date.textAlignment = NSTextAlignmentLeft;
        self.date.font = [UIFont phThin:18];
        [self addSubview:self.date];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.date.frame) , self.sharedData.screenWidth - 20, 20)];
        self.title.textColor = [UIColor blackColor];
        self.title.textAlignment = NSTextAlignmentLeft;
        self.title.adjustsFontSizeToFitWidth = YES;
        self.title.font = [UIFont phBold:19];
        [self addSubview:self.title];
        
        self.subtitle = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.title.frame), self.sharedData.screenWidth - 20, 18)];
        self.subtitle.textColor = [UIColor blackColor];
        self.subtitle.adjustsFontSizeToFitWidth = YES;
        self.subtitle.textAlignment = NSTextAlignmentLeft;
        self.subtitle.font = [UIFont phThin:18];
        [self addSubview:self.subtitle];
        
        self.tagsView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.subtitle.frame) + 2, self.sharedData.screenWidth, 20)];
        self.tagsView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.tagsView];
        
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.spinner setColor:[UIColor whiteColor]];
        self.spinner.frame = CGRectMake(0, 0, self.sharedData.screenWidth, 75);
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(clearData)
         name:@"APP_UNLOADED"
         object:nil];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.dimView.hidden = !highlighted;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)clearData
{
    self.cPicIndex = -1;
    [self.infoA removeAllObjects];
    [self.btnsA removeAllObjects];
    [self.cancelImagesA removeAllObjects];
    [self dismissAllPopTipViews];
}

-(void)tapHandler:(UILongPressGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        self.sharedData.cHost_index = self.cPicIndex;
        UITableView *TV = [self parentTableView];
        NSIndexPath *indexPath = [TV indexPathForCell:self];
        self.sharedData.cHost_index_path = indexPath;
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"EVENTS_PRESELECT"
         object:self];
    }
}

-(void)goPreselect
{
    self.sharedData.cHost_index = self.cPicIndex;
    UITableView *TV = [self parentTableView];
    NSIndexPath *indexPath = [TV indexPathForCell:self];
    self.sharedData.cHost_index_path = indexPath;
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EVENTS_PRESELECT"
     object:self];
}

-(void)showLoading
{
    self.title.text = self.subtitle.text = @"";
    self.mainImg.image = nil;
    [self dismissAllPopTipViews];
    [self.spinner startAnimating];
    [self addSubview:self.spinner];
}

-(void)hideLoading
{
    [self.spinner stopAnimating];
    [self.spinner removeFromSuperview];
}

-(void)loadData:(NSDictionary *)dict
{
    self.title.text = [dict[@"title"] uppercaseString];
    self.subtitle.text = [dict[@"venue_name"] capitalizedString];
    
    // Format date layout
//    NSDateFormatter *serverFormatter = [[NSDateFormatter alloc] init];
//    [serverFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
//    [serverFormatter setDateFormat: @"yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"];
//    NSDate *startDateTime = [serverFormatter dateFromString:dict[@"start_datetime"]];
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"EEE, MMM dd, hh:mm a"];
//    self.date.text = [dateFormatter stringFromDate:startDateTime];
    
    self.date.text = dict[@"start_datetime_str"];
    
    self.picURL = [Constants eventImageURL:dict[@"_id"]];
    
    //Load venue image
    [self.mainImg loadImage:self.picURL defaultImageNamed:@"nightclub_default"]; //This will load and can be cancelled?
    
    //remove all tags
    NSArray *viewsToRemove = [self.tagsView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    NSMutableArray *tags = [NSMutableArray arrayWithArray:[dict objectForKey:@"tags"]];
    if (self.isFeaturedEvent) {
        [tags insertObject:@"Featured" atIndex:0];
    }
    
    int currX = 0;
    for (NSString *tag in tags) {
        UIButton *tagPil = [[UIButton alloc] initWithFrame:CGRectMake(currX, 0, 80, 20)];
        tagPil.enabled = NO;
        tagPil.titleLabel.font = [UIFont phBlond:13];
        tagPil.titleEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0);
        [tagPil setTitle:tag forState:UIControlStateNormal];
        //        tagPil.layer.borderWidth = 1.0;
        //        tagPil.layer.borderColor = [UIColor darkGrayColor].CGColor;
        [tagPil setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        tagPil.layer.cornerRadius = 10;
        [self addSubview:tagPil];
        
        if ([tag isEqualToString:@"Featured"]) {
            tagPil.backgroundColor = [UIColor colorFromHexCode:@"D9603E"];
        } else if ([tag isEqualToString:@"Music"]) {
            tagPil.backgroundColor = [UIColor colorFromHexCode:@"5E3ED9"];
        } else if ([tag isEqualToString:@"Nightlife"]) {
            tagPil.backgroundColor = [UIColor colorFromHexCode:@"4A555A"];
        } else if ([tag isEqualToString:@"Food & Drink"]) {
            tagPil.backgroundColor = [UIColor colorFromHexCode:@"DDC54D"];
        } else if ([tag isEqualToString:@"Fashion"]) {
            tagPil.backgroundColor = [UIColor colorFromHexCode:@"68CE49"];
        } else {
            tagPil.backgroundColor = [UIColor colorFromHexCode:@"10BBFF"];
        }
        
        CGSize resizePill =  [self.sharedData sizeForLabelString:[tagPil titleForState:UIControlStateNormal]
                                                        withFont:tagPil.titleLabel.font
                                                      andMaxSize:CGSizeMake(120, tagPil.bounds.size.height)];
        [tagPil setFrame:CGRectMake(tagPil.frame.origin.x, tagPil.frame.origin.y, resizePill.width + 14, resizePill.height + 7)];
        
        currX = CGRectGetMaxX(tagPil.frame);
        if (currX < self.contentView.bounds.size.width) {
            [self.tagsView addSubview:tagPil];
        }
        currX = currX + 8;
    }
}

- (void)prepareForReuse
{
    //[self clearData];
}


-(UITableView *)parentTableView {
    // iterate up the view hierarchy to find the table containing this cell/view
    UIView *aView = self.superview;
    while(aView != nil) {
        if([aView isKindOfClass:[UITableView class]]) {
            return (UITableView *)aView;
        }
        aView = aView.superview;
    }
    return nil; // this view is not within a tableView
}

- (void)dismissAllPopTipViews
{
    while ([self.visiblePopTipViews count] > 0)
    {
        CMPopTipView *popTipView = [self.visiblePopTipViews objectAtIndex:0];
        [popTipView dismissAnimated:NO];
        [self.visiblePopTipViews removeObjectAtIndex:0];
    }
}

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
    [self.visiblePopTipViews removeObject:popTipView];
    self.currentPopTipViewTarget = nil;
}

-(void)wentOffscreen
{
    [self.mainImg cancelImage];
    for (int i=0; i<[self.cancelImagesA count]; i++) {
        NWURLConnection *connection = self.cancelImagesA[i];
        [connection cancel];
    }
}

@end
