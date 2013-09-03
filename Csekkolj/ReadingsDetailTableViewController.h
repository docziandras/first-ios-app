//
//  ReadingsDetailTableViewController.h
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.17..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reading.h"

@interface ReadingsDetailTableViewController : UITableViewController

@property (nonatomic, strong) Reading *reading;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *meterNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end
