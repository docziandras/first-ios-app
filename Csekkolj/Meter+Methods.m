//
//  Meter+Methods.m
//  Csekkolj
//
//  Created by András Dóczi on 2013.03.27..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "Meter+Methods.h"
#import "MeterType.h"
#import "Place.h"

@implementation Meter (Methods)

+ (Meter *)meterWithMeterNumber:(NSNumber *)meterNumber
                  partnerNumber:(NSNumber *)partnerNumber
                     atLocation:(Place *)place
                         ofType:(MeterType *)type
         inManagedObjectContext:(NSManagedObjectContext *)context
{
    Meter *meter = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Meter"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"meterNumber" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"(meterNumber = %@) OR ((atLocation = %@) AND (ofType = %@)) ", meterNumber, place, type];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        NSLog(@"An error occured adding %@ %@ to %@", meter.ofType.type, meter.meterNumber, meter.atLocation.name);
    } else if (![matches count]) {
        meter = [NSEntityDescription insertNewObjectForEntityForName:@"Meter" inManagedObjectContext:context];
        meter.meterNumber = meterNumber;
        meter.partnerNumber = partnerNumber;
        meter.atLocation = place;
        meter.ofType = type;
        NSLog(@"%@ %@ at %@ is added to the database.", meter.ofType.type, meter.meterNumber, meter.atLocation.name);
    } else {
        meter = [matches lastObject];
        NSLog(@"%@ %@ at %@ is already in the database.", meter.ofType.type, meter.meterNumber, meter.atLocation.name);
    }
    
    return meter;
}

+ (void)deleteMeter:(Meter *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    Meter *meter = name;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Meter"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"meterNumber" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"meterNumber = %@", meter.meterNumber];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1) || ![matches count]) {
        NSLog(@"An error occured deleting %@ %@ at %@", meter.ofType.type, meter.meterNumber, meter.atLocation.name);
    }
    else {
        meter = [matches lastObject];
        [context deleteObject:meter];
        NSLog(@"%@ %@ at %@ deleted", meter.ofType.type, meter.meterNumber, meter.atLocation.name);
        
        if ([context save:&error]) NSLog(@"Changes saved.");
        else NSLog(@"Error saving changes: %@", error);
    }
}

+ (NSArray *)allMetersInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Meter"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"atLocation.name" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"ofType.type" ascending:YES]];
    request.predicate = nil; //all Meters
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches) {
        NSLog(@"An error occured while listing all meters");
    } else if (![matches count]) {
        NSLog(@"No meters to list");
    } else {
        return matches;
    }
    
    return nil;
}

@end
