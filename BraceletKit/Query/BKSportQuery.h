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
 运动统计
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
 总卡路里
 */
@property (assign, nonatomic) CGFloat calorie;
/**
 总活动时间（分钟）
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
