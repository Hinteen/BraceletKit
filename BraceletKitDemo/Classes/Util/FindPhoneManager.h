//
//  FindPhoneManager.h
//  BraceletKitDemo
//
//  Created by xaoxuu on 06/11/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface FindPhoneManager : NSObject
@property(nonatomic, assign)SystemSoundID soundID;//播放文件标识

-(void) startPlay;
+ (void)alert;
@end
