//
//  ReadingsCDTVC.m
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.16..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "ReadingsCDTVC.h"
#import "CDConnectionHandler.h"
#import "AddReadingViewController.h"
#import "ReadingsDetailTableViewController.h"
#import "Reading+Methods.h"
#import "Meter+Methods.h"
#import "MeterType.h"
#import "Place.h"

@implementation ReadingsCDTVC

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
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reading"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO], [NSSortDescriptor sortDescriptorWithKey:@"forMeter.atLocation.name" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"forMeter.ofType.type" ascending:YES]];
        request.predicate = nil; //all Readings
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

#pragma mark UITableView methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Reading"];
    
    NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy.MM.dd."];
    }
    
    Reading *reading = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@, %@", reading.forMeter.atLocation.name, [reading.forMeter.ofType.type lowercaseString]];
    cell.detailTextLabel.text = [formatter stringFromDate:reading.date];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [Reading deleteReading:[self.fetchedResultsController objectAtIndexPath:indexPath] inManagedObjectContext:self.managedObjectContext];
    }
}

#pragma mark UIStoryboardSegue methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"AddReading"]) {
        AddReadingViewController *addController = (AddReadingViewController *)[[segue destinationViewController] topViewController];
        
        NSLog(@"addController class: %@", addController.class);
        NSLog(@"ReadingsCDTVC.managedObjectContext: %@", self.managedObjectContext);
        
        addController.meterPickerContent = [Meter allMetersInManagedObjectContext:self.managedObjectContext];
    } else if ([[segue identifier] isEqualToString:@"ShowReadingDetails"]) {
        ReadingsDetailTableViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.reading = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];        
    }
}

- (IBAction)doneAddingReading:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"ReturnReadingAddingInput"]) {
        NSLog(@"Segue identified: %@", [segue identifier]);
        AddReadingViewController *addController = [segue sourceViewController];
        
        if (!addController.selectedMeter) {
            addController.selectedMeter = [addController.meterPickerContent objectAtIndex:0];
        }
        
        if ((addController.value) && (addController.selectedDate) && (addController.selectedMeter)) {
            
            NSLog(@"Reading to add: %@ on %@ for %@", addController.value, addController.selectedDate, addController.selectedMeter);
            [Reading readingWithValue:addController.value date:addController.selectedDate forMeter:addController.selectedMeter inManagedObjectContext:self.managedObjectContext];
        }
        
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (IBAction)cancelAddingReading:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"CancelReadingAddingInput"]) {
        NSLog(@"Segue identified: %@", [segue identifier]);
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

@end
