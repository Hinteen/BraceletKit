//
//  BKAlarmClock.m
//  BraceletKit
//
//  Created by xaoxuu on 24/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKAlarmClock.h"
#import "_BKHeader.h"
@implementation BKAlarmClock

- (ZRClock *)transformToZRClock{
    ZRClock *model = [ZRClock defaultModel];
    model.clockId = self.clockId;
    model.weekRepeat = self.weekRepeat;
    model.clockHour = self.hour;
    model.clockMinute = self.minute;
    model.clockRingSetting = self.ringId;
    model.clockTips = self.clockTips;
    model.clockTipsLenth = self.clockTipsLenth;
    return model;
}
@end
