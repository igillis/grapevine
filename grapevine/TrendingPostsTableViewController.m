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

@synthesize currentlyPlaying;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"INIT WITH NIB NAME CALLED");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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


- (void)viewDidLoad
{
    [super viewDidLoad];
    cellLoader = [UINib nibWithNibName:@"AudioPostCell" bundle:[NSBundle mainBundle]];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    ParseObjects* parseObjects = [ParseObjects sharedInstance];
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
