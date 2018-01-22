//
//  BKSportList.h
//  BraceletKit
//
//  Created by xaoxuu on 22/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKBaseTable.h"
#import <BLE3Framework/ZeronerBleHeader.h>

@interface BKSportList : BKBaseTable

/**
 运动类型
 */
@property (assign, nonatomic) sd_sportType type;
/**
 运动名
 */
@property (copy, nonatomic) NSString *name;
/**
 运动计量单位
 */
@property (copy, nonatomic) NSString *unit;


@end
