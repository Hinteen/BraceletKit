//
//  BKHeartRateData.h
//  BraceletKit
//
//  Created by xaoxuu on 21/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKData.h"

@interface BKHeartRateData : BKData <BKData>


/**
 date integer
 */
@property (assign, nonatomic) NSInteger dateInteger;

/**
 seq
 */
@property (assign, nonatomic) NSInteger seq;
/**
 hr type
 */
@property (assign, nonatomic) NSInteger hrType;

/**
 start
 */
@property (strong, nonatomic) NSDate *start;
/**
 end
 */
@property (strong, nonatomic) NSDate *end;

/**
 energy
 */
@property (assign, nonatomic) CGFloat energy;

/**
 r1 , r2, r3, r4, r5
 */
@property (strong, nonatomic) NSMutableArray<NSNumber *> *timeDetail;

/**
 r1 , r2, r3, r4, r5
 */
@property (strong, nonatomic) NSMutableArray<NSNumber *> *energyDetail;

/**
 r1 , r2, r3, r4, r5
 */
@property (strong, nonatomic) NSMutableArray<NSNumber *> *hrDetail;



+ (instancetype)modelWithDict:(NSDictionary *)dict;


@end
