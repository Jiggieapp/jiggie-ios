//
//  ProfileViewController.m
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 4/29/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "EditProfileViewController.h"
#import "AnalyticManager.h"
#import "UIActionSheet+Blocks.h"
#import "UITextView+Placeholder.h"
#import "OLFacebookImagePickerController.h"
#import "OLFacebookImage.h"
#import "SVProgressHUD.h"
#import "SharedData.h"
#import "AnalyticManager.h"
#import "SidePhotoTableViewCell.h"

static NSString *const SidePhotoTableViewCellIdentifier = @"SidePhotoTableViewCellIdentifier";

@interface EditProfileViewController () <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, OLFacebookImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *mainPhotoIndicatorView;
@property (strong, nonatomic) IBOutlet UIImageView *mainPhotoActionImageView;

@property (strong, nonatomic) SharedData *sharedData;
@property (assign, nonatomic) BOOL isProfileChanges;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) NSMutableArray *photosURL;
@property (assign, nonatomic) NSInteger currentPhotoIndex;
@property (strong, nonatomic) NSMutableArray *photoIndexs;
@property (strong, nonatomic) UIImage *defaultImage;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Edit Profile";
    
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
     @{NSForegroundColorAttributeName : [UIColor whiteColor],
       NSFontAttributeName : [UIFont phBlond:16]}];
    
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
    self.photoIndexs = [NSMutableArray arrayWithCapacity:5];
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
    NSString *url = [NSString stringWithFormat:@"%@/memberinfo/%@", PHBaseNewURL, self.sharedData.fb_id];
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                        [self.mainPhotoIndicatorView setHidden:YES];
                        
                        if (photos.count > 0) {
                            [self.mainPhotoIndicatorView setHidden:NO];
                            [self.photosURL addObjectsFromArray:photos];
                            
                            for (int i=0; i<photos.count; i++) {
                                SidePhotoTableViewCell *cell = [self.sidePhotoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
                                UIActivityIndicatorView *activityIndicatorView = cell.activityIndicatorView.subviews.firstObject;
                                
                                [cell.activityIndicatorView setHidden:NO];
                                [activityIndicatorView startAnimating];
                            }
                            
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
                                                [strongSelf.sidePhotoTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:i-1]] withRowAnimation:UITableViewRowAnimationNone];
                                            }
                                        });
                                    }
                                }];
                            }
                            
                            for (NSUInteger i=photos.count; i<self.photos.count; i++) {
                                [self.sidePhotoTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:i-1]] withRowAnimation:UITableViewRowAnimationNone];
                            }
                        }
                    }
                }
            }
        });
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self.mainPhotoIndicatorView setHidden:YES];
         
         for (int i=0; i<self.photos.count; i++) {
             SidePhotoTableViewCell *cell = [self.sidePhotoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
             UIActivityIndicatorView *activityIndicatorView = cell.activityIndicatorView.subviews.firstObject;
             
             [cell.activityIndicatorView setHidden:YES];
             [activityIndicatorView stopAnimating];
         }
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
     }];
}

- (void)uploadPhotoWithImage:(UIImage *)image {
    [self.photoIndexs addObject:@(self.currentPhotoIndex)];
    
    NSString *url = [NSString stringWithFormat:@"%@/member/upload", PHBaseNewURL];
    NSDictionary *userInfo = @{@"CurrentPhotoIndex" : @(self.currentPhotoIndex)};
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    if (self.photos.firstObject == self.defaultImage) {
        [self.mainPhotoIndicatorView setHidden:NO];
    }
    
    for (int i=0; i<=self.currentPhotoIndex; i++) {
        SidePhotoTableViewCell *cell = [self.sidePhotoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i-1]];
        UIActivityIndicatorView *activityIndicatorView = cell.activityIndicatorView.subviews.firstObject;
        
        if (self.photos[i] == self.defaultImage) {
            [cell.activityIndicatorView setHidden:NO];
            [activityIndicatorView startAnimating];
            
            break;
        }
    }
    
    [manager POST:url parameters:@{} userInfo:userInfo constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
        NSData *fbIdData = [self.sharedData.fb_id dataUsingEncoding:NSUTF8StringEncoding];
        float maxFileSize = 250 * 1024;
        
        if ([imageData length] > maxFileSize) {
            imageData = UIImageJPEGRepresentation(image, maxFileSize/[imageData length]);
        }
        
        [formData appendPartWithFileData:imageData name:@"filefield" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
        [formData appendPartWithFormData:fbIdData name:@"fb_id"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSNumber *index = operation.userInfo[@"CurrentPhotoIndex"];
        
        [self.photoIndexs removeObject:index];
        
        NSString *responseString = operation.responseString;
        NSError *error;
        NSDictionary *json = (NSDictionary *)[NSJSONSerialization
                                              JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]
                                              options:kNilOptions
                                              error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (json && json != nil) {
                [self.photosURL addObject:json[@"url"]];
                [self reloadPhotoDataWithChosenImage:image andIndex:[index integerValue]];
                [self.mainPhotoIndicatorView setHidden:YES];
                
                NSDictionary *parameters = @{@"Image URL" : json[@"url"]};
                
                [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Picture Upload"
                                                              withDict:parameters];
            }
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSNumber *index = operation.userInfo[@"CurrentPhotoIndex"];
            
            [self.photoIndexs removeObject:index];
            [self reloadPhotoDataWithChosenImage:image andIndex:[index integerValue]];
            [self.mainPhotoIndicatorView setHidden:YES];
        });
    }];
}

- (void)removeSelectedPhoto {
    NSString *url = [NSString stringWithFormat:@"%@/remove_profileimage", PHBaseNewURL];
    NSString *photoURL = self.currentPhotoIndex < self.photosURL.count ? self.photosURL[self.currentPhotoIndex] : self.photosURL[self.photosURL.count-1];
    NSDictionary *parameters = @{@"fb_id" : self.sharedData.fb_id,
                                 @"url" : photoURL};
    NSDictionary *userInfo = @{@"CurrentPhotoIndex" : @(self.currentPhotoIndex)};
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    
    if (self.currentPhotoIndex == 0) {
        [self.mainPhotoIndicatorView setHidden:NO];
    } else {
        SidePhotoTableViewCell *cell = [self.sidePhotoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.currentPhotoIndex-1]];
        UIActivityIndicatorView *activityIndicatorView = cell.activityIndicatorView.subviews.firstObject;
        [cell.activityIndicatorView setHidden:NO];
        [activityIndicatorView startAnimating];
    }
    
    [manager POST:url parameters:parameters userInfo:userInfo
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              dispatch_async(dispatch_get_main_queue(), ^{
                  NSNumber *index = operation.userInfo[@"CurrentPhotoIndex"];
                  
                  if ([index integerValue] < self.photosURL.count) {
                      [self.photosURL removeObjectAtIndex:[index integerValue]];
                  } else {
                      [self.photosURL removeLastObject];
                  }
                  
                  for (NSInteger i=[index integerValue]; i<self.photos.count; i++) {
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
                  
                  for (NSInteger i=[index integerValue]; i<self.photos.count; i++) {
                      if (i==0) {
                          [self.sidePhotoTableView reloadData];
                      } else {
                          [self.sidePhotoTableView reloadRowsAtIndexPaths:@[[NSIndexPath
                                                                             indexPathForRow:0
                                                                             inSection:i-1]]
                                                         withRowAnimation:UITableViewRowAnimationNone];
                      }
                  }
                  
                  NSDictionary *parameters = @{@"Image URL" : photoURL};
                  
                  [[AnalyticManager sharedManager] trackMixPanelWithDict:@"Picture Delete"
                                                                withDict:parameters];
                  
                  [self.photoIndexs removeObject:index];
                  [self.mainPhotoIndicatorView setHidden:YES];
              });
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              dispatch_async(dispatch_get_main_queue(), ^{
                  NSNumber *index = operation.userInfo[@"CurrentPhotoIndex"];
                  
                  [self.photoIndexs removeObject:index];
                  [self.mainPhotoIndicatorView setHidden:YES];
              });
          }];
}

- (void)reloadPhotoDataWithChosenImage:(UIImage *)chosenImage andIndex:(NSInteger)index {
    for (int i=0; i<=self.currentPhotoIndex; i++) {
        if (self.photos[i] == self.defaultImage) {
            [self.photos replaceObjectAtIndex:i
                                   withObject:chosenImage];
            if (i==0 && self.photos[i] != self.defaultImage) {
                [self.mainPhotoImageView setImage:self.photos[i]];
                [self.mainPhotoActionImageView setImage:[UIImage imageNamed:@"delete_photo"]];
            }
            
            index = i;
            
            break;
        }
    }
    
    if (index != 0) {
        [self.sidePhotoTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:index-1]]
                                       withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

#pragma mark - Action
- (void)didTapDoneButton:(id)sender {
    if (self.isProfileChanges) {
        [self updateAboutInfo];
    }
    
    NSMutableArray *photos = [NSMutableArray array];
    
    for (UIImage *photo in self.photos) {
        if (photo != self.defaultImage) {
            [photos addObject:photo];
        }
    }
    
    NSDictionary *object = @{@"photos" : photos,
                             @"about" : self.aboutTextView.text};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EDIT_PROFILE_DONE"
                                                        object:object];
    
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapMainPhotoImageView:(id)sender {
    self.currentPhotoIndex = 0;
    
    if (self.mainPhotoImageView.image != self.defaultImage) {
        if (self.photosURL.count > 1) {
            [self showDeleteActionSheet];
        }
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
    UIActivityIndicatorView *activityIndicatorView = cell.activityIndicatorView.subviews.firstObject;
    
    if (photo != self.defaultImage) {
        [cell.photoActionImageView setImage:[UIImage imageNamed:@"delete_photo"]];
        [activityIndicatorView stopAnimating];
        [cell.activityIndicatorView setHidden:YES];
        [cell.photoImageView setImage:photo];
    } else {
        [cell.photoActionImageView setImage:[UIImage imageNamed:@"add_photo"]];
        [activityIndicatorView stopAnimating];
        [cell.activityIndicatorView setHidden:YES];
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
    
    SidePhotoTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIActivityIndicatorView *activityIndicatorView = cell.activityIndicatorView.subviews.firstObject;

    if (!activityIndicatorView.isAnimating) {
        if (self.photos[indexPath.section+1] == self.defaultImage) {
            [self showActionSheet];
        } else {
            [self showDeleteActionSheet];
        }
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
