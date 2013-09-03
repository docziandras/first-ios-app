//
//  MetersCDTVC.m
//  Csekkolj
//
//  Created by András Dóczi on 2013.03.27..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "MetersCDTVC.h"
#import "CDConnectionHandler.h"
#import "MetersDetailTableViewController.h"
#import "AddMeterViewController.h"
#import "Meter+Methods.h"
#import "MeterType+Methods.h"
#import "Place+Methods.h"

@implementation MetersCDTVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.managedObjectContext) {
        self.managedObjectContext = [CDConnectionHandler sharedInstance].managedObjectContext;
    }
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Meter"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"atLocation.name" ascending:YES],
                                    [NSSortDescriptor sortDescriptorWithKey:@"ofType.type" ascending:YES]];
        request.predicate = nil; //all Meters
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

#pragma mark UITableView methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Meter"];
    
    Meter *meter = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = meter.atLocation.name;
    cell.detailTextLabel.text = meter.ofType.type;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [Meter deleteMeter:[self.fetchedResultsController objectAtIndexPath:indexPath] inManagedObjectContext:self.managedObjectContext];
    }
}

#pragma mark UIStoryboardSegue methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"AddMeter"]) {
        AddMeterViewController *addController = (AddMeterViewController *)[[segue destinationViewController] topViewController];
        
        NSLog(@"addController class: %@", addController.class);
        NSLog(@"MetersCDTVC.managedObjectContext: %@", self.managedObjectContext);
        
        addController.typePickerContent = [MeterType allMeterTypesInManagedObjectContext:self.managedObjectContext];
        addController.placePickerContent = [Place allPlacesInManagedObjectContext:self.managedObjectContext];
    } else if ([[segue identifier] isEqualToString:@"ShowMeterDetails"]) {
        MetersDetailTableViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.meter = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];        
    }
}

- (IBAction)doneAddingMeter:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"ReturnMeterAddingInput"]) {
        NSLog(@"Segue identified: %@", [segue identifier]);
        AddMeterViewController *addController = [segue sourceViewController];
        
        if (!addController.selectedType) {
            addController.selectedType = [addController.typePickerContent objectAtIndex:0];
        }
        
        if (!addController.selectedPlace) {
            addController.selectedPlace = [addController.placePickerContent objectAtIndex:0];
        }
        
        if ((addController.meterNumber) && (addController.partnerNumber) && (addController.selectedPlace) && (addController.selectedType)) {
            
            NSLog(@"Meter to add: %@ number %@ - %@ at %@", addController.selectedType, addController.meterNumber, addController.partnerNumber, addController.selectedPlace);
            [Meter meterWithMeterNumber:addController.meterNumber partnerNumber:addController.partnerNumber atLocation:addController.selectedPlace ofType:addController.selectedType inManagedObjectContext:self.managedObjectContext];
        }
        
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (IBAction)cancelAddingMeter:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"CancelMeterAddingInput"]) {
        NSLog(@"Segue identified: %@", [segue identifier]);
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

@end
