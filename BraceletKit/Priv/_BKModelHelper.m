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

- (ZRPersonal *)transformToZRPersonal{
    ZRPersonal *model = [ZRPersonal defaultModel];
    model.height = (NSInteger)self.height;
    model.weight = (NSInteger)self.weight;
    if (self.gender == BKGenderFemale) {
        model.gender = 1;
    } else {
        model.gender = 0;
    }
    NSInteger year1 = [NSDate date].stringValue(@"yyyy").integerValue;
    NSInteger year2 = self.birthday.stringValue(@"yyyy").integerValue;
    model.age = year1 - year2;
    return model;
}

@end

@implementation ZRBlePeripheral (BKExtension)

- (BKDevice *)transformToBKDevice{
    BKDevice *bk = [BKDevice new];
    bk.mac = self.mediaAC;
    bk.name = self.deviceName;
    bk.uuid = self.uuidString;
    [BLEAutumn midAutumn:BLEProtocol_Any];

#warning    bk.type = (BKDeviceType)[ble].deviceType;
    bk.peripheral = self.cbDevice;
    bk.rssi = self.RSSI;
    bk.zrPeripheral = self;
    if ([bk.mac isEqualToString:@"advertisementData.length is less than 6"]) {
//        bk.mac = bk.restoreMac;
    }
    return bk;
}

@end

@implementation BKDevice (BKModelExtension)

- (ZRBlePeripheral *)transformToZRBlePeripheral{
    return nil;
}

@end

@implementation ZRHWOption (BKExtension)

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
//    model.findPhoneSwitch = self.findPhoneSwitch;
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

- (ZRHWOption *)transformToZRHWOption{
    ZRHWOption *model = [ZRHWOption defaultModel];
    model.ledSwitch = self.ledSwitch;
    model.leftHand = self.leftHand;
    model.wristSwitch = self.wristSwitch;
    model.autoSleep = self.autoSleep;
    model.advertisementSwitch = self.advertisementSwitch;
    model.backColor = self.backgroundColor;
    model.disConnectTip = self.disconnectTip;
    model.autoHeartRate = self.autoHeartRate;
    model.autoSport = self.autoSport;
//    model.findPhoneSwitch = self.findPhoneSwitch;
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

- (ZRCOption *)transformToZRCOption{
    ZRCOption *model = [ZRCOption defaultModel];
    model.findPhoneSwitch = self.findPhoneSwitch;
    
    return model;
}

@end

@implementation BKWeather (BKExtension)

- (ZRWeather *)transformToZeronerWeather{
    ZRWeather *model = [ZRWeather defaultModel];
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

@implementation BKDNDMode (BKModelExtension)

- (ZRDNDModel *)transformToZRDNDModel{
    ZRDNDModel *model = [ZRDNDModel defaultModel];
    model.dndType = self.type;
    model.startHour = self.startHour;
    model.startMinute = self.startMinute;
    model.endHour = self.endHour;
    model.endMinute = self.endMinute;
    return model;
}
@end
