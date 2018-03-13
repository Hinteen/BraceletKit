//
//  BKWeather.h
//  BraceletKit
//
//  Created by xaoxuu on 02/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKDefines.h"

@interface BKWeather : NSObject

/**
 温度值
 */
@property (assign, nonatomic) NSInteger temperature;

/**
 温度单位
 */
@property (assign, nonatomic) BKTemperatureUnit unit;

/**
 天气状况
 */
@property (assign, nonatomic) BKWeatherCondition condition;

/**
 PM2.5
 */
@property (assign, nonatomic) NSInteger pm2_5;


@end
