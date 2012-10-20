//
//  AudioStreamer.h
//  grapevine
//
//  Created by Ian Gillis on 10/20/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioStreamer : NSObject

-(void) initWithURL: (NSURL*) url;
-(void) play;
-(void) pause;
-(double) currentTime;
-(void) seekToTime: (double) time;
-(double) duration;

@end
