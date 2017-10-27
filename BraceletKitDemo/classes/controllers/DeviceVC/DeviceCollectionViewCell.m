//
//  DeviceCollectionViewCell.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 26/10/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import "DeviceCollectionViewCell.h"
#import <AXKit/AXKit.h>
#import "DeviceSettingTV.h"

@interface DeviceCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *deviceSettingView;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (strong, nonatomic) DeviceSettingTV *tv;
@end

@implementation DeviceCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.deviceSettingView.backgroundColor = [UIColor randomColor];
    CGRect frame = CGRectFromScreen();
    frame.size.height -= (kTopBarHeight + kTabBarHeight);
    DeviceSettingTV *tv = [[DeviceSettingTV alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    [self.deviceSettingView addSubview:tv];
    self.tv = tv;
}


- (IBAction)add:(UIButton *)sender {
    [self.controller.navigationController ax_pushViewControllerNamed:@"ScanViewController"];
}


- (void)setDevice:(ZeronerBlePeripheral *)device{
    _device = device;
    
    if (device) {
        self.deviceSettingView.hidden = NO;
    } else {
        self.deviceSettingView.hidden = YES;
    }
    [self.tv reloadDataSourceAndTableView];
}

@end
