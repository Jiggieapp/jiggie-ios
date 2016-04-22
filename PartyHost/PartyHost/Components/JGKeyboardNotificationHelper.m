//
//  JGKeyboardNotificationHelper.m
//  Jiggie
//
//  Created by Uuds on 4/21/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "JGKeyboardNotificationHelper.h"

@interface JGKeyboardNotificationHelper ()

@property (strong, nonatomic) KeyboardNotificatonCompletion keyboardNotificationCompletion;

@end

@implementation JGKeyboardNotificationHelper

- (void)addObserser {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveKeyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveKeyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeObserser:(id)observer {
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

- (void)handleKeyboardNotificationWithCompletion:(KeyboardNotificatonCompletion)completion {
    self.keyboardNotificationCompletion = completion;
}

#pragma mark - Private Function
- (void)didReceiveKeyboardWillShowNotification:(NSNotification *)notification
{
    [self keyboardHandleNotification:notification
                            willHide:NO];
}

- (void)didReceiveKeyboardWillHideNotification:(NSNotification *)notification
{
    [self keyboardHandleNotification:notification
                            willHide:YES];
}

- (void)keyboardHandleNotification:(NSNotification *)notification willHide:(BOOL)hide
{
    NSDictionary *info = [notification userInfo];
    UIViewAnimationOptions animation = [info[UIKeyboardAnimationCurveUserInfoKey] intValue];
    NSTimeInterval duration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = hide ? CGRectZero : [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (self.keyboardNotificationCompletion)
    {
        self.keyboardNotificationCompletion(animation,
                                            duration,
                                            frame);
    }
}

@end
