//
//  Reading+Methods.h
//  Csekkolj
//
//  Created by András Dóczi on 2013.03.26..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "Reading.h"
#import "Meter.h"

@interface Reading (Methods)

+ (Reading *)readingWithValue:(NSNumber *)value
                         date:(NSDate *)date
                     forMeter:(Meter *)meter
       inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)deleteReading:(Reading *)reading inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)allReadingsInManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)allReadingsOfType:(NSString *)type inManagedObjectContext:(NSManagedObjectContext *)context;

@end
