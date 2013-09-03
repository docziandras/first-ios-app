//
//  Meter.h
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.18..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bill, MeterType, Place, Reading;

@interface Meter : NSManagedObject

@property (nonatomic, retain) NSNumber * meterNumber;
@property (nonatomic, retain) NSNumber * partnerNumber;
@property (nonatomic, retain) Place *atLocation;
@property (nonatomic, retain) MeterType *ofType;
@property (nonatomic, retain) NSSet *readings;
@property (nonatomic, retain) NSSet *bills;
@end

@interface Meter (CoreDataGeneratedAccessors)

- (void)addReadingsObject:(Reading *)value;
- (void)removeReadingsObject:(Reading *)value;
- (void)addReadings:(NSSet *)values;
- (void)removeReadings:(NSSet *)values;

- (void)addBillsObject:(Bill *)value;
- (void)removeBillsObject:(Bill *)value;
- (void)addBills:(NSSet *)values;
- (void)removeBills:(NSSet *)values;

@end
