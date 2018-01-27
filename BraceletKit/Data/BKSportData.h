//
//  BKSportData.h
//  BraceletKit
//
//  Created by xaoxuu on 21/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKData.h"

@interface BKSportData : BKData <BKData>

/**
 date integer
 */
@property (assign, nonatomic) NSInteger dateInteger;

/**
 seq
 */
@property (assign, nonatomic) NSInteger seq;
/**
 sport type
 */
@property (assign, nonatomic) NSInteger sportType;

/**
 start
 */
@property (strong, nonatomic) NSDate *start;
/**
 end
 */
@property (strong, nonatomic) NSDate *end;
/**
 activity minutes
 */
@property (assign, nonatomic) NSInteger activity;


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


+ (instancetype)modelWithDict:(NSDictionary *)dict;


@end
