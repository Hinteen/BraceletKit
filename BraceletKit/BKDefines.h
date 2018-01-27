//
//  BKDefines.h
//  BraceletKit
//
//  Created by xaoxuu on 27/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>




/**
 查询单位
 
 - BKQueryUnitDaily: 每日数据
 - BKQueryUnitWeekly: 每周数据
 - BKQueryUnitMonthly: 每月数据
 - BKQueryUnitYearly: 每年数据
 */
typedef NS_ENUM(NSUInteger, BKQueryUnit) {
    BKQueryUnitDaily   = 1,
    BKQueryUnitWeekly  = 7,
    BKQueryUnitMonthly = 31,
    BKQueryUnitYearly  = 365,
};


