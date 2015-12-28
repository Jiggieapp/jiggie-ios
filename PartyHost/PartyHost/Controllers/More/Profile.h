//
//  Profile.h
//  PartyHost
//
//  Created by Sunny Clark on 12/26/14.
//  Copyright (c) 2014 Sunny Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHImage.h"

@interface Profile : UIView<UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) SharedData    *sharedData;

@property(nonatomic,strong) UIScrollView    *picScroll;
@property(nonatomic,strong) UIScrollView    *mainScroll;
@property(nonatomic,strong) UIView          *tabBar;
@property(nonatomic,strong) UILabel         *toLabel;
@property(nonatomic,strong) UIView          *aboutPanel;
@property(nonatomic,strong) UIView          *bgView;
@property(nonatomic,strong) UILabel         *nameLabel;
@property(nonatomic,strong) UILabel         *cityLabel;
@property(nonatomic,strong) UILabel         *aboutLabel;
@property(nonatomic,strong) UITextView      *aboutBody;
@property(nonatomic,strong) UIPageControl   *pControl;
@property(nonatomic,strong) UIView          *separator1;

@property(nonatomic,assign) BOOL            isPanelOpen;
@property(nonatomic,assign) BOOL            startPhotosLoad;

@property(nonatomic,strong) UIButton        *btnEdit;

-(void)initClass;

@end
