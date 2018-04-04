//
//  BKSedentary.h
//  BraceletKit
//
//  Created by xaoxuu on 24/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZRSedentary;
@interface BKSedentary : NSObject


/**
 * the state of reminder switch, default is NO ,means off.
 */
@property (nonatomic ,assign) BOOL switchStatus;

/*
 eg： @｛sedentaryId：0，startHour：8:00，endHour：12:00｝
 */
@property (nonatomic ,assign) NSUInteger sedentaryId;

/**
 * the repeats of sedentary ,to know more details to see @code weekRepeat methods。
 */
@property (nonatomic ,assign) NSUInteger weekRepeat ;

/**
 * the startTime of sedentary ,unit is hour .
 */
@property (nonatomic ,assign) NSUInteger startHour;

/**
 * the endTime of sedentary ,unit is hour .
 */
@property (nonatomic ,assign) NSUInteger endHour;

/**
 * the monitor duration ,unit is minute . your may demanded set a num is multiple of 5.
 * default duration is 60 minutes and threshold is 50 steps if you set both zero.
 * Special device support
 */
@property (nonatomic ,assign) NSUInteger sedentaryDuration;
@property (nonatomic ,assign) NSUInteger sedentaryThreshold;

/**
 *  Switch for ”No break during lunch break”
 */
@property (nonatomic ,assign) BOOL noDisturbing;


- (ZRSedentary *)transformToZRSedentary;

@end
