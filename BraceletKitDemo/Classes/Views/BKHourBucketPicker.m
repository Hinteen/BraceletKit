//
//  BKHourBucketPicker.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 02/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKHourBucketPicker.h"


@interface BKHourBucketPicker () <UIPickerViewDataSource, UIPickerViewDelegate>


@property (strong, nonatomic) NSMutableArray<NSNumber *> *values;


@end


@implementation BKHourBucketPicker

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.dataSource = self;
        self.delegate = self;
        [self selectRow:[BKDevice currentDevice].preferences.wristBlightStart inComponent:0 animated:YES];
        [self selectRow:[BKDevice currentDevice].preferences.wristBlightEnd inComponent:1 animated:YES];
    }
    return self;
}

- (void)dealloc{
    
}

- (NSMutableArray<NSNumber *> *)values{
    if (!_values) {
        _values = [NSMutableArray arrayWithCapacity:24];
        for (int i = 0; i < 24; i++) {
            [_values addObject:@(i)];
        }
    }
    return _values;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.values.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%d:00", self.values[row].intValue];
}


@end
