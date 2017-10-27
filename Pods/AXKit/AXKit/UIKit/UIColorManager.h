//
//  UIColorManager.h
//  AXKit
//
//  Created by xaoxuu on 05/03/2017.
//  Copyright © 2017 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class UIColorManager;
extern UIColorManager *axColor;


#pragma mark - 主题模型
@interface UIThemeColorModel : NSObject

/**
 当前app的主题色
 */
@property (strong, nonatomic) UIColor *theme;

/**
 当前app的强调色
 */
@property (strong, nonatomic) UIColor *accent;

/**
 当前app的背景色（一般为白色或很浅的灰色）
 */
@property (strong, nonatomic) UIColor *background;

/**
 组tableview背景色
 */
@property (strong, nonatomic) UIColor *groupTableViewBackground;

/**
 分割线颜色
 */
@property (strong, nonatomic) UIColor *separatorColor;


@property (strong, nonatomic) UIColor *title;
@property (strong, nonatomic) UIColor *subTitle;


#pragma mark - 系统颜色

- (UIColor *)black;      // 0.0 white
- (UIColor *)darkGray;   // 0.333 white
- (UIColor *)gray;       // 0.5 white
- (UIColor *)lightGray;  // 0.667 white
- (UIColor *)white;      // 1.0 white
- (UIColor *)clear;      // 0.0 white, 0.0 alpha


@end

#pragma mark - 主题管理
@interface UIColorManager : UIThemeColorModel


/**
 设置默认的颜色配置（会被新的更改覆盖，一般用在appDelegate中）

 @param colorManager 默认的颜色配置
 */
- (void)configColorManager:(void (^)(UIColorManager *manager))colorManager;

/**
 保存当前主题
 */
- (void)saveCurrentTheme;



#pragma mark - life circle

+ (instancetype)defaultManager;

+ (instancetype)sharedInstance;

@end

@interface UIColor (UIAdaptiveColor)


/**
 自适应颜色（取决于主题色的深浅）

 @return 当主题色比较浅时自动加深，用于主题色上的文字显示
 */
- (UIColor *)adaptive;

@end

NS_ASSUME_NONNULL_END
