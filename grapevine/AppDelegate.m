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
#import <Parse/Parse.h>
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
    
    [Parse setApplicationId:@"XTrDXkn1iCJN7BnNJvVgexKW9lk3zovtAloHxqR6"
                  clientKey:@"awYmVJEAegJMTHKpht7PyZGCSdPBtMJaeUgASeO7"];
    [PFFacebookUtils initializeWithApplicationId:@"348658601895040"];
    
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
    // this means the user switched back to this app without completing login
    if ([SessionManager sharedInstance].sessionState == SessionStatePending) {
        [[SessionManager sharedInstance] closeSession];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[SessionManager sharedInstance] closeSession];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

@end
