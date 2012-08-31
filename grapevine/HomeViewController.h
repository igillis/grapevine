//
//  FirstViewController.h
//  grapevine
//
//  Created by Ian Gillis on 8/28/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource> {
    UINib *cellLoader;
}

@property (nonatomic, strong) NSDictionary* posts;

@end
