//
//  BKDayData.h
//  BraceletKit
//
//  Created by xaoxuu on 21/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKData.h"

@interface BKDayData : BKData <BKData>

/**
 date integer
 */
@property (assign, nonatomic) NSInteger dateInteger;
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
 count
 */
@property (assign, nonatomic) NSInteger count;
/**
 activity minutes
 */
@property (assign, nonatomic) NSInteger activity;
/**
 avg bpm
 */
@property (assign, nonatomic) NSInteger avgBpm;
/**
 max bpm
 */
@property (assign, nonatomic) NSInteger maxBpm;
/**
 min bpm
 */
@property (assign, nonatomic) NSInteger minBpm;



+ (instancetype)modelWithDict:(NSDictionary *)dict;


//+ (NSArray<BKDayData *> *)selectFromDatabaseWithDate:(NSDate *)date;

@end
