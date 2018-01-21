//
//  BKUser.m
//  BraceletKit
//
//  Created by xaoxuu on 20/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKUser.h"
#import "BKDevice.h"
#import "BKServices.h"
#import "_BKDatabaseHelper.h"
#import <AXKit/AXKit.h>
#import "BKDatabase.h"
//NSString *TABLE_USER = @"users";
//static CGFloat db_version = 1.0;
//
//static inline NSDateFormatter *formatter(){
//    static NSDateFormatter *fm;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        fm = [[NSDateFormatter alloc] init];
//        fm.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
//    });
//    return fm;
//}
//
//static inline NSString *getColumnName(){
//    static NSString *columnName;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        NSMutableString *column = [NSMutableString string];
//        [column appendVarcharColumn:@"uid" comma:YES];
//        [column appendVarcharColumn:@"email" comma:YES];
//        [column appendVarcharColumn:@"name" comma:YES];
//        [column appendIntegerColumn:@"phone" comma:YES];
//
//        [column appendIntegerColumn:@"gender" comma:YES];
//        [column appendIntegerColumn:@"birthday" comma:YES];
//        [column appendDoubleColumn:@"height" comma:YES];
//        [column appendDoubleColumn:@"weight" comma:YES];
//        [column appendVarcharColumn:@"avatar" comma:YES];
//
//        [column appendVarcharColumn:@"lastmodified" comma:NO];
//        columnName = column;
//    });
//    return columnName;
//}
//
//static inline void initDatabase(){
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        databaseTransaction(^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
//            CGFloat lastDatabaseVersion = [NSUserDefaults ax_readDoubleForKey:@"db".extension(TABLE_USER)];
//            if (db_version > lastDatabaseVersion) {
//                [NSUserDefaults ax_setDouble:db_version forKey:@"db".extension(TABLE_USER)];
//                [db ax_dropTable:TABLE_USER];
//            }
//            [db ax_createTable:TABLE_USER column:getColumnName() primaryKey:@"uid"];
//        });
//    });
//}
//
//
//static inline BKUser *modelWithSet(FMResultSet *set){
//    int i = 0;
//    BKUser *model = [[BKUser alloc] init];
//    i++; // uid
//    model.email = [set stringForColumnIndex:i++];
//    model.name = [set stringForColumnIndex:i++];
//    model.phone = [set longForColumnIndex:i++];
//
//    model.gender = [set longForColumnIndex:i++];
//    model.birthday = [NSDate dateWithDateInteger:[set longForColumnIndex:i++]];
//    model.height = [set doubleForColumnIndex:i++];
//    model.weight = [set doubleForColumnIndex:i++];
//    model.avatar = [set stringForColumnIndex:i++];
//
//    return model;
//}
//
//static inline NSString *valueStringWithModel(BKUser *model){
//    NSMutableString *value = [NSMutableString string];
//    [value appendVarcharValue:model.uid comma:YES];
//    [value appendVarcharValue:model.email comma:YES];
//    [value appendVarcharValue:model.name comma:YES];
//    [value appendIntegerValue:model.phone comma:YES];
//
//    [value appendIntegerValue:model.gender comma:YES];
//    [value appendIntegerValue:model.birthday.dateInteger comma:YES];
//    [value appendDoubleValue:model.height comma:YES];
//    [value appendDoubleValue:model.weight comma:YES];
//    [value appendVarcharValue:model.avatar comma:YES];
//
//    [value appendVarcharValue:[formatter() stringFromDate:[NSDate date]] comma:NO];
//    return value;
//}

@implementation BKUser

+ (instancetype)currentUser{
    return [BKServices sharedInstance].user;
}

+ (instancetype)defaultUser{
    return [[self alloc] init];
}


- (instancetype)init{
    if (self = [super init]) {
        _name = @"";
        _avatar = @"";
        _birthday = [NSDate dateWithTimeIntervalSince1970:0];
        _height = 170;
        _weight = 60;
    }
    return self;
}


//+ (void)loginWithUser:(BKUser *)user{
//    BKUser *currentUser = [BKUser currentUser];
//    currentUser.email = user.email;
//    currentUser.name = user.name;
//    currentUser.phone = user.phone;
//    currentUser.gender = user.gender;
//    currentUser.birthday = user.birthday;
//    currentUser.height = user.height;
//    currentUser.weight = user.weight;
//    currentUser.avatar = user.avatar;
//}

+ (instancetype)loginWithEmail:(NSString *)email password:(NSString *)password{
    NSString *savedPsw = [NSUserDefaults ax_readStringForKey:@"login".extension(email)];
    if ([password isEqualToString:savedPsw]) {
        BKUser *cachedUser = [self loadUserWithEmail:email];
        return cachedUser;
    } else {
        return nil;
    }
}

+ (instancetype)registerWithEmail:(NSString *)email password:(NSString *)password{
    BOOL success = NO;
    BKUser *cachedUser = [self loadUserWithEmail:email];
    if (!cachedUser) {
        BKUser *user = [BKUser defaultUser];
        user.email = email;
        success = [user saveToDatabase];
        [NSUserDefaults ax_setString:password forKey:@"login".extension(email)];
    }
    if (success) {
        return cachedUser;
    } else {
        return nil;
    }
}


@end
