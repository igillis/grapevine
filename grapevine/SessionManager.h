//
//  SessionManager.h
//  grapevine
//
//  Created by Ian Gillis on 9/18/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>

extern NSString *const FBSessionStateChangedNotification;

@interface SessionManager : NSObject
@property(readonly, copy) NSArray* sessionPermissions;
@property(readonly) PFUser* currentUser;

+ (SessionManager*) sharedInstance;

- (BOOL) openFacebookSessionWithPermissions:(NSArray*) permissions;
- (BOOL) openTwitterSessionWithPermissions:(NSArray*) permissions;
- (BOOL) openGrapevineSessionWithLoginId:(NSString*) loginId
                             andPassword: (NSString*) password;
@end