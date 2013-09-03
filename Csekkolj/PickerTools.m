//
//  PickerTools.m
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.14..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "PickerTools.h"

@interface PickerTools ()

@end

@implementation PickerTools

- (UIPickerView *)createPickerOfType:(NSString *)type //inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    if (!self.managedObjectContext)         //miért?
    NSLog(@"self.managedObjectContext: %@", self.managedObjectContext);
    
    self.myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 236, 320, 200)];
    
    self.myPickerView.delegate = self;
    self.myPickerView.dataSource = self;
    self.myPickerView.showsSelectionIndicator = YES;
    
    if ([type isEqualToString: @"type"]) self.myPickerView.tag = 1;
    else if ([type isEqualToString:@"place"]) {
        self.myPickerView.tag = 2;
        self.pickerContent = [Place allPlacesInManagedObjectContext:self.managedObjectContext];
    }
    else if ([type isEqualToString:@"meter"]) self.myPickerView.tag = 3;
    else if ([type isEqualToString:@"reading"]) self.myPickerView.tag = 4;
    else NSLog(@"Undefined picker type");
    
    [self setupFetchedResultsController];
    
    return self.myPickerView;
}

- (void)setupFetchedResultsController
{
    switch (self.myPickerView.tag) {
            //meroora tipusa
        case 1:
            self.pickerContent = @[@"Villanyóra", @"Gázóra", @"Vízóra"];
            break;
            //hely
        case 2:
            self.pickerContent = [Place allPlacesInManagedObjectContext:self.managedObjectContext];
            break;
            //meroora
        case 3:
            self.pickerContent = [Meter allMetersInManagedObjectContext:self.managedObjectContext];
            break;
            //leolvasas
        case 4:
            self.pickerContent = [Reading allReadingsInManagedObjectContext:self.managedObjectContext];
            break;
        default:
            NSLog(@"Entity to display in picker view could not be determined");
            break;
    }
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.pickerContent count];
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
    NSLog(@"picker tag %i", self.myPickerView.tag);
    
    switch (self.myPickerView.tag) {
        case 1: {
            [self setupFetchedResultsController];
            MeterType *meterType = [self.pickerContent objectAtIndex:row];
            title = meterType.type;
            return title;
            break;
        }
        case 2: {
            [self setupFetchedResultsController];
            Place *place = [self.pickerContent objectAtIndex:row];
            title = place.name;
            break;
        }
        case 3: {
            [self setupFetchedResultsController];
            Meter *meter = [self.pickerContent objectAtIndex:row];
            title = [meter.meterNumber stringValue];
            break;
        }
        case 4: {
            [self setupFetchedResultsController];
            Reading *reading = [self.pickerContent objectAtIndex:row];
            title = [reading.date description];
            break;
        }
        default:
            NSLog(@"Unable to determine picker contents");
            break;
    }
    
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (self.myPickerView.tag) {
        case 1: {
            MeterType *meterType = [self.pickerContent objectAtIndex:row];
            self.selectedType = meterType;
            NSLog(@"The %@ type was selected using the picker", self.selectedType.type);
            break;
        }
        case 2: {
            Place *place = [self.pickerContent objectAtIndex:row];
            self.selectedPlace = place;
            NSLog(@"The %@ place was selected using the picker", self.selectedPlace.name);
            break;
        }
        case 3: {
            Meter *meter = [self.pickerContent objectAtIndex:row];
            self.selectedMeter = meter;
            NSLog(@"The %@ meter was selected using the picker", self.selectedMeter.meterNumber);
            break;
        }
        case 4: {
            Reading *reading = [self.pickerContent objectAtIndex:row];
            self.selectedReading = reading;
            NSLog(@"The %@ reading was selected using the picker", self.selectedReading.date);
            break;
        }
        default:
            NSLog(@"Unable to determine picker contents");
            break;
    }
}

@end
