//
//  BKDailySportQuery.h
//  BraceletKit
//
//  Created by xaoxuu on 23/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKQuery.h"

@class BKDataSport;
/**
 一天的运动量统计
 */
@interface BKDailySportQuery : BKQuery


/**
 一天总步数
 */
@property (assign, nonatomic) NSInteger steps;
/**
 一天总距离
 */
@property (assign, nonatomic) CGFloat distance;
/**
 一天消耗的总卡路里
 */
@property (assign, nonatomic) CGFloat calorie;
/**
 一天的总活动时间（分钟）
 */
@property (assign, nonatomic) NSInteger activity;


/**
 每小时步数详情（共24条）
 */
@property (strong, nonatomic) NSMutableArray<NSNumber *> *hourSteps;
/**
 每小时距离详情（共24条）
 */
@property (strong, nonatomic) NSMutableArray<NSNumber *> *hourDistance;
/**
 每小时卡路里详情（共24条）
 */
@property (strong, nonatomic) NSMutableArray<NSNumber *> *hourCalorie;

@end
