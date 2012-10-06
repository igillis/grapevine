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

@property (readwrite) PFUser* currentUser;
@property (readwrite, copy) NSArray* sessionPermissions;
@property NSMutableData* _data;

@end

@implementation SessionManager

@synthesize sessionPermissions;
@synthesize currentUser;
@synthesize _data;

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
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            return;
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            //consider updating user name if it changes on fb (move this to every login
            //and only update if data is stale
            [PF_FBRequestConnection startForMeWithCompletionHandler:^(PF_FBRequestConnection* connection,
                                                                      id result,
                                                                      NSError* error) {
                if (error) {
                    NSLog(@"%@", error);
                    return;
                }
                ParseObjects* parseObjects = [ParseObjects sharedInstance];
                NSDictionary* resultDict = (NSDictionary*) result;
                NSString* firstName = [resultDict valueForKey:@"first_name"];
                NSString* lastName = [resultDict valueForKey:@"last_name"];
                NSString* facebookId = [resultDict valueForKey:@"id"];
                NSString* username = [resultDict valueForKey:@"username"];
                [user setValue:firstName forKey:parseObjects.userFirstNameKey];
                [user setValue:lastName forKey:parseObjects.userLastNameKey];
                [user setValue:facebookId forKey:parseObjects.userFacebookIdKey];
                [user setValue:username forKey:parseObjects.userFacebookUsernameKey];
                [user saveEventually];
            }];
            //update their profile pic
            //TODO: only update if stale
            NSURL *profilePictureURL = [NSURL URLWithString:
                                        [NSString stringWithFormat:@"https://graph.facebook.com/me/picture?access_token=%@",
                                         [PFFacebookUtils session].accessToken]];
            NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL
                                                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                  timeoutInterval:8.0f];
            [NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self];

        } else {
            NSLog(@"User signed in through Facebook.");
        }
        self.currentUser = user;
        self.sessionPermissions = permissions;
        [[NSNotificationCenter defaultCenter] postNotificationName:FBSessionDidBecomeOpenActiveSessionNotification object:self];
    }];
    return NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (!_data) {
        NSLog(@"error retrieving profile picture");
        return;
    }
    PFFile* pictureFile = [PFFile fileWithName:@"profilePic" data:_data];
    [pictureFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [[PFUser currentUser] setObject:pictureFile forKey:[ParseObjects sharedInstance].userProfilePictureKey];
            [[PFUser currentUser] saveEventually];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (BOOL) openTwitterSessionWithPermissions:(NSArray*) permissions {
    return NO;
}

- (BOOL) openGrapevineSessionWithLoginId:(NSString*) loginId andPassword: (NSString*) password {
    return NO;
}
@end
