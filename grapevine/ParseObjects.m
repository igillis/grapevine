//
//  ParseObjects.m
//  grapevine
//
//  Created by Ian Gillis on 9/19/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "ParseObjects.h"

@interface ParseObjects ()

@property (readwrite) NSString* userFollowingListKey;

@property (readwrite) NSString* audioPostClassName;
@property (readwrite) NSString* audioFileKey;
@property (readwrite) NSString* descriptionKey;
@property (readwrite) NSString* postOwnerKey;


@end

@implementation ParseObjects
@synthesize audioPostClassName;
@synthesize userFollowingListKey;
@synthesize audioFileKey;
@synthesize descriptionKey;
@synthesize postOwnerKey;

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
        self.userFollowingListKey = @"followingList";
        
        self.audioPostClassName = @"audioPost";
        self.audioFileKey = @"audioFile";
        self.postOwnerKey = @"postOwner";
        self.descriptionKey = @"postDescription";
    }
    return self;
}

@end
