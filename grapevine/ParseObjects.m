//
//  ParseObjects.m
//  grapevine
//
//  Created by Ian Gillis on 9/19/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "ParseObjects.h"

@interface ParseObjects ()

@property (readwrite) NSString* userFollowingListName;
@property (readwrite) NSString* audioPostObjectName;

@end

@implementation ParseObjects
@synthesize audioPostObjectName;
@synthesize userFollowingListName;

static ParseObjects* _sharedInstance = nil;

+ (ParseObjects*) sharedInstance {
    if (!_sharedInstance) {
        _sharedInstance = [[self alloc]init];
    }
    return _sharedInstance;
}


- (id) init {
    self = [super init];
    if (self) {
        self.userFollowingListName = @"followingList";
        self.audioPostObjectName = @"audioPost";
    }
    return self;
}

@end
