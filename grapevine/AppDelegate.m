//
//  AppDelegate.m
//  grapevine
//
//  Created by Ian Gillis on 8/28/12.
//  Copyright (c) 2012 Ian Gillis. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "TrendingViewController.h"
#import "ContactsViewController.h"
#import "LoginViewController.h"
#import "SessionManager.h"
#import "AudioController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

@implementation AppDelegate {
    HomeViewController* homeViewController;
    TrendingViewController* trendingViewController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    homeViewController = [[HomeViewController alloc]
        initWithNibName:@"HomeViewController"bundle:nil];
    trendingViewController = [[TrendingViewController alloc]
                                                initWithNibName:@"TrendingViewController"bundle:nil];

    UIViewController *contactsViewController = [[ContactsViewController alloc]
                                                initWithNibName:@"ContactsViewController" bundle:nil];
    
    LoginViewController* loginViewController = [[LoginViewController alloc] init];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers =
        @[homeViewController, trendingViewController, contactsViewController];
    self.tabBarController.delegate = self;
    
    
    self.window.rootViewController = self.tabBarController;
    self.window.layer.cornerRadius = 3.0;
    self.window.layer.masksToBounds = YES;
    self.window.rootViewController.view.layer.cornerRadius = 3.0;
    self.window.rootViewController.view.layer.masksToBounds = YES;
    [self.window makeKeyAndVisible];
    
    [self.tabBarController presentViewController:loginViewController animated:YES completion:NULL];
    
    [Parse setApplicationId:@"XTrDXkn1iCJN7BnNJvVgexKW9lk3zovtAloHxqR6"
                  clientKey:@"awYmVJEAegJMTHKpht7PyZGCSdPBtMJaeUgASeO7"];
    [PFFacebookUtils initializeWithApplicationId:@"348658601895040"];
    
    //prime the audiocontroller so that playback isn't delayed while it initializes
    [[AudioController sharedInstance] prepareToPlay];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

- (void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSLog(@"changed views %@", viewController.view.subviews);
    if (viewController == trendingViewController) {
        [trendingViewController.postsTableViewController loadObjects];
    } else if (viewController == homeViewController) {
        [homeViewController.tableViewController loadObjects];
    }
}
@end
