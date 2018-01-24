//
//  BKSportQuery.h
//  BraceletKit
//
//  Created by xaoxuu on 23/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKQuery.h"

@class BKDataSport;
/**
 运动量统计
 */
@interface BKSportQuery : BKQuery


/**
 总步数
 */
@property (assign, nonatomic) NSInteger steps;
/**
 总距离
 */
@property (assign, nonatomic) CGFloat distance;
/**
 消耗的总卡路里
 */
@property (assign, nonatomic) CGFloat calorie;
/**
 总活动时间（分钟）
 */
@property (assign, nonatomic) NSInteger activity;


/**
 每小时步数详情
 
 如果查询单位是天，共24条，代表每一小时的步数
 如果查询单位是周、月或年，代表每一天的数据，有多少天就有多少条
 */
@property (strong, nonatomic) NSMutableArray<NSNumber *> *hourSteps;
/**
 每小时距离详情
 
 如果查询单位是天，共24条，代表每一小时的步数
 如果查询单位是周、月或年，代表每一天的数据，有多少天就有多少条
 */
@property (strong, nonatomic) NSMutableArray<NSNumber *> *hourDistance;
/**
 每小时卡路里详情
 
 如果查询单位是天，共24条，代表每一小时的步数
 如果查询单位是周、月或年，代表每一天的数据，有多少天就有多少条
 */
@property (strong, nonatomic) NSMutableArray<NSNumber *> *hourCalorie;

@end
