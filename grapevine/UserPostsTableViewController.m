//
//  UserPostsTableViewController.m
//  grapevine
//
//  Created by Ian Gillis on 10/24/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "UserPostsTableViewController.h"
#import "SessionManager.h"
#import "ParseObjects.h"
#import <QuartzCore/QuartzCore.h>

@interface UserPostsTableViewController ()

@end

#define DESCRIPTION_X 83.0
#define DESCRIPTION_Y 24.0
#define DESCRIPTION_FONT_SIZE 12.0

@implementation UserPostsTableViewController
- (PFQuery *)queryForTable {
    if (![SessionManager sharedInstance].currentUser) {
        return nil;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    [query whereKey:[ParseObjects sharedInstance].postOwnerKey
            equalTo:[SessionManager sharedInstance].currentUser];
    return query;
}
@end
