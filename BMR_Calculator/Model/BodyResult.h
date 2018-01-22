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

@interface BodyResult : NSObject

@property (nonatomic, assign, readonly) NSUInteger age;
@property (nonatomic, assign, readonly) NSUInteger heightInCm;
@property (nonatomic, assign, readonly) NSUInteger heightInFeet;
@property (nonatomic, assign, readonly) float heightInInch;
@property (nonatomic, assign, readonly) float weightInKg;
@property (nonatomic, assign, readonly) float weightInLb;
@property (nonatomic, copy, readonly) NSString *gender;

@property (nonatomic, assign, readonly) float bmrValue;
@property (nonatomic, assign, readonly) float bmiValue;
@property (nonatomic, assign, readonly) float suggestUpperWeight;
@property (nonatomic, assign, readonly) float suggestLowerWeight;
@property (nonatomic, copy, readonly) NSString *bodyStatus;

- (instancetype)initWithGender:(GENDER)gender age:(NSUInteger)age heightForCM:(NSUInteger)height weightForKg:(float)weight;

- (instancetype)initWithGender:(GENDER)gender age:(NSUInteger)age heightForFeet:(NSUInteger)feet heightForInches:(float)inches weightForLbs:(float)weight;

@end
