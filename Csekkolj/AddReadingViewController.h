//
//  AddReadingViewController.h
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.16..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Meter.h"

@interface AddReadingViewController : UITableViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) Meter *selectedMeter;
@property (nonatomic) BOOL select;

@property (weak, nonatomic) IBOutlet UITextField *valueInput;
@property (weak, nonatomic) IBOutlet UITextField *dateInput;
@property (weak, nonatomic) IBOutlet UITextField *meterInput;

@property (nonatomic, strong) NSArray *meterPickerContent;

- (IBAction)meterInputTouched:(UITextField *)sender;
- (IBAction)dateInputTouched:(UITextField *)sender;

@end
