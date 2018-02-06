//
//  BKRefreshView.h
//  BraceletKitDemo
//
//  Created by xaoxuu on 06/02/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BKRefreshView : UIImageView

/**
 enable
 */
@property (assign, getter=isEnable, nonatomic) BOOL enable;

+ (instancetype)sharedInstance;

- (void)updateState;

- (void)startAnimating;

- (void)stopAnimating;

@end
