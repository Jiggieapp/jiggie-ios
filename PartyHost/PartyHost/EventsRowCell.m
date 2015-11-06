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
        
        //Black fade bottom
        UIView *gradientView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 220)];
        CAGradientLayer *gradientMask = [CAGradientLayer layer];
        gradientMask.frame = CGRectMake(0, 0, self.sharedData.screenWidth, 220-8);
        gradientMask.colors = @[(id)[UIColor colorWithWhite:0 alpha:0.5].CGColor,(id)[UIColor blackColor].CGColor];
        gradientMask.locations = @[@0.65,@0.80];
        [gradientView.layer insertSublayer:gradientMask atIndex:0];
        //[self addSubview:gradientView];
        
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
        //self.title.shadowColor = [UIColor blackColor];
        //self.title.shadowOffset = CGSizeMake(0.5,0.5);
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
        
        /*
        
        self.trendingButton = [[TrendButton alloc] initWithFrame:CGRectMake(10, self.subtitle.frame.origin.y + self.subtitle.frame.size.height + 6, self.sharedData.screenWidth - 20, 10)];
        self.trendingButton.userInteractionEnabled = NO;
        [self addSubview:self.trendingButton];
        
        self.experienceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.trendingButton.frame.origin.y + self.trendingButton.frame.size.height + 16, self.sharedData.screenWidth - 20, 11)];
        self.experienceLabel.textColor = [UIColor colorWithWhite:1 alpha:1];
        self.experienceLabel.textAlignment = NSTextAlignmentCenter;
        self.experienceLabel.text = @"";
        self.experienceLabel.shadowColor = [UIColor blackColor];
        self.experienceLabel.shadowOffset = CGSizeMake(0.5,0.5);
        self.experienceLabel.font = [UIFont phBold:10];
        [self addSubview:self.experienceLabel];
        
        //This should be on the same line (Y) as subtitle
        self.hostNum = [[UILabel alloc] initWithFrame:CGRectMake(24, 220 - PROFILE_SIZE - 15 - 20, (self.sharedData.screenWidth/2)-24, PROFILE_SIZE)];
        //self.hostNum.backgroundColor = [UIColor colorWithWhite:0 alpha:.85];
        self.hostNum.textColor = [UIColor colorWithWhite:1 alpha:1];
        self.hostNum.textAlignment = NSTextAlignmentLeft;
        self.hostNum.font = [UIFont phBold:10];
        //self.hostNum.layer.cornerRadius = 10;
        //self.hostNum.layer.masksToBounds = YES;
        self.hostNum.shadowColor = [UIColor blackColor];
        self.hostNum.shadowOffset = CGSizeMake(0.5,0.5);
        [self addSubview:self.hostNum];
         
         */
        
        /*
        self.infoBody = [[UITextView alloc] initWithFrame:CGRectMake(5, 75, self.sharedData.screenWidth - 10, 60)];
        self.infoBody.layer.cornerRadius = 10;
        self.infoBody.layer.masksToBounds = YES;
        self.infoBody.textColor = [UIColor blackColor];
        self.infoBody.font = [UIFont phBlond:12];
        self.infoBody.backgroundColor = [UIColor clearColor];
        self.infoBody.editable = NO;
        self.infoBody.selectable = NO;
        
        self.tmpWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sharedData.screenWidth, 220)];
        
        UIView *roundedCorners = [[UIView alloc] initWithFrame:CGRectMake(5, 75, self.sharedData.screenWidth - 10, 60)];
        roundedCorners.layer.masksToBounds = YES;
        roundedCorners.layer.cornerRadius = 10;
        roundedCorners.backgroundColor = [UIColor whiteColor];
        [self.tmpWhiteView addSubview:roundedCorners];
        
        [self addSubview:self.tmpWhiteView];
        
        UIBezierPath* trianglePath = [UIBezierPath bezierPath];
        [[UIColor colorWithWhite:1.0 alpha:1] setStroke];
        [[UIColor colorWithWhite:1.0 alpha:1] setFill];
        [trianglePath moveToPoint:CGPointMake(0, 0)];
        [trianglePath addLineToPoint:CGPointMake(triWidth,0)];
        [trianglePath addLineToPoint:CGPointMake(triWidth/2, triHeight)];
        [trianglePath stroke];
        [trianglePath fill];
        [trianglePath closePath];
        
        CAShapeLayer *triangleMaskLayer = [CAShapeLayer layer];
        triangleMaskLayer.strokeColor = [UIColor colorWithWhite:1.0 alpha:1].CGColor;
        triangleMaskLayer.fillColor = [UIColor colorWithWhite:1.0 alpha:1].CGColor;
        [triangleMaskLayer setPath:trianglePath.CGPath];
        
        self.infoTri = [[UIView alloc] initWithFrame:CGRectMake(10,PROFILE_SIZE, triWidth, triHeight)];
        self.infoTri.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        self.infoTri.layer.borderWidth = 0;
        self.infoTri.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.1].CGColor;
        self.infoTri.hidden = YES;
        [self.tmpWhiteView addSubview:self.infoTri];
        
        self.tmpWhiteView.alpha = 0.8;
        
        [self addSubview:self.infoBody];
        
        UILongPressGestureRecognizer *tapGest = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
        tapGest.minimumPressDuration = 0.01;
        [roundedCorners addGestureRecognizer:tapGest];
        */

        //self.layer.masksToBounds = YES;

        /*
        int hostingWidth = (PROFILE_PICS * (PROFILE_SIZE+PROFILE_PADDING)) - PROFILE_PADDING;
        self.hostingsCon = [[UIView alloc] initWithFrame:CGRectMake(self.sharedData.screenWidth-hostingWidth-24, 220 - PROFILE_SIZE - 16, hostingWidth,PROFILE_SIZE)];
        self.hostingsCon.backgroundColor = [UIColor clearColor];
        [self addSubview:self.hostingsCon];
         */
        
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

-(void)updateTrendingButton:(NSString*)title
{
//    if([title length]>0) { //Has trend label
//        self.trendingButton.hidden = NO;
//        self.trendingButton.frame = CGRectMake(10, self.subtitle.frame.origin.y + self.subtitle.frame.size.height + 6, self.sharedData.screenWidth - 20, 10);
//        [self.trendingButton updateCenterFit:title color:[UIColor phBlueColor]];
//        
//        self.experienceLabel.frame = CGRectMake(10, self.trendingButton.frame.origin.y + self.trendingButton.frame.size.height + 16, self.sharedData.screenWidth - 20, 11);
//    }
//    else { //No trend
//        self.trendingButton.hidden = YES;
//        self.experienceLabel.frame = CGRectMake(10, self.trendingButton.frame.origin.y + 16, self.sharedData.screenWidth - 20, 11);
//    }

}

-(void)clearData
{
    self.cPicIndex = -1;
//    self.experienceLabel.hidden = self.trendingButton.hidden = YES;
    [self.infoA removeAllObjects];
    [self.btnsA removeAllObjects];
    [self.cancelImagesA removeAllObjects];
//    self.hostNum.text = @"";
//    [self.hostingsCon.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
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
//    self.experienceLabel.hidden = self.trendingButton.hidden = YES;
    [self dismissAllPopTipViews];
    [self.spinner startAnimating];
    [self addSubview:self.spinner];
//    [self.hostingsCon.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
}

-(void)hideLoading
{
//    self.experienceLabel.hidden = self.trendingButton.hidden = NO;
    [self.spinner stopAnimating];
    [self.spinner removeFromSuperview];
}

-(void)loadData:(NSDictionary *)dict
{    
    //self.infoBody.hidden = YES;
    //[self dismissAllPopTipViews];
    
    //Host and guest view are combined here, so I have to IF everything??
//    NSMutableArray *hostingsA;
//    if([self.sharedData isHost] || [self.sharedData isMember])
//    {
//        hostingsA = [dict objectForKey:@"guests_viewed"];
//        if([hostingsA count]<=0)
//        {
//            self.hostNum.text = @"";
//        }
//        else
//        {
//            self.hostNum.text = [NSString stringWithFormat:@"%d GUEST%@\nINTERESTED",(int)[hostingsA count],([hostingsA count] > 1)?@"S":@""];
//            self.hostNum.numberOfLines = 2;
//        }
//    }
//    else if([self.sharedData isGuest])
//    {
//        hostingsA = [dict objectForKey:@"hosters"];
//        if([hostingsA count]<=0)
//        {
//            self.hostNum.text = @"NO HOSTS";
//        }
//        else
//        {
//            self.hostNum.text = [NSString stringWithFormat:@"%d HOST%@",(int)[hostingsA count],([hostingsA count] > 1)?@"S":@""];
//            self.hostNum.numberOfLines = 1;
//        }
//    }
    
//    //Get starting location
//    long x1 = 0;
//    if([hostingsA count]<PROFILE_PICS) {
//        x1 = (PROFILE_PICS - [hostingsA count]) * (PROFILE_SIZE+PROFILE_PADDING);
//    }
//    
//    //Get total pics
//    long total_pics = [hostingsA count];
//    if(total_pics > PROFILE_PICS) total_pics = PROFILE_PICS - 1;
//    
//    //Loop through pics
//    for (int i = 0; i < total_pics; i++)
//    {
//        NSDictionary *event = [hostingsA objectAtIndex:i];
//        NSDictionary *user = event;
//        //if(self.sharedData.isGuest) user = event[@"host"]; //Gotta go one more deep for host
//        
//        if(self.sharedData.isHost || [self.sharedData isMember]) //Show bio of guest
//        {
//            if(user[@"about"]!=NULL) {[self.infoA addObject:user[@"about"]];}
//            else {[self.infoA addObject:@""];}
//        }
//        else if(self.sharedData.isGuest) //Shows event message, not BIO
//        {
//            if(event[@"description"]!=NULL) {[self.infoA addObject:event[@"description"]];}
//            else {[self.infoA addObject:@""];}
//        }
//        
//        //Add image
//        UserBubble *btnPic = [[UserBubble alloc] initWithFrame:CGRectMake(x1, 0, PROFILE_SIZE, PROFILE_SIZE)];
//        [self.btnsA addObject:btnPic];
//        btnPic.alpha = 1;
//        btnPic.tag = 10 + i;
//        btnPic.userInteractionEnabled = NO;
//        [btnPic setName:user[@"first_name"] lastName:nil];
//        NWURLConnection *connection = [btnPic loadFacebookImage:user[@"fb_id"]];
//        [self.cancelImagesA addObject:connection];
//        [self.hostingsCon addSubview:btnPic];
//        
//        x1 += PROFILE_SIZE + PROFILE_PADDING;
//    }
//    
//    //Show +MORE button
//    if([hostingsA count] > PROFILE_PICS)
//    {
//        UIButton *btnPic = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        btnPic.userInteractionEnabled = NO;
//        btnPic.frame = CGRectMake( x1, 0, PROFILE_SIZE, PROFILE_SIZE);
//        
//        //Put a black background, because the background just disappears when pressed
//        UIView *blackBg = [[UIView alloc] initWithFrame:CGRectMake(0,0, PROFILE_SIZE, PROFILE_SIZE)];
//        blackBg.backgroundColor = [UIColor blackColor];
//        [btnPic addSubview:blackBg];
//        
//        btnPic.layer.cornerRadius = PROFILE_SIZE/2;
//        btnPic.layer.masksToBounds = YES;
//        btnPic.layer.borderColor = [UIColor whiteColor].CGColor;
//        btnPic.layer.borderWidth = 2.0;
//        [btnPic setTitleEdgeInsets:UIEdgeInsetsMake(2,0,0,2)];
//        [btnPic setTitle:[NSString stringWithFormat:@"+%d",(int)[hostingsA count] - PROFILE_PICS + 1] forState:UIControlStateNormal];
//        btnPic.titleLabel.font = [UIFont phBold:18];
//        [btnPic setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self.hostingsCon addSubview:btnPic];
//    }

    //remove all tags
    NSArray *viewsToRemove = [self.tagsView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    NSArray *tags = [dict objectForKey:@"tags"];
    int currX = 0;
    for (NSString *tag in tags) {
        UIButton *tagPil = [[UIButton alloc] initWithFrame:CGRectMake(currX, 0, 80, 20)];
        tagPil.enabled = NO;
        tagPil.titleLabel.font = [UIFont phBlond:13];
        tagPil.layer.borderWidth = 1.0;
        tagPil.layer.borderColor = [UIColor darkGrayColor].CGColor;
        tagPil.titleEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 0);
        [tagPil setTitle:tag forState:UIControlStateNormal];
        [tagPil setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        tagPil.layer.cornerRadius = 10;
        [self addSubview:tagPil];
        
        CGSize resizePill =  [self.sharedData sizeForLabelString:[tagPil titleForState:UIControlStateNormal]
                                                        withFont:tagPil.titleLabel.font
                                                      andMaxSize:CGSizeMake(120, tagPil.bounds.size.height)];
        [tagPil setFrame:CGRectMake(tagPil.frame.origin.x, tagPil.frame.origin.y, resizePill.width + 14, resizePill.height + 7)];
        
        [self.tagsView addSubview:tagPil];
        currX = CGRectGetMaxX(tagPil.frame) + 8;
    }

//    self.experienceLabel.hidden = self.trendingButton.hidden = NO;

//    [self addSubview:self.infoBody];
}

/*
-(void)btnTapHandler:(UIButton *)btn
{
    if(self.cPicIndex != (int)btn.tag - 10 || [self.visiblePopTipViews count] == 0)
    {
        int seg = (self.sharedData.screenWidth - 250)/6;
        self.cPicIndex = (int)btn.tag - 10;
        NSString *txt = [NSString stringWithFormat:@"%@",[self.infoA objectAtIndex:self.cPicIndex]];
        txt = [txt stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        if([txt length] > 150)
        {
            txt = [txt substringToIndex:150];
            txt = [txt stringByAppendingString:@"..."];
        }
        
        [self dismissAllPopTipViews];
        CMPopTipView *popTipView;
        popTipView = [[CMPopTipView alloc] initWithMessage:txt];
        popTipView.delegate = self;
        popTipView.borderWidth = 0;
        popTipView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        popTipView.textColor = [UIColor blackColor];
        popTipView.offSetTri = -2 + ((self.cPicIndex < 2)?10:(self.cPicIndex < 3)?3:-7);
        
        UITableView *TV = [self parentTableView];
        NSIndexPath *indexPath = [TV indexPathForCell:self];
        popTipView.cHost_index = self.cPicIndex;
        popTipView.indexPathRow = (int)indexPath.row;
        popTipView.indexPathSection = (int)indexPath.section;
        
        [self.visiblePopTipViews addObject:popTipView];
        self.currentPopTipViewTarget = btn;
        
        [popTipView presentPointingAtView:btn inView:self animated:NO];
        
        self.infoTri.frame = CGRectMake((self.cPicIndex * (PROFILE_SIZE + seg)) + seg + 15, 135, triWidth, triHeight);
        self.infoTri.hidden = NO;
        self.infoBody.text = txt;
        //self.infoBody.hidden = NO;
        //self.tmpWhiteView.hidden = NO;
    }else{
        [self dismissAllPopTipViews];
        self.tmpWhiteView.hidden = YES;
        self.infoBody.hidden = YES;
        self.infoTri.hidden = YES;
    }
}
*/

/*
-(void)plusFourTapHandler
{
    UITableView *TV = [self parentTableView];
    NSIndexPath *indexPath = [TV indexPathForCell:self];
    self.sharedData.cHost_index_path = indexPath;
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"EVENTS_PRESELECT"
     object:self];
    //[TV selectRowAtIndexPath:indexPath animated:YES scrollPosition:<#(UITableViewScrollPosition)#>]
}
*/

- (void)prepareForReuse
{
    //[self clearData];
}


-(UITableView *) parentTableView {
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
