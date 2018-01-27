//
//  BKHeartRateHourData.h
//  BraceletKit
//
//  Created by xaoxuu on 21/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKData.h"

@interface BKHeartRateHourData : BKData <BKData>



/**
 date integer
 */
@property (assign, nonatomic) NSInteger dateInteger;

/**
 seq
 */
@property (assign, nonatomic) NSInteger seq;
/**
 seq
 */
@property (assign, nonatomic) NSInteger hour;

/**
 1小时内每分钟的心率，共60条
 */
@property (strong, nonatomic) NSArray<NSNumber *> *hrDetail;



+ (instancetype)modelWithDict:(NSDictionary *)dict;



@end
