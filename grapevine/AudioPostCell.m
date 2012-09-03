//
//  AudioPostCell.m
//  grapevine
//
//  Created by Ian Gillis on 8/30/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "AudioPostCell.h"
#import "AudioController.h"

@implementation AudioPostCell

@synthesize profilePic;
@synthesize name;
@synthesize description;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) toggleAudio: (NSString*) file {
    NSLog(@"toggle audio called");
    [[AudioController sharedInstance] toggleAudio:file];
}
@end
