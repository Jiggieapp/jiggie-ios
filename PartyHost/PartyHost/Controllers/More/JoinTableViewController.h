//
//  JoinTableViewController.h
//  Jiggie
//
//  Created by Setiady Wiguna on 8/3/16.
//  Copyright © 2016 Jiggie. All rights reserved.
//

#import "BaseViewController.h"

@interface JoinTableViewController : BaseViewController

- (IBAction)joinTableDidTap:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *tableCodeTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@end
