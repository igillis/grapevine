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
@synthesize tableView;

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
    UIImage* userProfilePic =[[UIImage alloc] initWithData:
                              [[[SessionManager sharedInstance].currentUser valueForKey:
                                [ParseObjects sharedInstance].userProfilePictureKey] getData]];
    
    if (userProfilePic) {
        self.profilePic.image = userProfilePic;
        self.profilePic.layer.cornerRadius = 5.0;
        self.profilePic.clipsToBounds = YES;
    } else {
        self.profilePic.image = nil;
    }
}

- (void)viewDidUnload
{
    [self setProfilePic:nil];
    [self setUserName:nil];
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


@end
