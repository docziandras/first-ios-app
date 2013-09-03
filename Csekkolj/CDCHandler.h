//
//  CDCHandler.h
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.26..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDCHandler : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

+ (CDCHandler *)sharedInstance;

@end
