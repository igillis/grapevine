//
//  FirstViewController.m
//  grapevine
//
//  Created by Ian Gillis on 8/28/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "HomeViewController.h"
#import "AudioPostCell.h"

#define DESCRIPTION_X 83.0
#define DESCRIPTION_Y 34.0

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize posts;
@synthesize images;

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
	NSString* postsFile = [[NSBundle mainBundle] pathForResource:@"FakePosts"
                                                     ofType:@"plist"];
    NSString* imagesFile = [[NSBundle mainBundle] pathForResource:@"FakeImages" ofType:@"plist"];
    self.posts = [[NSDictionary alloc] initWithContentsOfFile:postsFile];
    self.images = [[NSDictionary alloc] initWithContentsOfFile:imagesFile];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AudioPostCell *cell = (AudioPostCell *)[tableView dequeueReusableCellWithIdentifier:@"AudioPostCell"];
    if (!cell) {
        NSArray *topLevelItems = [cellLoader instantiateWithOwner:self options:nil];
        cell = [topLevelItems objectAtIndex:0];
    }
    NSString* name = [[posts allKeys] objectAtIndex:indexPath.row];
    CGSize labelsize = [self getLabelSize:cell.description withText:[posts objectForKey:name]];
    cell.description.frame=CGRectMake(DESCRIPTION_X, DESCRIPTION_Y,
                                      315 - DESCRIPTION_X,
                                      labelsize.height);
    cell.name.text = name;
    
    NSString* imagePath =
        [[NSBundle mainBundle] pathForResource:[images objectForKey:name] ofType:@"jpg"];
    cell.profilePic.image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize labelsize;
    UILabel * label = [[UILabel alloc] init];
    labelsize = [self getLabelSize:label
                  withText:[posts objectForKey:[[posts allKeys] objectAtIndex:indexPath.row]]];
    return MAX(82.0, labelsize.height + DESCRIPTION_Y + 10.0);
}

- (CGSize) getLabelSize:(UILabel*) label withText:(NSString*) text {
    [label setNumberOfLines:0];
    label.text = text;
    [label setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
    return [label.text sizeWithFont:label.font
                     constrainedToSize: CGSizeMake(315.0 - DESCRIPTION_X,300.0)
                         lineBreakMode:UILineBreakModeWordWrap];
}
@end
