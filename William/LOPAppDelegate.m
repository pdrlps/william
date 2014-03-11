//
//  LOPAppDelegate.m
//  William
//
//  Created by Pedro Lopes on 04/02/14.
//  Copyright (c) 2014 Pedro Lopes. All rights reserved.
//

#import "LOPAppDelegate.h"
#import "LOPListViewController.h"
#import <Crashlytics/Crashlytics.h>

@implementation LOPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Crashlytics startWithAPIKey:@"23fc3a72601974bf2932492e8609d82c6ca052fc"];
    
    application.statusBarStyle = UIStatusBarStyleLightContent;
    
    UIScreen *screen = [UIScreen mainScreen];
    CGRect frame = [screen bounds];
    
    self.window = [[UIWindow alloc] initWithFrame:frame];

    
    self.window.backgroundColor = [UIColor whiteColor];
    
    // UI appearance to all nav bar
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    navigationBar.barTintColor = [UIColor colorWithRed:0.32 green:0.40 blue:0.48 alpha:1];
    navigationBar.tintColor = [UIColor colorWithWhite:1 alpha:0.56];
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,
      [UIFont fontWithName:@"GillSans-Light" size:16.0f], NSFontAttributeName,nil]];
    
    
    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
    [barButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"GillSans-Light" size:16.0f]} forState:UIControlStateNormal];
    
    UIViewController *viewController = [[LOPListViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
  