//
//  BKDefines.h
//  BraceletKit
//
//  Created by xaoxuu on 20/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

// 依赖库
#import <UIKit/UIKit.h>
#import <BLE3Framework/BLE3Framework.h>
#import <AXKit/AXKit.h>
// 私有工具类
#import "_BKDatabaseHelper.h"
#import "_BKModelHelper.h"
#import "_BKLogHelper.h"


FOUNDATION_EXTERN NSDateFormatter *bk_formatter(void);

FOUNDATION_EXTERN NSDate *bk_today(void);

FOUNDATION_EXTERN NSString *bk_device_id(void);

FOUNDATION_EXTERN NSString *bk_device_name(void);

FOUNDATION_EXTERN NSString *bk_date_string(NSDate *date);


@interface BKDefines : NSObject

@end
