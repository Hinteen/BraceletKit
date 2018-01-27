//
//  BKSleepData.h
//  BraceletKit
//
//  Created by xaoxuu on 22/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKData.h"

@interface BKSleepData : BKData <BKData>

/**
 date integer
 */
@property (assign, nonatomic) NSInteger dateInteger;

/**
 seq
 */
@property (assign, nonatomic) NSInteger seq;
/**
 sleep_type
 */
@property (assign, nonatomic) NSInteger sleepType;
/**
 mode
 */
@property (assign, nonatomic) NSInteger mode;

/**
 start
 */
@property (strong, nonatomic) NSDate *start;
/**
 end
 */
@property (strong, nonatomic) NSDate *end;

/**
 duration minutes
 */
@property (assign, nonatomic) NSInteger duration;



/**
 sleep_enter
 */
@property (assign, nonatomic) NSInteger sleepEnter;
/**
 sleep_exit
 */
@property (assign, nonatomic) NSInteger sleepExit;
/**
 sport_type
 */
@property (assign, nonatomic) NSInteger sportType;



+ (instancetype)modelWithDict:(NSDictionary *)dict;



@end
