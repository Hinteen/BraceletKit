//
//  AppDelegate.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 25/10/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import "AppDelegate.h"
#import <BraceletKit/BraceletKit.h>
#import <BLE3Framework/BLE3Framework.h>
#import <AXKit/AXKit.h>
#import "ServicesLayer.h"
#import "RootViewController.h"

@interface AppDelegate () <BKServicesDelegate>

// @xaoxuu: root vc
@property (strong, nonatomic) RootViewController *rootVC;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    AXCachedLogOBJ(@"启动");
    // 加载数据库
//    [BKData loadDatabase];
    [[BLELib3 shareInstance] applicationDidFinishLaunchingWithOptions];
    // @xaoxuu: 启动服务
    [[BKServices sharedInstance] registerServicesDelegate:self];
    
    [ServicesLayer sharedInstance];
    [[UIThemeManager sharedInstance] configDefaultTheme:^(UIThemeManager *theme) {
        theme.color.theme = [UIColor ax_blue];
        theme.color.accent = [UIColor md_orange];
    }];
    
    // 创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 设置窗口根控制器
    self.rootVC = [[RootViewController alloc] init];
    self.window.rootViewController = self.rootVC;
    // 显示窗口
    [self.window makeKeyAndVisible];
    
    
    
    [UINavigationBar appearance].barStyle = UIBarStyleDefault;
    [UINavigationBar appearance].translucent = NO;
    [UINavigationBar appearance].opaque = YES;
    [UINavigationBar appearance].barTintColor = axThemeManager.color.theme;
    [UINavigationBar appearance].tintColor = UIColor.whiteColor;
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:UIColor.whiteColor};

    
    [UITabBar appearance].barStyle = UIBarStyleDefault;
    [UITabBar appearance].translucent = NO;
    [UITabBar appearance].opaque = YES;
    [UITabBar appearance].barTintColor = UIColor.whiteColor;
    [UITabBar appearance].tintColor = axThemeManager.color.theme;
    
    return YES;
}

- (void)servicesDidLoadFinished:(BKServices *)services{
    
    
    
    // 注册和登录用户
    BKUser *user = [BKUser registerWithEmail:@"me@xaoxuu.com" password:@"123456"];
    NSString *log = [NSString stringWithFormat:@"注册用户me@xaoxuu.com,密码123456.结果：%@", user ? @"成功":@"失败"];
    AXCachedLogOBJ(log);
    user = [BKUser loginWithEmail:@"me@xaoxuu.com" password:@"123456"];
    log = [NSString stringWithFormat:@"登录用户me@xaoxuu.com,密码123456.结果：%@", user ? @"成功":@"失败"];
    AXCachedLogOBJ(log);
    if (user) {
        BOOL ret = [[BKServices sharedInstance] registerServiceWithUser:user];
        log = [NSString stringWithFormat:@"使用用户<%@>注册服务，结果：%@", user.email, ret ? @"成功":@"失败"];
        AXCachedLogOBJ(log);
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    AXCachedLogOBJ(@"即将Resign Active");
//    [[BLELib3 shareInstance] application];
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    AXCachedLogOBJ(@"已经进入后台");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    AXCachedLogOBJ(@"即将进入前台");
    [[BKDevice currentDevice] requestSyncTimeAtOnceCompletion:nil error:nil];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    AXCachedLogOBJ(@"已经Become Active");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    AXCachedLogOBJ(@"即将terminate");
}


@end
