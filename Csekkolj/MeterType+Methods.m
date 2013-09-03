//
//  MeterType+Methods.m
//  Csekkolj
//
//  Created by András Dóczi on 2013.03.27..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "MeterType+Methods.h"
#import "Place+Methods.h"

@implementation MeterType (Methods)

+ (MeterType *)createMeterTypeWithType:(NSString *)type
                inManagedObjectContext:(NSManagedObjectContext *)context
{
    MeterType *meterType = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MeterType"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"type = %@", type];
    
    NSError *error;
    NSArray *matches;
    
    matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        NSLog(@"An error occured adding %@", type);
    } else if (![matches count]) {
        meterType = [NSEntityDescription insertNewObjectForEntityForName:@"MeterType" inManagedObjectContext:context];
        meterType.type = type;
        NSLog(@"%@ is added to the database.", type);
    } else {
        meterType = [matches lastObject];
        NSLog(@"%@ is already in the database.", type);
    }
        
    return meterType;
}

+ (NSArray *)allMeterTypesInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MeterType"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES]];
    request.predicate = nil; //all MeterTypes
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches) {
        NSLog(@"An error occured while listing all meter types");
    } else if (![matches count]) {
        NSLog(@"No meter types to list");
    } else {
        return matches;
    }
    
    return matches;
}

@end
