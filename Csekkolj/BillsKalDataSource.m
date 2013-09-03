//
//  BillsKalDataSource.m
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.19..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "BillsKalDataSource.h"
#import "CDConnectionHandler.h"
#import "Bill+Methods.h"
#import "Meter.h"
#import "Place.h"
#import "MeterType.h"

static BOOL IsDateBetweenInclusive(NSDate *date, NSDate *begin, NSDate *end)
{
    return [date compare:begin] != NSOrderedAscending && [date compare:end] != NSOrderedDescending;
}

@interface BillsKalDataSource ()
- (NSArray *)billsFrom:(NSDate *)fromDate to:(NSDate *)toDate;
@end

@implementation BillsKalDataSource

+ (BillsKalDataSource *)dataSource
{
    return [[[self class] alloc] init];
}

- (id)init
{
    if ((self = [super init])) {
        self.items = [[NSMutableArray alloc] init];
        self.bills = [[NSMutableArray alloc] init];
        if (!_managedObjectContext) _managedObjectContext = [CDConnectionHandler sharedInstance].managedObjectContext;
    }
    return self;
}

- (Bill *)billAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"BillsKalDataSource items objectAtIndex:indexPath.row: %@", [self.items objectAtIndex:indexPath.row]);
    return [self.items objectAtIndex:indexPath.row];
}

#pragma mark UITableViewDataSource protocol conformance

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    Bill *bill = [self billAtIndexPath:indexPath];
    if ((bill.utility) && (bill.forMeter)) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@, %@", bill.forMeter.atLocation.name, [bill.forMeter.ofType.type lowercaseString]];
    } else if (bill.notes) {
        cell.textLabel.text = bill.notes;
    } else if ((!bill.utility) && (!bill.notes)){
        cell.textLabel.text = @"Számla";
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ Ft", bill.amount];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [Bill deleteBill:[self billAtIndexPath:indexPath] inManagedObjectContext:self.managedObjectContext];
        [self removeAllItems];
    }
}

#pragma mark KalDataSource protocol conformance

- (void)loadBillsFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate
{
    if (self.managedObjectContext) {
        NSLog(@"Fetching bills from the database between %@ and %@...", fromDate, toDate);
        
        self.bills = [[Bill allBillsFromDate:fromDate toDate:toDate inManagedObjectContext:self.managedObjectContext] mutableCopy];
        
        [delegate loadedDataSource:self];
    }
    
}

- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate
{
    [self.bills removeAllObjects];
    [self loadBillsFrom:fromDate to:toDate delegate:delegate];
}

- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
    return [[self billsFrom:fromDate to:toDate] valueForKeyPath:@"dueDate"];
}

- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    [self.items addObjectsFromArray:[self billsFrom:fromDate to:toDate]];
    NSLog(@"BillsKalDataSource items: %@", self.items);
}

- (void)removeAllItems
{
    [self.items removeAllObjects];
}

#pragma mark -

- (NSArray *)billsFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
    NSMutableArray *matches = [NSMutableArray array];
    for (Bill *bill in self.bills)
        if (IsDateBetweenInclusive(bill.dueDate, fromDate, toDate))
            [matches addObject:bill];
    
    NSLog(@"BillsKalDataSource matches: %@", matches);
    return matches;
}

@end
