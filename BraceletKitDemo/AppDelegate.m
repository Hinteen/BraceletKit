//
//  AppDelegate.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 25/10/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import "AppDelegate.h"
#import <BraceletKit/BraceletKit.h>
#import <AXKit/AXKit.h>
#import "ServicesLayer.h"
#import "RootViewController.h"

@interface AppDelegate ()
// @xaoxuu: root vc
@property (strong, nonatomic) RootViewController *rootVC;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    AXLogToCachePath(@"启动");
    [[BLELib3 shareInstance] applicationDidFinishLaunchingWithOptions];
    // @xaoxuu: 启动服务
    [ServicesLayer sharedInstance];
    [[UIColorManager sharedInstance] configColorManager:^(UIColorManager * _Nonnull manager) {
        manager.theme = [UIColor md_red];
        manager.accent = [UIColor md_lime];
    }];
    
    // 创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 设置窗口根控制器
    self.rootVC = [[RootViewController alloc] init];
    self.window.rootViewController = self.rootVC;
    // 显示窗口
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    AXLogToCachePath(@"即将Resign Active");
//    [[BLELib3 shareInstance] application];
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    AXLogToCachePath(@"已经进入后台");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    AXLogToCachePath(@"即将进入前台");
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    AXLogToCachePath(@"已经Become Active");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    AXLogToCachePath(@"即将terminate");
}


@end
