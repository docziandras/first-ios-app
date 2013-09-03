//
//  AddMeterViewController.h
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.12..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"
#import "MeterType.h"

@interface AddMeterViewController : UITableViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSNumber *meterNumber;
@property (nonatomic, strong) NSNumber *partnerNumber;
@property (nonatomic, strong) Place *selectedPlace;
@property (nonatomic, strong) MeterType *selectedType;
@property (nonatomic) BOOL select;

@property (weak, nonatomic) IBOutlet UITextField *meterNumberInput;
@property (weak, nonatomic) IBOutlet UITextField *partnerNumberInput;
@property (weak, nonatomic) IBOutlet UITextField *locationInput;
@property (weak, nonatomic) IBOutlet UITextField *typeInput;

@property (nonatomic, strong) NSString *pickerType;
@property (nonatomic, strong) NSArray *placePickerContent;
@property (nonatomic, strong) NSArray *typePickerContent;

- (IBAction)locationInputTouched:(UITextField *)sender;
- (IBAction)typeInputTouched:(UITextField *)sender;

@end
