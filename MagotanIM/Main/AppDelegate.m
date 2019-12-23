//
//  AppDelegate.m
//  MagotanIM
//
//  Created by 新银河 on 2019/10/30.
//  Copyright © 2019 MJDev. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"CURRENTUSER"];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[LoginViewController new]];
    [self.window makeKeyWindow];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
   
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {

    NSLog(@"================applicationWillEnterForeground================");
    
    [[SocketIOManager sharedInstance] emitOrder:@"logout" with:@{@"userID":[[NSUserDefaults standardUserDefaults] valueForKey:@"CURRENTUSER"]}];
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
   
}


- (void)applicationWillTerminate:(UIApplication *)application {
  
}


@end
