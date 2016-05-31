//
//  ProfileViewController.m
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 5/25/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "ProfileViewController.h"
#import "AboutTableViewCell.h"
#import "ProfileEventTableViewCell.h"
#import "MemberInfo.h"
#import "MemberInfoEvent.h"
#import "SVProgressHUD.h"
#import "EditProfileViewController.h"
#import "EventsSummary.h"
#import "UIView+Animation.h"

#define ProfileHeaderHeight 300.0f

static NSString *const AboutTableViewCellIdentifier = @"AboutTableViewCellIdentifier";
static NSString *const ProfileEventTableViewCellIdentifier = @"ProfileEventTableViewCellIdentifier";

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) MemberInfo *memberInfo;
@property (copy, nonatomic) NSString *fbId;
@property (strong, nonatomic) NSMutableArray *memberEvents;

@end

@implementation ProfileViewController

- (instancetype)initWithFbId:(NSString *)fbId {
    if (self == [super init]) {
        self.fbId = fbId;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.memberEvents = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadNewData:)
                                                 name:@"EDIT_PROFILE_DONE"
                                               object:nil];
    
    [self setupView];
    
    SharedData *sharedData = [SharedData sharedInstance];
    
    [SVProgressHUD show];
    [MemberInfo retrieveMemberInfoWithFbId:self.fbId ?: sharedData.fb_id
                      andCompletionHandler:^(MemberInfo *memberInfo,
                                             NSInteger statusCode,
                                             NSError *error) {
                          [SVProgressHUD dismiss];
                          
                          dispatch_async(dispatch_get_main_queue(), ^{
                              if (memberInfo) {
                                  if (self.fbId) {
                                      self.title = memberInfo.firstName;
                                  } else {
                                      self.title = @"Your Profile";
                                  }
                                  
                                  self.memberInfo = memberInfo;
                                  
                                  if (memberInfo.bookings.count > 0) {
                                      for (MemberInfoEvent *memberEvent in memberInfo.bookings) {
                                          [memberEvent setEventType:EventTypeTable];
                                      }
                                      
                                      [self.memberEvents addObjectsFromArray:memberInfo.bookings];
                                  }
                                  if (memberInfo.tickets.count > 0) {
                                      for (MemberInfoEvent *memberEvent in memberInfo.tickets) {
                                          [memberEvent setEventType:EventTypeTicket];
                                      }
                                      
                                      [self.memberEvents addObjectsFromArray:memberInfo.tickets];
                                  }
                                  if (memberInfo.likesEvent.count > 0) {
                                      for (MemberInfoEvent *memberEvent in memberInfo.likesEvent) {
                                          [memberEvent setEventType:EventTypeLike];
                                      }
                                      
                                      [self.memberEvents addObjectsFromArray:memberInfo.likesEvent];
                                  }
                                  
                                  [self.tableView setDataSource:self];
                                  [self setupTableHeaderView];
                                  [self.tableView reloadData];
                              }
                          });
                      }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Observer
- (void)loadNewData:(NSNotification *)notification {
    UIScrollView *photoScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(.0f,
                                                                                    .0f,
                                                                                    CGRectGetWidth(self.tableView.bounds),
                                                                                    ProfileHeaderHeight)];
    
    photoScrollView.backgroundColor = [UIColor blackColor];
    [photoScrollView setShowsHorizontalScrollIndicator:NO];
    [photoScrollView setBounces:NO];
    [photoScrollView setPagingEnabled:YES];
    
    NSArray *photos = notification.object[@"photos"];
    
    for (int i = 0; i < [photos count]; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(photoScrollView.bounds) * i, 0, CGRectGetWidth(photoScrollView.bounds), CGRectGetHeight(photoScrollView.bounds))];
        [imageView setImage:photos[i]];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setClipsToBounds:YES];
        
        [photoScrollView addSubview:imageView];
    }
    
    photoScrollView.contentSize = CGSizeMake(CGRectGetWidth(photoScrollView.bounds) * [photos count], CGRectGetHeight(photoScrollView.bounds));
    
    self.tableView.tableHeaderView = photoScrollView;
    [self.memberInfo setAboutInfo:notification.object[@"about"]];
    
    [self.tableView reloadData];
}

#pragma mark - View
- (void)setupView {
    [self.navigationController.navigationBar setBarTintColor:[UIColor phPurpleColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName : [UIFont phBlond:16]}];
    
    
    UIBarButtonItem *closeBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_close"]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(didTapCloseButton:)];
    [self.navigationItem setLeftBarButtonItem:closeBarButtonItem];
    
    if (!self.fbId) {
        UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(didTapEditButton:)];
        [self.navigationItem setRightBarButtonItem:editBarButtonItem];
    }

    [self.tableView registerNib:[AboutTableViewCell nib]
         forCellReuseIdentifier:AboutTableViewCellIdentifier];
    [self.tableView registerNib:[ProfileEventTableViewCell nib]
         forCellReuseIdentifier:ProfileEventTableViewCellIdentifier];
}

- (void)setupTableHeaderView {
    UIScrollView *photoScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(.0f,
                                                                                    .0f,
                                                                                    CGRectGetWidth(self.tableView.bounds),
                                                                                    ProfileHeaderHeight)];
    
    photoScrollView.backgroundColor = [UIColor blackColor];
    [photoScrollView setShowsHorizontalScrollIndicator:NO];
    [photoScrollView setBounces:NO];
    [photoScrollView setPagingEnabled:YES];
    
    for (int i = 0; i < [self.memberInfo.photos count]; i++) {
        PHImage *imageView = [[PHImage alloc] initWithFrame:CGRectMake(CGRectGetWidth(photoScrollView.bounds) * i, 0, CGRectGetWidth(photoScrollView.bounds), CGRectGetHeight(photoScrollView.bounds))];
        imageView.showLoading = YES;
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setClipsToBounds:YES];
        [imageView loadImage:self.memberInfo.photos[i] defaultImageNamed:nil];
        
        [photoScrollView addSubview:imageView];
    }
    
    photoScrollView.contentSize = CGSizeMake(CGRectGetWidth(photoScrollView.bounds) * [self.memberInfo.photos count], CGRectGetHeight(photoScrollView.bounds));
    
    self.tableView.tableHeaderView = photoScrollView;
}

- (UIView *)headerViewWithText:(NSString *)text {
    UILabel *label = [UILabel new];
    [label setNumberOfLines:0];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor blackColor]];
    [label setText:text];
    [label setFont:[UIFont phBlond:17]];
    
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 80, 60)
                                         options:NSStringDrawingUsesFontLeading
                                      attributes:@{ NSFontAttributeName : label.font }
                                         context:nil].size;
    [label setFrame:CGRectMake(.0f,
                               .0f,
                               textSize.width,
                               textSize.height)];
    [label sizeToFit];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(.0f,
                                                            .0f,
                                                            CGRectGetWidth(label.bounds) + 10,
                                                            CGRectGetHeight(label.bounds) + 10)];
    
    [label setCenter:view.center];
    
    [view.layer setCornerRadius:5.0f];
    
    [view addSubview:label];
    
    return view;
}

#pragma mark - Action
- (void)didTapEditButton:(id)sender {
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[EditProfileViewController new]]
                       animated:YES
                     completion:nil];
}

- (void)didTapCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.memberInfo.bookings.count > 0 ||
        self.memberInfo.tickets.count > 0 ||
        self.memberInfo.likesEvent.count > 0) {
        return 2;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.memberInfo.bookings.count+self.memberInfo.tickets.count+self.memberInfo.likesEvent.count;
    }
    
    return 1;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        AboutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AboutTableViewCellIdentifier
                                                                   forIndexPath:indexPath];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell configureMemberInfo:self.memberInfo];
        
        return cell;
    } else {
        ProfileEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileEventTableViewCellIdentifier
                                                                   forIndexPath:indexPath];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell configureMemberEvent:self.memberEvents[indexPath.row]
                    withMemberInfo:self.memberInfo];
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        SharedData *sharedData = [SharedData sharedInstance];
        NSString *text = @"Events you're interested in";
        
        if ([self.memberInfo.fbId isEqualToString:sharedData.fb_id]) {
            text = @"Events you're interested in";
        } else {
            text = [NSString stringWithFormat:@"%@'s Events", self.memberInfo.firstName];
        }
        
        UIView *view = [self headerViewWithText:text];
        
        CGRect frame = view.frame;
        frame.origin.x = 10;
        frame.origin.y = 10;
        view.frame = frame;
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                                      0.0f,
                                                                      CGRectGetWidth(self.tableView.bounds),
                                                                      55.f)];
        [headerView addSubview:view];
        
        return headerView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 55;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending) {
        return UITableViewAutomaticDimension;
    } else {
        if (indexPath.section == 0) {
            AboutTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:AboutTableViewCellIdentifier];
            [cell configureMemberInfo:self.memberInfo];
            
            [cell setNeedsUpdateConstraints];
            [cell updateConstraintsIfNeeded];
            [cell setNeedsLayout];
            [cell layoutIfNeeded];
            
            CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            
            return height += 1;
        }
        
        return 90;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        SharedData *sharedData = [SharedData sharedInstance];

        MemberInfoEvent *memberEvent = self.memberEvents[indexPath.row];
        
        sharedData.selectedEvent[@"_id"] = memberEvent.eventId;
        sharedData.selectedEvent[@"venue_name"] = memberEvent.title;
        
        EventsSummary *eventDetail = [[EventsSummary alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [eventDetail initClassModalWithEventID:sharedData.selectedEvent[@"_id"]];
        
        eventDetail.mainScroll.frame = CGRectMake(0,
                                                  0,
                                                  CGRectGetWidth([UIScreen mainScreen].bounds),
                                                  CGRectGetHeight([UIScreen mainScreen].bounds) - 50);
        
        eventDetail.btnHostHere.frame = CGRectMake(0,
                                                   sharedData.screenHeight - 44,
                                                   sharedData.screenWidth, 44);
        
        [self.view presentView:eventDetail
                   withOverlay:NO
                      animated:YES
                    completion:nil];
    }
}

@end
