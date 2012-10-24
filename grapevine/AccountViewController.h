//
//  AccountViewController.h
//  grapevine
//
//  Created by Ian Gillis on 10/22/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *grapevine;
@property (weak, nonatomic) IBOutlet UIButton *signOutButton;

- (IBAction)signOutButtonTouched:(id)sender;
@end
