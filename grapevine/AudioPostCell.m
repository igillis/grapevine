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
@synthesize timeSlider;

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
        [self playAudio:self.audioPath];
    }
}

- (IBAction)timeSliderChanged:(id)sender {
    NSLog(@"TIMESLIDERCHANGED CALLED");
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
