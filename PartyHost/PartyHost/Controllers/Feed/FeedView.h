//
//  FeedViewController.h
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 4/25/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedView : UIView

+ (FeedView *)instanceFromNib;

- (void)loadDataAndShowHUD:(BOOL)show withCompletionHandler:(PartyFeedCompletionHandler)completion;

@end
