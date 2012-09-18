//
//  SessionManager.m
//  grapevine
//
//  Created by Ian Gillis on 9/18/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "SessionManager.h"

@interface SessionManager ()

@property (readwrite) SessionState sessionState;
@property (readwrite) SessionType sessionType;

@end

@implementation SessionManager

@synthesize sessionType;
@synthesize sessionState;
@synthesize isOpen;
@synthesize accessToken;
@synthesize expirationDate;
@synthesize sessionPermissions;

NSString *const FBSessionStateChangedNotification =
@"grapevine:FBSessionStateChangedNotification";

SessionManager* sharedInstance = nil;

+ (SessionManager*) sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openFacebookSessionWithPermissions:(NSArray *)permissions {
    return [FBSession openActiveSessionWithPermissions:permissions
                                          allowLoginUI:YES
                                     completionHandler:^(FBSession *session,
                                                         FBSessionState state,
                                                         NSError *error) {
                                         [self facebookSessionStateChanged:session
                                                             state:state
                                                             error:error];
                                     }];
}

- (BOOL)isOpen {
    return self.sessionState == SessionStateOpen;
}

- (void)facebookSessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                NSLog(@"User session found");
                self.sessionState = SessionStateOpen;
                self.sessionType = FacebookSession;
            }
            break;
        case FBSessionStateClosed:
            self.sessionState = SessionStateClose;
            self.sessionType = NoSession;
            break;
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            self.sessionState = SessionStateCloseLoginFailure;
            self.sessionType = NoSession;
            break;
        default:
            //TODO(igillis): handle other cases
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (BOOL) openTwitterSessionWithPermissions:(NSArray*) permissions {
    return NO;
}
- (BOOL) openGoogleSessionWithPermissions:(NSArray*) permissions {
    return NO;
}

- (BOOL) openGrapevineSessionWithLoginId:(NSString*) loginId andPassword: (NSString*) password {
    return NO;
}

- (void) closeSession {
    if (self.sessionState == FacebookSession) {
        
    }
}

- (void) closeSessionAndClearTokenInfo {
    if (self.sessionState == FacebookSession) {
        
    }
}
@end
