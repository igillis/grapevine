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

@implementation UserPostsTableViewController
@synthesize user;

- (PFQuery *)queryForTable {
    if (!self.user) {
        return nil;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    [query whereKey:[ParseObjects sharedInstance].postOwnerKey
            equalTo:self.user];
    return query;
}
@end
