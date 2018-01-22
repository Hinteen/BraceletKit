//
//  BKDefines.h
//  BraceletKit
//
//  Created by xaoxuu on 20/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BLE3Framework/BLE3Framework.h>
#import <AXKit/AXKit.h>
#import "_BKDatabaseHelper.h"
#import "_BKModelHelper.h"
#import "BKLogHelper.h"

FOUNDATION_EXTERN NSDateFormatter *formatter(void);

FOUNDATION_EXTERN NSDate *today(void);

FOUNDATION_EXTERN NSString *userId(void);

FOUNDATION_EXTERN NSString *deviceId(void);

FOUNDATION_EXTERN NSString *deviceName(void);

FOUNDATION_EXTERN NSString *dateString(NSDate *date);


@interface BKDefines : NSObject

@end
