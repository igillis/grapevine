//
//  AudioPostCell.m
//  grapevine
//
//  Created by Ian Gillis on 8/30/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "AudioPostCell.h"
#import "AudioController.h"
#import "ParseObjects.h"

@interface AudioPostCell ()

@property float duration;
@property float currentTime;
@property NSTimer* timer;
@property UIImage* playImage;
@property UIImage* pauseImage;

@end

@implementation AudioPostCell

@synthesize tableView;

@synthesize progressBar;
@synthesize playPauseButton;
@synthesize audioURL;
@synthesize post;

@synthesize mainView;
@synthesize profilePic;
@synthesize name;
@synthesize description;
@synthesize altView;

-(void) awakeFromNib {
    self.playImage =
    [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]
                                             pathForResource:@"play" ofType:@"png"]];
    self.pauseImage =
    [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle]
                                             pathForResource:@"pause" ofType:@"png"]];
}
-(void) pauseAudio {
    [self.playPauseButton setImage:self.playImage forState:UIControlStateNormal];
    [self.timer invalidate];
    [[AudioController sharedInstance] pauseAudio];
}
-(void) stopAudio {
    [self.playPauseButton setImage:self.playImage forState:UIControlStateNormal];
    [self.timer invalidate];
    [self.progressBar setProgress:0.0];
    self.currentTime = 0.0;
    [[AudioController sharedInstance] stopAudio];
}
-(void)playAudio {
    [self.playPauseButton setImage:self.pauseImage forState:UIControlStateNormal];
    self.tableView.currentlyPlaying = self;
    PFFile* audioFile = (PFFile*)[post objectForKey:[ParseObjects sharedInstance].audioFileKey];
    [[AudioController sharedInstance] playAudio:[audioFile getData]];
    self.duration = [[AudioController sharedInstance] lengthOfCurrentTrack];
    self.timer = [NSTimer scheduledTimerWithTimeInterval: 0.1f target:self selector:@selector(handleTimerFire:) userInfo:nil repeats:YES];
    [self.post incrementKey:[ParseObjects sharedInstance].numViewsKey];
    [self.post saveInBackground];
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

- (IBAction)playPauseButtonTouched:(id)sender {
    AudioController* audioController = [AudioController sharedInstance];
    if ([audioController isPlaying]) {
        if (self.tableView.currentlyPlaying == self) {
            [self pauseAudio];
            return;
        } else {
            [self.tableView.currentlyPlaying stopAudio];
        }
    }
    [self playAudio];
}

- (void) handleTimerFire: (NSTimer*) timer {
    self.currentTime += timer.timeInterval;
    [progressBar setProgress:self.currentTime / self.duration];
    if (self.currentTime >= self.duration) {
        [self stopAudio];
    }
}

- (IBAction)shareButtonTouched:(id)sender {
    NSLog(@"shareButtonTouched called");
}

-(void) toggleViews {
    mainView.hidden = !mainView.hidden;
    altView.hidden = !altView.hidden;
    if (mainView.hidden) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
}
@end
