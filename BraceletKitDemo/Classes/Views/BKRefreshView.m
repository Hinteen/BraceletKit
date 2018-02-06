//
//  BKRefreshView.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 06/02/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKRefreshView.h"
#import "BKServices.h"
#import "BKDevice.h"

static BKRefreshView *instance;


@interface BKRefreshView()<BKDeviceDelegate>




@end

@implementation BKRefreshView
@synthesize enable = _enable;

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
    if (self = [super initWithImage:UIImageNamed(@"nav_refresh")]) {
        
    }
    [[BKServices sharedInstance] registerDeviceDelegate:self];
    return self;
}

- (void)dealloc{
    [[BKServices sharedInstance] unRegisterDeviceDelegate:self];
}

- (BOOL)isEnable{
    return _enable;
}

- (void)setEnable:(BOOL)enable{
    _enable = enable;
    if (enable) {
        self.alpha = 1;
        self.userInteractionEnabled = YES;
    } else {
        self.alpha = 0.5;
        self.userInteractionEnabled = NO;
    }
}

- (void)updateState{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([BKServices sharedInstance].connector.state != BKConnectStateConnected) {
            [self stopAnimating];
            self.enable = NO;
        } else {
            if ([BKDevice currentDevice].isSynchronizing) {
                [self startAnimating];
            } else {
                [self stopAnimating];
            }
        }
    });
}

- (void)startAnimating{
    self.enable = NO;
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotation.duration = 1;
    rotation.cumulative = YES;
    rotation.repeatCount = HUGE_VALF;
    [self.layer addAnimation:rotation forKey:@"rotation"];
}

- (void)stopAnimating{
    if ([BKDevice currentDevice] && ![BKDevice currentDevice].isSynchronizing) {
        self.enable = YES;
    }
    [self.layer removeAnimationForKey:@"rotation"];
}


- (void)deviceDidSynchronizing:(BOOL)synchronizing{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (synchronizing) {
            [self startAnimating];
        } else {
            [self stopAnimating];
        }
    });
}


@end
