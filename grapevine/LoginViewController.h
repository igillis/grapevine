//
//  LoginViewController.h
//  grapevine
//
//  Created by Ian Gillis on 8/28/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LoginViewController : UIViewController
<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
- (IBAction)facebookLogin:(id)sender;
- (void)closeLoginView;

@property (strong, nonatomic) IBOutlet UILabel* grapevine;

@end
