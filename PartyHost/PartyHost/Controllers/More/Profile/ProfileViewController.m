//
//  ProfileViewController.m
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 4/29/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "ProfileViewController.h"
#import "AnalyticManager.h"
#import "UIActionSheet+Blocks.h"
#import "UITextView+Placeholder.h"
#import "OLFacebookImagePickerController.h"
#import "OLFacebookImage.h"
#import "SVProgressHUD.h"
#import "SharedData.h"
#import "SidePhotoTableViewCell.h"

static NSString *const SidePhotoTableViewCellIdentifier = @"SidePhotoTableViewCellIdentifier";

@interface ProfileViewController () <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, OLFacebookImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *mainPhotoIndicatorView;
@property (strong, nonatomic) IBOutlet UIImageView *mainPhotoActionImageView;

@property (strong, nonatomic) SharedData *sharedData;
@property (assign, nonatomic) BOOL isProfileChanges;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) NSMutableArray *photosURL;
@property (assign, nonatomic) NSInteger currentPhotoIndex;
@property (strong, nonatomic) UIImage *defaultImage;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"EDIT PROFILE";
    
    [self setupView];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Lazy Instantiation
- (SharedData *)sharedData {
    if (!_sharedData) {
        _sharedData = [SharedData sharedInstance];
    }
    
    return _sharedData;
}

#pragma mark - View
- (void)setupView {
    [self.navigationController.navigationBar setBarTintColor:[UIColor phPurpleColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(didTapDoneButton:)];
    [self.navigationItem setRightBarButtonItem:doneBarButtonItem];
    
    self.mainPhotoActionImageView.layer.cornerRadius = 2;
    self.mainPhotoActionImageView.layer.masksToBounds = YES;
    
    self.mainPhotoImageView.layer.cornerRadius = 2;
    self.mainPhotoImageView.layer.masksToBounds = YES;
    
    [self.aboutTextView setText:nil];
    [self.aboutTextView setPlaceholder:@"Write about yourself here..."];
    [self.aboutTextView setPlaceholderColor:[UIColor phDarkGrayColor]];
    [self.aboutTextView setDelegate:self];
    
    [self.sidePhotoTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.sidePhotoTableView setDataSource:self];
    [self.sidePhotoTableView setDelegate:self];
    [self.sidePhotoTableView registerNib:[SidePhotoTableViewCell nib]
                  forCellReuseIdentifier:SidePhotoTableViewCellIdentifier];
    
    self.defaultImage = [UIImage new];
    
    [self.mainPhotoImageView setImage:self.defaultImage];
    
    self.photos = [NSMutableArray arrayWithCapacity:5];
    [self.photos addObject:self.defaultImage];
    [self.photos addObject:self.defaultImage];
    [self.photos addObject:self.defaultImage];
    [self.photos addObject:self.defaultImage];
    [self.photos addObject:self.defaultImage];
    
    self.photosURL = [NSMutableArray arrayWithCapacity:5];
}

- (void)showImagePickerController {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    [imagePickerController setDelegate:self];
    [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePickerController setAllowsEditing:YES];
    [imagePickerController.navigationBar setTranslucent:NO];
    [imagePickerController.navigationBar setBarTintColor:[UIColor phPurpleColor]];
    [imagePickerController.navigationBar setTintColor:[UIColor whiteColor]];
    [imagePickerController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)showFacebookImagePickerController {
    OLFacebookImagePickerController *imagePickerController = [[OLFacebookImagePickerController alloc] init];
    [imagePickerController setDelegate:self];
    [imagePickerController setShouldDisplayLogoutButton:NO];
    [imagePickerController.navigationBar setTranslucent:NO];
    [imagePickerController.navigationBar setBarTintColor:[UIColor phFacebookBlueColor]];
    [imagePickerController.navigationBar setTintColor:[UIColor whiteColor]];
    [imagePickerController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - Action Sheet

- (void)showActionSheet {
    [UIActionSheet showInView:self.view
                    withTitle:nil
            cancelButtonTitle:@"Cancel"
       destructiveButtonTitle:nil
            otherButtonTitles:@[@"Camera Roll", @"Facebook"]
                     tapBlock:^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                         if (buttonIndex == 0) {
                             [self showImagePickerController];
                         } else if (buttonIndex == 1) {
                             [self showFacebookImagePickerController];
                         }
                     }];
}

- (void)showDeleteActionSheet {
    [UIActionSheet showInView:self.view
                    withTitle:nil
            cancelButtonTitle:@"Cancel"
       destructiveButtonTitle:nil
            otherButtonTitles:@[@"Delete"]
                     tapBlock:^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                         if (buttonIndex == 0) {
                             [self removeSelectedPhoto];
                         }
                     }];
}

#pragma mark - Data
- (void)loadData {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *urlToLoad = [NSString stringWithFormat:@"%@/memberinfo/%@", PHBaseNewURL, self.sharedData.fb_id];
    [manager GET:urlToLoad parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                    NSDictionary *memberinfo = [data objectForKey:@"memberinfo"];
                    if (memberinfo && memberinfo != nil) {
                        [self.aboutTextView setText:memberinfo[@"about"]];
                        [self.sharedData.userDict setValue:memberinfo[@"about"] forKey:@"about"];
                        
                        NSArray *photos = memberinfo[@"photos"];
                        [self.mainPhotoActionImageView setImage:[UIImage imageNamed:@"add_photo"]];
                        
                        if (photos.count > 0) {
                            [self.mainPhotoIndicatorView setHidden:NO];
                            [self.photosURL addObjectsFromArray:photos];
                            
                            for (int i=0; i<photos.count; i++) {
                                __weak typeof(self) weakSelf = self;
                                NSString *photoURL = photos[i];
                                [weakSelf.sharedData loadImage:photoURL onCompletion:^{
                                    __strong typeof(self) strongSelf = weakSelf;
                                    if (strongSelf) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            if (i < 5) {
                                                [strongSelf.photos replaceObjectAtIndex:i
                                                                             withObject:strongSelf.sharedData.imagesDict[photos[i]]];
                                            }
                                            
                                            if (i == 0) {
                                                [strongSelf.mainPhotoIndicatorView setHidden:YES];
                                                [strongSelf.mainPhotoActionImageView setImage:[UIImage imageNamed:@"delete_photo"]];
                                                [strongSelf.mainPhotoImageView setImage:strongSelf.sharedData.imagesDict[photos[0]]];
                                            } else {
                                                [strongSelf.sidePhotoTableView reloadData];
                                            }
                                        });
                                    }
                                }];
                            }
                        } else {
                            [self.mainPhotoIndicatorView setHidden:YES];
                            
                            for (int i=0; i<5; i++) {
                                SidePhotoTableViewCell *cell = [self.sidePhotoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
                                [cell.activityIndicatorView setHidden:YES];
                            }
                        }
                    }
                }
            }
        });
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     }];
}

- (void)updateAboutInfo {
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    NSString *url = [NSString stringWithFormat:@"%@/updateuserabout",PHBaseNewURL];
    NSDictionary *parameters = @{ //@"time" : dateWithNewFormat,
                                 @"fb_id" : self.sharedData.fb_id,
                                 @"about" : self.aboutTextView.text};
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[AnalyticManager sharedManager] trackMixPanelWithDict:@"MyProfile Update" withDict:@{}];
        [self.sharedData.userDict setValue:self.aboutTextView.text forKey:@"about"];
        
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                         message:@"There was an error updating your about info. Please try again"
//                                                        delegate:nil
//                                               cancelButtonTitle:@"OK"
//                                               otherButtonTitles:nil];
//         [alert show];
     }];
}

- (void)uploadPhotoWithImage:(UIImage *)image {
    NSString *url = [NSString stringWithFormat:@"%@/member/upload", PHBaseNewURL];
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    if (self.currentPhotoIndex == 0) {
        [self.mainPhotoIndicatorView setHidden:NO];
    }
    
    [manager POST:url parameters:@{} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
        NSData *fbIdData = [self.sharedData.fb_id dataUsingEncoding:NSUTF8StringEncoding];
        float maxFileSize = 250 * 1024;
        
        if ([imageData length] > maxFileSize) {
            imageData = UIImageJPEGRepresentation(image, maxFileSize/[imageData length]);
        }
        
        [formData appendPartWithFileData:imageData name:@"filefield" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
        [formData appendPartWithFormData:fbIdData name:@"fb_id"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self reloadPhotoDataWithChosenImage:image];
        [self.mainPhotoIndicatorView setHidden:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self reloadPhotoDataWithChosenImage:image];
        [self.mainPhotoIndicatorView setHidden:YES];
    }];
}

- (void)removeSelectedPhoto {
    NSString *url = [NSString stringWithFormat:@"%@/remove_profileimage", PHBaseNewURL];
    NSDictionary *parameters = @{@"fb_id" : self.sharedData.fb_id,
                                 @"url" : self.photosURL[self.currentPhotoIndex]};
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    if (self.currentPhotoIndex == 0) {
        [self.mainPhotoIndicatorView setHidden:NO];
    }
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        for (NSInteger i=self.currentPhotoIndex; i<=self.photos.count-1; i++) {
            if (i==self.photos.count-1) {
                [self.photos replaceObjectAtIndex:i
                                       withObject:self.defaultImage];
            } else {
                [self.photos replaceObjectAtIndex:i
                                       withObject:self.photos[i+1]];
            }
            
            if (i==0) {
                [self.mainPhotoImageView setImage:self.photos[i+1]];
                if (self.mainPhotoImageView.image == self.defaultImage) {
                    [self.mainPhotoActionImageView setImage:[UIImage imageNamed:@"add_photo"]];
                }
            }
        }
        
        [self.sidePhotoTableView reloadData];
        [self.mainPhotoIndicatorView setHidden:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.mainPhotoIndicatorView setHidden:YES];
    }];
}

- (void)reloadPhotoDataWithChosenImage:(UIImage *)chosenImage {
    for (int i=0; i<=self.currentPhotoIndex; i++) {
        if (self.photos[i] == self.defaultImage) {
            [self.photos replaceObjectAtIndex:i
                                   withObject:chosenImage];
            if (i==0 && self.photos[i] != self.defaultImage) {
                [self.mainPhotoImageView setImage:self.photos[i]];
                [self.mainPhotoActionImageView setImage:[UIImage imageNamed:@"delete_photo"]];
            }
            
            break;
        }
    }
    
    if (self.currentPhotoIndex != 0) {
        [self.sidePhotoTableView reloadData];
    }
    
}

#pragma mark - Action
- (void)didTapDoneButton:(id)sender {
    if (self.isProfileChanges) {
        [self updateAboutInfo];
    }
    
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapMainPhotoImageView:(id)sender {
    self.currentPhotoIndex = 0;
    
    if (self.mainPhotoImageView.image != self.defaultImage) {
        [self showDeleteActionSheet];
    } else {
        [self showActionSheet];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.photos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SidePhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SidePhotoTableViewCellIdentifier
                                                                   forIndexPath:indexPath];
    
    UIImage *photo = self.photos[indexPath.section+1];
    
    if (photo != self.defaultImage) {
        [cell.photoActionImageView setImage:[UIImage imageNamed:@"delete_photo"]];
        [cell.activityIndicatorView setHidden:YES];
        [cell.photoImageView setImage:photo];
    } else {
        [cell.photoActionImageView setImage:[UIImage imageNamed:@"add_photo"]];
        
        UIActivityIndicatorView *activityIndicatorView = cell.activityIndicatorView.subviews.firstObject;
        if (activityIndicatorView.isAnimating) {
            [cell.activityIndicatorView setHidden:NO];
        } else {
            [cell.activityIndicatorView setHidden:YES];
        }
        
        [cell.photoImageView setImage:nil];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return .0f;
    }
    
    return 15.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 62.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.currentPhotoIndex = indexPath.section+1;
    
    if (self.photos[indexPath.section+1] == self.defaultImage) {
        [self showActionSheet];
    } else {
        [self showDeleteActionSheet];
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    self.isProfileChanges = YES;
    
    return YES;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    self.isProfileChanges = YES;
    
    [self uploadPhotoWithImage:chosenImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - OLFacebookImagePickerControllerDelegate
- (void)facebookImagePickerDidCancelPickingImages:(OLFacebookImagePickerController *)imagePicker {
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)facebookImagePicker:(OLFacebookImagePickerController *)imagePicker didFailWithError:(NSError *)error {
}

- (void)facebookImagePicker:(OLFacebookImagePickerController *)imagePicker didFinishPickingImages:(NSArray *)images {
    NSDictionary *facebookPhotos = self.sharedData.facebookImagesDict;
    UIImage *chosenImage = facebookPhotos[[images.firstObject bestURLForSize:CGSizeMake(600, 600)]];
    
    self.isProfileChanges = YES;
    
    [self uploadPhotoWithImage:chosenImage];
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

@end
