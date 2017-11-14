//
//  FindPhoneManager.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 06/11/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import "FindPhoneManager.h"
#import <AVFoundation/AVFoundation.h>

@implementation FindPhoneManager

-(instancetype)init{
    self = [super init];
    if (self != nil) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        _soundID = kSystemSoundID_Vibrate;
//        NSString *strSoundFile = [BaseCommon getResourcePath:@"792.wav"];
//        if(strSoundFile){
//            AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:strSoundFile],&_soundID);
//        }
    }
    return self;
}

-(void)startPlay{
    AudioServicesPlayAlertSound(_soundID);
}
+ (void)alert{
    static int i;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        i = 1000;
    });
    AudioServicesPlayAlertSound(i++);
}
@end
