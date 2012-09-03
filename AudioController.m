//
//  AudioController.m
//  grapevine
//
//  Created by Ian Gillis on 9/3/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "AudioController.h"
#import <AVFoundation/AVFoundation.h>

@implementation AudioController
static AudioController* _sharedInstance = nil;
static AVAudioPlayer* _audioPlayer = nil;

+(AudioController*) sharedInstance {
    if (_sharedInstance == nil) {
        return [[self alloc] init];
    }
    return _sharedInstance;
}

-(void) playAudio:(NSString *)file {
    NSURL* soundUrl = [[NSURL alloc] initFileURLWithPath:file];
    if (_audioPlayer && [_audioPlayer.url isEqual:soundUrl]) {
        [_audioPlayer play];
    }
    else {
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: soundUrl error: nil];
    
        [_audioPlayer setVolume: 1.0];
        [_audioPlayer play];
    }
}

-(void) pauseAudio {
    if (_audioPlayer && [_audioPlayer isPlaying]) {
        [_audioPlayer pause];
    }
}

//file represents the file to play if none currently playing
//return value represents whether or not the file is now playing
-(BOOL) toggleAudio: (NSString*) file {
    if (_audioPlayer && [_audioPlayer isPlaying]) {
        [_audioPlayer pause];
        return NO;
    } else {
        [self playAudio:file];
        return YES;
    }
}

//newTime represents the time to start playback at
// in seconds (as we only have 30 secs of audio)
-(BOOL) setTime: (int) newTime {
    if (_audioPlayer && [_audioPlayer isPlaying]) {
        [_audioPlayer setCurrentTime:newTime];
        return YES;
    }
    return NO;
}

-(AudioController*) init {
    self = [super init];
    return self;
}

@end
