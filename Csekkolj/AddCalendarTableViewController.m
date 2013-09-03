//
//  AddCalendarTableViewController.m
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.18..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "AddCalendarTableViewController.h"
#import "Place.h"
#import "MeterType.h"

@interface AddCalendarTableViewController ()

@end

@implementation AddCalendarTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    self.mode = @"utility";
}

- (void)setMeterPickerContent:(NSArray *)meterPickerContent
{
    if (_meterPickerContent != meterPickerContent) _meterPickerContent = meterPickerContent;
}

- (NSArray *)notificationPickerContent
{
    if (!_notificationPickerContent) {
        _notificationPickerContent = @[@"Nincs", @"Aznap", @"Egy nappal előtte", @"Két nappal előtte", @"Három nappal előtte", @"Egy héttel előtte", @"Két héttel előtte"];
    }
    
    return _notificationPickerContent;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ((textField == self.amountInput) || (textField == self.dueDateInput)) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int rows = 0;
    
    if ([self.pickerType isEqualToString:@"meterPicker"]) {
        NSLog(@"meterPickerContent count: %i", [self.meterPickerContent count]);
        rows = [self.meterPickerContent count];
    } else {
        NSLog(@"notificationPickerContent count: %i", [self.notificationPickerContent count]);
        rows = [self.notificationPickerContent count];
    }
    
    return rows;
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
    NSString *title;
    
    if ([self.pickerType isEqualToString:@"meterPicker"]) {
        Meter *meter = [self.meterPickerContent objectAtIndex:row];
        title = [NSString stringWithFormat:@"%@ - %@", meter.atLocation.name, meter.ofType.type];
    } else {
        title = [self.notificationPickerContent objectAtIndex:row];
    }
    
    NSLog(@"title: %@", title);
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.select = YES;
    
    if ([self.pickerType isEqualToString:@"meterPicker"]) {
        self.selectedMeter = [self.meterPickerContent objectAtIndex:row];
        self.auxInput.text = [self.selectedMeter.meterNumber stringValue];
        NSLog(@"%@ %@ at %@ was selected using the picker", self.selectedMeter.ofType.type, self.selectedMeter.meterNumber, self.selectedMeter.atLocation.name);
    } else if ([self.pickerType isEqualToString:@"firstNotificationPicker"]) {
        self.firstNotification = row;
        self.firstNotificationInput.text = [self.notificationPickerContent objectAtIndex:row];
    } else {
        self.secondNotification = row;
        self.secondNotificiationInput.text = [self.notificationPickerContent objectAtIndex:row];
    }
}

- (IBAction)dueDateInputTouched:(UITextField *)sender {
}

- (IBAction)firstNotificationInputTouched:(UITextField *)sender
{
    self.pickerType = @"firstNotificationPicker";
    self.select = NO;
    [self createPickerForInputField:sender];
}

- (IBAction)secondNotificationInputTouched:(UITextField *)sender
{
    self.pickerType = @"secondNotificationPicker";
    self.select = NO;
    [self createPickerForInputField:sender];
}

- (IBAction)paidSwitchValueChanged:(UISwitch *)sender
{
    
}

- (IBAction)utilitySwitchValueChanged:(UISwitch *)sender
{
    if (sender.on) {
        self.mode = @"utility";
        self.auxLabel.text = @"Mérőóra";
    } else {
        self.mode = @"non-utility";
        self.auxLabel.text = @"Jegyzet";
    }
}

- (IBAction)auxInputTouched:(UITextField *)sender {
    if ([self.mode isEqualToString:@"utility"]) { //mérőóra hozzáadása
        self.pickerType = @"meterPicker";
        self.select = NO;
        [self createPickerForInputField:sender];
    } else { //jegyzet írása
        self.auxInput.inputView = nil;
    }
}

- (void)createPickerForInputField:(UITextField *)textField
{
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    picker.dataSource = self;
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
    textField.inputView = picker;
    [self.view addSubview:picker];
}

@end
