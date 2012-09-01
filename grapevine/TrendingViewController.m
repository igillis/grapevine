//
//  SecondViewController.m
//  grapevine
//
//  Created by Ian Gillis on 8/28/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "TrendingViewController.h"

@interface TrendingViewController ()

@end

@implementation TrendingViewController

@synthesize userSuggestions = userSuggestions_;
@synthesize topicSuggestions = topicSuggestions_;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return [userSuggestions_ count];
    } else {
        return [topicSuggestions_ count];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Trending Users";
    }
    else {
        return @"Trending Topics";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc]
                             initWithStyle:UITableViewCellStyleDefault
                             reuseIdentifier:@"cell"];
    }
    
    NSString *cellName;
    
    if ([indexPath section] == 0) {
        cellName = [userSuggestions_ objectAtIndex:[indexPath row]];
    }
    else {
        cellName = [topicSuggestions_ objectAtIndex:[indexPath row]];
    }
    
    NSString *imagefile;
    NSInteger randomNumber = arc4random() % 2;
    if (randomNumber == 0 || [indexPath row] == 0) {
        imagefile = [[NSBundle mainBundle] pathForResource:@"trendingUp" ofType:@"png"];
    }
    else {
        imagefile = [[NSBundle mainBundle] pathForResource:@"trendingDown" ofType:@"png"];
    }
    UIImage *cellImage = [[UIImage alloc] initWithContentsOfFile:imagefile];
    [[cell imageView] setImage:cellImage];

    [[cell textLabel] setText:cellName];
    return cell;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:98];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString* suggestedTopicsfile =
        [[NSBundle mainBundle] pathForResource:@"FakeSuggestedTopics" ofType:@"plist"];
    NSString* suggestedUsersfile =
        [[NSBundle mainBundle] pathForResource:@"FakeSuggestedUsers" ofType:@"plist"];

    userSuggestions_ = [[NSArray alloc] initWithContentsOfFile:suggestedUsersfile];
    topicSuggestions_ = [[NSArray alloc] initWithContentsOfFile:suggestedTopicsfile];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
