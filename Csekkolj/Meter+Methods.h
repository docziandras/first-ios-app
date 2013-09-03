//
//  Meter+Methods.h
//  Csekkolj
//
//  Created by András Dóczi on 2013.03.27..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "Meter.h"

@interface Meter (Methods)

+ (Meter *) meterWithMeterNumber:(NSNumber *)meterNumber
                   partnerNumber:(NSNumber *)partnerNumber
                      atLocation:(Place *)place
                          ofType:(MeterType *)type
          inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)deleteMeter:(Meter *)meter inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)allMetersInManagedObjectContext:(NSManagedObjectContext *)context;

@end
