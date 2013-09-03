//
//  Place+Methods.m
//  Csekkolj
//
//  Created by András Dóczi on 2013.03.27..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "Place+Methods.h"

@implementation Place (Methods)

+ (Place *)placeWithName:(NSString *)name city:(NSString *)city street:(NSString *)street inManagedObjectContext:(NSManagedObjectContext *)context
{
    Place *place = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];

    if (!matches || ([matches count] > 1)) {
        NSLog(@"An error occured adding %@", name);
    } else if (![matches count]) {
        place = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:context];
        place.name = name;
        place.city = [city description];
        place.street = [street description];
        NSLog(@"%@ at %@, %@ is added to the database.", name, city, street);
    } else {
        place = [matches lastObject];
        NSLog(@"%@ is already in the database.", name);
    }
    
    if ([context save:&error]) NSLog(@"Changes saved.");
    else NSLog(@"Error saving changes: %@", error);
    
    return place;
}

+ (void)deletePlace:(Place *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    Place *place = name;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", place.name];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1) || ![matches count]) {
        NSLog(@"An error occured deleting %@", place.name);
    }
    else {
        place = [matches lastObject];
        [context deleteObject:place];
        NSLog(@"%@ deleted", place.name);
        
        if ([context save:&error]) NSLog(@"Changes saved.");
        else NSLog(@"Error saving changes: %@", error);
    }
}

+ (NSArray *)allPlacesInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    request.predicate = nil; //all Places
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches) {
        NSLog(@"An error occured while listing all places");
    } else if (![matches count]) {
        NSLog(@"No places to list");
    } else {
        return matches;
    }
    
    return matches;
}

@end
