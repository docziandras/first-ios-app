//
//  CalendarViewController.h
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.18..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BillsKalDataSource.h"
#import "Kal.h"
#import "Bill.h"

@interface CalendarViewController : UIViewController <UITableViewDelegate>
@property (nonatomic, strong) KalViewController *calendar;
@property (nonatomic, strong) BillsKalDataSource *dataSource;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (IBAction)showAndSelectToday:(UIBarButtonItem *)sender;

@end
