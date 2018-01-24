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
#import "Constants.h"
#import "BodyResult.h"
#import "BMIStatusTableVC.h"

@interface MainVC () <UITextFieldDelegate> {
    UITextField *_activeTextField;
    BodyResult *_bodyResult;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentControl;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *inchTextField;
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;
@property (weak, nonatomic) IBOutlet UILabel *bmiResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *bmrResultLabel;
@property (weak, nonatomic) IBOutlet UIView *heightContainerView;
@property (weak, nonatomic) IBOutlet GADBannerView *gadBannerView;
@property (weak, nonatomic) IBOutlet UITextField *feetTextField;
@property (nonatomic, strong) UITextField *cmTextField;
@property (nonatomic, strong) BMIStatusTableVC *bmiStatusTableVC;
@property (weak, nonatomic) IBOutlet UILabel *suggestWeightResultLabel;

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureGADBanner];
    [self setupTextFields];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unitDidChanged:) name:kUnitDidChangeNotification object:nil];
    
    if (![self isImperialUnit]) {
        [self setupCMTextField];
        self.feetTextField.hidden = true;
        self.inchTextField.hidden = true;
        self.weightTextField.placeholder = NSLocalizedString(@"KG", nil);
    } else {
        
    }
    
    if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular && self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular) {
        self.cmTextField.font = [UIFont fontWithName:@"AvenirNext-Bold" size:26.0];
        
        UIFont *font = [UIFont boldSystemFontOfSize:22.0];
        NSDictionary *attributes = @{NSFontAttributeName: font};
        [self.genderSegmentControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"BMIStatusTableVC"]) {
        self.bmiStatusTableVC = (BMIStatusTableVC *)segue.destinationViewController;
    }
}

#pragma mark - Property

- (UITextField *)cmTextField {
    
    if (!_cmTextField) {
        _cmTextField = [[UITextField alloc] init];
        _cmTextField.translatesAutoresizingMaskIntoConstraints = false;
        _cmTextField.placeholder = NSLocalizedString(@"CM", nil);;
        _cmTextField.textAlignment = NSTextAlignmentCenter;
        _cmTextField.borderStyle = UITextBorderStyleRoundedRect;
        _cmTextField.delegate = self;
        _cmTextField.font = [UIFont fontWithName:@"AvenirNext-Bold" size:18.0];
        _cmTextField.keyboardType = UIKeyboardTypeNumberPad;
        _cmTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    
    return _cmTextField;
}

#pragma mark - Private Methods

- (void)configureGADBanner {
    
    self.gadBannerView.adUnitID = ADMOD_AD_ID;
    self.gadBannerView.rootViewController = self;
    [self.gadBannerView loadRequest:[GADRequest request]];
}

- (BOOL)isImperialUnit {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:UNIT_KEY] isEqualToString:IMPERIAL_UNIT];
}

- (void)setupCMTextField {
    
    [self.heightContainerView addSubview:self.cmTextField];
    [self.heightContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.cmTextField
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.heightContainerView
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0
                                                                          constant:0.0]];
    [self.heightContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.cmTextField
                                                                         attribute:NSLayoutAttributeWidth
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.heightContainerView
                                                                         attribute:NSLayoutAttributeWidth
                                                                        multiplier:0.5
                                                                          constant:0.0]];
    [self.heightContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.cmTextField
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.heightContainerView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1.0
                                                                          constant:3.0]];
    [self.heightContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.cmTextField
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.heightContainerView
                                                                         attribute:NSLayoutAttributeHeight
                                                                        multiplier:0.7
                                                                          constant:0.0]];
}

- (void)setupTextFields {
    
    self.ageTextField.delegate = self;
    self.feetTextField.delegate = self;
    self.inchTextField.delegate = self;
    self.weightTextField.delegate = self;
    
    self.ageTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.feetTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.inchTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.weightTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    self.ageTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.feetTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.inchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.weightTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    // Create a Toolbar for TextFields
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    UIBarButtonItem *doneBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBarBtnPressed)];
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelBarBtnPressed)];
    UIBarButtonItem *flexibleSpaceBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:@[cancelBarBtn, flexibleSpaceBarBtn, doneBarBtn]];
    
    self.ageTextField.inputAccessoryView = toolBar;
    self.feetTextField.inputAccessoryView = toolBar;
    self.inchTextField.inputAccessoryView = toolBar;
    self.weightTextField.inputAccessoryView = toolBar;
    self.cmTextField.inputAccessoryView = toolBar;
}

- (void)alertTitle:(NSString *)title
           message:(NSString *)message
actionCompletionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (completionHandler != nil) {
            completionHandler();
        }
    }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setDefault {
    
    self.bmiStatusTableVC.bodyResult = nil;
    [self.bmiStatusTableVC.tableView reloadData];
    
    self.ageTextField.text = nil;
    self.feetTextField.text = nil;
    self.inchTextField.text = nil;
    self.cmTextField.text = nil;
    self.weightTextField.text = nil;
    self.suggestWeightResultLabel.text = nil;
    self.bmiResultLabel.text = DEFAULT_ZERO_STRING;
    self.bmrResultLabel.text = DEFAULT_ZERO_STRING;
    self.genderSegmentControl.selectedSegmentIndex = 0;
}

#pragma mark - Notification

- (void)unitDidChanged:(NSNotification *)notification {
    
    if ([self isImperialUnit]) {
        self.cmTextField.hidden = true;
        self.weightTextField.placeholder = NSLocalizedString(@"LB", nil);
        self.feetTextField.hidden = false;
        self.inchTextField.hidden = false;
    } else {
        [self setupCMTextField];
        self.cmTextField.hidden = false;
        self.feetTextField.hidden = true;
        self.inchTextField.hidden = true;
        self.weightTextField.placeholder = NSLocalizedString(@"KG", nil);
    }
    
    [self setDefault];
}

#pragma mark - Action Methods

- (IBAction)calculateBtnPressed:(UIButton *)sender {
    
    _bodyResult = nil;
    NSUInteger age = [self.ageTextField.text integerValue];
    if ([self isImperialUnit]) {
        
        NSUInteger feet = [self.feetTextField.text integerValue];
        float inch = [self.inchTextField.text floatValue];
        float weight = [self.weightTextField.text floatValue];
        
        if (age == 0 || age > MAXIMUM_AGE || weight == 0.0 || weight > MAXIMUM_HEIGHT_POUND || feet > MAXIMUM_HEIGHT_FEET || inch > MAXIMUM_HEIGHT_INCH || (feet == 0 && inch == 0.0)) {
            
            [self alertTitle:NSLocalizedString(@"DATA_INVALID", nil) message:NSLocalizedString(@"INPUT_APPROPRIATE_DATA", nil) actionCompletionHandler:nil];
        } else {
            
            if (self.genderSegmentControl.selectedSegmentIndex == 0) {
                // Male
                _bodyResult = [[BodyResult alloc] initWithGender:GENDER_MALE age:age heightForFeet:feet heightForInches:inch weightForLbs:weight];
            } else {
                // Female
                _bodyResult = [[BodyResult alloc] initWithGender:GENDER_FEMALE age:age heightForFeet:feet heightForInches:inch weightForLbs:weight];
            }
            
            self.bmiResultLabel.text = [NSString stringWithFormat:@"%.1f", _bodyResult.bmiValue];
            self.bmrResultLabel.text = [NSString stringWithFormat:@"%.1f", _bodyResult.bmrValue];
            self.suggestWeightResultLabel.text = [NSString stringWithFormat:@"%.1f~%.1f %@", _bodyResult.suggestLowerWeight, _bodyResult.suggestUpperWeight,NSLocalizedString(@"LB", nil)];
            
            self.bmiStatusTableVC.bodyResult = _bodyResult;
            [self.bmiStatusTableVC.tableView reloadData];
        }
    } else {
        
        NSUInteger cm = [self.cmTextField.text integerValue];
        float weight = [self.weightTextField.text floatValue];
        
        // Check input data is valid
        if (age == 0 || age > MAXIMUM_AGE || cm == 0 || cm > MAXIMUM_HEIGHT_CM || weight == 0 || weight > MAXIMUM_WEIGHT_KG) {
            
            [self alertTitle:NSLocalizedString(@"DATA_INVALID", nil) message:NSLocalizedString(@"INPUT_APPROPRIATE_DATA", nil) actionCompletionHandler:nil];
            
        } else {
            
            if (self.genderSegmentControl.selectedSegmentIndex == 0) {
                // Male
                _bodyResult = [[BodyResult alloc] initWithGender:GENDER_MALE age:age heightForCM:cm weightForKg:weight];
            } else {
                // Female
                _bodyResult = [[BodyResult alloc] initWithGender:GENDER_FEMALE age:age heightForCM:cm weightForKg:weight];
            }
            
            self.bmiResultLabel.text = [NSString stringWithFormat:@"%.1f", _bodyResult.bmiValue];
            self.bmrResultLabel.text = [NSString stringWithFormat:@"%.1f", _bodyResult.bmrValue];
            self.suggestWeightResultLabel.text = [NSString stringWithFormat:@"%.1f~%.1f %@", _bodyResult.suggestLowerWeight, _bodyResult.suggestUpperWeight,NSLocalizedString(@"KG", nil)];
            
            self.bmiStatusTableVC.bodyResult = _bodyResult;
            [self.bmiStatusTableVC.tableView reloadData];
        }
    }
}

- (IBAction)clearBtnPressed:(UIButton *)sender {

    [self setDefault];
    [self alertTitle:NSLocalizedString(@"ALL_CLEAR", nil) message:nil actionCompletionHandler:nil];
}

- (IBAction)saveBtnPressed:(UIButton *)sender {
    
    if ([self.bmiResultLabel.text isEqualToString:DEFAULT_ZERO_STRING]) {

        [self alertTitle:NSLocalizedString(@"ERROR", nil) message:NSLocalizedString(@"NO_DATA_SAVE", nil) actionCompletionHandler:nil];

    } else {
        
        // Create a NSManagerObject for every record.
        [[CoreDataManager shareInstance] createNewRecord:_bodyResult];
        
        [self alertTitle:nil message:NSLocalizedString(@"SAVE_SUCCESSFULLY", nil) actionCompletionHandler:^{
            [self setDefault];
        }];
    }
}

- (void)doneBarBtnPressed {
    [_activeTextField resignFirstResponder];
}

- (void)cancelBarBtnPressed {
    [_activeTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _activeTextField = textField;
}

@end
