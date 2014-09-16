//
//  AppDelegate.m
//  youLost
//
//  Created by 1528 MAC on 14-9-4.
//  Copyright (c) 2014年 ksd. All rights reserved.
//

#import "AppDelegate.h"
#import "HostViewController.h"
#import "LoginViewController.h"
#import "KSDIMStatus.h"
#import "NSString+MD5.h"
#import "User.h"
#import "Common.h"
#import "AESCrypt.h"
#import <SMS_SDK/SMS_SDK.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "SetPasswordViewController.h"
#import "VerifyViewController.h"
@interface AppDelegate ()
            

@end

@implementation AppDelegate

- (void)test2
{
    
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [SMS_SDK	registerApp:@"3008e8f5d535" withSecret:@"b1a66881a0cd03bd5185487621f6f444"];
//    NSString *user = [AESCrypt encrypt:@"18617149851" password:@"11111111111111111111111111111111"];
//    [[KSDIMStatus sharedClient] POST:@"/login" parameters:[NSDictionary dictionaryWithObjectsAndKeys:user,@"username", [@"123321" MD5Digest],@"password",nil] success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//         NSLog(@"%@",dic);
//        if([[dic objectForKey:@"retcode"] integerValue] == 0)
//        {
//            NSDictionary *data = [dic objectForKey:@"data"];
//            User *user = [[User alloc]init];
//            user.username = @"zhao";
//            [Common sharedInstance].user = user;
//            [Common sharedInstance].token = [data objectForKey:@"token"];
//            //[self test];
//            [self test1];
//             self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[[ASViewController alloc]init]];
//        }
//       
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"%@",error);
//         self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[[ASViewController alloc]init]];
//    }];
    [self test2];
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    //VerifyViewController *v = [[VerifyViewController alloc]init];
   // [v setPhone:@"18617149851" AndAreaCode:@"+86"];
   self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[[LoginViewController alloc]init]];
    [self.window makeKeyAndVisible];
    
    return YES;
}
- (void)test1
{[[KSDIMStatus sharedClient] POST:@"/fetchweibo" parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"datafrom", @"4",@"dataend",nil] success:^(NSURLSessionDataTask *task, id responseObject) {
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
   
} failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSLog(@"%@",error);
}];
}
- (void)test
{

    [[KSDIMStatus sharedClient] POST:@"http://192.168.1.138:3000/createweibo" parameters:[[NSDictionary alloc]initWithObjectsAndKeys:@"xxxxxxxxx",@"content", nil] constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation([UIImage imageNamed:@"szz.jpg"], 0.8) name:@"avatar" fileName:@"szz.jpg" mimeType:@"image/jpeg"];
        [formData appendPartWithFileData:UIImageJPEGRepresentation([UIImage imageNamed:@"szz.jpg"], 0.8) name:@"avatar1" fileName:@"szz.jpg" mimeType:@"image/jpeg"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
//    [[KSDIMStatus sharedClient] POST:@"http://192.168.1.138:3000/post" parameters:[[NSDictionary alloc]initWithObjectsAndKeys:@"content",@"content", nil]  success:^(NSURLSessionDataTask *task, id responseObject) {
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
