//
//  FirstViewController.m
//  grapevine
//
//  Created by Ian Gillis on 8/28/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "HomeViewController.h"
#import "RecordingViewController.h"

#define DESCRIPTION_X 83.0
#define DESCRIPTION_Y 34.0
#define DESCRIPTION_FONT_SIZE 12.0

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize recordButton;
@synthesize grapevine;
@synthesize tableViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // placeholder until we design a home tab bar item
//        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:99];
        NSLog(@"%i",[UIImage imageNamed:@"home_w.png"] == nil);
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"53-house.png"] tag:99];
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
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)recordButtonPressed:(id)sender {
    //TODO: decide what to do when record button is pressed
    if (tableViewController.currentlyPlaying) {
        [tableViewController.currentlyPlaying stopAudio];
    }
    RecordingViewController* recordingViewController = [[RecordingViewController alloc] init];
    [self presentViewController:recordingViewController animated:YES completion:NULL];
}
@end
