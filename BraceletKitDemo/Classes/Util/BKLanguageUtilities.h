//
//  BKLanguageUtilities.h
//  BraceletKitDemo
//
//  Created by xaoxuu on 02/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BraceletKit.h"

@interface BKLanguageUtilities : NSObject

+ (NSString *)languageDescription:(BKLanguage)language;

+ (BKLanguage)languageWithDescription:(NSString *)description;

@end
