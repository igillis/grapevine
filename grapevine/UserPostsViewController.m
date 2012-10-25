//
//  UserPostsViewController.m
//  grapevine
//
//  Created by Ian Gillis on 10/24/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "UserPostsViewController.h"

@interface UserPostsViewController ()

@end

@implementation UserPostsViewController
@synthesize userPostsViewController;
@synthesize grapevine;
@synthesize backButton;
@synthesize user;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andUser:(PFUser*)u
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.user = u;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.grapevine setFont:[UIFont fontWithName:@"TalkingtotheMoon" size:26.0]];
}

- (void)viewDidUnload
{
    [self setUserPostsViewController:nil];
    [self setBackButton:nil];
    [self setGrapevine:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
