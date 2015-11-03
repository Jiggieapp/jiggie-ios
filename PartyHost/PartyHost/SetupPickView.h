//
//  SetupPickView.h
//  PartyHost
//
//  Created by Tony Suriyathep on 7/1/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetupPickViewCell.h"

@interface SetupPickView : UIView <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *choiceArray;

-(void)updateScrollGradients;

@end
