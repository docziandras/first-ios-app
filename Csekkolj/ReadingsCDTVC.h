//
//  ReadingsCDTVC.h
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.16..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface ReadingsCDTVC : CoreDataTableViewController
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end
