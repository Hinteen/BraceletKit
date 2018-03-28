//
//  UIApplication+AXExtension.h
//  AXKit
//
//  Created by xaoxuu on 10/10/2017.
//  Copyright © 2017 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIApplication (AXExtension)


/**
 打开app内置Safari浏览器

 @param URL 网址
 */
+ (void)ax_presentSafariViewControllerWithURL:(NSURL *)URL;

/**
 打开app内置Safari浏览器

 @param URL 网址
 @param viewController 从哪个视图控制器，传入nil可从根控制器打开
 */
+ (void)ax_presentSafariViewControllerWithURL:(NSURL *)URL fromViewController:(nullable UIViewController *)viewController;

#pragma mark - 跳转

/**
 打开蓝牙设置
 */
+ (void)ax_openBluetoothSetting NS_DEPRECATED_IOS(8.0, 10.0, "Please use ax_openAppSetting instead") NS_EXTENSION_UNAVAILABLE_IOS("");

/**
 打开WIFI设置
 */
+ (void)ax_openWIFISetting NS_DEPRECATED_IOS(8_0, 10_0, "Please use ax_openAppSetting instead") NS_EXTENSION_UNAVAILABLE_IOS("");

/**
 打开通知设置
 */
+ (void)ax_openNotificationSetting NS_DEPRECATED_IOS(8_0, 10_0, "Please use ax_openAppSetting instead") NS_EXTENSION_UNAVAILABLE_IOS("");

/**
 打开相册设置
 */
+ (void)ax_openPhotosSetting NS_DEPRECATED_IOS(8_0, 10_0, "Please use ax_openAppSetting instead") NS_EXTENSION_UNAVAILABLE_IOS("");

/**
 打开浏览器设置
 */
+ (void)ax_openSafariSetting NS_DEPRECATED_IOS(8_0, 10_0, "Please use ax_openAppSetting instead") NS_EXTENSION_UNAVAILABLE_IOS("");

/**
 打开当前app的设置页面
 */
+ (void)ax_openAppSetting NS_AVAILABLE_IOS(11.0);

@end
NS_ASSUME_NONNULL_END
