//
//  MyTabBarController.m
//  BMR_Calculator
//
//  Created by 趙子超 on 6/11/16.
//  Copyright © 2016 chao. All rights reserved.
//

#import "MyTabBarController.h"

@interface MyTabBarController ()

@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataManager = [[MyCoreDataManager alloc] initWithMomd:@"BMIBMRRecord.momd" dbFileName:@"BMIBMRRecord.sqlite" dbFilePathURL:nil sortKey:@"timeStamp" entityName:@"AllRecord"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
