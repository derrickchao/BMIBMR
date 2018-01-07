//
//  ViewController.m
//  BMR_Calculator
//
//  Created by 趙子超 on 6/8/16.
//  Copyright © 2016 chao. All rights reserved.
//

#import "ViewController.h"
#import "MyCoreDataManager.h"
#import "MyTabBarController.h"
#import "AllRecord+CoreDataProperties.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface ViewController () <UITextFieldDelegate>
{
    NSUInteger genderSelected; // 0:Male 1:Female
    float bmrResult;
    float bmiResult;
    UITextField *activeTextField;
    
    MyCoreDataManager *dataManager;
    AllRecord *allRecords;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentControl;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *heightTextField;
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;
@property (weak, nonatomic) IBOutlet UILabel *bmiResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *bmrResultLabel;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    genderSelected = 0;    // Default
    bmrResult = 0.0;
    bmiResult = 0.0;
    activeTextField = nil;
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage.png"]]];
    
    _ageTextField.delegate = self;
    _heightTextField.delegate = self;
    _weightTextField.delegate = self;
    
    _ageTextField.keyboardType = UIKeyboardTypeNumberPad;
    _heightTextField.keyboardType = UIKeyboardTypeNumberPad;
    _weightTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    _ageTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _heightTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _weightTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelBtnPressed)];
    UIBarButtonItem *spaceBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneBtnPressed)];
    [toolBar setItems:@[cancelBtn,spaceBtn,doneBtn]];
    
    _ageTextField.inputAccessoryView = toolBar;
    _heightTextField.inputAccessoryView = toolBar;
    _weightTextField.inputAccessoryView = toolBar;
    
    dataManager = ((MyTabBarController *)self.tabBarController).dataManager;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:@"Helvetica" size:13], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [_genderSegmentControl setTitleTextAttributes:attributes forState:UIControlStateSelected];
    
    // Add Google AdMod
    self.bannerView.adUnitID = @"ca-app-pub-3766057955642660/9386694236";
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];

    for (NSString *familyName in [UIFont familyNames]) {
        NSLog(@"Family Name: %@",familyName);
        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
            NSLog(@"--Font Name: %@", fontName);
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) defaultValue{
    
    _bmiResultLabel.text = @"0.0";
    _bmrResultLabel.text = @"0.0";
    _ageTextField.text = @"";
    _heightTextField.text = @"";
    _weightTextField.text = @"";
    _genderSegmentControl.selectedSegmentIndex = 0;
}

- (IBAction)genderValueChanged:(id)sender {
    
    genderSelected = [sender selectedSegmentIndex];
    
}

- (IBAction)calculateBtnPressed:(id)sender {
    
    int age = [_ageTextField.text intValue];
    int height = [_heightTextField.text intValue];
    float weight = [_weightTextField.text floatValue];
    
    if( age == 0 || height == 0 || weight == 0.0) {
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Input Field Invalid!" message:@"Please input correct number" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:ok];
        
        [self presentViewController:alert animated:true completion:nil];
        return;
    }

    if(genderSelected == 0) //Male
    {
        bmrResult = (13.7 * weight) + (5.0 * height) - (6.8 * age) + 66;
    }
    else //Female
    {
        bmrResult = (9.6 * weight) + (1.8 * height) - (4.7 * age) + 655;
    }
    
    float heightMeter = (height / 100.0);
    bmiResult = weight / (heightMeter * heightMeter);
        
    _bmrResultLabel.text = [NSString stringWithFormat:@"%.1f", bmrResult];
    _bmiResultLabel.text = [NSString stringWithFormat:@"%.1f",bmiResult];
}

- (IBAction)clearBtnPressed:(id)sender {
    
    [self defaultValue];
}
- (IBAction)saveBtnPressed:(id)sender {
    
    if([_bmrResultLabel.text isEqualToString:@"0.0"]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!" message:@"No Data to Save..." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:true completion:nil];

    }else {
        // Create a newItem for every record.
        allRecords = (AllRecord *)[dataManager createNewItem];
        
        allRecords.timeStamp = [NSDate date];
        allRecords.bmiRecord = @(bmiResult);
        allRecords.bmrRecord = @(bmrResult);
        
        [dataManager save];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Save successful" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self defaultValue];
        }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:true completion:nil];

    }
}

- (void) cancelBtnPressed {
    
    [activeTextField resignFirstResponder];
}

- (void) doneBtnPressed {
    
    [activeTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    
    activeTextField = textField;
}

@end
