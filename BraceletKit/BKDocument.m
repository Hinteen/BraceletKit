//
//  BKDocument.m
//  BraceletKit
//
//  Created by xaoxuu on 07/02/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKDocument.h"
#import <AXKit/AXKit.h>

static NSString *dbkey = @"com.xaoxuu.braceletkit.db";


@interface BKDocument()

@end

@implementation BKDocument


- (id)contentsForType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError{
    NSData *data = [NSData dataWithContentsOfFile:dbkey.docPath];
    return data;
}

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError{
    NSData *data = contents;
    BOOL ret = [data writeToFile:dbkey.docPath atomically:YES];
    [[NSFileManager defaultManager] setAttributes:[NSDictionary dictionaryWithObject:NSFileProtectionNone forKey:NSFileProtectionKey] ofItemAtPath:dbkey.docPath error:NULL];
    return ret;
}

@end
