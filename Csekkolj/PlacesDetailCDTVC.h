//
//  PlacesDetailCDTVC.h
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.08..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Place.h"

@interface PlacesDetailCDTVC : UITableViewController
@property (nonatomic, strong) Place *place;;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@end
