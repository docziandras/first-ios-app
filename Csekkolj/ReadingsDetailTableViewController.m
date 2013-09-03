//
//  ReadingsDetailTableViewController.m
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.17..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "ReadingsDetailTableViewController.h"
#import "Place.h"
#import "Meter.h"
#import "MeterType.h"

@implementation ReadingsDetailTableViewController

- (void)setReading:(Reading *)newReading
{
    if (_reading != newReading) {
        _reading = newReading;
        [self configureView];
    }
}

- (void)configureView
{
    Reading *reading = self.reading;
    
    if (reading) {
        self.valueLabel.text = [reading.value stringValue];
        
        NSDateFormatter *formatter = nil;
        if (formatter == nil) {
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy.MM.dd."];
        }
        
        self.dateLabel.text = [formatter stringFromDate:reading.date];
        self.meterNumberLabel.text = [reading.forMeter.meterNumber stringValue];
        self.locationLabel.text = reading.forMeter.atLocation.name;
        self.typeLabel.text = reading.forMeter.ofType.type;
        
        self.navigationItem.title = [NSString stringWithFormat:@"%@, %@", reading.forMeter.atLocation.name, [reading.forMeter.ofType.type lowercaseString]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

@end
