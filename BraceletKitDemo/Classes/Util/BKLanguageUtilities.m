//
//  BKLanguageUtilities.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 02/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKLanguageUtilities.h"

static NSDictionary *languageDescriptions(){
    static NSDictionary *dict;
    if (!dict) {
        dict = @{NSStringFromNSInteger(BKLanguageDefault):@"英语",
                 NSStringFromNSInteger(BKLanguageSimpleChinese):@"简体中文",
                 NSStringFromNSInteger(BKLanguageItalian):@"意大利语",
                 NSStringFromNSInteger(BKLanguageJapanese):@"日语",
                 NSStringFromNSInteger(BKLanguageFrench):@"法语",
                 NSStringFromNSInteger(BKLanguageGerman):@"德语",
                 NSStringFromNSInteger(BKLanguagePortugal):@"葡萄牙语",
                 NSStringFromNSInteger(BKLanguageSpanish):@"西班牙语",
                 NSStringFromNSInteger(BKLanguageRussian):@"俄罗斯语",
                 NSStringFromNSInteger(BKLanguageKorean):@"韩语",
                 NSStringFromNSInteger(BKLanguageArabic):@"阿拉伯语",
                 NSStringFromNSInteger(BKLanguageVietnamese):@"越南语",
                 NSStringFromNSInteger(BKLanguageSimpleMarkings):@"仅显示图标",
                 };
    }
    return dict;
}

@implementation BKLanguageUtilities

+ (NSString *)languageDescription:(BKLanguage)language{
    return [languageDescriptions() objectForKey:NSStringFromNSInteger(language)];
}

+ (BKLanguage)languageWithDescription:(NSString *)description{
    NSArray *allKeys = languageDescriptions().allKeys;
    for (NSString *tmp in allKeys) {
        if ([languageDescriptions()[tmp] isEqualToString:description]) {
            return (BKLanguage)tmp.integerValue;
        }
    }
    return BKLanguageDefault;
}

@end
