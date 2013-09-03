//
//  Place.h
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.18..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Meter;

@interface Place : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSSet *meters;
@end

@interface Place (CoreDataGeneratedAccessors)

- (void)addMetersObject:(Meter *)value;
- (void)removeMetersObject:(Meter *)value;
- (void)addMeters:(NSSet *)values;
- (void)removeMeters:(NSSet *)values;

@end
