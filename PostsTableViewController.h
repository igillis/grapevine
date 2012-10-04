//
//  PostsTableViewController.h
//  grapevine
//
//  Created by Ian Gillis on 9/20/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import <Parse/Parse.h>
#import "AudioPostCell.h"

@class AudioPostCell;

@interface PostsTableViewController : PFQueryTableViewController{
    UINib* cellLoader;
}

@property (nonatomic, strong) AudioPostCell* currentlySelected;
@property (nonatomic, strong) AudioPostCell* currentlyPlaying;

@end
