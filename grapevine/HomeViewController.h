//
//  FirstViewController.h
//  grapevine
//
//  Created by Ian Gillis on 8/28/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "HomeTableViewController.h"
#import "PostsTableViewController.h"

@interface HomeViewController : UIViewController

@property (nonatomic, strong) NSURL* soundUrl;
@property (nonatomic, strong) AVAudioPlayer* player;
@property (nonatomic, strong) IBOutlet UIButton* recordButton;
@property (nonatomic, strong) IBOutlet UILabel* grapevine;
@property (nonatomic, retain) IBOutlet PostsTableViewController* tableViewController;

-(IBAction)recordButtonPressed:(id)sender;

@end
