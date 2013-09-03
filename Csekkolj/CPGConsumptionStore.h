//
//  CPGConsumptionStore.h
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.26..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPGConsumptionStore : NSObject

+ (CPGConsumptionStore *)sharedInstance;

- (NSArray *)tickerSymbols;
- (NSArray *)dates;
- (NSArray *)consumption:(NSString *)tickerSymbol;

@end
