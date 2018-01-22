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
#import "BKDefines.h"

@implementation BKUser

+ (void)load{
    [self createTableIfNotExists];
}

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


#pragma mark - db delegate


+ (NSString *)tableName{
    return @"users";
}
+ (NSString *)tableColumns{
    static NSString *columnName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableString *column = [NSMutableString string];
        [column appendVarcharColumn:@"user_id" comma:YES];
        [column appendVarcharColumn:@"email" comma:YES];
        [column appendVarcharColumn:@"name" comma:YES];
        [column appendIntegerColumn:@"phone" comma:YES];
        
        [column appendIntegerColumn:@"gender" comma:YES];
        [column appendIntegerColumn:@"birthday" comma:YES];
        [column appendDoubleColumn:@"height" comma:YES];
        [column appendDoubleColumn:@"weight" comma:YES];
        [column appendVarcharColumn:@"avatar" comma:YES];
        
        [column appendVarcharColumn:@"lastmodified" comma:NO];
        columnName = column;
    });
    return columnName;
}
+ (NSString *)tablePrimaryKey{
    return @"user_id";
}

+ (instancetype)modelWithSet:(FMResultSet *)set{
    int i = 0;
    BKUser *model = [[BKUser alloc] init];
    i++; // user id
    model.email = [set stringForColumnIndex:i++];
    model.name = [set stringForColumnIndex:i++];
    model.phone = [set longForColumnIndex:i++];
    
    model.gender = [set longForColumnIndex:i++];
    model.birthday = [NSDate dateWithDateInteger:[set longForColumnIndex:i++]];
    model.height = [set doubleForColumnIndex:i++];
    model.weight = [set doubleForColumnIndex:i++];
    model.avatar = [set stringForColumnIndex:i++];
    
    return model;
}

- (NSString *)valueString{
    NSMutableString *value = [NSMutableString string];
    [value appendVarcharValue:self.email comma:YES]; // userid = email
    [value appendVarcharValue:self.email comma:YES];
    [value appendVarcharValue:self.name comma:YES];
    [value appendIntegerValue:self.phone comma:YES];
    
    [value appendIntegerValue:self.gender comma:YES];
    [value appendIntegerValue:self.birthday.dateInteger comma:YES];
    [value appendDoubleValue:self.height comma:YES];
    [value appendDoubleValue:self.weight comma:YES];
    [value appendVarcharValue:self.avatar comma:YES];
    
    [value appendVarcharValue:dateString(today()) comma:NO];
    return value;
}

+ (BKUser *)loadUserWithEmail:(NSString *)email{
    __block BKUser *cachedUser = nil;
    databaseTransaction(^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        NSString *where = [NSString stringWithFormat:@"email = '%@'", email];
        [db ax_select:@"*" from:BKUser.tableName where:where result:^(NSMutableArray * _Nonnull result, FMResultSet * _Nonnull set) {
            while (set.next) {
                cachedUser = [BKUser modelWithSet:set];
            }
        }];
    });
    return cachedUser;;
}

- (BOOL)cacheable{
    return self.email.length;
}

- (NSString *)whereExists{
    return [NSString stringWithFormat:@"email = '%@'", self.email];
}


@end
