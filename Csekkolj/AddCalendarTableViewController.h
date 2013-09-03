//
//  AddCalendarTableViewController.h
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.18..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Meter.h"

@interface AddCalendarTableViewController : UITableViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSDate *dueDate;
@property (nonatomic) NSInteger firstNotification;
@property (nonatomic) NSInteger secondNotification;
@property (nonatomic, strong) NSString *mode;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) Meter *selectedMeter;
@property (nonatomic) BOOL select;

@property (nonatomic, strong) NSString *pickerType;
@property (nonatomic, strong) NSArray *meterPickerContent;
@property (nonatomic, strong) NSArray *notificationPickerContent;

@property (weak, nonatomic) IBOutlet UITextField *amountInput;
@property (weak, nonatomic) IBOutlet UITextField *dueDateInput;
@property (weak, nonatomic) IBOutlet UITextField *firstNotificationInput;
@property (weak, nonatomic) IBOutlet UITextField *secondNotificiationInput;

@property (weak, nonatomic) IBOutlet UITextField *auxInput; //Meter, ha utility, notes, ha nem
@property (weak, nonatomic) IBOutlet UILabel *auxLabel; //Mérőóra, ha utility, Jegyzet, ha nem

- (IBAction)dueDateInputTouched:(UITextField *)sender;
- (IBAction)firstNotificationInputTouched:(UITextField *)sender;
- (IBAction)secondNotificationInputTouched:(UITextField *)sender;
- (IBAction)paidSwitchValueChanged:(UISwitch *)sender;
- (IBAction)utilitySwitchValueChanged:(UISwitch *)sender;
- (IBAction)auxInputTouched:(UITextField *)sender;

@end
