//
//  MeterType+Methods.h
//  Csekkolj
//
//  Created by András Dóczi on 2013.03.27..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "MeterType.h"

@interface MeterType (Methods)

+ (MeterType *)createMeterTypeWithType:(NSString *)type inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)allMeterTypesInManagedObjectContext:(NSManagedObjectContext *)context;

@end
