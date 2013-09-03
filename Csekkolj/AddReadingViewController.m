//
//  AddReadingViewController.m
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.16..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "AddReadingViewController.h"
#import "MeterType.h"
#import "Place.h"

@implementation AddReadingViewController

- (void)viewDidLoad
{
    if (!self.selectedDate) {
        NSDateFormatter *formatter = nil;
        if (formatter == nil) {
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy.MM.dd."];
        }
        
        self.dateInput.text = [formatter stringFromDate:[NSDate date]];
    }
}

- (void)setMeterPickerContent:(NSArray *)meterPickerContent
{
    if (_meterPickerContent != meterPickerContent) _meterPickerContent = meterPickerContent;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ((textField == self.valueInput) || (textField == self.dateInput) || (textField == self.meterInput)) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark UIPickerView/UIDatePicker

- (IBAction)dateInputTouched:(UITextField *)sender
{
    self.select = NO;
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    //a valaszthato datumok tartomanya az aktualis datumhoz kepest +/- 1 ev
    datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*365];
    datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*365];
    
    sender.inputView = datePicker;
    
    [datePicker addTarget:self action:@selector(getDatePickerValue:) forControlEvents:UIControlEventValueChanged];
}

- (IBAction)getDatePickerValue:(UIDatePicker *)sender
{
    self.selectedDate = sender.date;
    NSLog(@"selectedDate: %@", sender.date);
    
    NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy.MM.dd."];
    }
    
    self.dateInput.text = [formatter stringFromDate:sender.date];
}

- (IBAction)meterInputTouched:(UITextField *)sender
{
    self.select = NO;
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    picker.dataSource = self;
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
    sender.inputView = picker;
    [self.view addSubview:picker];
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.meterPickerContent count];
}

#pragma mark UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44.0f;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 300.0f;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Meter *meter = [self.meterPickerContent objectAtIndex:row];
    NSString *title = [NSString stringWithFormat:@"%@ - %@", meter.atLocation.name, meter.ofType.type];
    
    NSLog(@"title: %@", title);
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.select = YES;
    
    self.selectedMeter = [self.meterPickerContent objectAtIndex:row];
    self.meterInput.text = [self.selectedMeter.meterNumber stringValue];
    NSLog(@"%@ %@ at %@ was selected using the picker", self.selectedMeter.ofType.type, self.selectedMeter.meterNumber, self.selectedMeter.atLocation.name);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ReturnReadingAddingInput"]) {
        if ([self.valueInput.text length]) {
            
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            
            self.value = [numberFormatter numberFromString:self.valueInput.text];
            NSLog(@"ReturnReadingAddingInput segue self.value: %@", self.value);
            
            if (!self.selectedDate) {
                self.selectedDate = [NSDate date];
            }
            
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    }
}

@end
