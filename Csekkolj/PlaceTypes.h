//
//  PlaceTypes.h
//  Csekkolj
//
//  Created by András Dóczi on 2013.03.27..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MeterType, Place;

@interface PlaceTypes : NSManagedObject

@property (nonatomic, retain) MeterType *types;
@property (nonatomic, retain) Place *places;

@end
