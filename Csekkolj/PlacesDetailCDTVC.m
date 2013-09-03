//
//  PlacesDetailCDTVC.m
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.08..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "PlacesDetailCDTVC.h"

@implementation PlacesDetailCDTVC

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

/*- (void)setupFetchedResultsController
{
    if (self.place.managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", self.place.name];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                             managedObjectContext:self.place.managedObjectContext
                                                                               sectionNameKeyPath:nil
                                                                                        cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

@end
