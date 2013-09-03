//
//  Reading+Methods.m
//  Csekkolj
//
//  Created by András Dóczi on 2013.03.26..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "Reading+Methods.h"

@implementation Reading (Methods)

+ (Reading *)readingWithValue:(NSNumber *)value date:(NSDate *)date forMeter:(Meter *)meter inManagedObjectContext:(NSManagedObjectContext *)context
{
    Reading *reading = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reading"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"value = %@ AND date = %@", value, date];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        NSLog(@"An error occured adding %@", value);
    } else if (![matches count]) {
        reading = [NSEntityDescription insertNewObjectForEntityForName:@"Reading" inManagedObjectContext:context];
        reading.value = value;
        reading.date = date;
        reading.forMeter = meter;
        NSLog(@"%@ is added to the database.", value);
    } else {
        reading = [matches lastObject];
        NSLog(@"%@ is already in the database.", value);
    }
    
    return reading;
}

+ (void)deleteReading:(Reading *)aReading inManagedObjectContext:(NSManagedObjectContext *)context
{
    Reading *reading = aReading;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reading"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"date = %@ AND value = %@", reading.date, reading.value];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1) || ![matches count]) {
        NSLog(@"An error occured deleting reading %@ %@", reading.value, reading.date);
    }
    else {
        reading = [matches lastObject];
        [context deleteObject:reading];
        NSLog(@"%@ %@ deleted", reading.value, reading.date);
        
        if ([context save:&error]) NSLog(@"Changes saved.");
        else NSLog(@"Error saving changes: %@", error);
    }
}

+ (NSArray *)allReadingsInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reading"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    request.predicate = nil; //all Readings
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches) {
        NSLog(@"An error occured while listing all readings");
    } else if (![matches count]) {
        NSLog(@"No readings to list");
    } else {
        return matches;
    }
    
    return nil;
}

+ (NSArray *)allReadingsOfType:(NSString *)type inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reading"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"forMeter.ofType.type = %@", type];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches) {
        NSLog(@"An error occured while listing all readings of type: %@", type);
    } else if (![matches count]) {
        NSLog(@"No readings to list");
    } else {
        return matches;
    }
    
    return nil;
}

@end
