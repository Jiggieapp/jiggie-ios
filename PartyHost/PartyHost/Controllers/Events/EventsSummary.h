//
//  EventsVenueDetail.h
//  PartyHost
//
//  Created by Sunny Clark on 2/14/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MKMapView+ZoomLevel.h"
#import "SetupPickViewCell.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "KTCenterFlowLayout.h"
#import "EmptyView.h"
#import "Event.h"

@class JDFSequentialTooltipManager;
@interface EventsSummary : UIView<UIScrollViewDelegate,CLLocationManagerDelegate,MKMapViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}

@property (strong, nonatomic) SharedData *sharedData;

@property (nonatomic, assign) BOOL isLoaded;
@property (nonatomic, strong) NSMutableDictionary *mainDict;
@property (nonatomic, strong) NSString *event_id;
@property (nonatomic, strong) NSString *groupRoomId;
@property (nonatomic, assign) BOOL isFromMessage;

//Nav top
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UIView *navBar;
@property (nonatomic,strong) UIButton *btnBack;
@property (nonatomic, strong) UIButton *btnShare;
@property (nonatomic, assign) BOOL isNavBarShowing;

@property (nonatomic, strong) EmptyView *emptyView;

@property (nonatomic, strong) UIButton *btnHostHere;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UILabel *likeCount;
@property (nonatomic, strong) UIButton *chatButton;
@property (nonatomic, strong) UILabel *membersCount;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UILabel *eventName;
@property (nonatomic, strong) UILabel *venueName;
@property (nonatomic, strong) UIView *separator1;
@property (nonatomic, strong) UILabel *guestInterestedLabel;
@property (nonatomic, strong) UILabel *hostNum;
@property (nonatomic, strong) UIView *userContainer;
@property (nonatomic, strong) UIView *listingContainer;

@property(nonatomic,strong) UIView *infoView;
@property(nonatomic,strong) UILabel *startFromLabel;
@property(nonatomic,strong) UILabel *minimumPrice;

@property (nonatomic, strong) NSMutableArray *tagArray;
@property (nonatomic, strong) UICollectionView *tagCollection;

@property (nonatomic, strong) UIView *separator2;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *eventDate;
@property (nonatomic, strong) UITextView *aboutBody;
@property (nonatomic, strong) UIScrollView *mainScroll;
@property (nonatomic, strong) UIScrollView *picScroll;
@property (nonatomic, strong) UIPageControl *pControl;
@property (nonatomic, strong) UIView *innerBg;

@property (nonatomic, strong) UIView *seeMapView;
@property (nonatomic, strong) UILabel *seeMapLabel;
@property (nonatomic, strong) UILabel *externalSiteLabel;
@property (nonatomic, strong) UIImageView *seeMapCaret;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKPlacemark *cPlaceMark;
@property (nonatomic, strong) NSString *fillType;
@property (nonatomic, strong) NSString *fillValue;

@property (nonatomic, strong) Event *cEvent;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic,strong) JDFSequentialTooltipManager *tooltip;

@property (assign, nonatomic) BOOL isModal;

-(void)loadData:(NSString*)event_id;
-(void)populateData:(NSDictionary *)dict;
-(void)initClassWithEvent:(Event *)event;
-(void)initClassWithEventID:(NSString *)eventID;
-(void)initClassModalWithEventID:(NSString *)eventID;
-(void)reset;

@end
