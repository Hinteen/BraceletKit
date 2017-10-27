//
//  BaseSettingSwitch.m
//  AXKit
//
//  Created by xaoxuu on 07/05/2017.
//  Copyright © 2017 Titan Studio. All rights reserved.
//

#import "BaseSettingSwitch.h"
// =============== 第三方库
#import <YYKit/YYKit.h>
#import <AXKit/AXKit.h>

// =============== 内部
// @xaoxuu: 常量
#import "HTConst.h"
#import "HTMacros.h"
#import "HTStrings.h"
// @xaoxuu: 服务层
#import "ServicesLayer.h"



@implementation BaseSettingSwitch


- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupUI];
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    
    [self setOnTintColor:axColor.theme];
    [self setOffImage:[UIImage imageNamed:@"watch_close"]];
    [self setOnImage:[UIImage imageNamed:@"watch_open"]];
    
}



@end
