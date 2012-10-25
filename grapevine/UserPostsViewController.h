//
//  UserPostsViewController.h
//  grapevine
//
//  Created by Ian Gillis on 10/24/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserPostsTableViewController.h"

@interface UserPostsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UserPostsTableViewController *userPostsViewController;
@property (weak, nonatomic) IBOutlet UILabel *grapevine;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) PFUser* user;

- (IBAction)backButtonTouched:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil andUser:(PFUser*)u;
@end
