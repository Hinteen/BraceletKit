//
//  BKSchedule.h
//  BraceletKit
//
//  Created by xaoxuu on 24/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BKDefines.h"


@class ZRSchedule;
@interface BKSchedule : NSObject

/**
 title
 */
@property (copy, nonatomic) NSString *title;
/**
 subtitle
 */
@property (copy, nonatomic) NSString *subtitle;

/**
 date
 */
@property (strong, nonatomic) NSDate *date;

/**
 ring id
 */
@property (assign, nonatomic) BKRingId ringId;

/**
 valid
 */
@property (assign, nonatomic) BOOL valid;

/**
 invalidDate
 */
@property (strong, nonatomic) NSDate *invalidDate;


- (ZRSchedule *)transformToZRSchedule;

@end

