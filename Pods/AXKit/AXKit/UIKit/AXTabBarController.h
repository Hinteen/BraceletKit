//
//  AXTabBarController.h
//  AXKit
//
//  Created by xaoxuu on 13/11/2017.
//  Copyright © 2017 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AXTabBarController <NSObject>
@optional


/**
 导航栏基类名
 如果使用系统提供的UINavigationController而不进行继承，可以不实现此方法。
 
 @return 导航栏基类名
 */
- (NSString *)classNameForBaseNavigationController;

/**
 配置文件路径
 使用与本类同名的json文件作为配置文件时，可以不实现此方法。
 
 @return 配置文件路径
 */
- (NSString *)configurationFilePath;

/**
 配置文件中ViewController的类名的key值，默认是"vc"
 
 @return 配置文件中ViewController的name的key值，默认是"vc"
 */
- (NSString *)configurationKeyForViewControllerName;

/**
 配置文件中ViewController的类名的key值，默认是"title"
 
 @return 配置文件中ViewController的title的key值，默认是"title"
 */
- (NSString *)configurationKeyForViewControllerTitle;

/**
 配置文件中icon的key值，默认是"icon"
 
 @return 配置文件中icon的key值，默认是"icon"
 */
- (NSString *)configurationKeyForTabBarIconName;

/**
 配置文件中选中状态的icon的key值，默认是"icon_sel"
 
 @return 配置文件中选中状态的icon的key值，默认是"icon_sel"
 */
- (NSString *)configurationKeyForTabBarSelectedIconName;


@end

@interface AXTabBarController : UITabBarController <AXTabBarController>



@end




