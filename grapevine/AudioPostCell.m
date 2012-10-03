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

@implementation AudioPostCell
@synthesize timeSlider;
@synthesize playPauseButton;
@synthesize altName;
@synthesize audioData;
@synthesize post;

@synthesize mainView;
@synthesize profilePic;
@synthesize name;
@synthesize description;
@synthesize altView;

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
        UIImage* playImage =
            [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"play" ofType:@"png"]];
        [button setImage:playImage forState:UIControlStateNormal];
        [self pauseAudio];
    } else {
        UIImage* pauseImage =
            [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pause" ofType:@"png"]];
        [button setImage:pauseImage forState:UIControlStateNormal];
        [self playAudioFromData:self.audioData];
        timeSlider.maximumValue = [[AudioController sharedInstance] lengthOfCurrentTrack];
        [self.post incrementKey:[ParseObjects sharedInstance].numViewsKey];
        [self.post saveInBackground];
    }
}

- (IBAction)timeSliderChanged:(id)sender {
    UISlider* slider = (UISlider*) sender;
    float newTime = slider.value;
    [[AudioController sharedInstance] setTime:newTime];
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
