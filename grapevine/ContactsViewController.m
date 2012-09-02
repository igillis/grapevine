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
@synthesize cells = cells_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:97];
        cells_ = [[NSMutableArray alloc] init];
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
    if (currentKey != nil) {
        [contactsKeys addObject:currentKey];
        [contactsValues addObject:currentValues];
    }
    
    contactsDict_ = [[NSDictionary alloc] initWithObjects:contactsValues forKeys:contactsKeys];
    contactsKeys_ = contactsKeys;
    
    for (int i = 0; i < [contactsValues count]; i++) {
        [cells_ addObject:[[NSMutableArray alloc] init]];
        for (int j = 0; j < [[contactsValues objectAtIndex:i] count]; j++) {
            [[cells_ objectAtIndex:i] addObject:[[NSMutableDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:[NSNumber numberWithBool:NO],nil]
                                       forKeys:[[NSArray alloc] initWithObjects:@"checked",nil]]];
        }
    }
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
    static NSString *kCustomCellID = @"MyCellID";
    UITableViewCell *cell = [tableView    dequeueReusableCellWithIdentifier:kCustomCellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    NSString* name = [[contactsDict_ objectForKey:[contactsKeys_ objectAtIndex:[indexPath section]]] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:name];
    [[[cells_ objectAtIndex:indexPath.section] objectAtIndex: indexPath.row] setObject:cell forKey:@"cell"];
    
    BOOL isChecked = [self cellIsChecked:indexPath];
    UIImage *image = isChecked ? [UIImage   imageNamed:@"checked.png"] : [UIImage imageNamed:@"unchecked.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    button.frame = frame;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(checkButtonTapped:event:)  forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    cell.accessoryView = button;
    
    return cell;
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
    BOOL isChecked = ![self cellIsChecked:indexPath];
    UITableViewCell *cell = [[[cells_ objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"cell"];
    UIButton *button = (UIButton *)cell.accessoryView;
    
    UIImage *newImage = isChecked ? [UIImage imageNamed:@"checked.png"] : [UIImage imageNamed:@"unchecked.png"];
    [button setBackgroundImage:newImage forState:UIControlStateNormal];
    [[[cells_ objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] setObject:[NSNumber numberWithBool:isChecked] forKey:@"checked"];
}

- (BOOL)cellIsChecked:(NSIndexPath*) indexPath {
    return [[[[cells_ objectAtIndex:indexPath.section] objectAtIndex:indexPath.row ] objectForKey:@"checked" ] boolValue];
}

- (void)tableView:(UITableView *)tableView  didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:tableView  accessoryButtonTappedForRowWithIndexPath: indexPath];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end