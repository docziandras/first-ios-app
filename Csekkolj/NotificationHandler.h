//
//  NotificationHandler.h
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.25..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationHandler : NSObject

+ (void)addNotificationWithName:(NSString *)name relativeToDate:(NSDate *)date withBody:(NSString *)body;

@end
