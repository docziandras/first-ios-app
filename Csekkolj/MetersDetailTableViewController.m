//
//  MetersDetailTableViewController.m
//  Csekkolj
//
//  Created by András Dóczi on 2013.03.28..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "MetersDetailTableViewController.h"
#import "Meter.h"
#import "Place.h"
#import "MeterType.h"

@implementation MetersDetailTableViewController

- (void)setMeter:(Meter *)newMeter
{
    if (_meter != newMeter) {
        _meter = newMeter;
        [self configureView];
    }
}

- (void)configureView
{
    Meter *meter = self.meter;
    
    if (meter) {
        self.meterNumberLabel.text = [meter.meterNumber stringValue];
        self.partnerNumberLabel.text = [meter.partnerNumber stringValue];
        self.placeLabel.text = meter.atLocation.name;
        self.typeLabel.text = meter.ofType.type;
        
        self.navigationItem.title = [NSString stringWithFormat:@"%@, %@", meter.atLocation.name, [meter.ofType.type lowercaseString]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

@end
