//
//  ContactsViewController.m
//  grapevine
//
//  Created by Ian Gillis on 8/28/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "ContactsViewController.h"
#import <Parse/Parse.h>
#import "ParseObjects.h"
#import "SessionManager.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController

@synthesize searchResults = searchResults_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:97];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchResults_ count];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    searchResults_ = [[NSArray alloc] init];
}

- (void)viewDidUnload
{
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
    PFUser* resultAtIndex = (PFUser*) [searchResults_ objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",
                           [resultAtIndex objectForKey:parseObjects.userFirstNameKey],
                           [resultAtIndex objectForKey: parseObjects.userLastNameKey]];
    
    if ([self alreadyFollowing:resultAtIndex]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

-(BOOL) alreadyFollowing:(PFUser*) user {
    //TODO: stop calling this every time
    [user fetchIfNeeded];
    NSArray* following = [[SessionManager sharedInstance].currentUser
             objectForKey:[ParseObjects sharedInstance].userFollowingListKey];
    if ([following isEqual:[[NSNull alloc] init] ]) {
        return NO;
    }
    for (PFUser* followedUser in following) {
        [followedUser fetchIfNeeded];
        if ([followedUser.username isEqualToString:user.username]) {
            return YES;
        }
    }
    return NO;
}


- (void)tableView:(UITableView *)tableView  didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFUser* resultAtIndex = (PFUser*) [searchResults_ objectAtIndex:indexPath.row];
    if (![self alreadyFollowing:resultAtIndex]) {
        PFUser* currentUser = [SessionManager sharedInstance].currentUser;
        NSArray* following = [currentUser objectForKey:[ParseObjects sharedInstance].userFollowingListKey];
        NSMutableArray* followingMutable;
        if ([following isEqual:[[NSNull alloc] init]]) {
            followingMutable = [[NSMutableArray alloc] init];
        } else {
            followingMutable = [NSMutableArray arrayWithArray:following];
        }
        [followingMutable addObject:resultAtIndex];
        [currentUser setObject:followingMutable forKey:[ParseObjects sharedInstance].userFollowingListKey];
        [currentUser save];
        [tableView reloadData];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    if ([searchString length] > 1) {
        ParseObjects* parseObjects = [ParseObjects sharedInstance];
        PFQuery* userFirstNameQuery = [PFUser query];
        [userFirstNameQuery whereKey:parseObjects.userFirstNameKey containsString:searchString];
        
        PFQuery* userLastNameQuery = [PFUser query];
        [userLastNameQuery whereKey:parseObjects.userLastNameKey containsString:searchString];
        
        PFQuery* userQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:userFirstNameQuery, userLastNameQuery, nil]];
        
        searchResults_ = [userQuery findObjects];
    
        return YES;
    }
    return NO;
}

-(void) searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
    [self.tableView reloadData];
}
@end