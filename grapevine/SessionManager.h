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

typedef enum {
    // currently attempting to authenticate user
    SessionStatePending = 0,
    // session was opened
    SessionStateOpen = 1,
    // session was closed
    SessionStateClose = 2,
    // session closed due to login failure,
    SessionStateCloseLoginFailure
} SessionState;

extern NSString *const FBSessionStateChangedNotification;

@interface SessionManager : NSObject
@property (readonly) SessionState sessionState;
@property(readonly, copy) NSArray* sessionPermissions;
@property(readonly) PFUser* currentUser;

+ (SessionManager*) sharedInstance;

- (BOOL) openFacebookSessionWithPermissions:(NSArray*) permissions;
- (BOOL) openTwitterSessionWithPermissions:(NSArray*) permissions;
- (BOOL) openGrapevineSessionWithLoginId:(NSString*) loginId
                             andPassword: (NSString*) password;

- (void) closeSession;

@end