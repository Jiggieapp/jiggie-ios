//
//  JGKeyboardNotificationHelper.h
//  Jiggie
//
//  Created by Uuds on 4/21/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^KeyboardNotificatonCompletion)(UIViewAnimationOptions animation,
                                              NSTimeInterval duration,
                                              CGRect frame);

@interface JGKeyboardNotificationHelper : NSObject

- (void)addObserser;
- (void)removeObserser:(id)observer;

- (void)handleKeyboardNotificationWithCompletion:(KeyboardNotificatonCompletion)completion;

@end
