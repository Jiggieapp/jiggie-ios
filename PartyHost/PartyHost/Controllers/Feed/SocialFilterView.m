//
//  SocialFilterView.m
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 4/28/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "SocialFilterView.h"
#import "SocialOptionTableViewCell.h"
#import "SocialSliderTableViewCell.h"
#import "SocialMultiSliderTableViewCell.h"
#import "MSRangeSlider.h"

static NSString *const SocialOptionTableViewCellIdentifier = @"SocialOptionTableViewCellIdentifier";
static NSString *const SocialSliderTableViewCellIdentifier = @"SocialSliderTableViewCellIdentifier";
static NSString *const SocialMultiSliderTableViewCellIdentifier = @"SocialMultiSliderTableViewCellIdentifier";

@interface SocialFilterView () <SocialSliderTableViewCellDelegate, SocialMultiSliderTableViewCellDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSArray *filters;
@property (strong, nonatomic) SharedData *sharedData;

@end

@implementation SocialFilterView

+ (SocialFilterView *)instanceFromNib {
    return (SocialFilterView *)[[UINib nibWithNibName:@"SocialFilterView" bundle:nil] instantiateWithOwner:self options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.layer.cornerRadius = 6.0f;
    self.backgroundColor = [UIColor clearColor];
    
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView registerNib:[SocialOptionTableViewCell nib] forCellReuseIdentifier:SocialOptionTableViewCellIdentifier];
    [self.tableView registerNib:[SocialSliderTableViewCell nib] forCellReuseIdentifier:SocialSliderTableViewCellIdentifier];
    [self.tableView registerNib:[SocialMultiSliderTableViewCell nib] forCellReuseIdentifier:SocialMultiSliderTableViewCellIdentifier];
    
    self.sharedData = [SharedData sharedInstance];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    [self reloadData];
}

#pragma mark - Data
- (void)reloadData {
    [self.discoverSwitch setOn:self.sharedData.matchMe];
    
    NSString *genderInterest = @"";
    if ([self.sharedData.gender_interest isEqualToString:@"female"]) {
        genderInterest = @"Women";
    } else if([self.sharedData.gender_interest isEqualToString:@"male"]) {
        genderInterest = @"Men";
    } else {
        genderInterest = @"Both";
    }
    
    self.filters = @[@{@"Interested in Meeting" : genderInterest},
                     @{@"Maximum Distance" : self.sharedData.distance},
                     @{@"Age" : [NSString stringWithFormat:@"%@-%@ years old",
                                 self.sharedData.from_age,
                                 self.sharedData.to_age]}];
    [self.tableView reloadData];
}

#pragma mark - View
- (void)setMatchViewToOn:(BOOL)matched {
    [self.discoverSwitch setOn:matched animated:YES];
    
    if (matched) {
        [self.discoverImageView setImage:[UIImage imageNamed:@"discover_on"]];
        [self.discoverLabel setText:@"Turn off if you do not wish to be seen by others"];
    } else {
        [self.discoverImageView setImage:[UIImage imageNamed:@"discover_off"]];
        [self.discoverLabel setText:@"Turn on if you wish to be seen by others"];
    }
}

#pragma mark - Action
- (IBAction)discoverDidValueChanged:(UISwitch *)sender {
    if (!sender.isOn) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Turn off socialize?"
                                                        message:@"while turned off, your profile card won't be shown to other users."
                                                       delegate:self
                                              cancelButtonTitle:@"Go Invisible"
                                              otherButtonTitles:@"Cancel",nil];
        [alert show];
    } else {
        [self setMatchViewToOn:YES];
        
        if (self.delegate) {
            [self.delegate socialFilterView:self discoverDidValueChanged:sender];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.filters count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
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
    NSDictionary *filter = self.filters[indexPath.row];
    
    if (indexPath.row <= 0) {
        SocialOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SocialOptionTableViewCellIdentifier];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        [cell.titleLabel setText:filter.allKeys.firstObject];
        [cell.detailLabel setText:filter.allValues.firstObject];
    
        return cell;
    } else if (indexPath.row == 1) {
        SocialSliderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SocialSliderTableViewCellIdentifier];
        
        if (!cell.delegate) {
            cell.delegate = self;
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.titleLabel setText:filter.allKeys.firstObject];
        [cell.slider setMinimumValue:1];
        [cell.slider setMaximumValue:160];
        [cell.slider setValue:[self.sharedData.distance intValue]];
        [cell.detailLabel setText:[NSString stringWithFormat:@"%@ KM", self.sharedData.distance]];
        
        return cell;
    } else {
        SocialMultiSliderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SocialMultiSliderTableViewCellIdentifier];
        
        if (!cell.delegate) {
            cell.delegate = self;
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.titleLabel setText:filter.allKeys.firstObject];
        [cell.detailLabel setText:[NSString stringWithFormat:@"%@ - %@ years old",
                                         self.sharedData.from_age, self.sharedData.to_age]];
        [cell.slider setFromValue:[self.sharedData.from_age floatValue]];
        [cell.slider setToValue:[self.sharedData.to_age floatValue]];
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending) {
        return UITableViewAutomaticDimension;
    }

    return indexPath.row == 0 ? 50 : 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row <= 0) {
        SocialOptionTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell.detailLabel.text isEqualToString:@"Women"]) {
            [cell.detailLabel setText:@"Men"];
        } else if([cell.detailLabel.text isEqualToString:@"Men"]) {
            [cell.detailLabel setText:@"Both"];
        } else {
            [cell.detailLabel setText:@"Women"];
        }
        
        if (self.delegate) {
            [self.delegate socialFilterView:self interestDidValueChanged:cell.detailLabel.text];
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self setMatchViewToOn:NO];
        
        if (self.delegate) {
            [self.delegate socialFilterView:self discoverDidValueChanged:self.discoverSwitch];
        }
    } else {
        [self setMatchViewToOn:YES];
    }
}

#pragma mark - SocialSliderTableViewCellDelegate
- (void)socialSliderTableViewCell:(SocialSliderTableViewCell *)cell sliderDidValueChanged:(UISlider *)slider {
    [cell.detailLabel setText:[NSString stringWithFormat:@"%d KM", (int)roundf(slider.value)]];

    if (self.delegate) {
        [self.delegate socialFilterView:self distanceDidValueChanged:slider];
    }
}

#pragma mark - SocialMultiSliderTableViewCellDelegate
- (void)socialMultiSliderTableViewCell:(SocialMultiSliderTableViewCell *)cell sliderDidValueChanged:(MSRangeSlider *)slider {
    [cell.detailLabel setText:[NSString stringWithFormat:@"%d - %d years old", (int)roundf(slider.fromValue), (int)roundf(slider.toValue)]];
    
    if (self.delegate) {
        [self.delegate socialFilterView:self ageDidValueChanged:slider];
    }
}

@end
