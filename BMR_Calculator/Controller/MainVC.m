//
//  MainVC.m
//  BMIBMRCalculator
//
//  Created by 趙子超 on 06/01/2018.
//  Copyright © 2018 chao. All rights reserved.
//

#import "MainVC.h"
#import "AllRecord+CoreDataProperties.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "CoreDataManager.h"

#define DEFAULT_ZERO_STRING     @"0.0"

@interface MainVC () <UITextFieldDelegate> {
    UITextField *activeTextField;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentControl;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *heightTextField;
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;
@property (weak, nonatomic) IBOutlet UILabel *bmiResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *bmrResultLabel;
@property (weak, nonatomic) IBOutlet GADBannerView *gadBannerView;

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTextFields];
}

#pragma mark - Private Methods

- (void)setupTextFields {
    
    self.ageTextField.delegate = self;
    self.heightTextField.delegate = self;
    self.weightTextField.delegate = self;
    
    self.ageTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.heightTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.weightTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    self.ageTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.heightTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.weightTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    // Create a Toolbar for TextFields
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    UIBarButtonItem *doneBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBarBtnPressed)];
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelBarBtnPressed)];
    UIBarButtonItem *flexibleSpaceBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:@[cancelBarBtn, flexibleSpaceBarBtn, doneBarBtn]];
    
    self.ageTextField.inputAccessoryView = toolBar;
    self.heightTextField.inputAccessoryView = toolBar;
    self.weightTextField.inputAccessoryView = toolBar;
}

- (void)setDefault {
    self.ageTextField.text = nil;
    self.heightTextField.text = nil;
    self.weightTextField.text = nil;
    self.bmiResultLabel.text = DEFAULT_ZERO_STRING;
    self.bmrResultLabel.text = DEFAULT_ZERO_STRING;
    self.genderSegmentControl.selectedSegmentIndex = 0;
}

#pragma mark - Action Methods

- (IBAction)calculateBtnPressed:(UIButton *)sender {
    
    NSInteger age = [self.ageTextField.text integerValue];
    NSInteger height = [self.heightTextField.text integerValue];
    double weight = [self.weightTextField.text doubleValue];
    
    // Check input data is valid
    if (age == 0 || height == 0 || weight == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Input data Invalid!" message:@"Please input a correct number" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        
        double bmrResult = 0.0;
        double bmiResult = 0.0;
        
        if (self.genderSegmentControl.selectedSegmentIndex == 0) {
            // Male
            bmrResult = (13.7 * weight) + (5.0 * height) - (6.8 * age) + 66;
        } else {
            // Female
            bmrResult = (9.6 * weight) + (1.8 * height) - (4.7 * age) + 655;
        }
        
        double heightMeter = height / 100.0;
        bmiResult = weight / (heightMeter * heightMeter);
        
        self.bmiResultLabel.text = [NSString stringWithFormat:@"%.1f", bmiResult];
        self.bmrResultLabel.text = [NSString stringWithFormat:@"%.1f", bmrResult];
    }
}

- (IBAction)clearBtnPressed:(UIButton *)sender {
    [self setDefault];
}

- (IBAction)saveBtnPressed:(UIButton *)sender {
    
    if ([self.bmiResultLabel.text isEqualToString:DEFAULT_ZERO_STRING]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!" message:@"No Data to Save" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        
        // Create a newItem for every record.
        [[CoreDataManager shareInstance] createNewRecordWithBMI:self.bmiResultLabel.text bmr:self.bmrResultLabel.text timeStamp:[NSDate date]];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Save successful" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self setDefault];
        }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:true completion:nil];
    }
}

- (void)doneBarBtnPressed {
    [activeTextField resignFirstResponder];
}

- (void)cancelBarBtnPressed {
    [activeTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    activeTextField = textField;
}

@end
