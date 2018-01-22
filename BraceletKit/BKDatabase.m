//
//  BKDatabase.m
//  BraceletKit
//
//  Created by xaoxuu on 20/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKDatabase.h"
#import "_BKDatabaseHelper.h"
#import <AXKit/AXKit.h>
#import "BKServices.h"

static inline NSDateFormatter *formatter(){
    static NSDateFormatter *fm;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fm = [[NSDateFormatter alloc] init];
        fm.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
    });
    return fm;
}

static inline NSDate *today(){
    return [NSDate date];
}

static inline NSString *userId(){
    return [BKUser currentUser].email;
}

static inline NSString *deviceId(){
    return [BKDevice currentDevice].mac;
}

static inline NSString *deviceName(){
    return [BKDevice currentDevice].name;
}

static inline NSString *dateString(NSDate *date){
    return [formatter() stringFromDate:date];
}


@implementation BKUser (BKBaseTable)

+ (NSString *)tableName{
    return @"users";
}
+ (NSString *)tableColumns{
    static NSString *columnName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableString *column = [NSMutableString string];
        [column appendVarcharColumn:@"user_id" comma:YES];
        [column appendVarcharColumn:@"email" comma:YES];
        [column appendVarcharColumn:@"name" comma:YES];
        [column appendIntegerColumn:@"phone" comma:YES];
        
        [column appendIntegerColumn:@"gender" comma:YES];
        [column appendIntegerColumn:@"birthday" comma:YES];
        [column appendDoubleColumn:@"height" comma:YES];
        [column appendDoubleColumn:@"weight" comma:YES];
        [column appendVarcharColumn:@"avatar" comma:YES];
        
        [column appendVarcharColumn:@"lastmodified" comma:NO];
        columnName = column;
    });
    return columnName;
}
+ (NSString *)tablePrimaryKey{
    return @"user_id";
}

+ (instancetype)modelWithSet:(FMResultSet *)set{
    int i = 0;
    BKUser *model = [[BKUser alloc] init];
    i++; // user id
    model.email = [set stringForColumnIndex:i++];
    model.name = [set stringForColumnIndex:i++];
    model.phone = [set longForColumnIndex:i++];
    
    model.gender = [set longForColumnIndex:i++];
    model.birthday = [NSDate dateWithDateInteger:[set longForColumnIndex:i++]];
    model.height = [set doubleForColumnIndex:i++];
    model.weight = [set doubleForColumnIndex:i++];
    model.avatar = [set stringForColumnIndex:i++];
    
    return model;
}

- (NSString *)valueString{
    NSMutableString *value = [NSMutableString string];
    [value appendVarcharValue:self.email comma:YES]; // userid = email
    [value appendVarcharValue:self.email comma:YES];
    [value appendVarcharValue:self.name comma:YES];
    [value appendIntegerValue:self.phone comma:YES];
    
    [value appendIntegerValue:self.gender comma:YES];
    [value appendIntegerValue:self.birthday.dateInteger comma:YES];
    [value appendDoubleValue:self.height comma:YES];
    [value appendDoubleValue:self.weight comma:YES];
    [value appendVarcharValue:self.avatar comma:YES];
    
    [value appendVarcharValue:dateString(today()) comma:NO];
    return value;
}

+ (BKUser *)loadUserWithEmail:(NSString *)email{
    __block BKUser *cachedUser = nil;
    databaseTransaction(^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        NSString *where = [NSString stringWithFormat:@"email = '%@'", email];
        [db ax_select:@"*" from:BKUser.tableName where:where result:^(NSMutableArray * _Nonnull result, FMResultSet * _Nonnull set) {
            while (set.next) {
                cachedUser = [BKUser modelWithSet:set];
            }
        }];
    });
    return cachedUser;;
}

- (BOOL)cacheable{
    return self.email.length;
}

- (NSString *)whereExists{
    return [NSString stringWithFormat:@"email = '%@'", self.email];
}

@end


@implementation BKDevice (BKBaseTable)

+ (NSString *)tableName{
    return @"devices";
}
+ (NSString *)tableColumns{
    static NSString *columnName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableString *column = [NSMutableString string];
        [column appendVarcharColumn:@"device_id" comma:YES];
        [column appendVarcharColumn:@"mac" comma:YES];
        [column appendVarcharColumn:@"uuid" comma:YES];
        [column appendVarcharColumn:@"name" comma:YES];
        [column appendVarcharColumn:@"model" comma:YES];
        [column appendVarcharColumn:@"version" comma:YES];
        
        [column appendVarcharColumn:@"lastmodified" comma:NO];
        columnName = column;
    });
    return columnName;
}
+ (NSString *)tablePrimaryKey{
    return @"device_id, uuid";
}

+ (instancetype)modelWithSet:(FMResultSet *)set{
    int i = 0;
    BKDevice *model = [[BKDevice alloc] init];
    i++;// device_id
    model.mac = [set stringForColumnIndex:i++];
    model.uuid = [set stringForColumnIndex:i++];
    model.name = [set stringForColumnIndex:i++];
    model.model = [set stringForColumnIndex:i++];
    model.version = [set stringForColumnIndex:i++];
    
    return model;
}

- (NSString *)valueString{
    NSMutableString *value = [NSMutableString string];
    [value appendVarcharValue:deviceId() comma:YES]; // device_id = mac
    [value appendVarcharValue:self.mac comma:YES];
    [value appendVarcharValue:self.uuid comma:YES];
    [value appendVarcharValue:self.name comma:YES];
    [value appendVarcharValue:self.model comma:YES];
    [value appendVarcharValue:self.version comma:YES];
    
    [value appendVarcharValue:dateString(today()) comma:NO];
    return value;
}

- (BOOL)cacheable{
    return userId().length && self.mac.length && ![self.mac isEqualToString:@"advertisementData.length is less than 6"];
}

- (NSString *)whereExists{
    return [NSString stringWithFormat:@"device = '%@'", self.mac];
}

+ (instancetype)lastConnectedDevice{
    __block BKDevice *cachedDevice;
    databaseTransaction(^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        [db ax_select:@"*" from:self.tableName where:@"" orderBy:@"lastmodified DESC LIMIT 1" result:^(NSMutableArray * _Nonnull result, FMResultSet * _Nonnull set) {
            while (set.next) {
                cachedDevice = [self modelWithSet:set];
            }
        }];
    });
    return cachedDevice;
}

- (NSString *)restoreMac{
    __block NSString *mac;
    databaseTransaction(^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        NSString *where = [NSString stringWithFormat:@"uuid = '%@'", self.uuid];
        [db ax_select:@"mac" from:self.class.tableName where:where result:^(NSMutableArray * _Nonnull result, FMResultSet * _Nonnull set) {
            while (set.next) {
                mac = [set stringForColumnIndex:0];
            }
        }];
        if (!mac.length) { // 如果根据UUID找不到，可尝试根据设备name恢复
            NSString *where = [NSString stringWithFormat:@"name = '%@'", self.name];
            [db ax_select:@"mac" from:self.class.tableName where:where result:^(NSMutableArray * _Nonnull result, FMResultSet * _Nonnull set) {
                while (set.next) {
                    mac = [set stringForColumnIndex:0];
                }
            }];
        }
        if (!mac.length) { // 如果根据name找不到，可尝试根据设备model恢复
            NSString *where = [NSString stringWithFormat:@"model = '%@'", self.model];
            [db ax_select:@"mac" from:self.class.tableName where:where result:^(NSMutableArray * _Nonnull result, FMResultSet * _Nonnull set) {
                while (set.next) {
                    mac = [set stringForColumnIndex:0];
                }
            }];
        }
    });
    return mac;
}

@end

@implementation BKDeviceSetting (BKBaseTable)


+ (NSString *)tableName{
    return @"device_setting";
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
        [column appendIntegerColumn:@"unit_type" comma:YES];
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
    BKDeviceSetting *model = [[BKDeviceSetting alloc] init];
    i++;// user_id
    i++;// device_id
    i++;// device_name
    model.language = [set longForColumnIndex:i++];
    model.unitType = [set longForColumnIndex:i++];
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
    [value appendVarcharValue:userId() comma:YES];
    [value appendVarcharValue:deviceId() comma:YES];
    [value appendVarcharValue:deviceName() comma:YES];
    [value appendIntegerValue:self.language comma:YES];
    [value appendIntegerValue:self.unitType comma:YES];
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
    
    [value appendVarcharValue:dateString(today()) comma:NO];
    return value;
}

- (BOOL)cacheable{
    return userId().length && deviceId().length;
}

- (NSString *)whereExists{
    return [NSString stringWithFormat:@"user_id = '%@' and device_id = '%@'", userId(), deviceId()];
}

- (instancetype)restoreFromDatabase{
    __block BKDeviceSetting *model = [[BKDeviceSetting alloc] init];
    databaseTransaction(^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        [db ax_select:@"*" from:self.class.tableName where:self.whereExists result:^(NSMutableArray * _Nonnull result, FMResultSet * _Nonnull set) {
            while (set.next) {
                model = [self.class modelWithSet:set];
            }
        }];
    });
    return model;
}


- (BOOL)saveToDatabaseIfNotExists{
    __block BOOL ret = NO;
    if (self.cacheable) {
        databaseTransaction(^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
            __block BOOL exists = NO;
            [db ax_select:@"*" from:self.class.tableName where:self.whereExists result:^(NSMutableArray * _Nonnull result, FMResultSet * _Nonnull set) {
                while (set.next) {
                    exists = YES;
                }
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

@implementation BKSportList (BKBaseTable)



+ (NSString *)tableName{
    return @"sport_list";
}

+ (NSString *)tableColumns{
    static NSString *columnName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableString *column = [NSMutableString string];
        [column appendVarcharColumn:@"model" comma:YES];
        [column appendVarcharColumn:@"type" comma:YES];
        [column appendVarcharColumn:@"name" comma:YES];
        [column appendVarcharColumn:@"unit" comma:YES];
        
        [column appendVarcharColumn:@"lastmodified" comma:NO];
        columnName = column;
    });
    return columnName;
}
+ (NSString *)tablePrimaryKey{
    return @"model, type";
}

+ (instancetype)modelWithSet:(FMResultSet *)set{
    int i = 0;
    BKSportList *model = [[BKSportList alloc] init];
    i++;// model
    model.type = [set intForColumnIndex:i++];
    model.name = [set stringForColumnIndex:i++];
    model.unit = [set stringForColumnIndex:i++];
    
    return model;
}

- (NSString *)valueString{
    NSMutableString *value = [NSMutableString string];
    [value appendVarcharValue:[BKDevice currentDevice].model comma:YES];
    [value appendIntegerValue:self.type comma:YES];
    [value appendVarcharValue:self.name comma:YES];
    [value appendVarcharValue:self.unit comma:YES];
    
    [value appendVarcharValue:dateString(today()) comma:NO];
    return value;
}

- (BOOL)cacheable{
    return [UIDevice currentDevice].model.length;
}

- (NSString *)whereExists{
    return [NSString stringWithFormat:@"model = '%@' and type = %d", [UIDevice currentDevice].model, self.type];
}


@end

@implementation BKDataIndex (BKBaseTable)

+ (NSString *)tableName{
    return @"data_index";
}
+ (NSString *)tableColumns{
    static NSString *columnName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableString *column = [NSMutableString string];
        [column appendIntegerColumn:@"date" comma:YES];
        [column appendVarcharColumn:@"user_id" comma:YES];
        [column appendVarcharColumn:@"device_id" comma:YES];
        [column appendVarcharColumn:@"device_name" comma:YES];
        
        [column appendVarcharColumn:@"data_type" comma:YES];
        [column appendIntegerColumn:@"total" comma:YES];
        [column appendIntegerColumn:@"start" comma:YES];
        [column appendIntegerColumn:@"end" comma:YES];
        
        [column appendVarcharColumn:@"lastmodified" comma:NO];
        columnName = column;
    });
    return columnName;
}
+ (NSString *)tablePrimaryKey{
    return @"date, user_id, device_id, data_type, start";
}

+ (instancetype)modelWithSet:(FMResultSet *)set{
    int i = 0;
    BKDataIndex *model = [[BKDataIndex alloc] init];
    i++;// date
    i++;// user_id
    i++;// device_id
    i++;// device_name
    model.dataType = [set stringForColumnIndex:i++];
    model.total = [set longForColumnIndex:i++];
    model.start = [set longForColumnIndex:i++];
    model.end = [set longForColumnIndex:i++];
    
    return model;
}

- (NSString *)valueString{
    NSMutableString *value = [NSMutableString string];
    [value appendIntegerValue:today().dateInteger comma:YES];
    [value appendVarcharValue:userId() comma:YES];
    [value appendVarcharValue:deviceId() comma:YES];
    [value appendVarcharValue:deviceName() comma:YES];
    
    [value appendVarcharValue:self.dataType comma:YES];
    [value appendIntegerValue:self.total comma:YES];
    [value appendIntegerValue:self.start comma:YES];
    [value appendIntegerValue:self.end comma:YES];
    
    [value appendVarcharValue:dateString(today()) comma:NO];
    return value;
}

- (BOOL)cacheable{
    return userId().length && deviceId().length && self.dataType.length;
}


@end


@implementation BKDataDay (BKBaseTable)


+ (NSString *)tableName{
    return @"data_day";
}
+ (NSString *)tableColumns{
    static NSString *columnName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableString *column = [NSMutableString string];
        [column appendIntegerColumn:@"date" comma:YES];
        [column appendVarcharColumn:@"user_id" comma:YES];
        [column appendVarcharColumn:@"device_id" comma:YES];
        [column appendVarcharColumn:@"device_name" comma:YES];
        
        [column appendIntegerColumn:@"steps" comma:YES];
        [column appendDoubleColumn:@"distance" comma:YES];
        [column appendDoubleColumn:@"calorie" comma:YES];
        [column appendIntegerColumn:@"count" comma:YES];
        [column appendIntegerColumn:@"activity" comma:YES];
        
        [column appendIntegerColumn:@"avg_bpm" comma:YES];
        [column appendIntegerColumn:@"max_bpm" comma:YES];
        [column appendIntegerColumn:@"min_bpm" comma:YES];
        
        [column appendVarcharColumn:@"lastmodified" comma:NO];
        columnName = column;
    });
    return columnName;
}
+ (NSString *)tablePrimaryKey{
    return @"date, user_id, device_id, steps, distance, calorie";
}

+ (instancetype)modelWithSet:(FMResultSet *)set{
    int i = 0;
    BKDataDay *model = [[BKDataDay alloc] init];
    i++;// date
    i++;// user_id
    i++;// device_id
    i++;// device_name
    model.steps = [set longForColumnIndex:i++];
    model.distance = [set doubleForColumnIndex:i++];
    model.calorie = [set doubleForColumnIndex:i++];
    model.count = [set longForColumnIndex:i++];
    model.activity = [set longForColumnIndex:i++];
    
    model.avgBpm = [set longForColumnIndex:i++];
    model.maxBpm = [set longForColumnIndex:i++];
    model.minBpm = [set longForColumnIndex:i++];
    
    return model;
}

- (NSString *)valueString{
    NSMutableString *value = [NSMutableString string];
    [value appendIntegerValue:self.dateInteger comma:YES];
    [value appendVarcharValue:userId() comma:YES];
    [value appendVarcharValue:deviceId() comma:YES];
    [value appendVarcharValue:deviceName() comma:YES];
    
    [value appendIntegerValue:self.steps comma:YES];
    [value appendDoubleValue:self.distance comma:YES];
    [value appendDoubleValue:self.calorie comma:YES];
    [value appendIntegerValue:self.count comma:YES];
    [value appendIntegerValue:self.activity comma:YES];
    
    [value appendIntegerValue:self.avgBpm comma:YES];
    [value appendIntegerValue:self.maxBpm comma:YES];
    [value appendIntegerValue:self.minBpm comma:YES];
    
    [value appendVarcharValue:dateString(today()) comma:NO];
    return value;
}

- (BOOL)cacheable{
    return userId().length && deviceId().length;
}

@end






@implementation BKDataSport (BKBaseTable)


+ (NSString *)tableName{
    return @"data_sport";
}
+ (NSString *)tableColumns{
    static NSString *columnName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableString *column = [NSMutableString string];
        [column appendIntegerColumn:@"date" comma:YES];
        [column appendVarcharColumn:@"user_id" comma:YES];
        [column appendVarcharColumn:@"device_id" comma:YES];
        [column appendVarcharColumn:@"device_name" comma:YES];
        
        [column appendIntegerColumn:@"seq" comma:YES];
        [column appendIntegerColumn:@"sport_type" comma:YES];
        
        [column appendVarcharColumn:@"start" comma:YES];
        [column appendVarcharColumn:@"end" comma:YES];
        [column appendIntegerColumn:@"activity" comma:YES];
        
        [column appendIntegerColumn:@"steps" comma:YES];
        [column appendDoubleColumn:@"distance" comma:YES];
        [column appendDoubleColumn:@"calorie" comma:YES];
        
        [column appendVarcharColumn:@"lastmodified" comma:NO];
        columnName = column;
    });
    return columnName;
}
+ (NSString *)tablePrimaryKey{
    return @"date, user_id, device_id, seq, sport_type";
}

+ (instancetype)modelWithSet:(FMResultSet *)set{
    int i = 0;
    BKDataSport *model = [[BKDataSport alloc] init];
    i++;// date
    i++;// user_id
    i++;// device_id
    i++;// device_name
    model.seq = [set longForColumnIndex:i++];
    model.sportType = [set longForColumnIndex:i++];
    
    NSString *dateString = [set stringForColumnIndex:i++]; // start
    model.start = [formatter() dateFromString:dateString];
    dateString = [set stringForColumnIndex:i++]; // end
    model.end = [formatter() dateFromString:dateString];
    model.activity = [set longForColumnIndex:i++];
    
    model.steps = [set longForColumnIndex:i++];
    model.distance = [set doubleForColumnIndex:i++];
    model.calorie = [set doubleForColumnIndex:i++];
    
    return model;
}

- (NSString *)valueString{
    NSMutableString *value = [NSMutableString string];
    [value appendIntegerValue:self.dateInteger comma:YES];
    [value appendVarcharValue:userId() comma:YES];
    [value appendVarcharValue:deviceId() comma:YES];
    [value appendVarcharValue:deviceName() comma:YES];
    
    [value appendIntegerValue:self.seq comma:YES];
    [value appendIntegerValue:self.sportType comma:YES];
    
    [value appendVarcharValue:dateString(self.start) comma:YES];
    [value appendVarcharValue:dateString(self.end) comma:YES];
    [value appendIntegerValue:self.activity comma:YES];
    
    [value appendIntegerValue:self.steps comma:YES];
    [value appendDoubleValue:self.distance comma:YES];
    [value appendDoubleValue:self.calorie comma:YES];
    
    [value appendVarcharValue:dateString(today()) comma:NO];
    return value;
}

- (BOOL)cacheable{
    return userId().length && deviceId().length && self.dateInteger;
}

@end




@implementation BKDataHR (BKBaseTable)


+ (NSString *)tableName{
    return @"data_hr";
}
+ (NSString *)tableColumns{
    static NSString *columnName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableString *column = [NSMutableString string];
        [column appendIntegerColumn:@"date" comma:YES];
        [column appendVarcharColumn:@"user_id" comma:YES];
        [column appendVarcharColumn:@"device_id" comma:YES];
        [column appendVarcharColumn:@"device_name" comma:YES];
        
        [column appendIntegerColumn:@"seq" comma:YES];
        [column appendIntegerColumn:@"hr_type" comma:YES];
        
        [column appendVarcharColumn:@"start" comma:YES];
        [column appendVarcharColumn:@"end" comma:YES];
        [column appendDoubleColumn:@"energy" comma:YES];
        
        [column appendIntegerColumn:@"r1time" comma:YES];
        [column appendIntegerColumn:@"r2time" comma:YES];
        [column appendIntegerColumn:@"r3time" comma:YES];
        [column appendIntegerColumn:@"r4time" comma:YES];
        [column appendIntegerColumn:@"r5time" comma:YES];
        
        [column appendDoubleColumn:@"r1energy" comma:YES];
        [column appendDoubleColumn:@"r2energy" comma:YES];
        [column appendDoubleColumn:@"r3energy" comma:YES];
        [column appendDoubleColumn:@"r4energy" comma:YES];
        [column appendDoubleColumn:@"r5energy" comma:YES];
        
        [column appendIntegerColumn:@"r1hr" comma:YES];
        [column appendIntegerColumn:@"r2hr" comma:YES];
        [column appendIntegerColumn:@"r3hr" comma:YES];
        [column appendIntegerColumn:@"r4hr" comma:YES];
        [column appendIntegerColumn:@"r5hr" comma:YES];
        
        [column appendVarcharColumn:@"lastmodified" comma:NO];
        columnName = column;
    });
    return columnName;
}
+ (NSString *)tablePrimaryKey{
    return @"date, user_id, device_id, seq, hr_type";
}

+ (instancetype)modelWithSet:(FMResultSet *)set{
    int i = 0;
    BKDataHR *model = [[BKDataHR alloc] init];
    i++;// date
    i++;// user_id
    i++;// device_id
    i++;// device_name
    model.seq = [set longForColumnIndex:i++];
    model.hrType = [set longForColumnIndex:i++];
    
    NSString *dateString = [set stringForColumnIndex:i++]; // start
    model.start = [formatter() dateFromString:dateString];
    dateString = [set stringForColumnIndex:i++]; // end
    model.end = [formatter() dateFromString:dateString];
    model.energy = [set doubleForColumnIndex:i++];
    
    for (int j = 0; j < 5; j++) {
        [model.timeDetail addObject:@([set longForColumnIndex:i++])];
    }
    for (int j = 0; j < 5; j++) {
        [model.energyDetail addObject:@([set doubleForColumnIndex:i++])];
    }
    for (int j = 0; j < 5; j++) {
        [model.hrDetail addObject:@([set longForColumnIndex:i++])];
    }
    
    
    return model;
}

- (NSString *)valueString{
    NSMutableString *value = [NSMutableString string];
    [value appendIntegerValue:self.dateInteger comma:YES];
    [value appendVarcharValue:userId() comma:YES];
    [value appendVarcharValue:deviceId() comma:YES];
    [value appendVarcharValue:deviceName() comma:YES];
    
    [value appendIntegerValue:self.seq comma:YES];
    [value appendIntegerValue:self.hrType comma:YES];
    
    [value appendVarcharValue:dateString(self.start) comma:YES];
    [value appendVarcharValue:dateString(self.end) comma:YES];
    [value appendDoubleValue:self.energy comma:YES];
    
    for (int j = 0; j < 5; j++) {
        [value appendIntegerValue:self.timeDetail[j].integerValue comma:YES];
    }
    for (int j = 0; j < 5; j++) {
        [value appendDoubleValue:self.energyDetail[j].doubleValue comma:YES];
    }
    for (int j = 0; j < 5; j++) {
        [value appendIntegerValue:self.hrDetail[j].integerValue comma:YES];
    }
    
    [value appendVarcharValue:dateString(today()) comma:NO];
    return value;
}

- (BOOL)cacheable{
    return userId().length && deviceId().length && self.dateInteger;
}

@end



@implementation BKDataHRHour (BKBaseTable)


+ (NSString *)tableName{
    return @"data_hr_hour";
}
+ (NSString *)tableColumns{
    static NSString *columnName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableString *column = [NSMutableString string];
        [column appendIntegerColumn:@"date" comma:YES];
        [column appendVarcharColumn:@"user_id" comma:YES];
        [column appendVarcharColumn:@"device_id" comma:YES];
        [column appendVarcharColumn:@"device_name" comma:YES];
        
        [column appendIntegerColumn:@"seq" comma:YES];
        [column appendIntegerColumn:@"hour" comma:YES];
        
        [column appendVarcharColumn:@"detail" comma:YES];
        
        [column appendVarcharColumn:@"lastmodified" comma:NO];
        columnName = column;
    });
    return columnName;
}
+ (NSString *)tablePrimaryKey{
    return @"date, user_id, device_id, seq, hour";
}

+ (instancetype)modelWithSet:(FMResultSet *)set{
    int i = 0;
    BKDataHRHour *model = [[BKDataHRHour alloc] init];
    i++;// date
    i++;// user_id
    i++;// device_id
    i++;// device_name
    model.seq = [set longForColumnIndex:i++];
    model.hour = [set longForColumnIndex:i++];
    
    NSString *detailString = [set stringForColumnIndex:i++];
    NSData *data = [detailString dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        model.hrDetail = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    }
    
    return model;
}

- (NSString *)valueString{
    NSMutableString *value = [NSMutableString string];
    [value appendIntegerValue:self.dateInteger comma:YES];
    [value appendVarcharValue:userId() comma:YES];
    [value appendVarcharValue:deviceId() comma:YES];
    [value appendVarcharValue:deviceName() comma:YES];
    
    [value appendIntegerValue:self.seq comma:YES];
    [value appendIntegerValue:self.hour comma:YES];
    
    [value appendVarcharValue:self.hrDetail.description comma:YES];
    
    [value appendVarcharValue:dateString(today()) comma:NO];
    return value;
}

- (BOOL)cacheable{
    return userId().length && deviceId().length && self.dateInteger;
}

@end


@implementation BKDataSleep (BKBaseTable)


+ (NSString *)tableName{
    return @"data_sleep";
}
+ (NSString *)tableColumns{
    static NSString *columnName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableString *column = [NSMutableString string];
        [column appendIntegerColumn:@"date" comma:YES];
        [column appendVarcharColumn:@"user_id" comma:YES];
        [column appendVarcharColumn:@"device_id" comma:YES];
        [column appendVarcharColumn:@"device_name" comma:YES];
        
        [column appendIntegerColumn:@"seq" comma:YES];
        [column appendIntegerColumn:@"sleep_type" comma:YES];
        [column appendIntegerColumn:@"mode" comma:YES];
        
        [column appendVarcharColumn:@"start" comma:YES];
        [column appendVarcharColumn:@"end" comma:YES];
        [column appendIntegerColumn:@"duration" comma:YES];
        
        [column appendIntegerColumn:@"sleep_enter" comma:YES];
        [column appendIntegerColumn:@"sleep_exit" comma:YES];
        [column appendIntegerColumn:@"sport_type" comma:YES];
        
        [column appendVarcharColumn:@"lastmodified" comma:NO];
        columnName = column;
    });
    return columnName;
}
+ (NSString *)tablePrimaryKey{
    return @"date, user_id, device_id, seq, sleep_type";
}

+ (instancetype)modelWithSet:(FMResultSet *)set{
    int i = 0;
    BKDataSleep *model = [[BKDataSleep alloc] init];
    i++;// date
    i++;// user_id
    i++;// device_id
    i++;// device_name
    
    model.seq = [set longForColumnIndex:i++];
    model.sleepType = [set longForColumnIndex:i++];
    model.mode = [set longForColumnIndex:i++];
    
    NSString *dateString = [set stringForColumnIndex:i++];
    model.start = [formatter() dateFromString:dateString];
    dateString = [set stringForColumnIndex:i++];
    model.end = [formatter() dateFromString:dateString];
    model.duration = [set longForColumnIndex:i++];
    
    model.sleepEnter = [set longForColumnIndex:i++];
    model.sleepExit = [set longForColumnIndex:i++];
    model.sportType = [set longForColumnIndex:i++];
    
    return model;
}

- (NSString *)valueString{
    NSMutableString *value = [NSMutableString string];
    [value appendIntegerValue:self.dateInteger comma:YES];
    [value appendVarcharValue:userId() comma:YES];
    [value appendVarcharValue:deviceId() comma:YES];
    [value appendVarcharValue:deviceName() comma:YES];
    
    [value appendIntegerValue:self.seq comma:YES];
    [value appendIntegerValue:self.sleepType comma:YES];
    [value appendIntegerValue:self.mode comma:YES];
    
    [value appendVarcharValue:dateString(self.start) comma:YES];
    [value appendVarcharValue:dateString(self.end) comma:YES];
    [value appendIntegerValue:self.duration comma:YES];
    
    [value appendIntegerValue:self.sleepEnter comma:YES];
    [value appendIntegerValue:self.sleepExit comma:YES];
    [value appendIntegerValue:self.sportType comma:YES];
    
    [value appendVarcharValue:dateString(today()) comma:NO];
    return value;
}

- (BOOL)cacheable{
    return userId().length && deviceId().length && self.dateInteger;
}

@end






@implementation BKDatabase

+ (void)loadDatabase{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [BKUser loadDatabase];
        [BKDevice loadDatabase];
        [BKDeviceSetting loadDatabase];
        [BKSportList loadDatabase];
        [BKDataIndex loadDatabase];
        [BKDataDay loadDatabase];
        [BKDataSport loadDatabase];
        [BKDataHR loadDatabase];
        [BKDataHRHour loadDatabase];
        [BKDataSleep loadDatabase];
    });
}

+ (void)loadUserDB{
    
}








@end
