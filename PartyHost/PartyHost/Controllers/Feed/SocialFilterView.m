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

static NSString *const SocialOptionTableViewCellIdentifier = @"SocialOptionTableViewCellIdentifier";
static NSString *const SocialSliderTableViewCellIdentifier = @"SocialSliderTableViewCellIdentifier";

@interface SocialFilterView () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *discoverImageView;
@property (strong, nonatomic) IBOutlet UILabel *discoverLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation SocialFilterView

-(NSArray *)filters {
    return @[@{@"Interested in Meeting" : @"Women"},
             @{@"Maximum Distance" : @"22 miles"},
             @{@"Age" : @"18-32 years old"}];
}

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
}

#pragma mark - Action
- (IBAction)discoverDidValueChanged:(id)sender {
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
    UITableViewCell *cell;
    NSDictionary *filter = self.filters[indexPath.row];
    
    if (indexPath.row <= 0) {
        SocialOptionTableViewCell *optionCell = [tableView dequeueReusableCellWithIdentifier:SocialOptionTableViewCellIdentifier];
        if (cell == nil) {
            cell = [[SocialOptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SocialOptionTableViewCellIdentifier];
        }
        
        [optionCell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        [optionCell.titleLabel setText:filter.allKeys.firstObject];
        [optionCell.detailLabel setText:filter.allValues.firstObject];
        
        cell = optionCell;
    } else {
        SocialSliderTableViewCell *sliderCell = [tableView dequeueReusableCellWithIdentifier:SocialSliderTableViewCellIdentifier];
        if (cell == nil) {
            cell = [[SocialSliderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SocialSliderTableViewCellIdentifier];
        }
        
        [sliderCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [sliderCell.titleLabel setText:filter.allKeys.firstObject];
        [sliderCell.detailLabel setText:filter.allValues.firstObject];
        
        cell = sliderCell;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
