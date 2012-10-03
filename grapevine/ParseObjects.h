//
//  ParseObjects.h
//  grapevine
//
//  Created by Ian Gillis on 9/19/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseObjects : NSObject
//Strings for parse users
@property (readonly) NSString* userFollowingListKey;
@property (readonly) NSString* userLastNameKey;
@property (readonly) NSString* userFirstNameKey;
@property (readonly) NSString* userProfilePictureKey;

//Strings for audiopost parse objects
@property (readonly) NSString* audioPostClassName;
@property (readonly) NSString* audioFileKey;
@property (readonly) NSString* descriptionKey;
@property (readonly) NSString* postOwnerKey;
@property (readonly) NSString* numViewsKey;

+ (ParseObjects*) sharedInstance;

@end
