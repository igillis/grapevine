//
//  SessionManager.h
//  grapevine
//
//  Created by Ian Gillis on 9/18/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

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

typedef enum {
    TwitterSession = 0,
    GrapevineSession = 1,
    FacebookSession = 2,
    GoogleSession = 3,
    NoSession = 4,
} SessionType;

extern NSString *const FBSessionStateChangedNotification;

@interface SessionManager : NSObject
@property (readonly) SessionState sessionState;
@property (readonly) SessionType sessionType;
@property (readonly) BOOL isOpen;
@property (readonly, copy) NSString* accessToken;
@property(readonly, copy) NSDate *expirationDate;
@property(readonly, copy) NSArray *sessionPermissions;

+ (SessionManager*) sharedInstance;

- (BOOL) openFacebookSessionWithPermissions:(NSArray*) permissions;
- (BOOL) openTwitterSessionWithPermissions:(NSArray*) permissions;
- (BOOL) openGoogleSessionWithPermissions:(NSArray*) permissions;
- (BOOL) openGrapevineSessionWithLoginId:(NSString*) loginId andPassword: (NSString*) password;

- (void) closeSession;

- (void) closeSessionAndClearTokenInfo;

@end