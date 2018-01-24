//
//  BKSleepQuery.h
//  BraceletKit
//
//  Created by xaoxuu on 23/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKQuery.h"

@class BKDataSleep;

/**
 一天的睡眠统计
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
 睡眠时长（分钟）
 */
@property (assign, nonatomic) NSInteger duration;


/**
 睡眠区间详情
 */
@property (strong, nonatomic) NSMutableArray<BKDataSleep *> *detail;


@end
