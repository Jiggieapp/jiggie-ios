//
//  EventsRowCell.m
//  PartyHost
//
//  Created by Sunny Clark on 2/12/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "EventsRowCell.h"
#import "UIImageView+WebCache.h"

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
        self.mainImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, self.sharedData.screenWidth * heightRatio)];
        self.mainImg.contentMode = UIViewContentModeScaleAspectFill;
        self.mainImg.layer.masksToBounds = YES;
        [self addSubview:self.mainImg];
        
        self.dimView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mainImg.bounds.size.width, self.mainImg.bounds.size.height)];
        self.dimView.backgroundColor = [UIColor blackColor];
        self.dimView.alpha = 0.5;
        self.dimView.hidden = YES;
        [self addSubview:self.dimView];
        
        self.infoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mainImg.frame) - 60, self.sharedData.screenWidth, 60)];
        [self addSubview:self.infoView];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 &&
            !UIAccessibilityIsReduceTransparencyEnabled()) {
            self.infoView.backgroundColor = [UIColor clearColor];
            
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            blurEffectView.frame = self.infoView.bounds;
            blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            [self.infoView addSubview:blurEffectView];
        } else {
            self.infoView.backgroundColor = [UIColor blackColor];
            self.infoView.alpha = 0.4;
        }
        
        self.startFromLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.mainImg.frame) - 50, self.sharedData.screenWidth - 20, 18)];
        self.startFromLabel.textColor = [UIColor whiteColor];
        self.startFromLabel.text = @"Starts From";
        self.startFromLabel.font = [UIFont phBlond:12];
        [self addSubview:self.startFromLabel];
        
        self.minimumPrice = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.mainImg.frame) - 32, self.sharedData.screenWidth - 20, 20)];
        self.minimumPrice.textColor = [UIColor whiteColor];
        self.minimumPrice.font = [UIFont phBold:18];
        [self addSubview:self.minimumPrice];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.mainImg.frame) + 14, self.sharedData.screenWidth - 20 - 70, 70)];
        self.title.textColor = [UIColor blackColor];
        self.title.textAlignment = NSTextAlignmentLeft;
        self.title.adjustsFontSizeToFitWidth = YES;
        self.title.font = [UIFont phBlond:16];
        self.title.numberOfLines = 3;
        [self addSubview:self.title];
        
        self.likeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth - 70, CGRectGetMaxY(self.mainImg.frame) + 8, 40, 40)];
        [self.likeButton setImage:[UIImage imageNamed:@"icon_love_on"] forState:UIControlStateNormal];
        [self.likeButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [self.likeButton setAdjustsImageWhenDisabled:NO];
        [self.likeButton setEnabled:NO];
        [self addSubview:self.likeButton];
        
        self.likeCount = [[UILabel alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth - 34, CGRectGetMaxY(self.mainImg.frame) + 16, 28, 20)];
        self.likeCount.textColor = [UIColor darkGrayColor];
        self.likeCount.adjustsFontSizeToFitWidth = YES;
        self.likeCount.textAlignment = NSTextAlignmentCenter;
        self.likeCount.font = [UIFont phBlond:13];
        [self addSubview:self.likeCount];
        
        self.date = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.title.frame), self.sharedData.screenWidth - 20, 20)];
        self.date.textColor = [UIColor darkGrayColor];
        self.date.adjustsFontSizeToFitWidth = YES;
        self.date.textAlignment = NSTextAlignmentLeft;
        self.date.font = [UIFont phBlond:15];
        [self addSubview:self.date];
        
        self.subtitle = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.date.frame), self.sharedData.screenWidth - 20, 20)];
        self.subtitle.textColor = [UIColor darkGrayColor];
        self.subtitle.adjustsFontSizeToFitWidth = YES;
        self.subtitle.textAlignment = NSTextAlignmentLeft;
        self.subtitle.font = [UIFont phBlond:15];
        [self addSubview:self.subtitle];
        
        self.tagsView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.subtitle.frame) + 8, self.sharedData.screenWidth, 20)];
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

-(void)loadData:(Event *)event
{
    
    self.title.text = [event.title uppercaseString];
    self.title.frame = CGRectMake(10, CGRectGetMaxY(self.mainImg.frame) + 14, self.sharedData.screenWidth - 20 - 70, 70);
    [self.title sizeToFit];
    
    if ([event .fullfillmentType isEqualToString:@"ticket"]) {
        if (event.lowestPrice.integerValue > 0) {
            SharedData *sharedData = [SharedData sharedInstance];
            NSString *formattedPrice = [sharedData formatCurrencyString:event.lowestPrice.stringValue];
            [self.minimumPrice setText:[NSString stringWithFormat:@"Rp%@", formattedPrice]];
        } else {
            [self.minimumPrice setText:@"FREE"];
        }
        
        self.infoView.hidden = NO;
        self.minimumPrice.hidden = NO;
        self.startFromLabel.hidden = NO;
        
    } else {
        self.infoView.hidden = YES;
        self.minimumPrice.hidden = YES;
        self.startFromLabel.hidden = YES;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:PHDateFormatApp];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    self.date.text = [formatter stringFromDate:event.startDatetime];
    self.date.frame = CGRectMake(10, CGRectGetMaxY(self.title.frame) + 4, self.sharedData.screenWidth - 20, 20);
    
    self.subtitle.text = [event.venue capitalizedString];
    self.subtitle.frame = CGRectMake(10, CGRectGetMaxY(self.date.frame), self.sharedData.screenWidth - 20, 20);
    
    self.likeCount.text = [NSString stringWithFormat:@"%@", event.likes];
    
    if (event.photo && event.photo != nil) {
        self.picURL = [self.sharedData picURL:event.photo];
        
        //Load venue image
        [self.mainImg sd_setImageWithURL:[NSURL URLWithString:self.picURL]
                        placeholderImage:nil];
    } else {
        [self.mainImg setImage:nil];
    }
    
    NSLog(@"LOADING_IMG_URL :: %@ - %@",self.title.text, self.picURL);
    
    //remove all tags
    NSArray *viewsToRemove = [self.tagsView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    NSMutableArray *tags = [NSMutableArray arrayWithArray:(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:event.tags]];
    if (self.isFeaturedEvent) {
        [tags insertObject:@"Featured" atIndex:0];
    }
    
    self.tagsView.frame = CGRectMake(10, CGRectGetMaxY(self.subtitle.frame) + 8, self.sharedData.screenWidth, 20);
    
    int currX = 0;
    for (NSString *tag in tags) {
        UIButton *tagPil = [[UIButton alloc] initWithFrame:CGRectMake(currX, 0, 80, 20)];
        tagPil.enabled = NO;
        tagPil.titleLabel.font = [UIFont phBlond:11];
        tagPil.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 2, 0);
        [tagPil setTitle:tag forState:UIControlStateNormal];
        [tagPil setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        tagPil.layer.cornerRadius = 10;
        
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
            tagPil.backgroundColor = [UIColor colorFromHexCode:@"ED4FC4"];
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

@end
