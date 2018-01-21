//
//  BodyResult.m
//  BMIBMRCalculator
//
//  Created by 趙子超 on 19/01/2018.
//  Copyright © 2018 chao. All rights reserved.
//

/*
 公制單位: BMI = 體重 (公斤) / (身高 (公尺) x 身高 (公尺))
 英制單位: BMI = 體重 ((英磅) / (身高 (吋) x 身高 (吋))) x 703
 
 BMR calculation for men (metric)    BMR = 66.5 + ( 13.75 × weight in kg ) + ( 5.003 × height in cm ) – ( 6.755 × age in years )
 BMR calculation for women (metric)    BMR = 655.1 + ( 9.563 × weight in kg ) + ( 1.850 × height in cm ) – ( 4.676 × age in years )
 
 BMR calculation for men (imperial)    BMR = 66 + ( 6.2 × weight in pounds ) + ( 12.7 × height in inches ) – ( 6.76 × age in years )
 BMR calculation for women (imperial)    BMR = 655.1 + ( 4.35 × weight in pounds ) + ( 4.7 × height in inches ) - ( 4.7 × age in years )
 */

#import "BodyResult.h"
#import "Constants.h"

@interface BodyResult () {
    BOOL _isImperialUnit;
    float _heightInMeter;
    float _totalInches;
}

@end

@implementation BodyResult

- (instancetype)init {
    self = [super init];
    if (self) {
        _bmrValue = 0.0;
        _bmiValue = 0.0;
        _bodyStatus = nil;
    }
    
    return self;
}

- (instancetype)initWithGender:(GENDER)gender age:(NSUInteger)age heightForCM:(NSUInteger)height weightForKg:(float)weight {
    
    self = [super init];
    
    if (self) {
        _isImperialUnit = false;
        float bmi = 0.0;
        float bmr = 0.0;
        _heightInMeter = height / 100.0;
        bmi = weight / (_heightInMeter * _heightInMeter);

        if (gender == GENDER_MALE) {
            bmr = 66 + (13.75 * weight) + (5.0 * height) - (6.75 * age);
        } else {
            bmr = 655 + (9.56 * weight) + (1.85 * height) - (4.67 * age);
        }
        
        _bmiValue = bmi;
        _bmrValue = bmr;
    }
    
    return  self;
}

- (instancetype)initWithGender:(GENDER)gender age:(NSUInteger)age heightForFeet:(NSUInteger)feet heightForInches:(float)inches weightForLbs:(float)weight {
    
    self = [super init];
    
    if (self) {
        _isImperialUnit = true;
        float bmi = 0.0;
        float bmr = 0.0;
        _totalInches = (feet * 12.0) + inches;
        
        bmi = weight / (_totalInches * _totalInches) * 703;
        if (gender == GENDER_MALE) {
            bmr = 66 + (6.2 * weight) + (12.7 * _totalInches) - (6.76 * age);
        } else {
            bmr = 655 + (4.35 * weight) + (4.7 * _totalInches) - (4.7 * age);
        }
        
        _bmiValue = bmi;
        _bmrValue = bmr;
    }
    
    return self;
}

#pragma mark - Property

- (float)suggestLowerWeight {
    
    if (_isImperialUnit) {
        return (_totalInches * _totalInches) * UNDERWEIGHT / 703;
    } else {
        return (_heightInMeter * _heightInMeter) * UNDERWEIGHT;
    }
}

- (float)suggestUpperWeight {
    
    if (_isImperialUnit) {
        return (_totalInches * _totalInches) * NORMAL_WEIGHT / 703;
    } else {
        return (_heightInMeter * _heightInMeter) * NORMAL_WEIGHT;
    }
}

- (NSString *)bodyStatus {
    
    if (self.bmiValue < VERY_SEVERELY_UNDERWEIGHT) {
        return [BMI_STATUS_ARRAY objectAtIndex:0];
    } else if (self.bmiValue < SEVERELY_UNDERWEIGHT) {
        return [BMI_STATUS_ARRAY objectAtIndex:1];
    } else if (self.bmiValue < UNDERWEIGHT) {
        return [BMI_STATUS_ARRAY objectAtIndex:2];
    } else if (self.bmiValue < NORMAL_WEIGHT) {
        return [BMI_STATUS_ARRAY objectAtIndex:3];
    } else if (self.bmiValue < OVER_WEIGHT) {
        return [BMI_STATUS_ARRAY objectAtIndex:4];
    } else if (self.bmiValue < OBESE_CLASS_I) {
        return [BMI_STATUS_ARRAY objectAtIndex:5];
    } else if (self.bmiValue < OBESE_CLASS_II) {
        return [BMI_STATUS_ARRAY objectAtIndex:6];
    } else if (self.bmiValue > OBESE_CLASS_II) {
        return [BMI_STATUS_ARRAY objectAtIndex:7];
    }
    
    return nil;
}

@end
