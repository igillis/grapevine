//
//  AccountViewController.m
//  grapevine
//
//  Created by Ian Gillis on 10/22/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "AccountViewController.h"
#import "SessionManager.h"
#import "ParseObjects.h"
#import <QuartzCore/QuartzCore.h>

@interface AccountViewController ()

@end

@implementation AccountViewController
@synthesize profilePic;
@synthesize userName;
@synthesize grapevine;
@synthesize signOutButton;

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
    self.title = @"grapevine";
    [self.grapevine setFont:[UIFont fontWithName:@"TalkingtotheMoon" size:26.0]];
    ParseObjects* parseObjects = [ParseObjects sharedInstance];
    PFUser* currentUser = [SessionManager sharedInstance].currentUser;
    [currentUser fetchIfNeeded];
    
    
    UIImage* userProfilePic =[[UIImage alloc] initWithData:
                                 [[currentUser valueForKey:
                                   parseObjects.userProfilePictureKey] getData]];
    
    if (userProfilePic) {
        self.profilePic.image = userProfilePic;
        self.profilePic.layer.cornerRadius = 5.0;
        self.profilePic.clipsToBounds = YES;
    } else {
        self.profilePic.image = nil;
    }
    
    NSString* first = [currentUser objectForKey:parseObjects.userFirstNameKey];
    NSString* last = [currentUser objectForKey:parseObjects.userLastNameKey];
    self.userName.text = [NSString stringWithFormat:@"%@ %@", first, last];
    
    
}

- (void)viewDidUnload
{
    [self setProfilePic:nil];
    [self setUserName:nil];
    [self setGrapevine:nil];
    [self setSignOutButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"accountCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"accountCell"];
    }
    NSString* label;
    switch (indexPath.row) {
        case 0:
            label = @"My posts";
            break;
        case 1:
            label = @"Following";
            break;
        case 2:
            label = @"Followed by";
            break;
        default:
            break;
    }
    cell.textLabel.text = label;
    [cell.textLabel setFont:[UIFont fontWithName:nil size:10.0f]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (IBAction)signOutButtonTouched:(id)sender {
}
@end
