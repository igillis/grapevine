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

@synthesize mainView;
@synthesize profilePic;
@synthesize name;
@synthesize description;
@synthesize nowPlayingImage;
@synthesize altView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) toggleAudio: (NSString*) file {
    [nowPlayingImage setHidden: ![nowPlayingImage isHidden]];
    [[AudioController sharedInstance] toggleAudio:file];
}
-(void) pauseAudio {
    [[AudioController sharedInstance] pauseAudio];
}
-(void) stopAudio {
    [[AudioController sharedInstance] stopAudio];
}
-(void) playAudio:(NSString *) file {
    [[AudioController sharedInstance] playAudio:file];
}
-(BOOL) isEqual:(id)object {
    if (![object isKindOfClass:[AudioPostCell class]]) {
        return NO;
    } else {
        AudioPostCell* otherCell = (AudioPostCell*) object;
        return [self.description.text isEqualToString:otherCell.description.text]
            && [self.name.text isEqualToString:otherCell.name.text];
    }
}

-(void) toggleViews {
    NSLog(@"mainView hidden = %i, altview hidden = %i", mainView.hidden, altView.hidden);
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.3;
    if (!mainView.hidden) {
        [mainView.layer addAnimation:animation forKey:nil];
    } else {
        [altView.layer addAnimation:animation forKey:nil];
    }
    mainView.hidden = !mainView.hidden;
    altView.hidden = !altView.hidden;
}
@end
