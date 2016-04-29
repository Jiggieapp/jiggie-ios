//
//  VenuesList.m
//  PartyHost
//
//  Created by Sunny Clark on 2/4/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import "VenuesList.h"

#define contains(str1, str2) ([str1 rangeOfString:str2 options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)].location != NSNotFound)

@implementation VenuesList



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    self.sharedData = [SharedData sharedInstance];
    self.isSearching = NO;
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    self.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchBar.layer.borderColor = [UIColor whiteColor].CGColor;
    self.searchBar.delegate = self;
    
    self.venuesA = [[NSMutableArray alloc] init];
    self.originalVenuesA = [[NSMutableArray alloc] init];
    self.venuesList = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, frame.size.width, frame.size.height - 50)];
    self.venuesList.delegate = self;
    self.venuesList.dataSource = self;
    self.venuesList.tableHeaderView = self.searchBar;
    self.venuesList.allowsMultipleSelectionDuringEditing = NO;
    self.venuesList.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.hostingsList.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self addSubview:self.venuesList];
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(loadData)
     name:@"APP_LOADED"
     object:nil];
    
    
    return self;
}

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText
{
    if([searchText isEqualToString:@""])
    {
        self.isSearching = NO;
        [self.searchBar resignFirstResponder];
        [self.venuesA removeAllObjects];
        [self.venuesA addObjectsFromArray:self.originalVenuesA];
        [self.venuesList reloadData];
    }else{
        self.isSearching = YES;
        [self searchLoadData:searchText];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"CANCELLED!!");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.isVenuesListLoaded == NO)?1:[self.venuesA count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.isVenuesListLoaded)
    {
        return;
    }
    
    //MyHostingsCell *cell = (MyHostingsCell *)[tableView cellForRowAtIndexPath:indexPath];
    self.sharedData.cVenueListIndex = (int)indexPath.row;
    
    if(self.isSearching)
    {
        NSDictionary *dict = [self.venuesA objectAtIndex:indexPath.row];
        for (int i = 0; i < [self.originalVenuesA count]; i++)
        {
            NSDictionary *dictToCompare = [self.originalVenuesA objectAtIndex:i];
            if([dict isEqualToDictionary:dictToCompare])
            {
                self.sharedData.cVenueListIndex = i;
            }
        }
    }
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"VENUELIST_SELECTED"
     object:self];
    self.hidden = YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"VenueListCell";
    
    VenueListCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[VenueListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if(self.isVenuesListLoaded)
    {
        NSDictionary *dict = [self.venuesA objectAtIndex:indexPath.row];
        cell.textLabel.text = @"";
        cell.title.text = dict[@"name"];
        cell.subtitle.text = [dict[@"neighborhood"] capitalizedString];
        
        if([dict[@"photos"] count]>0)
        {
            NSString *picURL = [dict[@"photos"] objectAtIndex:0];
            [cell.bkImage loadImage:picURL defaultImageNamed:@"nightclub_default"];
        }
    }else{
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"Loading";
        cell.bkImage.image = [UIImage imageNamed:@"nightclub_default"];
    }
    
    return cell;
}

-(void)initClass
{
    self.venuesList.contentOffset = CGPointMake(0, 0);
    self.searchBar.text = @"";
    if(!self.isVenuesListLoaded)
    {
        [self loadData];
    }else{
        self.isSearching = NO;
        [self.searchBar resignFirstResponder];
        [self.venuesA removeAllObjects];
        [self.venuesA addObjectsFromArray:self.originalVenuesA];
        [self.venuesList reloadData];
    }
}

-(void)searchLoadData:(NSString *)term
{
    [self.venuesA removeAllObjects];
    
    for (int i = 0; i < [self.originalVenuesA count]; i++)
    {
        NSDictionary *dict = [self.originalVenuesA objectAtIndex:i];
        NSString *name = dict[@"name"];
        NSString *address = [dict[@"neighborhood"] capitalizedString];
        //NSString *name = dict[@"title"];
        //NSString *address = [dict[@"venue"][@"name"] capitalizedString];
        
        if(contains(name,term) || contains(address,term))
        {
            [self.venuesA addObject:dict];
        }
    }
    
    [self.venuesList reloadData];
}

-(void)loadData
{
    /**/
//    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
//    NSString *url = [NSString stringWithFormat:@"%@/venues/list",PHBaseURL];
//    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         self.isVenuesListLoaded = YES;
//         NSLog(@"VENUE_LIST");
//         NSLog(@"%@",responseObject);
//         
//         [self.sharedData.venuesNameList removeAllObjects];
//         [self.sharedData.venuesNameList addObjectsFromArray:responseObject];
//         [self.venuesA removeAllObjects];
//         [self.venuesA addObjectsFromArray:responseObject];
//         [self.originalVenuesA removeAllObjects];
//         [self.originalVenuesA addObjectsFromArray:responseObject];
//         [self.venuesList reloadData];
//     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
//         NSLog(@"ERROR :: %@",error);
//     }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
