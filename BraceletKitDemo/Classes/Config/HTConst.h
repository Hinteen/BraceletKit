//
//  HTConst.h
//  Hinteen
//
//  Created by xaoxuu on 07/09/2017.
//  Copyright © 2017 hinteen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


// @xaoxuu: 窄 margin = 4
CG_EXTERN const CGFloat kMargin4;
// @xaoxuu: 普通 margin = 8
CG_EXTERN const CGFloat kMarginNormal;
// @xaoxuu: 宽 margin = 12
CG_EXTERN const CGFloat kMargin12;
// @xaoxuu: 很宽 margin = 16
CG_EXTERN const CGFloat kMargin16;


// @xaoxuu: 按钮高度
CG_EXTERN const CGFloat kButtonHeight;


CG_EXTERN UIFont *kFontNormal();

// @xaoxuu: 重载冷却（1秒内最多加载一次数据）
CG_EXTERN NSTimeInterval reloadCooldown;
// @xaoxuu: 重载计时id（id相同则共享冷却时间）
FOUNDATION_EXTERN NSString *reloadToken;

// @xaoxuu: 刷新按钮的冷却（1秒内最多接受一次点击）
CG_EXTERN NSTimeInterval reloadBtnCooldown;
// @xaoxuu: 重载计时id（id相同则共享冷却时间）
FOUNDATION_EXTERN NSString *reloadBtnToken;



@interface HTConst : NSObject

@end
