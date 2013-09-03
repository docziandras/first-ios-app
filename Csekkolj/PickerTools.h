//
//  PickerTools.h
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.14..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "MeterType.h"
#import "Place+Methods.h"
#import "Meter+Create.h"
#import "Reading+Create.h"

@interface PickerTools : UIView/*Controller*/ <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *myPickerView;
@property (nonatomic, strong) NSArray *pickerContent;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) MeterType *selectedType;
@property (nonatomic, strong) Place *selectedPlace;
@property (nonatomic, strong) Meter *selectedMeter;
@property (nonatomic, strong) Reading *selectedReading;

- (UIPickerView *)createPickerOfType:(NSString *)type; //inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
