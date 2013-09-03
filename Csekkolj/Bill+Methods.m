//
//  Bill+Methods.m
//  Csekkolj
//
//  Created by András Dóczi on 2013.03.26..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "Bill+Methods.h"

@implementation Bill (Methods)

+ (Bill *)billWithAmount:(NSNumber *)amount dueDate:(NSDate *)date isUtility:(BOOL)utility forMeter:(Meter *)meter notes:(NSString *)notes inManagedObjectContext:(NSManagedObjectContext *)context
{
    Bill *bill = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Bill"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dueDate" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"dueDate = %@ AND amount = %@", date, amount];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        NSLog(@"An error occured adding %@ due %@", amount, date);
    } else if (![matches count]) {
        bill = [NSEntityDescription insertNewObjectForEntityForName:@"Bill" inManagedObjectContext:context];
        bill.amount = amount;
        bill.dueDate = date;
        bill.paid = NO;
        bill.utility = [NSNumber numberWithBool:utility];
        bill.forMeter = meter;
        bill.notes = [notes description];
        NSLog(@"%@ due %@ is added to the database.", amount, date);
    } else {
        bill = [matches lastObject];
        NSLog(@"Bill with %@ due %@ is already in the database.", amount, date);
    }
    
    return bill;
}

+ (void)deleteBill:(Bill *)aBill inManagedObjectContext:(NSManagedObjectContext *)context
{
    Bill *bill = aBill;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Bill"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dueDate" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"amount = %@ AND dueDate = %@", bill.amount, bill.dueDate];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1) || ![matches count]) {
        NSLog(@"An error occured deleting bill %@ due %@", bill.amount, bill.dueDate);
    }
    else {
        bill = [matches lastObject];
        [context deleteObject:bill];
        NSLog(@"Bill %@ due %@ deleted", bill.amount, bill.dueDate);
        
        if ([context save:&error]) NSLog(@"Changes saved.");
        else NSLog(@"Error saving changes: %@", error);
    }
}

+ (NSArray *)allBillsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Bill"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dueDate" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"dueDate >= %@ AND dueDate <= %@", fromDate, toDate];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches) {
        NSLog(@"An error occured while listing bills from %@ to %@", fromDate, toDate);
    } else if (![matches count]) {
        NSLog(@"No bills to list");
    } else {
        return matches;
    }
    
    return nil;
}

@end
