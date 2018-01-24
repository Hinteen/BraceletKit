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
 总能量消耗
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
 心率详情
 
 如果查询单位是天，则代表每分钟心率，共24x60=1440条
 如果查询单位是周、月或年，则代表每天的平均心率，有多少天就有多少条
 */
@property (strong, nonatomic) NSMutableArray<NSNumber *> *minuteDetail;


/**
 每天平均心率
 
 如果查询单位是天，则此值为空
 如果查询单位是周、月或年，则代表每天的平均心率，有多少天就有多少条
 */
@property (strong, nonatomic) NSMutableArray<NSNumber *> *dailyAvgBpms;

/**
 每天最大心率
 
 如果查询单位是天，则此值为空
 如果查询单位是周、月或年，则代表每天的平均心率，有多少天就有多少条
 */
@property (strong, nonatomic) NSMutableArray<NSNumber *> *dailyMaxBpms;

/**
 每天最小心率
 
 如果查询单位是天，则此值为空
 如果查询单位是周、月或年，则代表每天的平均心率，有多少天就有多少条
 */
@property (strong, nonatomic) NSMutableArray<NSNumber *> *dailyMinBpms;

/**
 每天能量消耗
 
 如果查询单位是天，则此值为空
 如果查询单位是周、月或年，则代表每天的平均心率，有多少天就有多少条
 */
@property (strong, nonatomic) NSMutableArray<NSNumber *> *dailyEnergys;



@end
