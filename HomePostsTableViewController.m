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
@property NSString* searchTerm;
@property UISearchBar* mySearchBar;
@end

@implementation HomePostsTableViewController

@synthesize currentlySelected;
@synthesize currentlyPlaying;
@synthesize searchTerm;
@synthesize mySearchBar;

- (void) awakeFromNib {
    self.objectsPerPage = 6;
    self.searchTerm = nil;
    [super awakeFromNib];
}

#pragma mark - Parse

- (PFQuery *)queryForTable {
    
    if (![SessionManager sharedInstance].currentUser) {
        return nil;
    }
    
    PFUser* user = [SessionManager sharedInstance].currentUser;
    ParseObjects* parseObjects = [ParseObjects sharedInstance];
    [user fetchIfNeeded];
    NSArray* following = [user objectForKey:parseObjects.userFollowingListKey];
    if (![following isEqual:[[NSNull alloc] init]]) {
        PFQuery* query = [PFQuery queryWithClassName:self.className];
        [query whereKey:parseObjects.postOwnerKey containedIn:following];
        [query orderByDescending:@"createdAt"];
        
        if (self.searchTerm && ![self.searchTerm isEqualToString:@""]) {
            [query whereKey:parseObjects.descriptionKey matchesRegex:searchTerm modifiers:@"imx"];
        }
        
        return query;
    }
    return nil;
}

#pragma mark - UISearchBarDelegate

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchTerm = searchText;
}

-(void) searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self loadObjects];
    [searchBar resignFirstResponder];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self loadObjects];
    [searchBar resignFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 30.0;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
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
            searchBar.delegate = self;
            for (UIView* view in [searchBar subviews]) {
                if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                    [view removeFromSuperview];
                } else if ([view isKindOfClass:NSClassFromString(@"UITextField")]) {
                    UITextField* tf = (UITextField*) view;
                    tf.enablesReturnKeyAutomatically = NO;
                    tf.returnKeyType = UIReturnKeyDone;
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
