//
//  AXTableModel.m
//  AXTableKit
//
//  Created by xaoxuu on 27/10/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import "AXTableModel.h"

@implementation NSDictionary (AXTableModelExtension)

- (NSDictionary *)dictionaryValueForKey:(NSString *)key{
    NSObject *obj = self[key];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)obj;
    } else {
        return [NSDictionary dictionary];
    }
}

- (NSArray *)arrayValueForKey:(NSString *)key{
    NSObject *obj = self[key];
    if ([obj isKindOfClass:[NSArray class]]) {
        return (NSArray *)obj;
    } else {
        return [NSArray array];
    }
}

- (NSString *)stringValueForKey:(NSString *)key{
    NSObject *obj = self[key];
    if ([obj isKindOfClass:[NSString class]]) {
        return (NSString *)obj;
    } else {
        return @"";
    }
}

- (double)doubleValueForKey:(NSString *)key{
    NSObject *obj = self[key];
    if ([obj isKindOfClass:[NSString class]]) {
        NSString *strValue = (NSString *)obj;
        return strValue.doubleValue;
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        NSNumber *numValue = (NSNumber *)obj;
        return numValue.doubleValue;
    } else {
        return 0;
    }
}

- (NSInteger)integerValueForKey:(NSString *)key{
    NSObject *obj = self[key];
    if ([obj isKindOfClass:[NSString class]]) {
        NSString *strValue = (NSString *)obj;
        return strValue.integerValue;
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        NSNumber *numValue = (NSNumber *)obj;
        return numValue.integerValue;
    } else {
        return 0;
    }
}

- (BOOL)boolValueForKey:(NSString *)key{
    NSObject *obj = self[key];
    if ([obj isKindOfClass:[NSString class]]) {
        NSString *strValue = (NSString *)obj;
        return strValue.boolValue;
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        NSNumber *numValue = (NSNumber *)obj;
        return numValue.boolValue;
    } else {
        return 0;
    }
}

@end

@implementation AXTableModel

- (instancetype)init{
    if (self = [super init]) {
        _title = @"";
        _headerTitle = @"";
        _headerHeight = 0;
        _footerTitle = @"";
        _footerHeight = 20;
        _sections = [NSMutableArray array];
    }
    return self;
}

- (void)addSection:(void (^)(AXTableSectionModel *))section{
    AXTableSectionModel *model = [[AXTableSectionModel alloc] init];
    if (section) {
        section(model);
    }
    [self.sections addObject:model];
}


+ (instancetype)modelWithDictionary:(NSDictionary *)dict{
    AXTableModel *model = [[AXTableModel alloc] init];
    if (dict) {
        model.title = [dict stringValueForKey:@"title"];
        model.headerTitle = [dict stringValueForKey:@"headerTitle"];
        model.headerHeight = [dict doubleValueForKey:@"headerHeight"];
        model.footerTitle = [dict stringValueForKey:@"footerTitle"];
        model.footerHeight = [dict doubleValueForKey:@"footerHeight"];
        NSArray<NSDictionary *> *sections = [dict arrayValueForKey:@"sections"];
        [sections enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [model.sections addObject:[AXTableSectionModel modelWithDictionary:obj]];
        }];
    }
    return model;
}

@end

@implementation AXTableSectionModel

- (instancetype)init{
    if (self = [super init]) {
        _headerTitle = @"";
        _headerHeight = 44;
        _footerTitle = @"";
        _footerHeight = 0;
        _rowHeight = 44;
        _rows = [NSMutableArray array];
    }
    return self;
}


- (void)addRow:(void (^)(AXTableRowModel *))row{
    AXTableRowModel *model = [[AXTableRowModel alloc] init];
    if (row) {
        row(model);
    }
    [self.rows addObject:model];
}


+ (instancetype)modelWithDictionary:(NSDictionary *)dict{
    AXTableSectionModel *model = [[AXTableSectionModel alloc] init];
    if (dict) {
        model.headerTitle = [dict stringValueForKey:@"headerTitle"];
        model.headerHeight = [dict doubleValueForKey:@"headerHeight"];
        model.footerTitle = [dict stringValueForKey:@"footerTitle"];
        model.footerHeight = [dict doubleValueForKey:@"footerHeight"];
        model.rowHeight = [dict doubleValueForKey:@"rowHeight"];
        NSArray<NSDictionary *> *rows = [dict arrayValueForKey:@"rows"];
        [rows enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [model.rows addObject:[AXTableRowModel modelWithDictionary:obj]];
        }];
    }
    return model;
}

@end

@implementation AXTableRowModel

- (instancetype)init{
    if (self = [super init]) {
        _title = @"";
        _detail = @"";
        _icon = @"";
        _target = @"";
        _rowHeight = 44;
        _accessoryType = UITableViewCellAccessoryNone;
    }
    return self;
}


+ (instancetype)modelWithDictionary:(NSDictionary *)dict{
    AXTableRowModel *model = [[AXTableRowModel alloc] init];
    if (dict) {
        model.title = [dict stringValueForKey:@"title"];
        model.detail = [dict stringValueForKey:@"detail"];
        model.icon = [dict stringValueForKey:@"icon"];
        model.target = [dict stringValueForKey:@"target"];
        CGFloat rowHeight = [dict doubleValueForKey:@"rowHeight"];
        if (rowHeight) {
            model.rowHeight = rowHeight;
        }
        if (model.target.length) {
            model.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            model.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return model;
}

@end
