//
//  AXTableViewCell.h
//  AXTableKit
//
//  Created by xaoxuu on 27/10/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXTableKitProtocol.h"


@interface AXTableViewCell : UITableViewCell <AXTableViewCell>

// @xaoxuu: model
@property (strong, readwrite, nonatomic) NSObject<AXTableRowModel> *model;

// @xaoxuu: image
@property (strong, readonly, nonatomic) UIImageView *icon;

@end
