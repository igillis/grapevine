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

@synthesize contacts;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:97];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString* file = [[NSBundle mainBundle] pathForResource:@"FakeContacts"
                                                     ofType:@"plist"];
    contacts = [[NSArray alloc] initWithContentsOfFile:file];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [contacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
                    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    NSString* name = [contacts objectAtIndex:[indexPath row]];
    
    [[cell textLabel] setText:name];
    
    return cell;
}
@end