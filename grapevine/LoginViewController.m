//
//  LoginViewController.m
//  grapevine
//
//  Created by Ian Gillis on 8/28/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "LoginViewController.h"
#import "SessionManager.h"
#import "ParseObjects.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize grapevine;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [grapevine setFont:[UIFont fontWithName:@"TalkingtotheMoon" size:34.0]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.grapevine = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)facebookLogin:(id)sender {
    // The user has initiated a login, so call the openSession method
    // and show the login UX if necessary.
    [[SessionManager sharedInstance] openFacebookSessionWithPermissions:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(closeLoginView)
                                               name:FBSessionDidBecomeOpenActiveSessionNotification
                                             object:[SessionManager sharedInstance]];
}
         
- (void)closeLoginView {
    PFUser* user = [SessionManager sharedInstance].currentUser;
    if (user) {
        [self dismissModalViewControllerAnimated:YES];
    }
}
@end
