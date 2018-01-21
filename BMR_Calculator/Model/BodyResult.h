//
//  BodyResult.h
//  BMIBMRCalculator
//
//  Created by 趙子超 on 19/01/2018.
//  Copyright © 2018 chao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, GENDER) {
    GENDER_MALE = 0,
    GENDER_FEMALE
};

//typedef NS_ENUM(NSUInteger, BODY_STATUS) {
//    BODY_STATUS_VERY_SEVERELY_UNDERWEIGHT = 0,
//    BODY_STATUS_SEVERELY_UNDERWEIGHT ,
//    BODY_STATUS_UNDERWEIGHT,
//    BODY_STATUS_NORMAL_WEIGHT,
//    BODY_STATUS_OVER_WEIGHT,
//    BODY_STATUS_OBESE_CLASS_I,
//    BODY_STATUS_OBESE_CLASS_II,
//    BODY_STATUS_OBESE_CLASS_III
//};

@interface BodyResult : NSObject

@property (nonatomic, assign) float bmrValue;
@property (nonatomic, assign) float bmiValue;
@property (nonatomic, assign) float suggestUpperWeight;
@property (nonatomic, assign) float suggestLowerWeight;
@property (nonatomic, copy) NSString *bodyStatus;

- (instancetype)initWithGender:(GENDER)gender age:(NSUInteger)age heightForCM:(NSUInteger)height weightForKg:(float)weight;

- (instancetype)initWithGender:(GENDER)gender age:(NSUInteger)age heightForFeet:(NSUInteger)feet heightForInches:(float)inches weightForLbs:(float)weight;

@end
