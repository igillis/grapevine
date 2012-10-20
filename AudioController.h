//
//  AudioController.h
//  grapevine
//
//  Created by Ian Gillis on 9/3/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioController : NSObject
<AVAudioPlayerDelegate>

@property (nonatomic, strong) NSString* recordingPath;

+ (AudioController*) sharedInstance;

//Playback methods
-(void) prepareToPlay;
-(void) playAudio: (NSData*) data;
-(void) playAudioFromFile: (NSString*) file;
-(void) pauseAudio;
-(void) stopAudio;
-(BOOL) setTime: (int) newTime;
-(BOOL) isPlaying;
-(int) lengthOfCurrentTrack;
-(NSData*) currentlyPlayingTrack;

//Recording methods
-(void) beginRecording;
-(void) stopRecording;
-(BOOL) isRecording;

//Streaming methods
-(void) playStreamedAudio:(NSString*) url;
-(void) pauseStreamedAudio;
-(void) stopStreamedAudio;
-(BOOL) isStreaming;
-(double) lengthOfStreamingTrack;
@end
