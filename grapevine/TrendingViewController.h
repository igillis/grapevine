//
//  TrendingViewController.h
//  grapevine
//
//  Created by Ian Gillis on 10/3/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendingPostsTableViewController.h"

@interface TrendingViewController : UIViewController
@property (strong, nonatomic) IBOutlet TrendingPostsTableViewController *postsTableViewController;
@end
