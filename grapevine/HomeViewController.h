//
//  FirstViewController.h
//  grapevine
//
//  Created by Ian Gillis on 8/28/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface HomeViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate> {
    UINib* cellLoader;
}

@property (nonatomic, strong) NSDictionary* posts;
@property (nonatomic, strong) NSDictionary* images;
@property (nonatomic, strong) NSURL* soundUrl;
@property (nonatomic, strong) AVAudioPlayer* player;

@end
