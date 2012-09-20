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
@property (readwrite) SessionType sessionType;
@property (readwrite) PFUser* currentUser;

@end

@implementation SessionManager

@synthesize sessionType;
@synthesize sessionState;
@synthesize accessToken;
@synthesize expirationDate;
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addUserToUserFollowingList)
                                                 name:@"newFbUser"
                                               object:nil];
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
            return;
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newFbUser" object:self];
        } else {
            NSLog(@"User signed in through Facebook.");
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:FBSessionDidBecomeOpenActiveSessionNotification object:self];
        self.currentUser = user;
    }];
    return NO;
}

- (void)addUserToUserFollowingList {
    NSLog(@"user now following themself");
    [self.currentUser addObject:self.currentUser
                         forKey:[[ParseObjects sharedInstance] userFollowingListName]];
    [self.currentUser saveInBackground];
}



- (BOOL)isOpen {
    NSLog(@"%i", self.sessionState);
    return self.sessionState == SessionStateOpen;
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
