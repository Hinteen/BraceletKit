//
//  BKHeartRateQuery.h
//  BraceletKit
//
//  Created by xaoxuu on 23/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKQuery.h"

@class BKDataHR, BKDataHRHour;
/**
 一天的心率统计
 */
@interface BKHeartRateQuery : BKQuery

/**
 平均心率
 */
@property (assign, nonatomic) NSInteger avgBpm;
/**
 最大心率
 */
@property (assign, nonatomic) NSInteger maxBpm;
/**
 最小心率
 */
@property (assign, nonatomic) NSInteger minBpm;

/**
 总能量消耗
 */
@property (assign, nonatomic) CGFloat energy;


/**
 5个区间的时间详情r1 , r2, r3, r4, r5
 */
@property (strong, nonatomic) NSMutableArray<NSNumber *> *timeDetail;

/**
 5个区间的能量详情r1 , r2, r3, r4, r5
 */
@property (strong, nonatomic) NSMutableArray<NSNumber *> *energyDetail;

/**
 5个区间的心率详情r1 , r2, r3, r4, r5
 */
@property (strong, nonatomic) NSMutableArray<NSNumber *> *hrDetail;


/**
 每分钟心率详情（共24x60=1440条）
 */
@property (strong, nonatomic) NSMutableArray<NSNumber *> *minuteDetail;




@end
