//
//  BKDescriptionUtilities.h
//  BraceletKitDemo
//
//  Created by xaoxuu on 02/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BraceletKit.h"

@interface BKDescriptionUtilities : NSObject

+ (NSString *)languageDescription:(BKLanguage)language;

+ (BKLanguage)languageWithDescription:(NSString *)description;



+ (NSString *)tempUnitDescription:(BKTemperatureUnit)temp;

+ (BKTemperatureUnit)tempWithDescription:(NSString *)description;




+ (NSString *)distanceUnitDescription:(BKDistanceUnit)distance;

+ (BKDistanceUnit)distanceWithDescription:(NSString *)description;



+ (NSString *)hourFormatDescription:(BKHourFormat)hour;

+ (BKHourFormat)hourFormatWithDescription:(NSString *)description;


+ (NSString *)dateFormatDescription:(BKDateFormat)date;

+ (BKDateFormat)dateFormatWithDescription:(NSString *)description;



+ (NSString *)bgColorDescription:(BKDeviceBGColor)date;

+ (BKDeviceBGColor)bgColorWithDescription:(NSString *)description;




@end
