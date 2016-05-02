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

#define kSidePhotoTag 1500

@interface ProfileViewController () <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, OLFacebookImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *sidePhoto1Button;
@property (strong, nonatomic) IBOutlet UIButton *sidePhoto2Button;
@property (strong, nonatomic) IBOutlet UIButton *sidePhoto3Button;
@property (strong, nonatomic) IBOutlet UIButton *sidePhoto4Button;

@property (strong, nonatomic) SharedData *sharedData;
@property (assign, nonatomic) BOOL isProfileChanges;

@property (strong, nonatomic) UIImageView *currentImageView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"EDIT PROFILE";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadPhotos)
                                                 name:@"LOAD_PROFILE_PHOTOS"
                                               object:nil];
    
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
    
    CGFloat radius = 2;
    
    self.mainPhotoImageView.layer.cornerRadius = radius;
    self.sidePhoto1ImageView.layer.cornerRadius = radius;
    self.sidePhoto2ImageView.layer.cornerRadius = radius;
    self.sidePhoto3ImageView.layer.cornerRadius = radius;
    self.sidePhoto4ImageView.layer.cornerRadius = radius;
    
    self.mainPhotoImageView.layer.masksToBounds = YES;
    self.sidePhoto1ImageView.layer.masksToBounds = YES;
    self.sidePhoto2ImageView.layer.masksToBounds = YES;
    self.sidePhoto3ImageView.layer.masksToBounds = YES;
    self.sidePhoto4ImageView.layer.masksToBounds = YES;
    
    self.sidePhoto1Button.layer.cornerRadius = radius;
    self.sidePhoto2Button.layer.cornerRadius = radius;
    self.sidePhoto3Button.layer.cornerRadius = radius;
    self.sidePhoto4Button.layer.cornerRadius = radius;
    
    self.sidePhoto1Button.tag = kSidePhotoTag+1;
    self.sidePhoto2Button.tag = kSidePhotoTag+2;
    self.sidePhoto3Button.tag = kSidePhotoTag+3;
    self.sidePhoto4Button.tag = kSidePhotoTag+4;
    
    [self.aboutTextView setText:nil];
    [self.aboutTextView setPlaceholder:@"Write about yourself here..."];
    [self.aboutTextView setPlaceholderColor:[UIColor phDarkGrayColor]];
    [self.aboutTextView setDelegate:self];
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

#pragma mark - Data
- (void)loadData {
    NSString *aboutText = self.sharedData.userDict[@"about"];
    if (aboutText.length > 0) {
        [self.aboutTextView setText:aboutText];
    } else {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        NSString *urlToLoad = [NSString stringWithFormat:@"%@/memberinfo/%@",PHBaseNewURL,self.sharedData.fb_id];
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
                        }
                    }
                }
            });
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         }];
    }
    
    [self loadPhotos];
}

- (void)loadPhotos {
    NSArray *photos = self.sharedData.photosDict[@"photos"];
    for (int i=0; i<photos.count; i++) {
        __weak typeof(self) weakSelf = self;
        NSString *photoURL = photos[i];
        [weakSelf.sharedData loadImage:photoURL onCompletion:^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (i == 0) {
                        [strongSelf.mainPhotoImageView setImage:strongSelf.sharedData.imagesDict[photos[0]]];
                    } else if (i == 1) {
                        [strongSelf.sidePhoto1ImageView setImage:strongSelf.sharedData.imagesDict[photos[1]]];
                    } else if (i == 2) {
                        [strongSelf.sidePhoto2ImageView setImage:strongSelf.sharedData.imagesDict[photos[2]]];
                    } else if (i == 3) {
                        [strongSelf.sidePhoto3ImageView setImage:strongSelf.sharedData.imagesDict[photos[3]]];
                    } else if (i == 4) {
                        [strongSelf.sidePhoto4ImageView setImage:strongSelf.sharedData.imagesDict[photos[4]]];
                    }
                });
            }
        }];
    }
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

#pragma mark - Action
- (void)didTapDoneButton:(id)sender {
    if (self.isProfileChanges) {
        [self updateAboutInfo];
    }
    
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapMainPhotoImageView:(id)sender {
    self.currentImageView = self.mainPhotoImageView;
    [self showActionSheet];
}

- (IBAction)didTapSidePhotoButton:(UIButton *)sender {
    NSInteger tag = sender.tag-kSidePhotoTag;
    if (tag == 1) {
        self.currentImageView = self.sidePhoto1ImageView;
    } else if (tag == 2) {
        self.currentImageView = self.sidePhoto2ImageView;
    } else if (tag == 3) {
        self.currentImageView = self.sidePhoto3ImageView;
    } else {
        self.currentImageView = self.sidePhoto4ImageView;
    }
    
    [self showActionSheet];
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
    [self.currentImageView setImage:chosenImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    self.isProfileChanges = YES;
}

#pragma mark - OLFacebookImagePickerControllerDelegate
- (void)facebookImagePickerDidCancelPickingImages:(OLFacebookImagePickerController *)imagePicker {
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)facebookImagePicker:(OLFacebookImagePickerController *)imagePicker didFailWithError:(NSError *)error {
}

- (void)facebookImagePicker:(OLFacebookImagePickerController *)imagePicker didFinishPickingImages:(NSArray *)images {
    OLFacebookImage *chosenImage = images.firstObject;
    NSDictionary *facebookPhotos = self.sharedData.facebookImagesDict;
    
    [self.currentImageView setImage:facebookPhotos[[chosenImage bestURLForSize:CGSizeMake(600, 600)]]];
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

@end
