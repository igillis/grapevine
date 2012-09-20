//
//  ParseObjects.h
//  grapevine
//
//  Created by Ian Gillis on 9/19/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseObjects : NSObject
@property (readonly) NSString* userFollowingListName;
@property (readonly) NSString* audioPostObjectName;

+ (ParseObjects*) sharedInstance;

@end
