//
//  AppDelegate.m
//  yoforchinese
//
//  Created by NPHD on 14-7-28.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "AppDelegate.h"
#import "APService.h"
#import "MainViewController.h"
#import "APAddressBook.h"
#import "APContact.h"
#import <ShareSDK/ShareSDK.h>
#import "config.h"
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:[[MainViewController alloc]init]];
    [navi setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
    
    // Required
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)];
    // Required
    [APService setupWithOption:launchOptions];
    
    
    [ShareSDK registerApp:@"2833ca5999d7"];
    [ShareSDK connectSMS];
    return YES;
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveRemoteNotifiaction object:userInfo];
        
    }
    [APService handleRemoteNotification:userInfo];
}
- (void)clear
{
    [[self.window viewWithTag:1001] removeFromSuperview];
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
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
