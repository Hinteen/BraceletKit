//
//  BKUser.h
//  BraceletKit
//
//  Created by xaoxuu on 20/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKData.h"

typedef NS_ENUM(NSUInteger, BKGender) {
    BKGenderUnknown,
    BKGenderMale,
    BKGenderFemale,
};

@interface BKUser : BKData <BKData>


/**
 name
 */
@property (copy, nonatomic) NSString *name;
/**
 email (作为user id)
 */
@property (copy, nonatomic) NSString *email;
/**
 phone
 */
@property (copy, nonatomic) NSString *phone;
/**
 gender
 */
@property (assign, nonatomic) BKGender gender;
/**
 birthday
 */
@property (strong, nonatomic) NSDate *birthday;
/**
 height (cm)
 */
@property (assign, nonatomic) CGFloat height;
/**
 weight (kg)
 */
@property (assign, nonatomic) CGFloat weight;
/**
 avatar url
 */
@property (copy, nonatomic) NSString *avatar;


+ (instancetype)currentUser;

+ (instancetype)defaultUser;

+ (instancetype)registerWithEmail:(NSString *)email password:(NSString *)password;

+ (instancetype)loginWithEmail:(NSString *)email password:(NSString *)password;

- (void)transaction:(void (^)(BKUser *user))transaction;

@end
