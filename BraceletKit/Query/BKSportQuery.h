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
 运动开始时间
 */
@property (strong, nonatomic) NSDate *start;
/**
 运动结束时间
 */
@property (strong, nonatomic) NSDate *end;
/**
 活动时间
 */
@property (assign, nonatomic) NSInteger activity;

/**
 步数
 */
@property (assign, nonatomic) NSInteger steps;
/**
 距离
 */
@property (assign, nonatomic) CGFloat distance;
/**
 卡路里
 */
@property (assign, nonatomic) CGFloat calorie;

@end
