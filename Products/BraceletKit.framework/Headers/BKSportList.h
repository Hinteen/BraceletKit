//
//  BKSportList.h
//  BraceletKit
//
//  Created by xaoxuu on 22/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKData.h"
#import <BLEMidAutumn/BLEMidAutumn.h>

@interface BKSportList : BKData <BKData>

/**
 运动类型
 */
@property (assign, nonatomic) sd_sportType type;
/**
 运动名
 */
@property (copy, nonatomic) NSString *name;
/**
 运动计量单位
 */
@property (copy, nonatomic) NSString *unit;


@end
