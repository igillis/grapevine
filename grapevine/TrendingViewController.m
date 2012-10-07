//
//  TrendingViewController.m
//  grapevine
//
//  Created by Ian Gillis on 10/3/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "TrendingViewController.h"
#import "RecordingViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TrendingViewController ()

@end

@implementation TrendingViewController
@synthesize recordButton;
@synthesize grapevine;
@synthesize postsTableViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Trending" image:[UIImage imageNamed:@"stock.png"] tag:98];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [grapevine setFont:[UIFont fontWithName:@"TalkingtotheMoon" size:26.0]];
    
    self.recordButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.recordButton.layer.borderWidth = 0.5;
    self.recordButton.layer.cornerRadius = 3.0;
}

- (void)viewDidUnload
{
    [self setPostsTableViewController:nil];
    [self setPostsTableViewController:nil];
    [self setGrapevine:nil];
    [self setRecordButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)recordButtonPressed:(id)sender {
    //TODO: decide what to do when record button is pressed
    if (postsTableViewController.currentlyPlaying) {
        [postsTableViewController.currentlyPlaying stopAudio];
    }
    RecordingViewController* recordingViewController = [[RecordingViewController alloc] init];
    [self presentViewController:recordingViewController animated:YES completion:NULL];
}
@end
