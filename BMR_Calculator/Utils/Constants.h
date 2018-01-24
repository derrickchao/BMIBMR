//
//  Constants.h
//  BMIBMRCalculator
//
//  Created by 趙子超 on 07/01/2018.
//  Copyright © 2018 chao. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#pragma mark - Database
#define DB_FILE_NAME                        @"BMIBMRRecord.sqlite"
#define OBJECT_MODEL_NAME                   @"BMIBMRRecord.momd"
#define DEFAULT_ENTITY_NAME                 @"AllRecord"

#define COLUMN_NAME_AGE                     @"age"
#define COLUMN_NAME_HEIGHT_IN_CM            @"heightInCm"
#define COLUMN_NAME_HEIGHT_IN_FEET          @"heightInFeet"
#define COLUMN_NAME_HEIGHT_IN_INCH          @"heightInInch"
#define COLUMN_NAME_WEIGHT_IN_KG            @"weightInKg"
#define COLUMN_NAME_WEIGHT_IN_LB            @"weightInLb"
#define COLUMN_NAME_SUGGEST_UPPER_WEIGHT    @"suggestUpperWeight"
#define COLUMN_NAME_SUGGEST_LOWER_WEIGHT    @"suggestLowerWeight"
#define COLUMN_NAME_BODY_STATUS             @"bodyStatus"
#define COLUMN_NAME_GENDER                  @"gender"
#define COLUMN_NAME_TIMESTAMP               @"timeStamp"
#define COLUMN_NAME_BMI_RECORD              @"bmiRecord"
#define COLUMN_NAME_BMR_RECORD              @"bmrRecord"


#pragma mark -
#define DEFAULT_ZERO_STRING                 @"0.0"

#define ADMOD_AD_ID                         @"ca-app-pub-3766057955642660/9386694236"

#pragma mark - Default Units
#define MAXIMUM_AGE                         150
#define MAXIMUM_HEIGHT_CM                   300
#define MAXIMUM_WEIGHT_KG                   800
#define MAXIMUM_HEIGHT_FEET                 9
#define MAXIMUM_HEIGHT_INCH                 12.0
#define MAXIMUM_HEIGHT_POUND                1500
#define METRIC_UNIT                         @"Metric"
#define IMPERIAL_UNIT                       @"Imperial"

#define VERY_SEVERELY_UNDERWEIGHT           15.0    // below 14.9
#define SEVERELY_UNDERWEIGHT                16.0    // 15~15.9
#define UNDERWEIGHT                         18.5    // 16~18.4
#define NORMAL_WEIGHT                       25.0    // 18.5~24.9
#define OVER_WEIGHT                         30.0    // 25.0~29.9
#define OBESE_CLASS_I                       35.0    // 30.0~34.9
#define OBESE_CLASS_II                      40.0    // 35.0~39.9
// OBESE_CLASS_III: Over 40.0

#pragma mark - BMI Status info


#define BMI_STATUS_LOCALIZABLE_ARRAY                    @[NSLocalizedString(@"VERY_SEVERELY_UNDERWEIGHT", nil), NSLocalizedString(@"SEVERELY_UNDERWEIGHT", nil), NSLocalizedString(@"UNDERWEIGHT", nil), NSLocalizedString(@"NORMAL", nil), NSLocalizedString(@"OVERWEIGHT", nil), NSLocalizedString(@"OBESE_CLASS_I", nil), NSLocalizedString(@"OBESE_CLASS_II", nil), NSLocalizedString(@"OBESE_CLASS_III", nil)]
#define BMI_STATUS_ARRAY                    @[@"Very severely underweight", @"Severely underweight", @"Underweight", @"Normal", @"Overweight", @"Obese class I", @"Obese class II", @"Obese class III"]
#define BMI_RANGE_ARRAY                     @[@"≤ 14.9", @"15.0~15.9", @"16.0~18.4", @"18.5~24.9", @"25.0~29.9", @"30.0~34.9", @"35.0~39.9", @"≥ 40.0"]

#pragma mark - User Default
#define UNIT_KEY                            @"unit"

#pragma mark - Notification

#define kUnitDidChangeNotification          @"unitDidChange"

#endif /* Constants_h */
