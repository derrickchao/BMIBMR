//
//  MyTabBarController.h
//  BMR_Calculator
//
//  Created by 趙子超 on 6/11/16.
//  Copyright © 2016 chao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCoreDataManager.h"
@interface MyTabBarController : UITabBarController

@property (strong, nonatomic) MyCoreDataManager *dataManager;

@end
