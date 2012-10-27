//
//  FollowingViewController.h
//  grapevine
//
//  Created by Ian Gillis on 10/27/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowingViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *grapevine;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

- (IBAction)backButtonTouched:(id)sender;
@end
