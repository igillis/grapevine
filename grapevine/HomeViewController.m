//
//  FirstViewController.m
//  grapevine
//
//  Created by Ian Gillis on 8/28/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "HomeViewController.h"
#import "AudioPostCell.h"

#define DESCRIPTION_X 83.0
#define DESCRIPTION_Y 34.0
#define DESCRIPTION_FONT_SIZE 12.0

@interface HomeViewController ()

@end

@implementation HomeViewController

static AudioPostCell* currentlyPlaying = nil;

@synthesize posts;
@synthesize images;
@synthesize recordButton;
@synthesize grapevine;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // placeholder until we design a home tab bar item
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:99];
        cellLoader = [UINib nibWithNibName:@"AudioPostCell" bundle:[NSBundle mainBundle]];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	NSString* postsFile = [[NSBundle mainBundle] pathForResource:@"FakePosts"
                                                     ofType:@"plist"];
    NSString* imagesFile = [[NSBundle mainBundle] pathForResource:@"FakeImages" ofType:@"plist"];
    
    self.posts = [[NSDictionary alloc] initWithContentsOfFile:postsFile];
    self.images = [[NSDictionary alloc] initWithContentsOfFile:imagesFile];
    
    [grapevine setFont:[UIFont fontWithName:@"TalkingtotheMoon" size:24.0]];
    
    self.recordButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.recordButton.layer.borderWidth = 0.5;
    self.recordButton.layer.cornerRadius = 3.0;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return [[posts allKeys] count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        AudioPostCell *cell = (AudioPostCell *)[tableView dequeueReusableCellWithIdentifier:[[NSString alloc] initWithFormat:@"AudioPostCell%i", indexPath.row]];
        if (!cell) {
            NSArray *topLevelItems = [cellLoader instantiateWithOwner:self options:nil];
            cell = [topLevelItems objectAtIndex:0];
        }
        NSString* name = [[posts allKeys] objectAtIndex:indexPath.row];
        CGSize labelsize = [self setCellLabel:cell.description withText:[posts objectForKey:name]];
        //Don't use labelsize.width in case the description is shorter than the cell
        cell.description.frame=CGRectMake(DESCRIPTION_X, DESCRIPTION_Y,
                                          295 - DESCRIPTION_X,
                                          labelsize.height);
        cell.name.text = name;
        
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

//"private" method to determine how big label will be if filled with text
- (CGSize) setCellLabel:(UILabel*) label withText:(NSString*) text {
    [label setNumberOfLines:0];
    label.text = text;
    [label setFont:[UIFont fontWithName:@"Helvetica" size:DESCRIPTION_FONT_SIZE]];
    return [label.text sizeWithFont:label.font
                     constrainedToSize: CGSizeMake(295 - DESCRIPTION_X,300.0)
                         lineBreakMode:UILineBreakModeWordWrap];
}

- (void)tableView:(UITableView *)tableView  didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* soundFile = [[NSBundle mainBundle] pathForResource:@"FakeSound" ofType:@"mp3"];
    if(currentlyPlaying) {
        [currentlyPlaying stopAudio];
        [self toggleHidden:currentlyPlaying];
    }

    AudioPostCell* cell = (AudioPostCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell playAudio:soundFile];
    [self toggleHidden:cell];
    currentlyPlaying = cell;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)toggleHidden: (AudioPostCell*) cell {
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.3;
    [cell.layer addAnimation:animation forKey:nil];
    cell.hidden = !cell.hidden;
}

- (void)recordButtonPressed:(id)sender {
    //TODO: decide what to do when record button is pressed
    if (currentlyPlaying) {
        [currentlyPlaying pauseAudio];
    }
    NSLog(@"record button pressed");
}
@end
