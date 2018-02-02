//
//  ScanTableViewCell.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 26/10/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import "ScanTableViewCell.h"
#import <AXKit/AXKit.h>
#import <BraceletKit/BraceletKit.h>

@interface ScanTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *lb_name;

@property (weak, nonatomic) IBOutlet UILabel *lb_uuid;
@property (weak, nonatomic) IBOutlet UILabel *lb_mac;
@property (weak, nonatomic) IBOutlet UILabel *lb_status;

@property (weak, nonatomic) IBOutlet UISwitch *switch_bind;



@end

@implementation ScanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.lb_name.font = [UIFont fontWithName:@"DIN Condensed" size:24];
    self.lb_name.font = [UIFont fontWithName:@"Calibri" size:24];
    [self.lb_name sizeToFit];
    self.lb_uuid.adjustsFontSizeToFitWidth = YES;
    self.lb_uuid.font = [UIFont fontWithName:@"Calibri" size:14];
    self.lb_mac.font = [UIFont fontWithName:@"Calibri" size:14];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BKDevice *)model{
    _model = model;
    if ([model.mac isEqualToString:@"advertisementData.length is less than 6"]) {
        if ([model.uuid isEqualToString:[BKDevice currentDevice].uuid]) {
            _model.mac = [BKDevice currentDevice].mac;
        }
    }
    self.lb_name.text = model.name;
    self.lb_uuid.text = model.uuid;
    self.lb_mac.text = model.mac;
    
    if ([_model.mac isEqualToString:[BKDevice currentDevice].mac]) {
        self.lb_status.text = @"已连接";
        self.switch_bind.on = YES;
        self.switch_bind.enabled = YES;
    } else {
        if (model.peripheral.state == CBPeripheralStateDisconnected) {
            self.lb_status.text = @"未连接";
            self.switch_bind.on = NO;
            self.switch_bind.enabled = YES;
        } else if (model.peripheral.state == CBPeripheralStateConnected) {
            self.lb_status.text = @"已连接";
            self.switch_bind.on = YES;
            self.switch_bind.enabled = YES;
        } else if (model.peripheral.state == CBPeripheralStateConnecting) {
            self.lb_status.text = @"正在连接";
            self.switch_bind.on = NO;
            self.switch_bind.enabled = NO;
        }
    }
    
    if (@available(iOS 9.0, *)) {
        // on newer versions
        if (model.peripheral.state == CBPeripheralStateDisconnecting) {
            self.lb_status.text = @"正在断开连接";
            self.switch_bind.on = YES;
            self.switch_bind.enabled = NO;
        }
    } else {
        // Fallback on earlier versions
        
    }
    
    
    
}

- (IBAction)connect:(UISwitch *)sender {
    sender.enabled = NO;
    if ([self.delegate respondsToSelector:@selector(cell:didTappedSwitch:)]) {
        [self.delegate cell:self didTappedSwitch:sender];
    }
}

@end
