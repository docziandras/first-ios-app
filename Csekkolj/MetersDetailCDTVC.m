//
//  MetersDetailCDTVC.m
//  Csekkolj
//
//  Created by András Dóczi on 2013.03.28..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "MetersDetailCDTVC.h"
#import "Meter.h"

@implementation MetersDetailCDTVC

- (void)setMeter:(Meter *)meter
{
    _meter = meter;
    [self setupFetchedResultsController];
}

- (void)setupFetchedResultsController
{
    if (self.meter.managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Meter"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"meterNumber" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"meterNumber = %@", self.meter.meterNumber];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.meter.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

@end
