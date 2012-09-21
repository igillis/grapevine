//
//  HomeTableViewController.m
//  grapevine
//
//  Created by Ian Gillis on 9/14/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

/*
#import "HomeTableViewController.h"
#import "AudioPostCell.h"

#define DESCRIPTION_X 83.0
#define DESCRIPTION_Y 34.0
#define DESCRIPTION_FONT_SIZE 12.0

@interface HomeTableViewController ()

@end

@implementation HomeTableViewController
@synthesize posts;
@synthesize images;
@synthesize currentlyPlaying;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    cellLoader = [UINib nibWithNibName:@"AudioPostCell" bundle:[NSBundle mainBundle]];
	NSString* postsFile = [[NSBundle mainBundle] pathForResource:@"FakePosts"
                                                          ofType:@"plist"];
    NSString* imagesFile = [[NSBundle mainBundle] pathForResource:@"FakeImages" ofType:@"plist"];
    
    self.posts = [[NSDictionary alloc] initWithContentsOfFile:postsFile];
    self.images = [[NSDictionary alloc] initWithContentsOfFile:imagesFile];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return [[posts allKeys] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        AudioPostCell *cell = (AudioPostCell *)[tableView dequeueReusableCellWithIdentifier:@"AudioPostCell%i"];
        if (!cell) {
            NSArray *topLevelItems = [cellLoader instantiateWithOwner:cell options:nil];
            cell = [topLevelItems objectAtIndex:0];
        }
        NSString* name = [[posts allKeys] objectAtIndex:indexPath.row];
        CGSize labelsize = [self setCellLabel:cell.description withText:[posts objectForKey:name]];
        //Don't use labelsize.width in case the description is shorter than the cell
        cell.description.frame=CGRectMake(DESCRIPTION_X, DESCRIPTION_Y,
                                          295 - DESCRIPTION_X,
                                          labelsize.height);
        cell.name.text = name;
        cell.altName.text = name;
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
        
        NSString* imagePath =
        [[NSBundle mainBundle] pathForResource:[images objectForKey:name] ofType:@"jpg"];
        cell.profilePic.image = [[UIImage alloc] initWithContentsOfFile:imagePath];
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 30.0;
    }
    CGSize labelsize;
    UILabel * label = [[UILabel alloc] init];
    labelsize = [self setCellLabel:label
                          withText:[posts objectForKey:[[posts allKeys] objectAtIndex:indexPath.row]]];
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
*/