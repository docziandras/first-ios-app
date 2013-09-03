//
//  MetersDetailTableViewController.h
//  Csekkolj
//
//  Created by András Dóczi on 2013.03.28..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "Meter.h"

@interface MetersDetailTableViewController : UITableViewController

@property (nonatomic, strong) Meter *meter;
@property (weak, nonatomic) IBOutlet UILabel *meterNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *partnerNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end
