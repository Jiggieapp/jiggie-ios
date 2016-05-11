//
//  InviteFriendsViewController.m
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 5/11/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "InviteFriendsTableViewCell.h"
#import "APAddressBook.h"
#import "SVProgressHUD.h"
#import "APContact.h"

static NSString *const InviteFriendsTableViewCellIdentifier = @"InviteFriendsTableViewCellIdentifier";

@interface InviteFriendsViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, InviteFriendsTableViewCellDelegate>

@property (strong, nonatomic) APAddressBook *addressBook;
@property (strong, nonatomic) NSMutableArray *contacts;

@end

@implementation InviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupView];
    
    __weak typeof(self) weakSelf = self;
    [self.addressBook startObserveChangesWithCallback:^{
        [weakSelf loadContacts];
    }];
    
    [self checkAddressBookAccess];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Lazy Instantiation
- (APAddressBook *)addressBook {
    if (!_addressBook) {
        _addressBook = [[APAddressBook alloc] init];
    }
    
    return _addressBook;
}

#pragma mark - View
- (void)setupView {
    self.title = @"Invite Friends";
    [self.tableView registerNib:[InviteFriendsTableViewCell nib]
         forCellReuseIdentifier:InviteFriendsTableViewCellIdentifier];
}

#pragma mark - Contacts
- (void)checkAddressBookAccess {
    switch ([APAddressBook access]) {
        case APAddressBookAccessDenied: {
            [self.contacts removeAllObjects];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                            message:@"Please go to Settings and turn on Contacts Service for this app."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"OK",nil];
            [alert setDelegate:self];
            [alert show];
            
            break;
        }
            
        default: {
            [self loadContacts];
            
            break;
        }
    }
}

- (void)loadContacts {
    __weak typeof(self) weakSelf = self;
    
    [SVProgressHUD show];
    
    [self.addressBook setFieldsMask:APContactFieldName |
     APContactFieldPhonesOnly |
     APContactFieldEmailsOnly |
     APContactFieldThumbnail];
    
    [self.addressBook setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name.firstName" ascending:YES],
                                           [NSSortDescriptor sortDescriptorWithKey:@"name.lastName" ascending:YES]]];
    [self.addressBook setFilterBlock:^BOOL(APContact *contact) {
        if (contact.phones.count > 0) {
            return contact.phones.count > 0;
        }
        
        return contact.emails.count > 0;
    }];
    [self.addressBook loadContacts:^(NSArray<APContact *> * _Nullable contacts, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if (contacts) {
            weakSelf.contacts = [NSMutableArray arrayWithArray:contacts];
            [weakSelf.tableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InviteFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InviteFriendsTableViewCellIdentifier
                                                                       forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (self.contacts) {
        APContact *contact = self.contacts[indexPath.row];
        [cell configureContact:contact];
        [cell setDelegate:self];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 76;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending) {
        return UITableViewAutomaticDimension;
    }
    
    return 76;

}

#pragma mark - InviteFriendsTableViewCellDelegate
- (void)InviteFriendsTableViewCell:(InviteFriendsTableViewCell *)cell didTapInviteButton:(UIButton *)sender {
    sender.backgroundColor = [UIColor phGrayColor];
    [sender setTitle:@"SENT" forState:UIControlStateNormal];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark - Action
- (IBAction)didTapInviteAllButton:(id)sender {
    
}

@end
