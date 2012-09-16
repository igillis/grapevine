//
//  RecordingViewController.m
//  grapevine
//
//  Created by Ian Gillis on 9/15/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "RecordingViewController.h"

@interface RecordingViewController ()

@end

@implementation RecordingViewController
@synthesize upperBackgroundButton;
@synthesize lowerBackgroundButton;
@synthesize descriptionField;
@synthesize progressBar;
@synthesize shareButton;
@synthesize recordButton;
@synthesize lowerHalf;
@synthesize progressLabel;
@synthesize currentRecordingLocation;
@synthesize isRecording;

static CGRect viewOriginalFrame;
static NSTimer* recordingTimer = nil;
static float currentTime = 0.0f;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentRecordingLocation = nil;
    isRecording = NO;
    viewOriginalFrame = lowerHalf.frame;
    
    upperBackgroundButton.enabled = NO;
    lowerBackgroundButton.enabled = NO;
    shareButton.enabled = NO;
    shareButton.alpha = 0.8f;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    tap.delegate = self;
    
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidUnload
{
    [self setProgressBar:nil];
    [self setShareButton:nil];
    [self setRecordButton:nil];
    [self setLowerHalf:nil];
    [self setDescriptionField:nil];
    self.progressBar = nil;
    self.upperBackgroundButton = nil;
    self.lowerBackgroundButton = nil;
    [self setProgressLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)textViewDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    lowerHalf.frame = CGRectMake(0,-70,320,400);
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextField *)textField
{
    [descriptionField resignFirstResponder];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    lowerHalf.frame = viewOriginalFrame;
    [UIView commitAnimations];
}

-(void)dismissKeyboard {
    [self textViewDidEndEditing:descriptionField];
}

- (IBAction)closeRecordingView:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)sharePost:(id)sender {
    NSLog(@"post shared!");
    [self closeRecordingView:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:recordButton]) {
        // we touched our control surface
        return NO; // ignore the touch
    }
    return YES; // handle the touch
}

- (void) recordingComplete {
    isRecording = NO;
    [recordButton setTitle:@"Rec" forState:UIControlStateNormal];
    shareButton.enabled = YES;
    shareButton.alpha = 1.0;
    [recordingTimer invalidate];
    recordingTimer = nil;
    NSLog(@"recording complete! %f", currentTime);
}

- (void) handleTimerFire: (NSTimer*) timer {
    currentTime += timer.timeInterval;
    [progressBar setProgress:currentTime / 30.0];
    [progressLabel setText:[NSString stringWithFormat:@"%.01f", currentTime]];
    if (currentTime >= 30.0) {
        [self recordingComplete];
    }
}

- (IBAction)recordStopButtonPressed:(id)sender {
    UIButton* button = (UIButton*) sender;
    if (!isRecording) {
        isRecording = YES;
        [button setTitle:@"Stop" forState:UIControlStateNormal];
        recordingTimer = [NSTimer scheduledTimerWithTimeInterval: 0.1f target:self selector:@selector(handleTimerFire:) userInfo:nil repeats:YES];
    } else {
        [self recordingComplete];
    }
    
}
@end
