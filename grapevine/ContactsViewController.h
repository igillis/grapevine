//
//  ContactsViewController.h
//  grapevine
//
//  Created by Ian Gillis on 8/28/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsViewController : UITableViewController
    <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray* contacts;
@property (nonatomic, strong) NSMutableArray* filteredContacts;
@property (nonatomic, strong) NSDictionary* contactsDict;
@property (nonatomic, strong) NSArray* contactsKeys;
@end
