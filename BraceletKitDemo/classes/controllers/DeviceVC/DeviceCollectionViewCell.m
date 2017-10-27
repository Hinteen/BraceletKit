//
//  DeviceCollectionViewCell.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 26/10/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import "DeviceCollectionViewCell.h"
#import <AXKit/AXKit.h>


@interface DeviceCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation DeviceCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (IBAction)add:(UIButton *)sender {
    [self.controller.navigationController ax_pushViewControllerNamed:@"ScanViewController"];
}


- (void)setDevice:(ZeronerBlePeripheral *)device{
    _device = device;
    
    
    if (device) {
        self.addBtn.hidden = YES;
    } else {
        self.addBtn.hidden = NO;
    }
}

@end
