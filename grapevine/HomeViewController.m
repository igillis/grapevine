//
//  FirstViewController.m
//  grapevine
//
//  Created by Ian Gillis on 8/28/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "HomeViewController.h"
#import "AudioPostCell.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize posts;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // placeholder until we design a home tab bar item
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:99];
        cellLoader = [UINib nibWithNibName:@"AudioPostCell" bundle:[NSBundle mainBundle]];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	NSString* file = [[NSBundle mainBundle] pathForResource:@"Posts"
                                                     ofType:@"plist"];
    self.posts = [[NSDictionary alloc] initWithContentsOfFile:file];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[posts allKeys] count];
}

static NSString* CellNib = @"AudioPostCell";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AudioPostCell *cell = (AudioPostCell *)[tableView dequeueReusableCellWithIdentifier:CellNib];
    if (!cell) {
        NSArray *topLevelItems = [cellLoader instantiateWithOwner:self options:nil];
        cell = [topLevelItems objectAtIndex:0];
    }
    cell.name.text = [[posts allKeys] objectAtIndex:indexPath.row];
    cell.topics.text = [posts objectForKey:[[posts allKeys] objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 77.0;
}
@end
