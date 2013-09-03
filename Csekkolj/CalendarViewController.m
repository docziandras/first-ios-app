//
//  CalendarViewController.m
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.18..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "CalendarViewController.h"
#import "CDConnectionHandler.h"
#import "AddBillViewController.h"
#import "Meter+Methods.h"
#import "Bill+Methods.h"
#import "Place.h"
#import "MeterType.h"
#import "NotificationHandler.h"

@implementation CalendarViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (!self.managedObjectContext) {
        self.managedObjectContext = [CDConnectionHandler sharedInstance].managedObjectContext;
    }
    
    self.calendar = [[KalViewController alloc] init];
    [self.navigationController addChildViewController:self.calendar];
    self.calendar.delegate = self;
    self.dataSource = [[BillsKalDataSource alloc] init];
    self.calendar.dataSource = self.dataSource;
}

- (IBAction)showAndSelectToday:(UIBarButtonItem *)sender
{
    [self.calendar showAndSelectDate:[NSDate date]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"AddBill"]) {
        AddBillViewController *addController = (AddBillViewController *)[[segue destinationViewController] topViewController];
        
        NSLog(@"addController class: %@", addController.class);
        NSLog(@"CalendarViewController.managedObjectContext: %@", self.managedObjectContext);
        
        addController.meterPickerContent = [Meter allMetersInManagedObjectContext:self.managedObjectContext];
    } else if ([[segue identifier] isEqualToString:@"ShowBillDetails"]) {
        //számla részletes adatlapja
    }
}

#pragma mark BillAddingInput methods

- (IBAction)doneAddingBill:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"ReturnBillAddingInput"]) {
        NSLog(@"Segue identified: %@", [segue identifier]);
        AddBillViewController *addController = [segue sourceViewController];
        
        if (([addController.mode isEqualToString:@"utility"]) && (!addController.selectedMeter)) {
            addController.selectedMeter = [addController.meterPickerContent objectAtIndex:0];
        }
        
        NSString *notificationBody = [[NSString alloc] init];
        
        NSDateFormatter *formatter = nil;
        if (formatter == nil) {
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy.MM.dd."];
        }
        
        if ((addController.amount) && (addController.dueDate)) {
            NSLog(@"Bill to add: %@ Ft due %@, %@", addController.amount, addController.dueDate, addController.mode);
            if (([addController.mode isEqualToString:@"utility"]) && (addController.selectedMeter)) {
                [Bill billWithAmount:addController.amount dueDate:addController.dueDate isUtility:YES forMeter:addController.selectedMeter notes:nil inManagedObjectContext:self.managedObjectContext];
                
                notificationBody = [NSString stringWithFormat:@"%@ %@ %@ Ft számla fizetési határideje %@", addController.selectedMeter.atLocation.name, [addController.selectedMeter.ofType.type lowercaseString], addController.amount, [formatter stringFromDate:addController.dueDate]];
                
            } else {
                [Bill billWithAmount:addController.amount dueDate:addController.dueDate isUtility:NO forMeter:nil notes:addController.notes inManagedObjectContext:self.managedObjectContext];
                
                notificationBody = [NSString stringWithFormat:@"%@ %@ Ft fizetési határideje %@", addController.notes, addController.amount, [formatter stringFromDate:addController.dueDate]];
            }
            
            if ((addController.firstNotification) && (![addController.firstNotification isEqualToString:@"Nincs"])) {
                [NotificationHandler addNotificationWithName:addController.firstNotification relativeToDate:addController.dueDate withBody:notificationBody];
            }
            
            if ((addController.secondNotification) && (![addController.secondNotification isEqualToString:@"Nincs"])) {
                [NotificationHandler addNotificationWithName:addController.secondNotification relativeToDate:addController.dueDate withBody:notificationBody];
            }
        }
        
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (IBAction)cancelAddingBill:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"CancelBillAddingInput"]) {
        NSLog(@"Segue identified: %@", [segue identifier]);
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

@end
