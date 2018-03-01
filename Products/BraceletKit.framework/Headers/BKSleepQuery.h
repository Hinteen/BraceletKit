//
//  BKSleepQuery.h
//  BraceletKit
//
//  Created by xaoxuu on 23/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKQuery.h"

@class BKSleepData;

/**
 一天的睡眠统计（开始时间所在的天，如今天晚上睡到明天早上的数据属于今天的睡眠数据）
 */
@interface BKSleepQuery : BKQuery


/**
 睡眠开始时间
 */
@property (strong, nonatomic) NSDate *start;
/**
 睡眠结束时间
 */
@property (strong, nonatomic) NSDate *end;

/**
 睡眠总时长（分钟）
 */
@property (assign, nonatomic) NSInteger duration;

/**
 深睡时长
 */
@property (assign, nonatomic) NSInteger deepSleep;

/**
 浅睡时长
 */
@property (assign, nonatomic) NSInteger lightSleep;


/**
 睡眠区间详情（一天的）
 
 如果查询单位是周、月或年，则此值为空
 */
@property (strong, nonatomic) NSMutableArray<BKSleepData *> *items;


@end
