//
//  BKAlarmClock.h
//  BraceletKit
//
//  Created by xaoxuu on 24/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BKDefines.h"

@class ZRClock;
@interface BKAlarmClock : NSObject

/**
 Index of clock .Most device valiable range is 0～3, special device valiable range is 0～7
 */
@property (assign, nonatomic) NSUInteger clockId;

/**
 * Description: Use a Byte number identify repeat day ,recycle by a week .Detail of every byte as follows ,use b7~b1 declared :
 * b7:Valid mark, b6:Satueday, b5:Friday, b4:Thursday, b3:Wednesday, b2:Tuesday, b1:Monday, b0:Sunday
 * 1 means on ,0 indicate off .
 */
@property (assign, nonatomic) NSUInteger weekRepeat;

/**
 hour
 */
@property (assign, nonatomic) NSUInteger hour;

/**
 minute
 */
@property (assign, nonatomic) NSUInteger minute;

/**
 RingSetting
 */
@property (assign, nonatomic) BKRingId ringId;

/**
 clockTipsLenth
 */
@property (assign, nonatomic) NSUInteger clockTipsLenth;

/**
 clockTips
 */
@property (copy, nonatomic) NSString *clockTips;

- (ZRClock *)transformToZRClock;

@end

