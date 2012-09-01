//
//  ContactsViewController.m
//  grapevine
//
//  Created by Ian Gillis on 8/28/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "ContactsViewController.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController

@synthesize contactsDict = contactsDict_;
@synthesize contactsKeys = contactsKeys_;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:97];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [contactsDict_ count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[contactsDict_ objectForKey:[contactsKeys_ objectAtIndex:section]] count];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [contactsKeys_ objectAtIndex:section];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString* file = [[NSBundle mainBundle] pathForResource:@"FakeContacts"
                                                     ofType:@"plist"];
    NSArray* contacts = [[NSArray alloc] initWithContentsOfFile:file];
    NSLog(@"contacts is: %@", contacts);
    contacts = [contacts sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    NSMutableArray* contactsKeys = [[NSMutableArray alloc] init];
    NSMutableArray* contactsValues = [[NSMutableArray alloc] init];
    NSString* currentKey = nil;
    NSMutableArray* currentValues = nil;
    for (NSString* contact in contacts) {
        NSString* contactKey = [[contact substringToIndex:1] uppercaseString];
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

- (UITableViewCell *)tableView:(UITableView *)tableView
                    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    NSString* name = [[contactsDict_ objectForKey:[contactsKeys_ objectAtIndex:[indexPath section]]] objectAtIndex:[indexPath row]];
    
    [[cell textLabel] setText:name];
    
    return cell;
}
@end