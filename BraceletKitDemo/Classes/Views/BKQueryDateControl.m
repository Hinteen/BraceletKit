//
//  BKQueryDateControl.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 28/02/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKQueryDateControl.h"

static CGFloat buttonSize = 44;
static CGFloat buttonMargin = 8;

BKQueryViewUnit queryUnitWithIndex(int i){
    switch (i) {
        case 1:
            return BKQueryViewUnitWeekly;
        case 2:
            return BKQueryViewUnitMonthly;
        case 3:
            return BKQueryViewUnitYearly;
        default:
            return BKQueryViewUnitDaily;
    }
}

@interface BKQueryDateControl ()

@property (strong, nonatomic) NSArray<NSString *> *units;

@property (strong, nonatomic) UIButton *unit;

@property (strong, nonatomic) UIButton *previous;

@property (strong, nonatomic) UIButton *next;

@end

@implementation BKQueryDateControl

- (instancetype)initWithDelegate:(NSObject<BKQueryDateControlDelegate> *)delegate{
    if (self = [self init]) {
        self.delegate = delegate;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.tintColor = axThemeManager.color.theme;
        self.queryViewUnit = BKQueryViewUnitWeekly;
        
        self.previous = [self buttonWithImageName:@"icon_previous"];
        self.previous.left = 0;
        [self.previous ax_addTouchUpInsideHandler:^(__kindof UIButton * _Nonnull sender) {
            [self updateDateToNextQueryUnitWithStep:-1];
            [self refreshQueryDate];
        } animatedScale:1.1 duration:0.8];
        [self addSubview:self.previous];
        
        self.unit = [self defaultButtonWithType:UIButtonTypeSystem];
        [self.unit setTitle:self.units[1] forState:UIControlStateNormal];
        self.unit.centerX = 0.5 * self.width;
        [self.unit ax_addTouchUpInsideHandler:^(__kindof UIButton * _Nonnull sender) {
            [UIAlertController ax_showActionSheetWithTitle:@"选择视图" message:nil actions:^(UIAlertController * _Nonnull alert) {
                for (int i = 0; i < self.units.count; i++) {
                    [alert ax_addDefaultActionWithTitle:self.units[i] handler:^(UIAlertAction * _Nonnull sender) {
                        [self.unit setTitle:self.units[i] forState:UIControlStateNormal];
                        self.queryViewUnit = queryUnitWithIndex(i);
                        [self resetWithUnit];
                        [self refreshQueryDate];
                    }];
                }
                [alert ax_addCancelAction];
            }];
        } animatedScale:1.1 duration:0.8];
        [self addSubview:self.unit];
        
        
        self.next = [self buttonWithImageName:@"icon_next"];
        self.next.right = self.width;
        [self.next ax_addTouchUpInsideHandler:^(__kindof UIButton * _Nonnull sender) {
            [self updateDateToNextQueryUnitWithStep:1];
            [self refreshQueryDate];
        } animatedScale:1.1 duration:0.8];
        [self addSubview:self.next];
        
        [self resetWithUnit];
        
        
    }
    return self;
}

- (instancetype)init{
    if (self = [self initWithFrame:CGRectMake(0, 0, buttonSize * 3 + buttonMargin * 2, buttonSize)]) {
        
    }
    return self;
}

- (void)refreshQueryDate{
    if (self.delegate && [self.delegate respondsToSelector:@selector(queryDateDidChanged:start:end:)]) {
        [self.delegate queryDateDidChanged:self.queryViewUnit start:self.start end:self.end];
    }
}

- (NSArray<NSString *> *)units{
    if (!_units) {
        _units = @[@"天", @"周", @"月", @"年"];
    }
    return _units;
}

- (void)resetWithUnit{
    NSDate *today = [NSDate ax_dateWithIntegerValue:[NSDate date].integerValue];
    if (self.queryViewUnit == BKQueryViewUnitDaily) {
        self.start = today;
        self.end = self.start.addDays(1);
    } else if (self.queryViewUnit == BKQueryViewUnitWeekly) {
        self.start = today.addDays(-today.weekday+1);
        self.end = self.start.addWeeks(1);
    } else if (self.queryViewUnit == BKQueryViewUnitMonthly) {
        self.start = today.addDays(-today.day+1);
        self.end = self.start.addMonths(1);
    } else if (self.queryViewUnit == BKQueryViewUnitYearly) {
        self.start = today.addMonths(-today.month+1).addDays(-today.day+1);
        self.end = self.start.addYears(1);
    }
}

- (void)updateDateToNextQueryUnitWithStep:(NSInteger)step{
    if (self.queryViewUnit == BKQueryViewUnitWeekly) {
        self.start = self.start.addWeeks(step);
        self.end = self.end.addWeeks(step);
    } else if (self.queryViewUnit == BKQueryViewUnitMonthly) {
        self.start = self.start.addMonths(step);
        self.end = self.end.addMonths(step);
    } else if (self.queryViewUnit == BKQueryViewUnitYearly) {
        self.start = self.start.addYears(step);
        self.end = self.end.addYears(step);
    } else {
        self.start = self.start.addDays(step);
        self.end = self.end.addDays(step);
    }
}

- (UIButton *)defaultButtonWithType:(UIButtonType)type{
    UIButton *btn = [UIButton buttonWithType:type];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [btn.layer ax_cornerRadius:8 shadow:LayerShadowDownLight];
    btn.backgroundColor = [UIColor whiteColor];
    btn.size = CGSizeMake(buttonSize, buttonSize);
    return btn;
}

- (UIButton *)buttonWithImageName:(NSString *)name{
    UIButton *btn = [self defaultButtonWithType:UIButtonTypeCustom];
    [btn setImage:UIImageNamed(name) forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
    return btn;
}


@end
