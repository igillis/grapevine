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

#import <QuartzCore/QuartzCore.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UIViewController *homeViewController = [[HomeViewController alloc]
        initWithNibName:@"HomeViewController"bundle:nil];
    UIViewController *trendingViewController = [[TrendingViewController alloc] initWithNibName:@"TrendingViewController" bundle:nil];
    UIViewController *contactsViewController = [[ContactsViewController alloc]
        initWithNibName:@"ContactsViewController" bundle:nil];
    
    LoginViewController* loginViewController = [[LoginViewController alloc] init];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers =
        @[homeViewController, trendingViewController, contactsViewController];
    
    
    
    self.window.rootViewController = self.tabBarController;
    self.window.layer.cornerRadius = 3.0;
    self.window.layer.masksToBounds = YES;
    self.window.rootViewController.view.layer.cornerRadius = 3.0;
    self.window.rootViewController.view.layer.masksToBounds = YES;
    [self.window makeKeyAndVisible];
    
    [self.tabBarController presentViewController:loginViewController animated:YES completion:NULL];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
