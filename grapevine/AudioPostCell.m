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

@synthesize progressBar;
@synthesize playPauseButton;
@synthesize altName;
@synthesize audioData;
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

-(void) toggleAudio: (NSString*) file {
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
-(void)playAudioFromData:(NSData *)data {
    [[AudioController sharedInstance] playAudioFromData:data];
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
    UIButton* button = (UIButton*) sender;
    if ([[AudioController sharedInstance] isPlaying]) {
        [button setImage:self.playImage forState:UIControlStateNormal];
        [self pauseAudio];
    } else {
        [button setImage:self.pauseImage forState:UIControlStateNormal];
        [self playAudioFromData:self.audioData];
        self.timer = [NSTimer scheduledTimerWithTimeInterval: 0.1f target:self selector:@selector(handleTimerFire:) userInfo:nil repeats:YES];
        self.duration = [[AudioController sharedInstance] lengthOfCurrentTrack];
        [self.post incrementKey:[ParseObjects sharedInstance].numViewsKey];
        [self.post saveInBackground];
    }
}

- (void) handleTimerFire: (NSTimer*) timer {
    self.currentTime += timer.timeInterval;
    [progressBar setProgress:self.currentTime / self.duration];
    //[progressLabel setText:[NSString stringWithFormat:@"%.01f", self.currentTime]];
    if (self.currentTime >= self.duration) {
        [self audioComplete];
    }
}

-(void) audioComplete {
    [self.playPauseButton setImage:self.playImage forState:UIControlStateNormal];
    [progressBar setProgress:0.0];
}

- (IBAction)shareButtonTouched:(id)sender {
    NSLog(@"shareButtonTouched called");
}

-(void) toggleViews {
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.3;
    [mainView.layer addAnimation:animation forKey:nil];
    [altView.layer addAnimation:animation forKey:nil];
    mainView.hidden = !mainView.hidden;
    altView.hidden = !altView.hidden;
    if (mainView.hidden) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
}
@end
