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

@synthesize username;
@synthesize password;
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
    self.username = nil;
    self.password = nil;
    self.grapevine = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)facebookLogin:(id)sender {
    // The user has initiated a login, so call the openSession method
    // and show the login UX if necessary.
    if ([[SessionManager sharedInstance] openFacebookSessionWithPermissions:nil]) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(closeLoginView)
                                                   name:FBSessionDidBecomeOpenActiveSessionNotification
                                                 object:[SessionManager sharedInstance]];
    }
}
         
- (void)closeLoginView {
    PFUser* user = [SessionManager sharedInstance].currentUser;
    if (user) {
        [PF_FBRequestConnection startWithGraphPath:@"m/picture"
                                 completionHandler:^(PF_FBRequestConnection* connection, id result, NSError* error) {
                                     NSData* resultData = (NSData*) result;
                                     PFFile* pictureFile = [PFFile fileWithName:@"audioRecording" data:resultData];
                                     [pictureFile saveInBackground];
                                     [user setObject:resultData forKey:[[ParseObjects sharedInstance] userProfilePictureKey]];
                                     [user saveInBackground];
                                 }] ;
        [self dismissModalViewControllerAnimated:YES];
    }

}

- (IBAction)twitterLogin:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [tableView setBackgroundColor:[UIColor clearColor]];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:@"Cell"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        UITextField* loginTextField;
        if ([indexPath row] == 0) {
            self.username = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 185, 30)];
            loginTextField = self.username;
            loginTextField.placeholder = @"Username";
            loginTextField.returnKeyType = UIReturnKeyNext;
        }
        else {
            self.password = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 185, 30)];
            loginTextField = self.password;
            loginTextField.placeholder = @"Password";
            loginTextField.returnKeyType = UIReturnKeyDone;
            loginTextField.secureTextEntry = YES;
        }
        loginTextField.keyboardType = UIKeyboardTypeDefault;
        loginTextField.adjustsFontSizeToFitWidth = YES;
        loginTextField.backgroundColor = [UIColor clearColor];
        loginTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        loginTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        loginTextField.textAlignment = UITextAlignmentLeft;
        loginTextField.tag = 0;
        loginTextField.delegate = self;
        
        [loginTextField setEnabled: YES];
        
        [cell addSubview:loginTextField];
    }
    return cell;    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (IBAction)grapevineLogin:(id)sender {
    [self hideKeyboard:nil];
    [[SessionManager sharedInstance] openGrapevineSessionWithLoginId:username.text andPassword:password.text];
}

- (IBAction)hideKeyboard:(id)sender {
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.password) {
        [textField resignFirstResponder];
        [self grapevineLogin:self];
    } else if (textField == self.username) {
        [self.password becomeFirstResponder];
    }
    return YES;
}
    
@end
