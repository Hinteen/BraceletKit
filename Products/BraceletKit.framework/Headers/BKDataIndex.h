//
//  BKDataIndex.h
//  BraceletKit
//
//  Created by xaoxuu on 21/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKData.h"


/**
 数据类型

 - BKDataTypeIndex:     0x08 updateNormalHealthData 索引数据
 - BKDataTypeDay:       0x29 updateCurrentWholeDaySportData/updateWholeDaySportData 天总数据
 - BKDataTypeSport:     0x28 updateSportData 分段运动
 - BKDataTypeSleep:     0x28 updateSleepData 睡眠数据
 - BKDataTypeHR:        0x51 updateHeartRateData 心率数据
 - BKDataTypeHRHours:   0x53 updateHeartRateData_hours 小时心率数据
 */
//typedef NS_ENUM(NSUInteger, BKDataType) {
//    BKDataTypeUnknown   = 0,
//    BKDataTypeIndex     = 0x08,
//    BKDataTypeDay       = 0x29,
//    BKDataTypeSport     = 0x28,
//    BKDataTypeSleep     = 0x28,
//    BKDataTypeHR        = 0x51,
//    BKDataTypeHRHours   = 0x53,
//};


@interface BKDataIndex : BKData <BKData>

/**
 type
 */
@property (copy, nonatomic) NSString *dataType;
/**
 total
 */
@property (assign, nonatomic) NSInteger total;
/**
 start seq
 */
@property (assign, nonatomic) NSInteger start;
/**
 end seq
 */
@property (assign, nonatomic) NSInteger end;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
