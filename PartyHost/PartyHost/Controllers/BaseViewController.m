//
//  BaseViewController.m
//  Jiggie
//
//  Created by Setiady Wiguna on 2/3/16.
//  Copyright © 2016 Sunny Clark. All rights reserved.
//

#import "BaseViewController.h"
#import "UIColor+PH.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationBar *navigationBar = [self.navigationController navigationBar];
    [navigationBar setBarTintColor:[UIColor phPurpleColor]];
    [navigationBar setTintColor:[UIColor whiteColor]];
    [navigationBar setTranslucent:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self loadVisibleSize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadVisibleSize {
    CGSize result;
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        result.width = size.height;
        result.height = size.width;
    }
    else {
        result.width = size.width;
        result.height = size.height;
    }
    
    size = [[UIApplication sharedApplication] statusBarFrame].size;
    result.height -= MIN(size.width, size.height);
    
    if (self.navigationController != nil) {
        size = self.navigationController.navigationBar.frame.size;
        result.height -= MIN(size.width, size.height);
    }
    
    if (self.tabBarController != nil) {
        size = self.tabBarController.tabBar.frame.size;
        result.height -= MIN(size.width, size.height);
    }
    
    self.visibleSize = result;

}

@end
