//
//  AudioStreamer.m
//  grapevine
//
//  Created by Ian Gillis on 10/20/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "AudioStreamer.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioStreamer ()
@property (strong, nonatomic) AVPlayer* player;
@end

@implementation AudioStreamer

-(void) initWithURL:(NSURL *)url {
}

-(void) play {
    
}

-(void) pause {
    
}

-(double) currentTime {
    return 0.0f;
}

-(void) seekToTime:(double)time {
    
}

-(double) duration {
    return 0.0f;
}

@end
