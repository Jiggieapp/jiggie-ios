//
//  ProfileViewController.m
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 5/25/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "ProfileViewController.h"
#import "AboutTableViewCell.h"
#import "MemberInfo.h"
#import "SVProgressHUD.h"
#import "EditProfileViewController.h"

#define ProfileHeaderHeight 300.0f

static NSString *const AboutTableViewCellIdentifier = @"AboutTableViewCellIdentifier";

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) MemberInfo *memberInfo;
@property (copy, nonatomic) NSString *fbId;

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
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Your Profile";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadNewData:)
                                                 name:@"EDIT_PROFILE_DONE"
                                               object:nil];
    
    [self setupView];
    
    [SVProgressHUD show];
    if (self.fbId) {
        [MemberInfo retrieveMemberInfoWithFbId:self.fbId
                          andCompletionHandler:^(MemberInfo *memberInfo,
                                                 NSInteger statusCode,
                                                 NSError *error) {
                              [SVProgressHUD dismiss];
                              
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  if (memberInfo) {
                                      self.memberInfo = memberInfo;
                                      
                                      [self.tableView setDataSource:self];
                                      [self setupTableHeaderView];
                                      [self.tableView reloadData];
                                  }
                              });
        }];
    } else {
        [MemberInfo retrieveMemberInfoWithCompletionHandler:^(MemberInfo *memberInfo,
                                                              NSInteger statusCode,
                                                              NSError *error) {
            [SVProgressHUD dismiss];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (memberInfo) {
                    self.memberInfo = memberInfo;
                    
                    [self.tableView setDataSource:self];
                    [self setupTableHeaderView];
                    [self.tableView reloadData];
                }
            });
        }];
    }
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
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
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

    [self.tableView registerNib:[AboutTableViewCell nib] forCellReuseIdentifier:AboutTableViewCellIdentifier];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AboutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AboutTableViewCellIdentifier
                                                               forIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell configureMemberInfo:self.memberInfo];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
