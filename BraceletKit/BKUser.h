//
//  BKUser.h
//  BraceletKit
//
//  Created by xaoxuu on 20/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, BKGender) {
    BKGenderUnknown,
    BKGenderMale,
    BKGenderFemale,
};

@interface BKUser : NSObject


/**
 user id
 */
@property (copy, nonatomic) NSString *uid;
/**
 name
 */
@property (copy, nonatomic) NSString *name;
/**
 email
 */
@property (copy, nonatomic) NSString *email;
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


@end
