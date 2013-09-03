//
//  MetersDetailCDTVC.h
//  Csekkolj
//
//  Created by András Dóczi on 2013.03.28..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Meter.h"

@interface MetersDetailCDTVC : CoreDataTableViewController

@property (nonatomic, strong) Meter *meter;

@end
