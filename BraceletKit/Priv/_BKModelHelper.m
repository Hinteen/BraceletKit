//
//  _BKModelHelper.m
//  BraceletKit
//
//  Created by xaoxuu on 20/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "_BKModelHelper.h"


@implementation _BKModelHelper

@end

@implementation BKUser (BKExtension)

- (ZeronerPersonal *)transformToZeronerPersonal{
    ZeronerPersonal *model = [ZeronerPersonal defaultPersonalModel];
    if (self.gender == BKGenderFemale) {
        model.gender = 1;
    } else {
        model.gender = 0;
    }
    model.height = (NSInteger)self.height;
    model.weight = (NSInteger)self.weight;
    NSInteger year1 = [NSDate date].stringValue(@"yyyy").integerValue;
    NSInteger year2 = self.birthday.stringValue(@"yyyy").integerValue;
    model.age = year1 - year2;
    return model;
}

@end

@implementation ZeronerBlePeripheral (BKExtension)

- (BKDevice *)transformToBKDevice{
    BKDevice *bk = [BKDevice new];
    bk.mac = self.mediaAC;
    bk.name = self.deviceName;
    bk.uuid = self.uuidString;
    bk.type = (BKDeviceType)[BLELib3 shareInstance].deviceType;
    bk.peripheral = self.cbDevice;
    bk.rssi = self.RSSI;
    bk.zeronerBlePeripheral = self;
    if ([bk.mac isEqualToString:@"advertisementData.length is less than 6"]) {
        bk.mac = bk.restoreMac;
    }
    return bk;
}

@end


@implementation ZeronerHWOption (BKExtension)

- (BKPreferences *)transformToBKPreferences{
    BKPreferences *model = [[BKPreferences alloc] init];
    model.ledSwitch = self.ledSwitch;
    model.leftHand = self.leftHand;
    model.wristSwitch = self.wristSwitch;
    model.autoSleep = self.autoSleep;
    model.advertisementSwitch = self.advertisementSwitch;
    model.backgroundColor = self.backColor;
    model.disconnectTip = self.disConnectTip;
    model.autoHeartRate = self.autoHeartRate;
    model.autoSport = self.autoSport;
    model.findPhoneSwitch = self.findPhoneSwitch;
    model.distanceUnit = (NSUInteger)self.unitType;
    model.hourFormat = (NSUInteger)self.timeFlag;
    model.language = (NSUInteger)self.language;
    model.backlightStart = self.backlightStart;
    model.backlightEnd = self.backlightEnd;
    model.dateFormat = self.dateFormatter;
    model.wristBlightStart = self.wristBlightStart;
    model.wristBlightEnd = self.wristBlightEnd;
    return model;
}

@end


@implementation BKPreferences (BKExtension)

- (ZeronerHWOption *)transformToZeronerHWOption{
    ZeronerHWOption *model = [ZeronerHWOption defaultHWOption];
    model.ledSwitch = self.ledSwitch;
    model.leftHand = self.leftHand;
    model.wristSwitch = self.wristSwitch;
    model.autoSleep = self.autoSleep;
    model.advertisementSwitch = self.advertisementSwitch;
    model.backColor = self.backgroundColor;
    model.disConnectTip = self.disconnectTip;
    model.autoHeartRate = self.autoHeartRate;
    model.autoSport = self.autoSport;
    model.findPhoneSwitch = self.findPhoneSwitch;
    model.unitType = (int)self.distanceUnit;
    model.timeFlag = (int)self.hourFormat;
    model.language = (int)self.language;
    model.backlightStart = self.backlightStart;
    model.backlightEnd = self.backlightEnd;
    model.dateFormatter = self.dateFormat;
    model.wristBlightStart = self.wristBlightStart;
    model.wristBlightEnd = self.wristBlightEnd;
    return model;
}

@end

@implementation BKWeather (BKExtension)

- (ZeronerWeather *)transformToZeronerWeather{
    ZeronerWeather *model = [[ZeronerWeather alloc] init];
    model.temp = self.temperature;
    if (self.unit == BKTemperatureUnitKelvin) {
        // 手表暂不支持开尔文温度
        model.unit = Centigrade;
    } else {
        model.unit = (TempUnit)self.unit;
    }
    model.type = self.condition;
    model.pm = self.pm2_5;
    return model;
}

@end
