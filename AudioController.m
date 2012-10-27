//
//  AudioController.m
//  grapevine
//
//  Created by Ian Gillis on 9/3/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "AudioController.h"
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

@implementation AudioController
@synthesize recordingPath;

static AudioController* _sharedInstance = nil;
static AVAudioPlayer* _audioPlayer = nil;
static AVAudioRecorder* _audioRecorder = nil;
static AVPlayer* _audioStreamer = nil;

+(AudioController*) sharedInstance {
    if (_sharedInstance == nil) {
        _sharedInstance = [[self alloc] init];
    }
    return _sharedInstance;
}

-(void) prepareToPlay {
    [_audioPlayer prepareToPlay];
}

-(int) lengthOfCurrentTrack {
    if (_audioPlayer && _audioPlayer.isPlaying) {
        return _audioPlayer.duration;
    }
    return 0;
}

-(void) playAudio:(NSData *)data {
    if (!(_audioPlayer && [_audioPlayer.data isEqualToData:data])) {
        _audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
        [_audioPlayer setVolume:1.0];
    }
    [_audioPlayer play];
}

-(void) playAudioFromFile:(NSString *)file {
    NSURL* url = [NSURL fileURLWithPath:file];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_audioPlayer setVolume:1.0];
    [_audioPlayer play];
}

-(void) pauseAudio {
    if (_audioPlayer && [_audioPlayer isPlaying]) {
        [_audioPlayer pause];
    }
}

//newTime represents the time to start playback at
// in seconds (as we only have 30 secs of audio)
-(BOOL) setTime: (int) newTime {
    [_audioPlayer setCurrentTime:newTime];
    if (![_audioPlayer isPlaying]) {
        [_audioPlayer play];
    }
    return YES;
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
    if (_audioStreamer) {
        return _audioStreamer.rate > 0.0;
    }
    return NO;
}

-(NSData*) currentlyPlayingTrack {
    if (_audioPlayer) {
        return _audioPlayer.data;
    }
    return nil;
}

-(BOOL) isRecording {
    return _audioRecorder.isRecording;
}

-(void) beginRecording {
    [_audioRecorder record];
}

-(void) stopRecording {
    [_audioRecorder stop];
}

-(void) pauseStreamedAudio {
    [_audioStreamer pause];
}

-(void) prepareToStream:(NSString *)url {
    NSURL* urlObj = [NSURL URLWithString:url];
    _audioStreamer = [[AVPlayer alloc] initWithURL:urlObj];
}

-(void) playStreamedAudio {
    [_audioStreamer play];
}

-(void) stopStreamedAudio {
    [_audioStreamer pause];
    _audioStreamer = nil;
}

-(BOOL) isStreaming {
    return YES;
}

-(double) lengthOfStreamingTrack {
    return CMTimeGetSeconds(_audioStreamer.currentItem.duration);
}

-(AudioController*) init {
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir =[paths objectAtIndex:0];
        recordingPath =[documentsDir stringByAppendingPathComponent:@"mysound.aiff"];
        NSURL* recordingURL = [[NSURL alloc] initFileURLWithPath: recordingPath];
        
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
                         initWithURL:recordingURL
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
