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
@synthesize recording;

static AudioController* _sharedInstance = nil;
static AVAudioPlayer* _audioPlayer = nil;
static AVAudioRecorder* _audioRecorder = nil;

+(AudioController*) sharedInstance {
    if (_sharedInstance == nil) {
        _sharedInstance = [[self alloc] init];
    }
    return _sharedInstance;
}

//Should make this threaded so that it can continue in the background without holding up the UI from updating
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

-(void) stopAudio {
    if (_audioPlayer) {
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
}

-(BOOL) isPlaying {
    if (_audioPlayer) {
        return [_audioPlayer isPlaying];
    }
    return NO;
}

-(BOOL) isRecording {
    return _audioRecorder.isRecording;
}

-(void) beginRecording {
    [_audioRecorder record];
    NSLog(@"now recording, right?? %i", _audioRecorder.isRecording);
}

-(void) stopRecording {
    [_audioRecorder stop];
}

-(AudioController*) init {
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir =[paths objectAtIndex:0];
        NSString *soundFilePath =[documentsDir stringByAppendingPathComponent:@"mysound.caf"];
        self.recording = [[NSURL alloc] initFileURLWithPath: soundFilePath];
        
        NSDictionary *recordSettings = [NSDictionary
                                        dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:AVAudioQualityMedium],
                                        AVEncoderAudioQualityKey,
                                        [NSNumber numberWithInt:16],
                                        AVEncoderBitRateKey,
                                        [NSNumber numberWithInt: 2],
                                        AVNumberOfChannelsKey,
                                        [NSNumber numberWithFloat:44100.0],
                                        AVSampleRateKey,
                                        nil];
        
        NSError *error = nil;
        
        _audioRecorder = [[AVAudioRecorder alloc]
                         initWithURL:self.recording
                         settings:recordSettings
                         error:&error];
        
        if (error)
        {
            NSLog(@"error: %@", [error localizedDescription]);
            
        } else {
            NSLog(@"%@", _audioRecorder.url);
            [_audioRecorder prepareToRecord];
        }
    }
    return self;
}
@end
