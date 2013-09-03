//
//  PlacesCDTVC.m
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.07..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "PlacesCDTVC.h"
#import "CDConnectionHandler.h"
#import "PlacesDetailTableViewController.h"
#import "AddPlaceViewController.h"
#import "Place+Methods.h"
#import "MeterType+Methods.h"

@implementation PlacesCDTVC

static BOOL firstLaunch = YES;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.managedObjectContext) {
        self.managedObjectContext = [CDConnectionHandler sharedInstance].managedObjectContext;
    }
    
    if (firstLaunch) {
        [MeterType createMeterTypeWithType:@"Villanyóra" inManagedObjectContext:self.managedObjectContext];
        [MeterType createMeterTypeWithType:@"Gázóra" inManagedObjectContext:self.managedObjectContext];
        [MeterType createMeterTypeWithType:@"Vízóra" inManagedObjectContext:self.managedObjectContext];
        firstLaunch = NO;
    }
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
        request.predicate = nil; //all Places
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

#pragma mark UITableView methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Place"];
    
    Place *place = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = place.name;
    cell.detailTextLabel.text = place.city;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [Place deletePlace:[self.fetchedResultsController objectAtIndexPath:indexPath] inManagedObjectContext:self.managedObjectContext];
    }
}

#pragma mark UIStoryboardSegue methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowPlaceDetails"]) {
        PlacesDetailTableViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.place = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
    }
}

- (IBAction)doneAddingPlace:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"ReturnPlaceAddingInput"]) {
        NSLog(@"Segue identified: %@", [segue identifier]);
        AddPlaceViewController *addController = [segue sourceViewController];
        
        if ((addController.name) && (addController.city) && (addController.street)) {
            NSLog(@"Place to add: %@ - %@, %@", addController.name, addController.city, addController.street);
            [Place placeWithName:addController.name
                            city:addController.city
                          street:addController.street
          inManagedObjectContext:self.managedObjectContext];
        }
        
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (IBAction)cancelAddingPlace:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"CancelPlaceAddingInput"]) {
        NSLog(@"Segue identified: %@", [segue identifier]);
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

@end
