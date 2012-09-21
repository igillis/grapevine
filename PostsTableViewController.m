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

#define DESCRIPTION_X 83.0
#define DESCRIPTION_Y 34.0
#define DESCRIPTION_FONT_SIZE 12.0

static NSDictionary* images;

@interface PostsTableViewController ()

@end

@implementation PostsTableViewController

@synthesize currentlyPlaying;


- (id)initWithStyle:(UITableViewStyle)style
{
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
        self.objectsPerPage = 5;
    }
    NSLog(@"init with self.className=%@", self.className);
    return self;
}

- (void) awakeFromNib {
    // Custom the table
    
    // The className to query on
    self.className =
    [[ParseObjects sharedInstance] audioPostClassName];
    
    // Whether the built-in pull-to-refresh is enabled
    self.pullToRefreshEnabled = YES;
    
    // Whether the built-in pagination is enabled
    self.paginationEnabled = YES;
    
    // The number of objects to show per page
    self.objectsPerPage = 5;
    NSLog(@"awoke with self.className=%@", self.className);
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    cellLoader = [UINib nibWithNibName:@"AudioPostCell" bundle:[NSBundle mainBundle]];
    NSLog(@"viewdidload with self.className=%@", self.className);
    
    self.clearsSelectionOnViewWillAppear = NO;
    
    NSString* imagesFile = [[NSBundle mainBundle] pathForResource:@"FakeImages" ofType:@"plist"];
    images = [[NSDictionary alloc] initWithContentsOfFile:imagesFile];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewwillappear");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self viewDidLoad];
    NSLog(@"viewdidappear");
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


// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"priority"];
    
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
    NSLog(@"return height of %f", MAX(82.0, labelsize.height + DESCRIPTION_Y + 10.0));
    return MAX(82.0, labelsize.height + DESCRIPTION_Y + 10.0);
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
    AudioPostCell* cell = (AudioPostCell *)[tableView dequeueReusableCellWithIdentifier:@"AudioPostCell%i"];
    if (!cell) {
        NSArray *topLevelItems = [cellLoader instantiateWithOwner:cell options:nil];
        cell = [topLevelItems objectAtIndex:0];
    }
    PFUser* name = [object valueForKey:parseObjects.postOwnerKey];
    CGSize labelsize = [self setCellLabel:cell.description
                                 withText:[object valueForKey:parseObjects.descriptionKey]];
    //Don't use labelsize.width in case the description is shorter than the cell
    cell.description.frame=CGRectMake(DESCRIPTION_X, DESCRIPTION_Y,
                                      295 - DESCRIPTION_X,
                                      labelsize.height);
    
    [name fetchIfNeeded];
    cell.name.text = [name objectForKey:parseObjects.userFirstNameKey];
    //cell.altName.text = [name objectForKey:parseObjects.userLastNameKey];
    cell.timeSlider.continuous = NO;
    cell.audioPath = [[NSBundle mainBundle] pathForResource:@"FakeSound" ofType:@"mp3"];
    CGRect newFrame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width-5.0, cell.frame.size.height);
    cell.altView.frame = newFrame;
    cell.mainView.frame = newFrame;
    cell.altView.layer.cornerRadius = 10.0;
    cell.mainView.layer.cornerRadius = 10.0;
    
    //handles the case where a cell started playing and then the user scrolled away
    //and then scrolled back
    if ([cell isEqual:currentlyPlaying]) {
        cell = nil;
        return currentlyPlaying;
    }
    
    NSString* imagePath = [[NSBundle mainBundle] pathForResource:[images objectForKey:name] ofType:@"jpg"];
    cell.profilePic.image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    NSLog(@"%f", cell.mainView.frame.origin.y);
    return cell;
}


 // Override if you need to change the ordering of objects in the table.
 /*- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
     NSLog(@"getting object at %@", indexPath);
     if (indexPath.section == 1) {
         return [self.objects objectAtIndex:indexPath.row];
     }
     return nil;
 }*/

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
