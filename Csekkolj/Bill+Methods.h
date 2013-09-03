//
//  Bill+Methods.h
//  Csekkolj
//
//  Created by András Dóczi on 2013.03.26..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "Bill.h"

@interface Bill (Methods)

+ (Bill *)billWithAmount:(NSNumber *)amount
                 dueDate:(NSDate *)date
               isUtility:(BOOL)utility
                forMeter:(Meter *)meter
                   notes:(NSString *)notes
     inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)deleteBill:(Bill *)bill inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSArray *)allBillsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate inManagedObjectContext:(NSManagedObjectContext *)context;

@end
