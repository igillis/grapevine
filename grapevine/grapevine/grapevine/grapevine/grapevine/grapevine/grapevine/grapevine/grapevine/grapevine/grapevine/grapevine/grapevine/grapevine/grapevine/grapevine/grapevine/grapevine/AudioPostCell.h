//
//  AudioPostCell.h
//  grapevine
//
//  Created by Ian Gillis on 8/30/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioPostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIImageView* profilePic;
@property (strong, nonatomic) IBOutlet UILabel* name;
@property (strong, nonatomic) IBOutlet UILabel* description;
@property (weak, nonatomic) IBOutlet UIImageView *nowPlayingImage;
@property (weak, nonatomic) IBOutlet UIView *altView;

-(void) toggleViews;
-(void) toggleAudio: (NSString*) file;
-(void) pauseAudio;
-(void) stopAudio;
-(void) playAudio: (NSString*) file;

@end
