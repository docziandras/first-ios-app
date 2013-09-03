//
//  CPGConsumptionStore.m
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.26..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "CPGConsumptionStore.h"
#import "CPGConstants.h"
#import "CDConnectionHandler.h"
#import "Reading+Methods.h"

#define HEATING @"Gázóra"
#define ELECTRICITY @"Villanyóra"
#define WATER @"Vízóra"

@interface CPGConsumptionStore ()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation CPGConsumptionStore

- (id)init
{
    self = [super init];
 
    if (!_managedObjectContext) _managedObjectContext = [CDConnectionHandler sharedInstance].managedObjectContext;
 
    return self;
}

#pragma mark Class methods

+ (CPGConsumptionStore *)sharedInstance
{
    static CPGConsumptionStore *sharedInstance;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark API methods

- (NSArray *)tickerSymbols
{
    static NSArray *symbols = nil;
    if (!symbols)
    {
        symbols = [NSArray arrayWithObjects:
                   @"HEAT",
                   @"ELEC",
                   @"WATR",
                   nil];
    }
    return symbols;
}

- (NSArray *)dates
{
    static NSArray *dates = nil;
    if (!dates)
    {
        NSArray *readings = [Reading allReadingsInManagedObjectContext:self.managedObjectContext];
        NSMutableArray *mutableDates = [[NSMutableArray alloc] init];
        
        NSDateFormatter *formatter = nil;
        if (formatter == nil) {
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy.MM.dd."];
        }
        
        for (Reading *reading in readings) {
            [mutableDates addObject:[formatter stringFromDate:reading.date]];
        }
        
        dates = [mutableDates copy];
    }
    
    NSLog(@"CPGConsumptionStore.dates count: %i", [dates count]);
    return dates;
}

- (NSArray *)consumption:(NSString *)tickerSymbol
{
    if ([CPGTickerSymbolHEAT isEqualToString:[tickerSymbol uppercaseString]] == YES)
    {
        return [self heatingConsumption];
    }
    else if ([CPGTickerSymbolELEC isEqualToString:[tickerSymbol uppercaseString]] == YES)
    {
        return [self electricityConsumption];
    }
    else if ([CPGTickerSymbolWATR isEqualToString:[tickerSymbol uppercaseString]] == YES)
    {
        return [self waterConsumption];
    }
    return [NSArray array];
}

- (NSArray *)heatingConsumption
{
    static NSArray *consumption = nil;
    if (!consumption)
    {
       NSArray *readings = [Reading allReadingsOfType:HEATING inManagedObjectContext:self.managedObjectContext];
        
        NSLog(@"HEATING readings.count: %i", [readings count]);
        NSMutableArray *mutableConsumption = [[NSMutableArray alloc] init];
        
        NSUInteger count = [readings count];
        for (NSUInteger i = 0; i < (count-2); i++) {
            NSLog(@"i: %i", i);
            NSNumber *first = [[readings objectAtIndex:i] valueForKey:@"value"];
            NSNumber *next = [[readings objectAtIndex:i+1] valueForKey:@"value"];
            float consumed = [next floatValue] - [first floatValue];
            NSLog(@"consumed: %f", consumed);
            
            [mutableConsumption addObject:[NSNumber numberWithFloat:consumed]];
        }
        
        consumption = [mutableConsumption copy];
    }
    
    return consumption;
}

- (NSArray *)electricityConsumption
{
    static NSArray *consumption = nil;
    if (!consumption)
    {
        NSArray *readings = [Reading allReadingsOfType:ELECTRICITY inManagedObjectContext:self.managedObjectContext];
        
        NSLog(@"ELECTRICITY readings.count: %i", [readings count]);
        NSMutableArray *mutableConsumption = [[NSMutableArray alloc] init];
        
        NSUInteger count = [readings count];
        for (NSUInteger i = 0; i < (count-2); i++) {
            NSLog(@"i: %i", i);
            NSNumber *first = [[readings objectAtIndex:i] valueForKey:@"value"];
            NSNumber *next = [[readings objectAtIndex:i+1] valueForKey:@"value"];
            float consumed = [next floatValue] - [first floatValue];
            NSLog(@"consumed: %f", consumed);
            
            [mutableConsumption addObject:[NSNumber numberWithFloat:consumed]];
        }
        
        consumption = [mutableConsumption copy];
    }
    
    return consumption;
}

- (NSArray *)waterConsumption
{
    static NSArray *consumption = nil;
    if (!consumption)
    {
        NSArray *readings = [Reading allReadingsOfType:WATER inManagedObjectContext:self.managedObjectContext];
        
        NSLog(@"WATER readings.count: %i", [readings count]);
        NSMutableArray *mutableConsumption = [[NSMutableArray alloc] init];
        
        NSUInteger count = [readings count];
        for (NSUInteger i = 0; i < (count-2); i++) {
            NSLog(@"i: %i", i);
            NSNumber *first = [[readings objectAtIndex:i] valueForKey:@"value"];
            NSNumber *next = [[readings objectAtIndex:i+1] valueForKey:@"value"];
            float consumed = [next floatValue] - [first floatValue];
            NSLog(@"consumed: %f", consumed);
            
            [mutableConsumption addObject:[NSNumber numberWithFloat:consumed]];
        }
        
        consumption = [mutableConsumption copy];
    }
    
    return consumption;
}

@end
