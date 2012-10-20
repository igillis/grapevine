//
//  PostsTableViewController.m
//  grapevine
//
//  Created by Ian Gillis on 10/4/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "PostsTableViewController.h"
#import "ParseObjects.h"
#import <QuartzCore/QuartzCore.h>

@interface PostsTableViewController ()

@end

@implementation PostsTableViewController

#define DESCRIPTION_X 83.0
#define DESCRIPTION_Y 24.0
#define DESCRIPTION_FONT_SIZE 12.0

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidUnload
{
    self.currentlySelected = nil;
    self.currentlyPlaying = nil;
    self.tableView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self viewDidLoad];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    cellLoader = [UINib nibWithNibName:@"AudioPostCell" bundle:[NSBundle mainBundle]];
    
    self.clearsSelectionOnViewWillAppear = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) formatCell: (AudioPostCell*)cell withObject:(PFObject*) object {
    ParseObjects* parseObjects = [ParseObjects sharedInstance];
    cell.post = object;
    cell.tableView = self;
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
    
    //Add an identical label to the alternate view
    UILabel* altName = [[UILabel alloc] initWithFrame:cell.name.frame];
    altName.text = name;
    altName.font = [UIFont systemFontOfSize:15.0];
    [cell.altView addSubview:altName];


    
    PFFile* userProfilePicFile = [user valueForKey:parseObjects.userProfilePictureKey];
    if (![userProfilePicFile isEqual:[[NSNull alloc] init]]) {
        UIImage* userProfilePic =[[UIImage alloc] initWithData:[userProfilePicFile getData]];
        
        cell.profilePic.image = userProfilePic;
        
        //Add the same image view to the view users see after selecting a cell
        UIImageView* altViewImage = [[UIImageView alloc] initWithFrame:cell.profilePic.frame];
        altViewImage.image = userProfilePic;
        altViewImage.layer.cornerRadius = 5.0;
        altViewImage.clipsToBounds = YES;
        [cell.altView addSubview:altViewImage];
    } else {
        cell.profilePic.image = nil;
    }
    cell.profilePic.layer.cornerRadius = 5.0;
    cell.profilePic.clipsToBounds = YES;
    
    cell.audioURL = ((PFFile*)[object valueForKey:parseObjects.audioFileKey]).url;
    
    CGRect newFrame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width-5.0, cell.frame.size.height);
    cell.altView.frame = newFrame;
    cell.mainView.frame = newFrame;
    cell.altView.layer.cornerRadius = 10.0;
    cell.mainView.layer.cornerRadius = 10.0;
}

- (CGSize) setCellLabel:(UILabel*) label withText:(NSString*) text {
    [label setNumberOfLines:0];
    label.text = text;
    [label setFont:[UIFont fontWithName:@"Helvetica" size:DESCRIPTION_FONT_SIZE]];
    return [label.text sizeWithFont:label.font
                  constrainedToSize: CGSizeMake(295 - DESCRIPTION_X,300.0)
                      lineBreakMode:UILineBreakModeWordWrap];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell class] == [AudioPostCell class]) {
        if(self.currentlySelected) {
            [self.currentlySelected toggleViews];
        }
        AudioPostCell* audioPostCell = (AudioPostCell*) cell;
        [audioPostCell toggleViews];
        self.currentlySelected = audioPostCell;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
