//
//  SettingsVC.m
//  BMIBMRCalculator
//
//  Created by 趙子超 on 18/01/2018.
//  Copyright © 2018 chao. All rights reserved.
//

#import "SettingsVC.h"
#import "Constants.h"

const CGFloat UNIT_PICKERVIEW_HEIGHT = 100.0;

@interface SettingsVC () <UIPickerViewDelegate, UIPickerViewDataSource> {
    NSArray *_unitArray;
}

@property (weak, nonatomic) IBOutlet UITextView *introductionTextView;
@property (weak, nonatomic) IBOutlet UIButton *unitButton;
@property (weak, nonatomic) IBOutlet UIView *dividerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewTopConstraint;
@property (weak, nonatomic) IBOutlet UIPickerView *unitPickerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unitPickerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _unitArray = @[NSLocalizedString(@"IMPERIAL", nil), NSLocalizedString(@"METRIC", nil)];
    self.unitPickerView.delegate = self;
    self.unitPickerView.dataSource = self;
    
    self.introductionTextView.editable = false;
    self.introductionTextView.backgroundColor = [UIColor colorWithRed:63.0/255.0 green:59.0/255.0 blue:58.0/255.0 alpha:0.85];
    self.introductionTextView.text = [NSString stringWithFormat:@"%@\n\n%@",NSLocalizedString(@"INTRODUCTION_OF_BMI", nil),NSLocalizedString(@"INTRODUCTION_OF_BMR", nil)];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:UNIT_KEY] isEqualToString:IMPERIAL_UNIT]) {
        self.unitLabel.text = NSLocalizedString(@"IMPERIAL", nil);
        [self.unitPickerView selectRow:0 inComponent:0 animated:false];
    } else {
        self.unitLabel.text = NSLocalizedString(@"METRIC", nil);
        [self.unitPickerView selectRow:1 inComponent:0 animated:false];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (!self.unitPickerView.isHidden) {
        [self collapseUnitMenu];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.introductionTextView scrollRangeToVisible:NSMakeRange(0, 0)];
}

#pragma mark - Private Methods

- (void)expandUnitMenu {
    
    [self.unitButton setImage:[UIImage imageNamed:@"up-arrow"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.unitPickerView.hidden = false;
        self.unitPickerViewHeightConstraint.constant = UNIT_PICKERVIEW_HEIGHT;
        self.textViewTopConstraint.constant = UNIT_PICKERVIEW_HEIGHT;
        
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {}];
}

- (void)collapseUnitMenu {
    
    [self.unitButton setImage:[UIImage imageNamed:@"down-arrow"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        self.unitPickerView.hidden = true;
        self.unitPickerViewHeightConstraint.constant = 0.0;
        self.textViewTopConstraint.constant = 0.0;
        
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {}];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 2;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_unitArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *currentUnit = row == 0 ? IMPERIAL_UNIT : METRIC_UNIT;
    [[NSUserDefaults standardUserDefaults] setObject:currentUnit forKey:UNIT_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.unitLabel.text = [_unitArray objectAtIndex:row];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUnitDidChangeNotification object:nil];
    
    [self collapseUnitMenu];
}

#pragma mark - Action Methods

- (IBAction)unitButtonPressed:(UIButton *)sender {

    if (self.unitPickerView.isHidden) {
        [self expandUnitMenu];
    } else {
        [self collapseUnitMenu];
    }
}

@end
