//
//  BKHeartRateQuery.h
//  BraceletKit
//
//  Created by xaoxuu on 23/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKQuery.h"

@class BKHeartRateData, BKHeartRateHourData;
/**
 心率统计
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
 消耗的能力
 */
@property (assign, nonatomic) CGFloat energy;



/**
 5个心率区间的时间详情r1 , r2, r3, r4, r5
 */
@property (strong, nonatomic) NSMutableArray<NSNumber *> *timeDetail;

/**
 5个心率区间的能量详情r1 , r2, r3, r4, r5
 */
@property (strong, nonatomic) NSMutableArray<NSNumber *> *energyDetail;

/**
 5个心率区间的心率详情r1 , r2, r3, r4, r5
 */
@property (strong, nonatomic) NSMutableArray<NSNumber *> *hrDetail;


/**
 分钟心率详情（只有当查询单位为天时才有这个值）
 代表每分钟心率，共24x60=1440条
 */
@property (strong, nonatomic) NSMutableArray<NSNumber *> *minuteHR;




@end
