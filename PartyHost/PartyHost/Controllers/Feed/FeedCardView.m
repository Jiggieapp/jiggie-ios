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
    
    [self.overlayView setAlpha:0];
}

- (void)showConnectOverlayView {
    [self.overlayView setAlpha:1.0f];
    [self.overlayView setBackgroundColor:[[UIColor phBlueColor] colorWithAlphaComponent:0.7f]];
    [self.connectIconImageView setImage:[UIImage imageNamed:@"social-connect-overlay-icon"]];
}

- (void)showSkipOverlayView {
    [self.overlayView setAlpha:1.0f];
    [self.overlayView setBackgroundColor:[[UIColor colorFromHexCode:@"B4B4B4"] colorWithAlphaComponent:0.8f]];
    [self.connectIconImageView setImage:[UIImage imageNamed:@"skip-connect-overlay-icon"]];
}

- (void)showOverlayViewAtLocation:(CGPoint)location withAlpha:(CGFloat)alpha {
    if (alpha <= 1.0f) {
        [self.overlayView setAlpha:alpha];
    }
    
    if (location.x > (CGRectGetWidth([UIScreen mainScreen].bounds) / 2) - 10) {
        [self.overlayView setBackgroundColor:[[UIColor phBlueColor] colorWithAlphaComponent:0.7f]];
        [self.connectIconImageView setImage:[UIImage imageNamed:@"social-connect-overlay-icon"]];
    } else {
        [self.overlayView setBackgroundColor:[[UIColor colorFromHexCode:@"B4B4B4"] colorWithAlphaComponent:0.8f]];
        [self.connectIconImageView setImage:[UIImage imageNamed:@"skip-connect-overlay-icon"]];
    }
}

- (void)configureCardWithFeed:(Feed *)feed {
    self.feed = feed;
    
    SharedData *sharedData = [SharedData sharedInstance];
    
    [sharedData loadImage:feed.fromImageURL onCompletion:^{
        [self.personImageButton setImage:sharedData.imagesDict[feed.fromImageURL] forState:UIControlStateNormal];
        [self.personImageButton setContentMode:UIViewContentModeScaleAspectFill];
        [self.personImageButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
    }];
    
    if ([feed.hasBooking boolValue]) {
        [self.hasTableImageView setImage:[UIImage imageNamed:@"feed-table-icon"]];
    } else {
        [self.hasTableImageView setImage:nil];
    }
    
    if ([feed.hasTicket boolValue]) {
        [self.hasTicketImageView setImage:[UIImage imageNamed:@"feed-ticket-icon"]];
    } else {
        [self.hasTicketImageView setImage:nil];
    }
    
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
    
    switch (feed.source) {
        case FeedSourceEvent: {
            
            break;
        }
            
        case FeedSourceNearby: {
             [self.eventNameLabel setText:@"IS NEARBY"];
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
        if (self.feed.source) {
            if (self.feed.source == FeedSourceEvent) {
                [self.delegate feedCardView:self didTapEventNameLabel:sender withFeed:self.feed];
            }
        } else {
            [self.delegate feedCardView:self didTapEventNameLabel:sender withFeed:self.feed];
        }
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
