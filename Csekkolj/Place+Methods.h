//
//  Place+Methods.h
//  Csekkolj
//
//  Created by András Dóczi on 2013.03.27..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "Place.h"

@interface Place (Methods)

+ (Place *)placeWithName:(NSString *)name
                    city:(NSString *)city
                  street:(NSString *)street
  inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)deletePlace:(Place *)place inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)allPlacesInManagedObjectContext:(NSManagedObjectContext *)context;

@end
