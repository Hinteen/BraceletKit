//
//  BKLogHelper.m
//  BraceletKit
//
//  Created by xaoxuu on 20/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "_BKLogHelper.h"
#import <BLEMidAutumn/BLEMidAutumn.h>

/*
@implementation ZeronerBlePeripheral (BKLogExtension)

- (NSString *)description{
    NSMutableString *str = [NSMutableString string];
    [str appendFormat:@"%@:{\n",self.class];
    [str appendFormat:@"deviceName: '%@'\n", self.deviceName];
    [str appendFormat:@"uuidString: '%@'\n", self.uuidString];
    [str appendFormat:@"mediaAC: '%@'\n", self.mediaAC];
    [str appendFormat:@"cbDevice: '%@'\n", self.cbDevice];
    [str appendFormat:@"}"];
    return str;
}

@end

@implementation ZeronerDeviceInfo (BKLogExtension)

- (NSString *)description{
    NSMutableString *str = [NSMutableString string];
    [str appendFormat:@"%@:{\n",self.class];
    [str appendFormat:@"protocolVer: '%@'\n", self.protocolVer];
    [str appendFormat:@"model: '%@'\n", self.model];
    [str appendFormat:@"version: '%@'\n", self.version];
    [str appendFormat:@"versionValue: %ld\n", (long)self.versionValue];
    [str appendFormat:@"oadMode: %ld\n", (long)self.oadMode];
    [str appendFormat:@"batLevel: %ld\n", (long)self.batLevel];
    [str appendFormat:@"seriesNo: '%@'\n", self.seriesNo];
    [str appendFormat:@"bleAddr: '%@'\n", self.bleAddr];
    [str appendFormat:@"hwVersion: %ld\n", (long)self.hwVersion];
    [str appendFormat:@"hrVersion: '%@'\n", self.hrVersion];
    [str appendFormat:@"hrVersionValue: %ld\n", (long)self.hrVersionValue];
    [str appendFormat:@"fontSupport: '%@'\n", self.fontSupport];
    [str appendFormat:@"protocalMap: %ld\n", (long)self.protocalMap];
    [str appendFormat:@"isDialogDFU: %d\n", self.isDialogDFU];
    [str appendFormat:@"}"];
    return str;
}

@end

@implementation ZeronerClock (BKLogExtension)

- (NSString *)description{
    NSMutableString *str = [NSMutableString string];
    [str appendFormat:@"%@:{\n",self.class];
    [str appendFormat:@"switchStatus: %d\n", self.switchStatus];
    [str appendFormat:@"viable: %d\n", self.viable];
    [str appendFormat:@"clockId: %ld\n", (long)self.clockId];
    [str appendFormat:@"clockType: %ld\n", (long)self.clockType];
    [str appendFormat:@"weekRepeat: %ld\n", (long)self.weekRepeat];
    [str appendFormat:@"clockHour: %ld\n", (long)self.clockHour];
    [str appendFormat:@"clockMinute: %ld\n", (long)self.clockMinute];
    [str appendFormat:@"clockTipsLenth: %ld\n", (long)self.clockTipsLenth];
    [str appendFormat:@"clockTips: '%@'\n", self.clockTips];
    [str appendFormat:@"}"];
    return str;
}

@end

@implementation ZeronerSedentary (BKLogExtension)

- (NSString *)description{
    NSMutableString *str = [NSMutableString string];
    [str appendFormat:@"%@:{\n",self.class];
    [str appendFormat:@"switchStatus: %d\n", self.switchStatus];
    [str appendFormat:@"sedentaryId: %ld\n", (long)self.sedentaryId];
    [str appendFormat:@"weekRepeat: %ld\n", (long)self.weekRepeat];
    [str appendFormat:@"startHour: %ld\n", (long)self.startHour];
    [str appendFormat:@"endHour: %ld\n", (long)self.endHour];
    [str appendFormat:@"sedentaryDuration: %ld\n", (long)self.sedentaryDuration];
    [str appendFormat:@"sedentaryThreshold: %ld\n", (long)self.sedentaryThreshold];
    [str appendFormat:@"noDisturbing: %d\n", self.noDisturbing];
    [str appendFormat:@"}"];
    return str;
}

@end

@implementation ZeronerHWOption (BKLogExtension)

- (NSString *)description{
    NSMutableString *str = [NSMutableString string];
    [str appendFormat:@"%@:{\n",self.class];
    [str appendFormat:@"ledSwitch: %d\n", self.ledSwitch];
    [str appendFormat:@"leftHand: %d\n", self.leftHand];
    [str appendFormat:@"wristSwitch: %d\n", self.wristSwitch];
    [str appendFormat:@"autoSleep: %d\n", self.autoSleep];
    [str appendFormat:@"advertisementSwitch: %d\n", self.advertisementSwitch];
    [str appendFormat:@"backColor: %d\n", self.backColor];
    [str appendFormat:@"disConnectTip: %d\n", self.disConnectTip];
    [str appendFormat:@"autoHeartRate: %d\n", self.autoHeartRate];
    [str appendFormat:@"autoSport: %d\n", self.autoSport];
    [str appendFormat:@"findPhoneSwitch: %d\n", self.findPhoneSwitch];
    [str appendFormat:@"unitType: %d\n", self.unitType];
    [str appendFormat:@"timeFlag: %d\n", self.timeFlag];
    [str appendFormat:@"language: %d\n", self.language];
    [str appendFormat:@"backlightStart: %ld\n", (long)self.backlightStart];
    [str appendFormat:@"backlightEnd: %ld\n", (long)self.backlightEnd];
    [str appendFormat:@"dateFormatter: %ld\n", (long)self.dateFormatter];
    [str appendFormat:@"wristBlightStart: %ld\n", (long)self.wristBlightStart];
    [str appendFormat:@"wristBlightEnd: %ld\n", (long)self.wristBlightEnd];
    [str appendFormat:@"}"];
    return str;
}

@end

@implementation ZeronerSportTarget (BKLogExtension)

- (NSString *)description{
    NSMutableString *str = [NSMutableString string];
    [str appendFormat:@"%@:{\n",self.class];
    [str appendFormat:@"day: %ld\n", (long)self.day];
    [str appendFormat:@"sportArr: '%@'\n", self.sportArr.description];
    [str appendFormat:@"}"];
    return str;
}

@end

@implementation ZeronerDNDModel (BKLogExtension)

- (NSString *)description{
    NSMutableString *str = [NSMutableString string];
    [str appendFormat:@"%@:{\n",self.class];
    [str appendFormat:@"dndType: %ld\n", (long)self.dndType];
    [str appendFormat:@"startHour: %ld\n", (long)self.startHour];
    [str appendFormat:@"startMinute: %ld\n", (long)self.startMinute];
    [str appendFormat:@"endHour: %ld\n", (long)self.endHour];
    [str appendFormat:@"endMinute: %ld\n", (long)self.endMinute];
    [str appendFormat:@"}"];
    return str;
}

@end

@implementation ZeronerPersonal (BKLogExtension)

- (NSString *)description{
    NSMutableString *str = [NSMutableString string];
    [str appendFormat:@"%@:{\n",self.class];
    [str appendFormat:@"height: %ld\n", (long)self.height];
    [str appendFormat:@"weight: %ld\n", (long)self.weight];
    [str appendFormat:@"gender: %ld\n", (long)self.gender];
    [str appendFormat:@"age: %ld\n", (long)self.age];
    [str appendFormat:@"target: %ld\n", (long)self.target];
    [str appendFormat:@"}"];
    return str;
}

@end

@implementation ZeronerCOption (BKLogExtension)

- (NSString *)description{
    NSMutableString *str = [NSMutableString string];
    [str appendFormat:@"%@:{\n",self.class];
    [str appendFormat:@"findPhoneSwitch: %ld\n", (long)self.findPhoneSwitch];
    [str appendFormat:@"wristDelicacy: %ld\n", (long)self.wristDelicacy];
    [str appendFormat:@"}"];
    return str;
}

@end

@implementation ZeronerGPSPoint (BKLogExtension)

- (NSString *)description{
    NSMutableString *str = [NSMutableString string];
    [str appendFormat:@"%@:{\n",self.class];
    [str appendFormat:@"timeZone: %ld\n", (long)self.timeZone];
    [str appendFormat:@"latitude: %lf\n", self.latitude];
    [str appendFormat:@"longitude: %lf\n", self.longitude];
    [str appendFormat:@"altitude: %ld\n", (long)self.altitude];
    [str appendFormat:@"}"];
    return str;
}

@end
@implementation ZeronerRoll (BKLogExtension)

- (NSString *)description{
    NSMutableString *str = [NSMutableString string];
    [str appendFormat:@"%@:{\n",self.class];
    [str appendFormat:@"rId: %ld\n", (long)self.rId];
    [str appendFormat:@"rollName: '%@'\n", self.rollName];
    [str appendFormat:@"}"];
    return str;
}

@end


@implementation BKLogHelper
//typedef enum{
//    KSyscDataStateBegin = 0, //同步开始
//    KSyscDataState29End,     //29结束
//    KSyscDataStateSleepEnd , //28结束
//    KSyscDataStateHeartRateEnd , //51结束
//    KSyscDataStateInFinished , //全部结束
//    KSyscDataState61End,     //61结束
//    KSyscDataState62End,     //62结束
//    KSyscDataState64End,     //64结束
//    KSyscDataStateStartSyscF1Data,     //64结束
//}KSyscDataState;

+ (NSString *)descriptionForSyncState:(int)state{
    NSMutableString *str = [NSMutableString string];
    [str appendFormat:@"KSyscDataState:{\n"];
    switch (state) {
        case KSyscDataStateBegin:
            [str appendFormat:@"KSyscDataStateBegin\n"];
            break;
        case KSyscDataState29End:
            [str appendFormat:@"KSyscDataState29End\n"];
            break;
        case KSyscDataStateSleepEnd:
            [str appendFormat:@"KSyscDataStateSleepEnd\n"];
            break;
        case KSyscDataStateHeartRateEnd:
            [str appendFormat:@"KSyscDataStateHeartRateEnd\n"];
            break;
        case KSyscDataStateInFinished:
            [str appendFormat:@"KSyscDataStateInFinished\n"];
            break;
        case KSyscDataState61End:
            [str appendFormat:@"KSyscDataState61End\n"];
            break;
        case KSyscDataState62End:
            [str appendFormat:@"KSyscDataState62End\n"];
            break;
        case KSyscDataState64End:
            [str appendFormat:@"KSyscDataState64End\n"];
            break;
        case KSyscDataStateStartSyscF1Data:
            [str appendFormat:@"KSyscDataStateStartSyscF1Data\n"];
            break;
        default:
            [str appendFormat:@"unknown\n"];
            break;
    }
    [str appendFormat:@"}"];
    return str;
}
*/
//@end

