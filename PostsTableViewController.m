//
//  PostsTableViewController.m
//  grapevine
//
//  Created by Ian Gillis on 9/20/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "PostsTableViewController.h"
#import "ParseObjects.h"
#import "AudioPostCell.h"
#import <QuartzCore/QuartzCore.h>
#import "SessionManager.h"
#import <FacebookSDK/FacebookSDK.h>

#define DESCRIPTION_X 83.0
#define DESCRIPTION_Y 24.0
#define DESCRIPTION_FONT_SIZE 12.0

@interface PostsTableViewController ()

@end

@implementation PostsTableViewController

@synthesize currentlyPlaying;


- (id)initWithStyle:(UITableViewStyle)style
{
    NSLog(@"init with style called");
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.className =
            [[ParseObjects sharedInstance] audioPostClassName];
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loadObjects)
                                                     name:FBSessionDidBecomeOpenActiveSessionNotification
                                                   object:[SessionManager sharedInstance]];
    }
    return self;
}

- (void) awakeFromNib {
    // Custom the table
    NSLog(@"AWAKE FROM NIB CALLED");
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    cellLoader = [UINib nibWithNibName:@"AudioPostCell" bundle:[NSBundle mainBundle]];
    
    self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    // This method is called every time objects are loaded from Parse via the PFQuery
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    // This method is called before a PFQuery is fired to get more objects
}

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

- (CGSize) setCellLabel:(UILabel*) label withText:(NSString*) text {
    [label setNumberOfLines:0];
    label.text = text;
    [label setFont:[UIFont fontWithName:@"Helvetica" size:DESCRIPTION_FONT_SIZE]];
    return [label.text sizeWithFont:label.font
                  constrainedToSize: CGSizeMake(295 - DESCRIPTION_X,300.0)
                      lineBreakMode:UILineBreakModeWordWrap];
}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    ParseObjects* parseObjects = [ParseObjects sharedInstance];
    if (indexPath.section == 1) {
        AudioPostCell* cell = (AudioPostCell *)[tableView dequeueReusableCellWithIdentifier:@"AudioPostCell%i"];
        if (!cell) {
            NSArray *topLevelItems = [cellLoader instantiateWithOwner:cell options:nil];
            cell = [topLevelItems objectAtIndex:0];
        }
        cell.post = object;
        PFUser* user = [object valueForKey:parseObjects.postOwnerKey];
        [user fetchIfNeeded];
        
        CGSize labelsize = [self setCellLabel:cell.description
                                     withText:[object valueForKey:parseObjects.descriptionKey]];
        //Don't use labelsize.width in case the description is shorter than the cell
        cell.description.frame=CGRectMake(DESCRIPTION_X, DESCRIPTION_Y,
                                          295 - DESCRIPTION_X,
                                          labelsize.height);
        
        NSString* name = [[NSString alloc] initWithFormat:@"%@ %@",
                          [user valueForKey:parseObjects.userFirstNameKey], [user valueForKey:parseObjects.userLastNameKey]];
        cell.name.text = name;
        cell.altName.text = name;
        
        //handles the case where a cell started playing and then the user scrolled away
        //and then scrolled back
        if ([cell isEqual:currentlyPlaying]) {
            cell = nil;
            return currentlyPlaying;
        }
        
        PFFile* userProfilePicFile = [user valueForKey:parseObjects.userProfilePictureKey];
       if (![userProfilePicFile isEqual:[[NSNull alloc] init]]) {
           UIImage* userProfilePic =[[UIImage alloc] initWithData:[userProfilePicFile getData]];

           cell.profilePic.image = userProfilePic;
        } else {
           cell.profilePic.image = nil;
        }
        cell.profilePic.layer.cornerRadius = 5.0;
        cell.profilePic.clipsToBounds = YES;
        
        cell.audioData = [[object valueForKey:parseObjects.audioFileKey] getData];
        
        CGRect newFrame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width-5.0, cell.frame.size.height);
        cell.altView.frame = newFrame;
        cell.mainView.frame = newFrame;
        cell.altView.layer.cornerRadius = 10.0;
        cell.mainView.layer.cornerRadius = 10.0;
        
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

// Override if you need to change the ordering of objects in the table.
-(PFObject*) objectAtIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.section == 1) {
         return [self.objects objectAtIndex:indexPath.row];
     }
     return nil;
 }

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */
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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell class] == [AudioPostCell class]) {
        if(currentlyPlaying) {
            [currentlyPlaying toggleViews];
        }
        AudioPostCell* audioPostCell = (AudioPostCell*) cell;
        [audioPostCell toggleViews];
        currentlyPlaying = audioPostCell;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



@end
