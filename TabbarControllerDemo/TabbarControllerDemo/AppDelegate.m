//
//  AppDelegate.m
//  TabbarControllerDemo
//
//  Created by 123456 on 2016/10/20.
//  Copyright © 2016年 KuXing. All rights reserved.
//

#import "AppDelegate.h"

#import "HLViewControllerOne.h"
#import "HLViewControllerTwo.h"
#import "HLViewControllerFour.h"
#import "HLViewControllerThree.h"

#import "HLTabBarController.h"


@interface AppDelegate ()<HLTabbarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    HLViewControllerOne *one     = [[HLViewControllerOne alloc] init];
    HLViewControllerTwo *two     = [HLViewControllerTwo   new];
    HLViewControllerThree *three = [HLViewControllerThree new];
    HLViewControllerFour *four   = [HLViewControllerFour  new];
    
    HLTabBarController *tabBar   = [HLTabBarController new];
    [tabBar setViewControllers:@[one,two,three,four]];
    tabBar.title                 = @"附近";
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tabBar];

    self.window.rootViewController = nav;
    
    tabBar.delegate = self;
    
    return YES;
}

- (void)tabBarController:(HLTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    NSString *title = nil;
    
    if ([viewController isKindOfClass:[HLViewControllerOne class]])
    {
        title = @"附近";
    }
    else if ([viewController isKindOfClass:[HLViewControllerTwo class]])
    {
        title = @"动态";
    }
    else if ([viewController isKindOfClass:[HLViewControllerThree class]])
    {
        title = @"消息";
    }
    else if ([viewController isKindOfClass:[HLViewControllerFour class]])
    {
        title = @"发现";
    }
    
    tabBarController.title = title;
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
