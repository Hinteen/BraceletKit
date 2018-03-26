//
//  BKSedentary.m
//  BraceletKit
//
//  Created by xaoxuu on 24/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKSedentary.h"
#import "_BKHeader.h"

@implementation BKSedentary

- (ZRSedentary *)transformToZRSedentary{
    ZRSedentary *model = [ZRSedentary defaultModel];
    model.switchStatus = self.switchStatus;
    model.sedentaryId = self.sedentaryId;
    model.weekRepeat = self.weekRepeat;
    model.startHour = self.startHour;
    model.endHour = self.endHour;
    model.sedentaryDuration = self.sedentaryDuration;
    model.sedentaryThreshold = self.sedentaryThreshold;
    model.noDisturbing = self.noDisturbing;
    return model;
}

@end
