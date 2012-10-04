//
//  SessionManager.m
//  grapevine
//
//  Created by Ian Gillis on 9/18/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "SessionManager.h"
#import <Parse/Parse.h>
#import "ParseObjects.h"

@interface SessionManager ()

@property (readwrite) SessionState sessionState;
@property (readwrite) PFUser* currentUser;
@property (readwrite, copy) NSArray* sessionPermissions;

@end

@implementation SessionManager

@synthesize sessionState;
@synthesize sessionPermissions;
@synthesize currentUser;

NSString *const FBSessionStateChangedNotification =
@"grapevine:FBSessionStateChangedNotification";

static SessionManager* _sharedInstance = nil;

+ (SessionManager*) sharedInstance {
    if (_sharedInstance == nil) {
        _sharedInstance = [[self alloc] init];
    }
    return _sharedInstance;
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openFacebookSessionWithPermissions:(NSArray *)permissions {
    self.sessionState = SessionStatePending;
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            if (error) {
                NSLog(@"error during login: %@", error);
            }
            else {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            }
            self.sessionState = SessionStateCloseLoginFailure;
            return;
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
        } else {
            NSLog(@"User signed in through Facebook.");
        }
        self.currentUser = user;
        self.sessionPermissions = permissions;
        self.sessionState = SessionStateOpen;
        [[NSNotificationCenter defaultCenter] postNotificationName:FBSessionDidBecomeOpenActiveSessionNotification object:self];
    }];
    return NO;
}

- (BOOL) openTwitterSessionWithPermissions:(NSArray*) permissions {
    return NO;
}

- (BOOL) openGrapevineSessionWithLoginId:(NSString*) loginId andPassword: (NSString*) password {
    return NO;
}

- (void) closeSession {
    self.sessionState = SessionStateClose;
}
@end
