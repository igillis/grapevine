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
@property (readwrite) NSString* userLastNameKey;
@property (readwrite) NSString* userFirstNameKey;
@property (readwrite) NSString* userProfilePictureKey;
@property (readwrite) NSString* userFacebookIdKey;
@property (readwrite) NSString* userFacebookUsernameKey;


@property (readwrite) NSString* audioPostClassName;
@property (readwrite) NSString* audioFileKey;
@property (readwrite) NSString* descriptionKey;
@property (readwrite) NSString* postOwnerKey;
@property (readwrite) NSString* numViewsKey;


@end

@implementation ParseObjects

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
        self.userFirstNameKey = @"firstName";
        self.userLastNameKey = @"lastName";
        self.userProfilePictureKey = @"profilePic";
        self.userFacebookIdKey = @"facebookdId";
        self.userFacebookUsernameKey = @"facebookUsername";
        
        self.audioPostClassName = @"audioPost";
        self.audioFileKey = @"audioFile";
        self.postOwnerKey = @"postOwner";
        self.descriptionKey = @"postDescription";
        self.numViewsKey = @"numViews";
    }
    return self;
}

@end
