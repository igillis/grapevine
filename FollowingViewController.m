//
//  FollowingViewController.m
//  grapevine
//
//  Created by Ian Gillis on 10/27/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "FollowingViewController.h"
#import "ParseObjects.h"
#import "SessionManager.h"
#import "UserPostsViewController.h"

@interface FollowingViewController ()
@property (strong, nonatomic) NSArray* followingList;
@end

@implementation FollowingViewController
@synthesize grapevine;
@synthesize backButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.followingList =
    [[SessionManager sharedInstance].currentUser objectForKey:[ParseObjects sharedInstance].userFollowingListKey];
    [grapevine setFont:[UIFont fontWithName:@"TalkingtotheMoon" size:26.0]];
}

- (void)viewDidUnload
{
    [self setGrapevine:nil];
    [self setBackButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* reuseId = @"ContactCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:reuseId];
    }
    
    ParseObjects* parseObjects = [ParseObjects sharedInstance];
    PFUser* resultAtIndex = [self.followingList objectAtIndex:indexPath.row];
    [resultAtIndex fetchIfNeeded];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",
                           [resultAtIndex objectForKey:parseObjects.userFirstNameKey],
                           [resultAtIndex objectForKey: parseObjects.userLastNameKey]];
    cell.imageView.image = [UIImage imageWithData:
                            [[resultAtIndex objectForKey:parseObjects.userProfilePictureKey] getData]];
    return cell;
}

- (void)tableView:(UITableView *)tableView  didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFUser* resultAtIndex = (PFUser*) [self.followingList objectAtIndex:indexPath.row];
    [resultAtIndex fetchIfNeeded];
    [self.navigationController pushViewController:[[UserPostsViewController alloc] initWithNibName:@"UserPostsViewController" bundle:nil andUser:resultAtIndex] animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.followingList count];
}


- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
