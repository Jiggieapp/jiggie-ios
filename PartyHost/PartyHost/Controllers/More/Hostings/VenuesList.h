//
//  VenuesList.h
//  PartyHost
//
//  Created by Sunny Clark on 2/4/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VenueListCell.h"
#import "PHImage.h"

@interface VenuesList : UIView<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (strong, nonatomic) SharedData    *sharedData;

@property(nonatomic,strong) UISearchBar     *searchBar;
@property(nonatomic,assign) BOOL            isVenuesListLoaded;
@property(nonatomic,strong) NSMutableArray  *venuesA;
@property(nonatomic,strong) UITableView     *venuesList;

@property(nonatomic,strong) NSMutableArray  *originalVenuesA;

@property(nonatomic,assign) BOOL            isSearching;

-(void)initClass;

@end
