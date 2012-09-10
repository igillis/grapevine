//
//  ContactsViewController.m
//  grapevine
//
//  Created by Ian Gillis on 8/28/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "ContactsViewController.h"
#import "Contact.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController

@synthesize contactsDict = contactsDict_;
@synthesize contactsKeys = contactsKeys_;
@synthesize contacts = contacts_;
@synthesize filteredContacts = filteredContacts_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:97];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    else {
        return [contactsDict_ count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [filteredContacts_ count];
    } else {
        return [[contactsDict_ objectForKey:[contactsKeys_ objectAtIndex:section]] count];
    }
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return @"Matching Contacts";
    } else {
        return [contactsKeys_ objectAtIndex:section];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString* file = [[NSBundle mainBundle] pathForResource:@"FakeContacts"
                                                     ofType:@"plist"];
    NSArray* rawNames = [[NSArray alloc] initWithContentsOfFile:file];
    rawNames = [rawNames sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];

    contacts_ = [[NSMutableArray alloc] initWithCapacity:[rawNames count]];
    filteredContacts_ = [[NSMutableArray alloc] initWithCapacity:[rawNames count]];

    for(NSString *rawName in rawNames) {
        [contacts_ addObject:[[Contact alloc] initWithName:rawName]];
    }
    
    NSMutableArray* contactsKeys = [[NSMutableArray alloc] init];
    NSMutableArray* contactsValues = [[NSMutableArray alloc] init];
    NSString* currentKey = nil;
    NSMutableArray* currentValues = nil;
    for (Contact* contact in contacts_) {
        NSString* contactKey = [[[contact name] substringToIndex:1] uppercaseString];
        if (![contactKey isEqualToString:currentKey]) {
            if (currentKey != nil) {
                [contactsKeys addObject:currentKey];
                [contactsValues addObject:currentValues];
            }
            currentValues = [[NSMutableArray alloc] init];
            currentKey = contactKey;
        }
        [currentValues addObject:contact];
    }
    if (currentKey != nil) {
        [contactsKeys addObject:currentKey];
        [contactsValues addObject:currentValues];
    }
    
    contactsDict_ = [[NSDictionary alloc] initWithObjects:contactsValues forKeys:contactsKeys];
    contactsKeys_ = contactsKeys;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (Contact *) contactAtIndexPath:(NSIndexPath *) indexPath {
    return [[contactsDict_ objectForKey:[contactsKeys_ objectAtIndex:[indexPath section]]] objectAtIndex:[indexPath row]];
}

-(void) fillCell:(UITableViewCell*) cell withContact:(Contact *) contact {
    [[cell textLabel] setText:[contact name]];
    
    UIImage *image = [contact following] ? [UIImage imageNamed:@"checked.png"] : [UIImage imageNamed:@"unchecked.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    button.frame = frame;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(checkButtonTapped:event:)  forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    cell.accessoryView = button;
}

-(Contact *) filteredContactAtIndexPath:(NSIndexPath *) indexPath {
    return [filteredContacts_ objectAtIndex:[indexPath row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
                    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
{
        static NSString *kCustomCellID = @"ContactsCellID";
        UITableViewCell *cell = [tableView    dequeueReusableCellWithIdentifier:kCustomCellID];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }

    Contact* contact;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        contact = [self filteredContactAtIndexPath:indexPath];
    } else {
        contact = [self contactAtIndexPath:indexPath];
    }
        [self fillCell:cell withContact:contact];

        return cell;
    }
}

- (void)checkButtonTapped:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil)
    {
        [self tableView: self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    Contact* contact;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        contact = [self filteredContactAtIndexPath:indexPath];
    } else {
        contact = [self contactAtIndexPath:indexPath];
    }
    [contact setFollowing:![contact following]];

    [tableView reloadData];
}

- (void)tableView:(UITableView *)tableView  didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:tableView  accessoryButtonTappedForRowWithIndexPath: indexPath];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void) filterForSearchString:(NSString*) searchString {
    [filteredContacts_ removeAllObjects];
    for(Contact* contact in contacts_) {
        if([[contact name] rangeOfString:searchString options:NSCaseInsensitiveSearch].location == NSNotFound) {
            continue;
        }
        [filteredContacts_ addObject:contact];
    }
}

-(BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    
    return YES;
}

-(BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterForSearchString:searchString];
    
    return YES;
}
@end