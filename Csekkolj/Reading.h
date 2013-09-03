//
//  Reading.h
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.18..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Meter;

@interface Reading : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) Meter *forMeter;

@end
