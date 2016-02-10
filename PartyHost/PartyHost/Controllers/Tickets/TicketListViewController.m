//
//  TicketListViewController.m
//  Jiggie
//
//  Created by Setiady Wiguna on 2/3/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "TicketListViewController.h"
#import "SharedData.h"

@interface TicketListViewController ()

@end

@implementation TicketListViewController

- (id)init {
    if ((self = [super init])) {
        self.sharedData = [SharedData sharedInstance];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"nav_cancel"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    
    [[self navigationItem] setLeftBarButtonItem:closeBarButtonItem];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    [titleView setBackgroundColor:[UIColor clearColor]];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
- (void)closeButtonDidTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Data 
- (void)loadData {
    AFHTTPRequestOperationManager *manager = [self.sharedData getOperationManager];
    //events/list/
//    NSString *url = [NSString stringWithFormat:@"%@/product/list/%@",PHBaseNewURL,self.cEvent.eventID];
    NSString *url = [NSString stringWithFormat:@"%@/product/list/56b1a0bf89bfed03005c50f0",PHBaseNewURL];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSInteger responseStatusCode = operation.response.statusCode;
        if (responseStatusCode != 200) {
            return;
        }
        
        NSString *responseString = operation.responseString;
        NSError *error;
        
        NSDictionary *json = (NSDictionary *)[NSJSONSerialization
                                              JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]
                                              options:kNilOptions
                                              error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (json && json != nil) {
                @try {
                    NSDictionary *data = [json objectForKey:@"data"];
                    if (data && data != nil) {
                        NSArray *product_lists = [data objectForKey:@"product_lists"];
                        if (product_lists && product_lists != nil) {
                            self.products = product_lists;
                        }
                    }
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
            }
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


@end
