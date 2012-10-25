//
//  TrendingPostsTableViewController.m
//  grapevine
//
//  Created by Ian Gillis on 10/3/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "TrendingPostsTableViewController.h"
#import "SessionManager.h"
#import "ParseObjects.h"
#import <QuartzCore/QuartzCore.h>

@interface TrendingPostsTableViewController ()

@end

#define DESCRIPTION_X 83.0
#define DESCRIPTION_Y 24.0
#define DESCRIPTION_FONT_SIZE 12.0

@implementation TrendingPostsTableViewController

- (void) awakeFromNib {
    self.objectsPerPage = 5;
    [super awakeFromNib];
}

- (PFQuery *)queryForTable {
    if (![SessionManager sharedInstance].currentUser) {
        return nil;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    [query setLimit:2];
    [query orderByDescending:@"numViews"];
    return query;
}
@end
