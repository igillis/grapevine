//
//  TrendingPostsTableViewController.m
//  grapevine
//
//  Created by Ian Gillis on 10/3/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "TrendingPostsTableViewController.h"
#import "SessionManager.h"
#import "ParseObjects.h"
#import <QuartzCore/QuartzCore.h>

@interface TrendingPostsTableViewController ()

@end

#define DESCRIPTION_X 83.0
#define DESCRIPTION_Y 24.0
#define DESCRIPTION_FONT_SIZE 12.0

@implementation TrendingPostsTableViewController

@synthesize currentlySelected;

- (void) awakeFromNib {
    // Custom the table
    self.className =
    [[ParseObjects sharedInstance] audioPostClassName];
    
    // Whether the built-in pull-to-refresh is enabled
    self.pullToRefreshEnabled = YES;
    
    // Whether the built-in pagination is enabled
    self.paginationEnabled = YES;
    
    // The number of objects to show per page
    self.objectsPerPage = 5;
    [self viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (PFQuery *)queryForTable {
    NSLog(@"query for table called");
    if (![SessionManager sharedInstance].currentUser) {
        return nil;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    [query setLimit:5];
    [query orderByDescending:@"numViews"];
    return query;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.objects count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath
                        object:(PFObject *)object{
    AudioPostCell* cell = (AudioPostCell *)[tableView dequeueReusableCellWithIdentifier:@"AudioPostCell%i"];
    if (!cell) {
        NSArray *topLevelItems = [cellLoader instantiateWithOwner:cell options:nil];
        cell = [topLevelItems objectAtIndex:0];
    }
    [self formatCell:cell withObject:object];
    //handles the case where a cell started playing and then the user scrolled away
    //and then scrolled back
    if ([cell isEqual:currentlySelected]) {
        cell = nil;
        return currentlySelected;
    }
    return cell;
}
- (CGSize) setCellLabel:(UILabel*) label withText:(NSString*) text {
    [label setNumberOfLines:0];
    label.text = text;
    [label setFont:[UIFont fontWithName:@"Helvetica" size:DESCRIPTION_FONT_SIZE]];
    return [label.text sizeWithFont:label.font
                  constrainedToSize: CGSizeMake(295 - DESCRIPTION_X,300.0)
                      lineBreakMode:UILineBreakModeWordWrap];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize labelsize;
    UILabel * label = [[UILabel alloc] init];
    labelsize = [self setCellLabel:label
                          withText:[[self objectAtIndexPath:indexPath]
                                    valueForKey:[ParseObjects sharedInstance].descriptionKey]];
    return MAX(65.0, labelsize.height + DESCRIPTION_Y + 10.0);
}
@end
