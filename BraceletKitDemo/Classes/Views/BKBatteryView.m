//
//  BKBatteryView.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 03/02/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKBatteryView.h"

static BKBatteryView *instance;
static UIView *batteryLevelView;
static UIView *maskView;


@implementation BKBatteryView

+ (instancetype)sharedInstance{
    if (!instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[self alloc] init];
        });
    }
    return instance;
}


- (instancetype)init{
    if (self = [super initWithImage:UIImageNamed(@"nav_battery")]) {
        
    }
    self.alpha = 0.5;
    batteryLevelView = [[UIView alloc] initWithFrame:CGRectMake(3, 8, 17, 8)];
    [self addSubview:batteryLevelView];
    [batteryLevelView.layer ax_cornerRadius:1 shadow:LayerShadowNone];
    maskView = UIMaskViewWithSizeAndCornerRadius(batteryLevelView.frame.size, 1);
    batteryLevelView.maskView = maskView;
    [self updateBatteryPercent:1];
    return self;
}

/**
 更新电池百分比
 
 @param percent 百分比
 */
- (void)updateBatteryPercent:(CGFloat)percent{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.alpha = 1;
        maskView.width = percent * batteryLevelView.width;
        if (percent <= 0.3) {
            batteryLevelView.backgroundColor = [UIColor md_red];
            [batteryLevelView.layer ax_animatedColor:[UIColor whiteColor] duration:1 repeatCount:HUGE_VALF];
        } else {
            batteryLevelView.backgroundColor = [UIColor whiteColor];
        }
    });
}

@end
