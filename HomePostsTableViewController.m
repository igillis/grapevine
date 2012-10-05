//
//  PostsTableViewController.m
//  grapevine
//
//  Created by Ian Gillis on 9/20/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "HomePostsTableViewController.h"
#import "ParseObjects.h"
#import "AudioPostCell.h"
#import <QuartzCore/QuartzCore.h>
#import "SessionManager.h"
#import <FacebookSDK/FacebookSDK.h>

#define DESCRIPTION_X 83.0
#define DESCRIPTION_Y 24.0
#define DESCRIPTION_FONT_SIZE 12.0

@interface HomePostsTableViewController ()

@end

@implementation HomePostsTableViewController

@synthesize currentlySelected;
@synthesize currentlyPlaying;

- (void) awakeFromNib {
    // The className to query on
    self.className =
    [[ParseObjects sharedInstance] audioPostClassName];
    
    // Whether the built-in pull-to-refresh is enabled
    self.pullToRefreshEnabled = YES;
    
    // Whether the built-in pagination is enabled
    self.paginationEnabled = YES;
    
    // The number of objects to show per page
    self.objectsPerPage = 10;
}

#pragma mark - Parse

- (PFQuery *)queryForTable {
    
    if (![SessionManager sharedInstance].currentUser) {
        return nil;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    [query orderByDescending:@"createdAt"];
    return query;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 30.0;
    }
    CGSize labelsize;
    UILabel * label = [[UILabel alloc] init];
    labelsize = [self setCellLabel:label
                          withText:[[self objectAtIndexPath:indexPath]
                                        valueForKey:[ParseObjects sharedInstance].descriptionKey]];
    return MAX(65.0, labelsize.height + DESCRIPTION_Y + 10.0);
}



// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    if (indexPath.section == 1) {
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
    } else {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView* bgView = [[UIView alloc] initWithFrame:[cell bounds]];
            bgView.backgroundColor = [UIColor clearColor];
            cell.backgroundView = bgView;
            UISearchBar* searchBar = [[UISearchBar alloc] initWithFrame:[cell bounds]];
            [cell addSubview:searchBar];
            searchBar.showsBookmarkButton = NO;
            for (UIView* view in [searchBar subviews]) {
                if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                    [view removeFromSuperview];
                }
            }
        }
        return cell;
    }
}

-(PFObject*) objectAtIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.section == 1) {
         return [self.objects objectAtIndex:indexPath.row];
     }
     return nil;
 }

#pragma mark -- Table view datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return [self.objects count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
@end
