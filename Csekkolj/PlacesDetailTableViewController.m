//
//  PlacesDetailTableViewController.m
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.08..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "PlacesDetailTableViewController.h"

@implementation PlacesDetailTableViewController

- (void)setPlace:(Place *)newPlace
{
    if (_place != newPlace) {
        _place = newPlace;
        [self configureView];
    }
}

- (void)configureView
{
    Place *place = self.place;
    
    if (place) {
        self.nameLabel.text = place.name;
        self.cityLabel.text = place.city;
        self.streetLabel.text = place.street;
        
        self.navigationItem.title = place.name;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

@end
