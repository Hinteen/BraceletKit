//
//  BKWeightPicker.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 28/02/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKWeightPicker.h"

@interface BKWeightPicker () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) NSMutableArray<NSNumber *> *values;

@end
@implementation BKWeightPicker



- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.dataSource = self;
        self.delegate = self;
        self.values = [NSMutableArray arrayWithCapacity:200];
        for (int i = 0; i <= 200; i++) {
            [self.values addObject:@(i+50)];
        }
        self.value = @([BKUser currentUser].weight);
    }
    return self;
}


- (NSNumber *)value{
    NSInteger row = [self selectedRowInComponent:0];
    return @(self.values[row].floatValue / 2);
}

- (void)setValue:(NSNumber *)value{
    NSInteger row = [self.values indexOfObject:@(value.floatValue * 2)];
    if (row >= self.values.count) {
        row = 0;
    }
    [self selectRow:row inComponent:0 animated:YES];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.values.count;
    } else {
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return [NSString stringWithFormat:@"%.1f %@", self.values[row].floatValue / 2, @"kg"];
    } else {
        return nil;
    }
}


@end

