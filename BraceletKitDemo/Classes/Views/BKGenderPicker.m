//
//  BKGenderPicker.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 28/02/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKGenderPicker.h"

@interface BKGenderPicker () <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation BKGenderPicker



- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.dataSource = self;
        self.delegate = self;
        [self selectRow:[BKUser currentUser].gender inComponent:0 animated:YES];
    }
    return self;
}

- (void)dealloc{
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    BKGender gender = row;
    switch (gender) {
        case BKGenderUnknown:
            return @"未知";
        case BKGenderMale:
            return @"男";
        case BKGenderFemale:
            return @"女";
    }
}

@end
