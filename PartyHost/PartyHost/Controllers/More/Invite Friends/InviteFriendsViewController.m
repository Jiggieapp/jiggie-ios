//
//  InviteFriendsViewController.m
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 5/11/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "InviteFriendsTableViewCell.h"
#import "AnalyticManager.h"
#import "APAddressBook.h"
#import "SVProgressHUD.h"
#import "APContact.h"
#import "Contact.h"
#import <MessageUI/MessageUI.h>

static NSString *const InviteFriendsTableViewCellIdentifier = @"InviteFriendsTableViewCellIdentifier";

@interface InviteFriendsViewController () <MFMessageComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, InviteFriendsTableViewCellDelegate>

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *inviteAllButtonHeightConstraint;

@property (strong, nonatomic) APAddressBook *addressBook;
@property (strong, nonatomic) NSMutableArray *contacts;
@property (strong, nonatomic) Contact *selectedContact;
@property (strong, nonatomic) NSMutableArray *invitedFriendsRecordIDs;
@property (copy, nonatomic) NSString *inviteMessage;

@end

@implementation InviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.invitedFriendsRecordIDs = [NSMutableArray array];
    
    [self setupView];
    [self getInvitationMessage];
    
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
    [self.navigationController.navigationBar setBarTintColor:[UIColor phPurpleColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.title = @"Invite Friends";
    [self.tableView registerNib:[InviteFriendsTableViewCell nib]
         forCellReuseIdentifier:InviteFriendsTableViewCellIdentifier];

    if (self.isShowCloseButton) {
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setFrame:CGRectMake(0.0f, 0.0f, 40.0f, 27.0f)];
        [closeButton setTitle:@"Done" forState:UIControlStateNormal];
        [[closeButton titleLabel] setFont:[UIFont phBlond:14.0]];
        [closeButton addTarget:self action:@selector(closeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *closeBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
        
        [[self navigationItem] setRightBarButtonItem:closeBarButtonItem];
    }

    [self.inviteAllButton setHidden:YES];
}

- (void)updateInviteButtonWithCredit:(NSNumber *)totalCredit {
    if (totalCredit == nil) {
        return;
    }
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"id_ID"]];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    
    NSString *totalCreditFormatted = [numberFormatter stringFromNumber:totalCredit];
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    UIFont *font1 = [UIFont fontWithName:@"Lato-Regular" size:11.0f];
    UIFont *font2 = [UIFont fontWithName:@"Lato-Bold" size:16.0f];
    NSDictionary *dict1 = @{NSFontAttributeName:font1,
                            NSParagraphStyleAttributeName:style}; // Added line
    NSDictionary *dict2 = @{NSFontAttributeName:font2,
                            NSParagraphStyleAttributeName:style}; // Added line
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"INVITE ALL\n" attributes:dict1]];
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"+Rp %@", totalCreditFormatted] attributes:dict2]];
    
    [[self.inviteAllButton titleLabel] setNumberOfLines:2];
    [[self.inviteAllButton titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [self.inviteAllButton setAttributedTitle:attString forState:UIControlStateNormal];
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
        if (contacts) {
            SharedData *sharedData = [SharedData sharedInstance];
            AFHTTPRequestOperationManager *manager = [sharedData getOperationManager];
            NSString *url = [NSString stringWithFormat:@"%@/credit/contact", PHBaseNewURL];
            NSError *error = nil;
            NSMutableArray *contactsModel = [NSMutableArray arrayWithCapacity:contacts.count];
            
            for (APContact *contact in contacts) {
                [contactsModel addObject:[[Contact alloc] initWithContact:contact]];
            }
            
            NSMutableDictionary *parameters = [NSMutableDictionary
                                               dictionaryWithDictionary:@{@"fb_id" : sharedData.fb_id,
                                                                          @"device_type" : @"1",
                                                                          @"contact" : [MTLJSONAdapter
                                                                                        JSONArrayFromModels:contactsModel
                                                                                        error:&error]}];
            
            for (NSMutableDictionary *contact in parameters[@"contact"]) {
                [contact removeObjectForKey:@"is_active"];
                
                if ([contact[@"email"] isKindOfClass:[NSNull class]]) {
                    contact[@"email"] = [@[] mutableCopy];
                }
                
                if ([contact[@"phone"] isKindOfClass:[NSNull class]]) {
                    contact[@"phone"] = [@[] mutableCopy];
                }
            }
            
            [SVProgressHUD show];
            [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [SVProgressHUD dismiss];
                
                NSInteger responseStatusCode = operation.response.statusCode;
                if (responseStatusCode != 200) {
                    return;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSError *error = nil;
                    NSArray *contactsModel = [MTLJSONAdapter modelsOfClass:[Contact class]
                                                             fromJSONArray:responseObject[@"data"][@"contact"]
                                                                     error:&error];
                    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
                    NSArray *sortedContactsModel = [contactsModel sortedArrayUsingDescriptors:@[sortDescriptor]];
                    NSArray *recordIDs = [sortedContactsModel valueForKey:@"recordID"];
                    
                    for (Contact *contact in contactsModel) {
                        if ([recordIDs indexOfObject:contact.recordID] &&
                            [recordIDs indexOfObject:contact.recordID] < contacts.count) {
                            APContact *apContact = contacts[[recordIDs indexOfObject:contact.recordID]];
                            [contact setThumbnailWithImage:apContact.thumbnail];
                        }
                    }
                    
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.isActive == %@", [NSNumber numberWithBool:YES]];
                    NSArray *contacts = [contactsModel filteredArrayUsingPredicate:predicate];
                    NSArray *sortedContacts = [contacts sortedArrayUsingDescriptors:@[sortDescriptor]];
                    
                    weakSelf.contacts = [NSMutableArray arrayWithArray:sortedContacts];
                    [weakSelf.tableView reloadData];
                    [weakSelf.inviteAllButton setHidden:NO];
                });
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD dismiss];
                [self.inviteAllButton setHidden:YES];
            }];
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
        Contact *contact = self.contacts[indexPath.row];
        [cell configureContact:contact];
        [cell setDelegate:self];
        
        [self setInviteFriendsTableViewCell:cell
                                  asInvited:[self.invitedFriendsRecordIDs
                                             containsObject:contact.recordID]];
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

#pragma mark --
- (void)setInviteFriendsTableViewCell:(InviteFriendsTableViewCell *)cell asInvited:(BOOL)invited {
    if (invited) {
        cell.inviteButton.backgroundColor = [UIColor phGrayColor];
        [cell.inviteButton setTitle:@"SENT" forState:UIControlStateNormal];
        [cell.inviteButton setEnabled:NO];
    } else {
        cell.inviteButton.backgroundColor = [UIColor phBlueColor];
        [cell.inviteButton setTitle:@"INVITE" forState:UIControlStateNormal];
        [cell.inviteButton setEnabled:YES];
    }
}

#pragma mark - InviteFriendsTableViewCellDelegate
- (void)InviteFriendsTableViewCell:(InviteFriendsTableViewCell *)cell didTapInviteButton:(UIButton *)sender {
    Contact *contact = self.contacts[[self.tableView indexPathForCell:cell].row];
    self.selectedContact = contact;
    
    if (!contact.emails || [contact.emails.firstObject isEqualToString:@""]) {
        if ([MFMessageComposeViewController canSendText]) {
            MFMessageComposeViewController *messageComposeViewController = [[MFMessageComposeViewController alloc] init];
            [messageComposeViewController setMessageComposeDelegate:self];
            [messageComposeViewController setRecipients:contact.phones];
            [messageComposeViewController setBody:self.inviteMessage];
            
            [self presentViewController:messageComposeViewController
                               animated:YES
                             completion:nil];
        }
    } else {
        SharedData *sharedData = [SharedData sharedInstance];
        AFHTTPRequestOperationManager *manager = [sharedData getOperationManager];
        NSString *url = [NSString stringWithFormat:@"%@/credit/invite", PHBaseNewURL];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"fb_id" : sharedData.fb_id,
                                                                                          @"contact" : @{
                                                                                                  @"name" : contact.name,
                                                                                                  @"phone" : contact.phones ?: @[],
                                                                                                  @"email" : contact.emails ?: @[]
                                                                                                  }
                                                                                          }];
        
        [SVProgressHUD show];
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            
            NSInteger responseStatusCode = operation.response.statusCode;
            if (responseStatusCode != 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setInviteFriendsTableViewCell:cell asInvited:NO];
                });
                
                return;
            }
            
            NSDictionary *invite = [[NSUserDefaults standardUserDefaults] objectForKey:@"INVITE_CREDIT"];
            
            if (invite) {
                NSDictionary *parameters = @{@"Promo Code" : invite[@"code"],
                                             @"Promo URL" : invite[@"url"],
                                             @"Contact Full Name" : contact.name,
                                             @"Contact Email" : contact.emails,
                                             @"Contact Phone" : contact.phones};
                
                [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Share Referral Phone All"
                                                              withDict:parameters];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (![self.invitedFriendsRecordIDs containsObject:contact.recordID]) {
                    [self.invitedFriendsRecordIDs addObject:contact.recordID];
                }
                
                [self.tableView reloadData];
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setInviteFriendsTableViewCell:cell asInvited:NO];
            });
        }];
    }
}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    switch (result) {
        case MessageComposeResultSent: {
            if (![self.invitedFriendsRecordIDs containsObject:self.selectedContact.recordID]) {
                [self.invitedFriendsRecordIDs addObject:self.selectedContact.recordID];
            }
            
            [self.tableView reloadData];
            
            NSDictionary *invite = [[NSUserDefaults standardUserDefaults] objectForKey:@"INVITE_CREDIT"];
            
            if (invite) {
                NSDictionary *parameters = @{@"Promo Code" : invite[@"code"],
                                             @"Promo URL" : invite[@"url"],
                                             @"Contact Full Name" : self.selectedContact.name,
                                             @"Contact Email" : @[],
                                             @"Contact Phone" : self.selectedContact.phones};
                
                [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Share Referral Phone All"
                                                              withDict:parameters];
            }
            
            break;
        }
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark - Action
- (IBAction)didTapInviteAllButton:(id)sender {
    SharedData *sharedData = [SharedData sharedInstance];
    AFHTTPRequestOperationManager *manager = [sharedData getOperationManager];
    NSString *url = [NSString stringWithFormat:@"%@/credit/invite_all", PHBaseNewURL];
    
    NSMutableArray *contacts = [NSMutableArray arrayWithCapacity:self.contacts.count];
    
    for (Contact *contact in self.contacts) {
        NSMutableDictionary *contactDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"name" : contact.name}];
        
        [contactDictionary setObject:contact.phones forKey:@"phone"];
        [contactDictionary setObject:contact.emails forKey:@"email"];
        
        if (![self.invitedFriendsRecordIDs containsObject:contact.recordID]) {
            [contacts addObject:contactDictionary];
        }
    }
    
    NSDictionary *parameters = @{@"fb_id" : sharedData.fb_id,
                                 @"contact" : contacts};
    
    [SVProgressHUD show];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        
        NSDictionary *invite = [[NSUserDefaults standardUserDefaults] objectForKey:@"INVITE_CREDIT"];
        
        if (invite) {
            NSDictionary *parameters = @{@"Promo Code" : invite[@"code"],
                                         @"Promo URL" : invite[@"url"]};
            
            [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Share Referral Phone All"
                                                          withDict:parameters];
        }
        
        NSInteger responseStatusCode = operation.response.statusCode;
        if (responseStatusCode != 200) {
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.inviteAllButtonHeightConstraint.constant = 0;
            
            [self.view setNeedsUpdateConstraints];
            [self.view layoutIfNeeded];
            
            for (APContact *contact in self.contacts) {
                if (![self.invitedFriendsRecordIDs containsObject:contact.recordID]) {
                    [self.invitedFriendsRecordIDs addObject:contact.recordID];
                }
            }
            
            [self.tableView reloadData];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - Data
- (void)getInvitationMessage {
    
    NSDictionary *invite = [[NSUserDefaults standardUserDefaults] objectForKey:@"INVITE_CREDIT"];
    
    if (invite) {
        self.inviteMessage = invite[@"message"];
    } else {
        SharedData *sharedData = [SharedData sharedInstance];
        AFHTTPRequestOperationManager *manager = [sharedData getOperationManager];
        NSString *url = [NSString stringWithFormat:@"%@/credit/invite_code/%@", PHBaseNewURL, sharedData.fb_id];
        
        [SVProgressHUD show];
        [manager GET:url parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            
            NSInteger responseStatusCode = operation.response.statusCode;
            if (responseStatusCode != 200) {
                return;
            }
            
            NSString *responseString = operation.responseString;
            NSError *error;
            NSDictionary *json = (NSDictionary *)[NSJSONSerialization
                                                  JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]
                                                  options:kNilOptions
                                                  error:&error];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (json && json != nil) {
                    NSDictionary *data = [json objectForKey:@"data"];
                    if (data && data != nil) {
                        NSDictionary *inviteCode = [data objectForKey:@"invite_code"];
                        NSString *code = inviteCode[@"code"];
                        NSString *description = inviteCode[@"msg_invite"];
                        NSString *message = inviteCode[@"msg_share"];
                        NSString *url = inviteCode[@"invite_url"];
                        
                        self.inviteMessage = message;
                        
                        NSDictionary *invite = @{@"code" : code,
                                                 @"description" : description,
                                                 @"message" : message,
                                                 @"url" : url};
                        
                        [[NSUserDefaults standardUserDefaults] setObject:invite forKey:@"INVITE_CREDIT"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }
}

- (void)closeButtonDidTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
