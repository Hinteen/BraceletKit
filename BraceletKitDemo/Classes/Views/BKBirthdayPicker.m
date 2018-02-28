//
//  BKBirthdayPicker.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 28/02/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKBirthdayPicker.h"

@implementation BKBirthdayPicker


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.datePickerMode = UIDatePickerModeDate;
        self.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];
        self.maximumDate = [NSDate date];
        self.date = [BKUser currentUser].birthday;
    }
    return self;
}

@end
