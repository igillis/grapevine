//
//  AudioPostCell.h
//  grapevine
//
//  Created by Ian Gillis on 8/30/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AudioPostCell : PFTableViewCell

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIImageView* profilePic;
@property (strong, nonatomic) IBOutlet UILabel* name;
@property (strong, nonatomic) IBOutlet UILabel* description;
@property (weak, nonatomic) IBOutlet UIView *altView;
@property (strong, nonatomic) NSString* audioPath;
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (weak, nonatomic) IBOutlet UILabel *altName;
@property (strong, nonatomic) NSData* audioData;
@property (strong, nonatomic) PFObject* post;

- (IBAction)playPauseButtonTouched:(id)sender;
- (IBAction)timeSliderChanged:(id)sender;
- (IBAction)shareButtonTouched:(id)sender;
-(void) toggleViews;
-(void) toggleAudio: (NSString*) file;
-(void) pauseAudio;
-(void) stopAudio;
-(void) playAudio: (NSString*) file;
-(void) playAudioFromData: (NSData*) data;

@end
