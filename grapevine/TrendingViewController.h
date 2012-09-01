//
//  SecondViewController.h
//  grapevine
//
//  Created by Ian Gillis on 8/28/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrendingViewController : UIViewController <UITableViewDataSource,
    UITableViewDelegate>

@property (nonatomic, strong) NSArray* topicSuggestions;
@property (nonatomic, strong) NSArray* userSuggestions;

@end
