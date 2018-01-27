//
//  BKPreferences.m
//  BraceletKit
//
//  Created by xaoxuu on 22/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKPreferences.h"
#import "_BKHeader.h"

@implementation BKPreferences

+ (void)load{
    [self createTableIfNotExists];
}


- (void)applyToMyDevice{
    [[BLELib3 shareInstance] setFirmwareOption:self.transformToZeronerHWOption];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[BLELib3 shareInstance] readFirmwareOption];
    });
}



+ (NSString *)tableName{
    return @"preferences";
}
+ (NSString *)tableColumns{
    static NSString *columnName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableString *column = [NSMutableString string];
        [column appendVarcharColumn:@"user_id" comma:YES];
        [column appendVarcharColumn:@"device_id" comma:YES];
        [column appendVarcharColumn:@"device_name" comma:YES];
        
        [column appendIntegerColumn:@"language" comma:YES];
        [column appendIntegerColumn:@"distance_unit" comma:YES];
        [column appendIntegerColumn:@"temperature_unit" comma:YES];
        [column appendIntegerColumn:@"date_format" comma:YES];
        [column appendIntegerColumn:@"hour_format" comma:YES];
        
        [column appendIntegerColumn:@"auto_sport" comma:YES];
        [column appendIntegerColumn:@"auto_heartrate" comma:YES];
        [column appendIntegerColumn:@"auto_sleep" comma:YES];
        
        [column appendIntegerColumn:@"disConnectTip" comma:YES];
        [column appendIntegerColumn:@"findPhoneSwitch" comma:YES];
        [column appendIntegerColumn:@"led_switch" comma:YES];
        [column appendIntegerColumn:@"left_hand" comma:YES];
        [column appendIntegerColumn:@"advertisementSwitch" comma:YES];
        
        [column appendIntegerColumn:@"backColor" comma:YES];
        [column appendIntegerColumn:@"backlightStart" comma:YES];
        [column appendIntegerColumn:@"backlightEnd" comma:YES];
        
        [column appendIntegerColumn:@"wristSwitch" comma:YES];
        [column appendIntegerColumn:@"wristBlightStart" comma:YES];
        [column appendIntegerColumn:@"wristBlightEnd" comma:YES];
        
        [column appendVarcharColumn:@"lastmodified" comma:NO];
        columnName = column;
    });
    return columnName;
}
+ (NSString *)tablePrimaryKey{
    return @"user_id, device_id";
}

+ (instancetype)modelWithSet:(FMResultSet *)set{
    int i = 0;
    BKPreferences *model = [[BKPreferences alloc] init];
    i++;// user_id
    i++;// device_id
    i++;// device_name
    model.language = [set longForColumnIndex:i++];
    model.distanceUnit = [set longForColumnIndex:i++];
    model.temperatureUnit = [set longForColumnIndex:i++];
    model.dateFormat = [set longForColumnIndex:i++];
    model.hourFormat = [set longForColumnIndex:i++];
    
    model.autoSport = [set longForColumnIndex:i++];
    model.autoHeartRate = [set longForColumnIndex:i++];
    model.autoSleep = [set longForColumnIndex:i++];
    
    model.disConnectTip = [set longForColumnIndex:i++];
    model.findPhoneSwitch = [set longForColumnIndex:i++];
    model.ledSwitch = [set longForColumnIndex:i++];
    model.leftHand = [set longForColumnIndex:i++];
    model.advertisementSwitch = [set longForColumnIndex:i++];
    
    model.backgroundColor = [set longForColumnIndex:i++];
    model.backlightStart = [set longForColumnIndex:i++];
    model.backlightEnd = [set longForColumnIndex:i++];
    
    model.wristSwitch = [set longForColumnIndex:i++];
    model.wristBlightStart = [set longForColumnIndex:i++];
    model.wristBlightEnd = [set longForColumnIndex:i++];
    
    return model;
}

- (NSString *)valueString{
    NSMutableString *value = [NSMutableString string];
    [value appendVarcharValue:bk_user_id() comma:YES];
    [value appendVarcharValue:bk_device_id() comma:YES];
    [value appendVarcharValue:bk_device_name() comma:YES];
    [value appendIntegerValue:self.language comma:YES];
    [value appendIntegerValue:self.distanceUnit comma:YES];
    [value appendIntegerValue:self.temperatureUnit comma:YES];
    [value appendIntegerValue:self.dateFormat comma:YES];
    [value appendIntegerValue:self.hourFormat comma:YES];
    
    [value appendIntegerValue:self.autoSport comma:YES];
    [value appendIntegerValue:self.autoHeartRate comma:YES];
    [value appendIntegerValue:self.autoSleep comma:YES];
    
    [value appendIntegerValue:self.disConnectTip comma:YES];
    [value appendIntegerValue:self.findPhoneSwitch comma:YES];
    [value appendIntegerValue:self.ledSwitch comma:YES];
    [value appendIntegerValue:self.leftHand comma:YES];
    [value appendIntegerValue:self.advertisementSwitch comma:YES];
    
    [value appendIntegerValue:self.backgroundColor comma:YES];
    [value appendIntegerValue:self.backlightStart comma:YES];
    [value appendIntegerValue:self.backlightEnd comma:YES];
    
    [value appendIntegerValue:self.wristSwitch comma:YES];
    [value appendIntegerValue:self.wristBlightStart comma:YES];
    [value appendIntegerValue:self.wristBlightEnd comma:YES];
    
    [value appendVarcharValue:bk_date_string(bk_today()) comma:NO];
    return value;
}

- (BOOL)cacheable{
    return bk_user_id().length && bk_device_id().length;
}

- (NSString *)whereExists{
    return [NSString stringWithFormat:@"user_id = '%@' and device_id = '%@'", bk_user_id(), bk_device_id()];
}

- (instancetype)restoreFromDatabase{
    __block BKPreferences *model = [[BKPreferences alloc] init];
    databaseTransaction(^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        [db ax_select:@"*" from:self.class.tableName where:^NSString * _Nonnull{
            return self.whereExists;
        } result:^(FMResultSet * _Nonnull set) {
            model = [self.class modelWithSet:set];
        }];
    });
    return model;
}


- (BOOL)saveToDatabaseIfNotExists{
    __block BOOL ret = NO;
    if (self.cacheable) {
        databaseTransaction(^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
            __block BOOL exists = NO;
            [db ax_select:@"*" from:self.class.tableName where:^NSString * _Nonnull{
                return self.whereExists;
            } result:^(FMResultSet * _Nonnull set) {
                exists = YES;
            }];
            if (!exists) {
                ret = [db ax_replaceIntoTable:self.class.tableName column:self.class.tableColumns.stringByDeletingTypeAndComma value:self.valueString];
            } else {
                ret = NO;
            }
        });
    }
    return ret;
}


@end

