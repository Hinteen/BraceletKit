//
//  BKRefreshView.h
//  BraceletKitDemo
//
//  Created by xaoxuu on 06/02/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BKRefreshView : UIImageView

+ (instancetype)sharedInstance;

- (void)updateState;

@end
