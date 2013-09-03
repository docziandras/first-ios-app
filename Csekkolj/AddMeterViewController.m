//
//  AddMeterViewController.m
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.12..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "AddMeterViewController.h"

@implementation AddMeterViewController

- (void)setTypePickerContent:(NSArray *)typePickerContent
{
    if (_typePickerContent != typePickerContent) _typePickerContent = typePickerContent;
}

- (void)setPlacePickerContent:(NSArray *)placePickerContent
{
    if (_placePickerContent != placePickerContent) _placePickerContent = placePickerContent;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ((textField == self.meterNumberInput) || (textField == self.partnerNumberInput) || (textField == self.locationInput) || (textField == self.typeInput)) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark UIPickerView

- (IBAction)typeInputTouched:(UITextField *)sender
{
    self.pickerType = @"typePicker";
    self.select = NO;
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    picker.dataSource = self;
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
    self.typeInput.inputView = picker;
    [self.view addSubview:picker];
}

- (IBAction)locationInputTouched:(UITextField *)sender
{
    self.pickerType = @"placePicker";
    self.select = NO;
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    picker.dataSource = self;
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
    self.locationInput.inputView = picker;
    [self.view addSubview:picker];
    self.locationInput.text = self.selectedPlace.name;
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int rows = 0;
    
    if ([self.pickerType isEqualToString:@"typePicker"]) {
        NSLog(@"typePickerContent count: %i", [self.typePickerContent count]);
        rows = [self.typePickerContent count];
    } else if ([self.pickerType isEqualToString:@"placePicker"]) {
        NSLog(@"placePickerContent count: %i", [self.placePickerContent count]);
        rows = [self.placePickerContent count];
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
    
    if ([self.pickerType isEqualToString:@"typePicker"]) {
        MeterType *meterType = [self.typePickerContent objectAtIndex:row];
        title = meterType.type;
    } else if ([self.pickerType isEqualToString:@"placePicker"]) {
        Place *place = [self.placePickerContent objectAtIndex:row];
        title = place.name;
    }

    NSLog(@"title: %@", title);
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.select = YES;
    
    if ([self.pickerType isEqualToString:@"typePicker"]) {
        self.selectedType = [self.typePickerContent objectAtIndex:row];
        self.typeInput.text = self.selectedType.type;
        NSLog(@"The %@ type was selected using the picker", self.selectedType.type);
    } else if ([self.pickerType isEqualToString:@"placePicker"]) {
        self.selectedPlace = [self.placePickerContent objectAtIndex:row];
        self.locationInput.text = self.selectedPlace.name;
        NSLog(@"The %@ place was selected using the picker", self.selectedPlace.name);
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ReturnMeterAddingInput"]) {
        if ([self.meterNumberInput.text length] && [self.partnerNumberInput.text length]) {
            
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            
            self.meterNumber = [numberFormatter numberFromString:self.meterNumberInput.text];
            self.partnerNumber = [numberFormatter numberFromString:self.partnerNumberInput.text];
            
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    }
}

@end
