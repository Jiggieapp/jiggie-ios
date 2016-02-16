//
//  SetupPickView.m
//  PartyHost
//
//  Created by Tony Suriyathep on 7/1/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "SetupPickView.h"

@implementation SetupPickView

-(void)awakeFromNib {
    [self.collectionView registerClass:[SetupPickViewCell class] forCellWithReuseIdentifier:@"SetupPickViewCell"];
    
    //Init array
    self.choiceArray = [[NSMutableArray alloc] init];
    
    //Allow multiple selection
    self.collectionView.allowsMultipleSelection = YES;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.choiceArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SetupPickViewCell";
    SetupPickViewCell *cell = (SetupPickViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSString *title = self.choiceArray[indexPath.row];
    [cell.button.button setTitle:title forState:UIControlStateNormal];
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    //Get select state now
    if ([collectionView.indexPathsForSelectedItems containsObject:indexPath]) {
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        cell.button.onBorderColor = [UIColor whiteColor];        
        cell.button.offTextColor = [UIColor whiteColor];

        
        [cell.button buttonSelect:YES checkmark:YES animated:NO];
    }
    else {
        [cell.button buttonSelect:NO checkmark:NO animated:NO];
    }
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *title = self.choiceArray[indexPath.row];
    NSDictionary *fontDict = @{NSFontAttributeName:[UIFont phBold:14]};
    CGSize stringSize = [title sizeWithAttributes:fontDict];
    
    return CGSizeMake(stringSize.width + 6 + 4 + 30,38);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SetupPickViewCell *cell = (SetupPickViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    SharedData *sharedData = [SharedData sharedInstance];
    if (![sharedData.experiences containsObject:cell.button.button.titleLabel.text])
        [sharedData.experiences addObject:cell.button.button.titleLabel.text];
    [cell.button buttonSelect:YES checkmark:YES animated:YES];
}

- (BOOL)collectionView:(UICollectionView *)collectionView
shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    SharedData *sharedData = [SharedData sharedInstance];
    if (sharedData.experiences.count > 1) {
        return YES;
    }
    return NO;
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    SetupPickViewCell *cell = (SetupPickViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    SharedData *sharedData = [SharedData sharedInstance];
    [sharedData.experiences removeObject:cell.button.button.titleLabel.text];
    [cell.button buttonSelect:NO checkmark:NO animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateScrollGradients];
}

-(void)updateScrollGradients {
    UIScrollView *scrollView = (UIScrollView*)self.collectionView;
    
    if(scrollView.contentSize.height>scrollView.frame.size.height) {
        if(scrollView.contentOffset.y<=0) { //Bottom
            CAGradientLayer *gradientMask = [CAGradientLayer layer];
            gradientMask.frame = self.collectionView.bounds;
            gradientMask.colors = @[(id)[UIColor whiteColor].CGColor,(id)[UIColor clearColor].CGColor];
            gradientMask.locations = @[@0.95,@1.0];
            self.collectionView.layer.mask = gradientMask;
        }
        else if(scrollView.contentOffset.y>=scrollView.contentSize.height-scrollView.frame.size.height) { //Top
            CAGradientLayer *gradientMask = [CAGradientLayer layer];
            gradientMask.frame = self.collectionView.bounds;
            gradientMask.colors = @[(id)[UIColor clearColor].CGColor,(id)[UIColor whiteColor].CGColor];
            gradientMask.locations = @[@0.0,@0.05];
            self.collectionView.layer.mask = gradientMask;
        }
        else { //Top AND Bottom
            CAGradientLayer *gradientMask = [CAGradientLayer layer];
            gradientMask.frame = self.collectionView.bounds;
            gradientMask.colors = @[(id)[UIColor clearColor].CGColor,(id)[UIColor whiteColor].CGColor,(id)[UIColor whiteColor].CGColor,(id)[UIColor clearColor].CGColor];
            gradientMask.locations = @[@0.0,@0.05,@0.95,@1.0];
            self.collectionView.layer.mask = gradientMask;
        }
    }
}

/*
-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    //SetupPickViewCell *cell = (SetupPickViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
}

-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    //SetupPickViewCell *cell = (SetupPickViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //SetupPickViewCell *cell = (SetupPickViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    //cell.doAnimation = YES;
    return YES;
}
*/

@end
