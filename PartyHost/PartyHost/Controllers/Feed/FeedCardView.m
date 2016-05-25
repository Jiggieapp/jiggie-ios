//
//  FeedCardView.m
//  Jiggie
//
//  Created by Jiggie - Mohammad Nuruddin Effendi on 4/25/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "FeedCardView.h"
#import "Feed.h"

@interface FeedCardView ()

@property (strong, nonatomic) Feed *feed;

@end

@implementation FeedCardView

+ (FeedCardView *)instanceFromNib {
    return (FeedCardView *)[[UINib nibWithNibName:@"FeedCardView" bundle:nil] instantiateWithOwner:self options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.messageIconView.layer.cornerRadius = CGRectGetHeight(self.messageIconView.bounds) / 2;
    
    [self.personImageButton setContentMode:UIViewContentModeScaleAspectFill];
    [self.personImageButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
}

- (void)configureCardWithFeed:(Feed *)feed {
    self.feed = feed;
    
    SharedData *sharedData = [SharedData sharedInstance];
    
    [sharedData loadImage:feed.fromImageURL onCompletion:^{
        [self.personImageButton setImage:sharedData.imagesDict[feed.fromImageURL] forState:UIControlStateNormal];
        [self.personImageButton setContentMode:UIViewContentModeScaleAspectFill];
        [self.personImageButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
    }];
    
    switch (feed.type) {
        case FeedTypeViewed: {
            [self.messageIconView setHidden:YES];
            [self.cancelButton setTitle:@"SKIP" forState:UIControlStateNormal];
            [self.okButton setTitle:@"CONNECT" forState:UIControlStateNormal];
            [self.interestLabel setText:[NSString stringWithFormat:@"%@ is also interested in", feed.fromFirstName]];
            [self.eventNameLabel setText:[NSString stringWithFormat:@"%@", [feed.eventName uppercaseString]]];
            [self.connectLabel setText:[NSString stringWithFormat:@"Connect with %@", feed.fromFirstName]];
            
            break;
        }
            
        case FeedTypeApproved: {
            [self.messageIconView setHidden:NO];
            [self.cancelButton setTitle:@"NO" forState:UIControlStateNormal];
            [self.okButton setTitle:@"YES" forState:UIControlStateNormal];
            
            if ([sharedData.ABTestChat isEqualToString:@"YES"]) {
                [self.interestLabel setText:[NSString stringWithFormat:@"%@ wants to go with you to", feed.fromFirstName]];
                [self.eventNameLabel setText:[NSString stringWithFormat:@"%@", [feed.eventName uppercaseString]]];
                [self.connectLabel setText:@"Interested?"];
            } else {
                [self.interestLabel setText:[NSString stringWithFormat:@"%@ wants to chat with you about", feed.fromFirstName]];
                [self.eventNameLabel setText:[NSString stringWithFormat:@"%@", [feed.eventName uppercaseString]]];
                [self.connectLabel setText:[NSString stringWithFormat:@"Chat with %@", feed.fromFirstName]];
            }
            
            break;
        }
    }
}

- (IBAction)didTapPersonImageButton:(id)sender {
    if (self.delegate) {
        [self.delegate feedCardView:self didTapPersonImageButton:sender withFeed:self.feed];
    }
}

- (IBAction)didTapEventNameLabel:(id)sender {
    if (self.delegate) {
        [self.delegate feedCardView:self didTapEventNameLabel:sender withFeed:self.feed];
    }
}

- (IBAction)didTapOkButton:(id)sender {
    if (self.delegate) {
        [self.delegate feedCardView:self didTapButton:sender withFeed:self.feed];
    }
}

- (IBAction)didTapCancelButton:(id)sender {
    if (self.delegate) {
        [self.delegate feedCardView:self didTapButton:sender withFeed:self.feed];
    }
}

@end
