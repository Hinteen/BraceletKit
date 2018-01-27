//
//  BKSportQuery.h
//  BraceletKit
//
//  Created by xaoxuu on 23/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKQuery.h"

@class BKSportData;
/**
 运动量统计
 */
@interface BKSportQuery : BKQuery

/**
 steps
 */
@property (assign, nonatomic) NSInteger steps;
/**
 distance
 */
@property (assign, nonatomic) CGFloat distance;
/**
 calorie
 */
@property (assign, nonatomic) CGFloat calorie;
/**
 activity
 */
@property (assign, nonatomic) NSInteger activity;


/**
 每小时步数详情
 共24条，代表每一小时的步数
 */
@property (strong, nonatomic) NSMutableArray<NSNumber *> *hourSteps;
/**
 每小时距离详情
 共24条，代表每一小时的步数
 */
@property (strong, nonatomic) NSMutableArray<NSNumber *> *hourDistance;
/**
 每小时卡路里详情
 共24条，代表每一小时的步数
 */
@property (strong, nonatomic) NSMutableArray<NSNumber *> *hourCalorie;


@end
