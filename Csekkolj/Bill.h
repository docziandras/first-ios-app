//
//  Bill.h
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.18..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Meter;

@interface Bill : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * paid;
@property (nonatomic, retain) NSNumber * utility;
@property (nonatomic, retain) Meter *forMeter;

@end
