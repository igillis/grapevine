//
//  PostsTableViewController.h
//  grapevine
//
//  Created by Ian Gillis on 10/4/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import <Parse/Parse.h>
#import "AudioPostCell.h"

@class AudioPostCell;

@interface PostsTableViewController : PFQueryTableViewController {
    UINib* cellLoader;
}

@property (nonatomic, strong) AudioPostCell* currentlySelected;
@property (nonatomic, strong) AudioPostCell* currentlyPlaying;

-(void) formatCell:(AudioPostCell*) cell withObject:(PFObject*) object;
-(CGSize) setCellLabel:(UILabel*) label withText:(NSString*) text;
@end
