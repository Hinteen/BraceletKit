//
//  ScanTableViewCell.h
//  BraceletKitDemo
//
//  Created by xaoxuu on 26/10/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BraceletKit/BraceletKit.h>


@interface ScanTableViewCell : UITableViewCell

// @xaoxuu: model
@property (strong, nonatomic) BKDevice *model;

@end
