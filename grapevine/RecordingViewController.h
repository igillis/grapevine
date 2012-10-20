//
//  RecordingViewController.h
//  grapevine
//
//  Created by Ian Gillis on 9/15/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordingViewController : UIViewController
<UITextViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UIButton* upperBackgroundButton;
@property (nonatomic, weak) IBOutlet UIButton* lowerBackgroundButton;
@property (nonatomic, weak) IBOutlet UITextView* descriptionField;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIView *lowerHalf;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *grapevine;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (nonatomic, strong) NSString* currentRecordingLocation;
@property (nonatomic, strong) NSString* descriptionLabelPlaceholderText;
@property BOOL isRecording;

- (IBAction)closeRecordingView:(id)sender;
- (IBAction)sharePost:(id)sender;
- (IBAction)recordStopButtonPressed:(id)sender;
- (IBAction)playButtonPressed:(id)sender;

@end
