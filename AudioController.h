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
-(void) playAudio: (NSString*) file;
-(void) playAudioFromData: (NSData*) data;
-(void) pauseAudio;
-(void) stopAudio;
-(BOOL) toggleAudio: (NSString*) file;
-(BOOL) setTime: (int) newTime;
-(BOOL) isPlaying;

//Recording methods
-(void) beginRecording;
-(void) stopRecording;
-(BOOL) isRecording;

@end
