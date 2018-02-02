//
//  BKBatteryView.h
//  BraceletKitDemo
//
//  Created by xaoxuu on 03/02/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BKBatteryView : UIImageView

+ (instancetype)sharedInstance;

/**
 更新电池百分比

 @param percent 百分比
 */
- (void)updateBatteryPercent:(CGFloat)percent;

@end
