//
//  CDConnectionHandler.m
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.26..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "CDConnectionHandler.h"

@implementation CDConnectionHandler

- (id)init
{
    self = [super init];
    
    if (!_managedObjectContext) [self useDocument];
    
    return self;
}

#pragma mark Class methods

+ (CDConnectionHandler *)sharedInstance
{
    static CDConnectionHandler *sharedInstance;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)useDocument
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"database"];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success) {
                  self.managedObjectContext = document.managedObjectContext;
                  NSLog(@"CDConnectionHandler.managedObjectContext: %@", self.managedObjectContext);
              }
          }];
    } else if (document.documentState == UIDocumentStateClosed) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                self.managedObjectContext = document.managedObjectContext;
                NSLog(@"CDConnectionHandler.managedObjectContext: %@", self.managedObjectContext);
            }
        }];
    } else {
        self.managedObjectContext = document.managedObjectContext;
        NSLog(@"CDConnectionHandler.managedObjectContext: %@", self.managedObjectContext);
    }
}


@end
