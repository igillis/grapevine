//
//  TrendingPostsTableViewController.h
//  grapevine
//
//  Created by Ian Gillis on 10/3/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "PostsTableViewController.h"

@interface TrendingPostsTableViewController : PFQueryTableViewController {
    UINib* cellLoader;
}

@property (nonatomic, strong) AudioPostCell* currentlyPlaying;

@end
