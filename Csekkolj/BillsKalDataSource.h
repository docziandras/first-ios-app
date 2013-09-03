//
//  BillsKalDataSource.h
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.19..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataTableViewController.h"
#import "Kal.h"
#import "Bill.h"

@interface BillsKalDataSource : NSObject <KalDataSource>

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *bills;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

+ (BillsKalDataSource *)dataSource;
- (Bill *)billAtIndexPath:(NSIndexPath *)indexPath;

@end
