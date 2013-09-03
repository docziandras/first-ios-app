//
//  NotificationHandler.m
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.25..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "NotificationHandler.h"

#define ONE_DAY_BEFORE -60*60*24

@implementation NotificationHandler

+ (void)addNotificationWithName:(NSString *)name relativeToDate:(NSDate *)date withBody:(NSString *)body
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    //csak a datum kinyeresere a hataridobol
    NSDateFormatter *dueDateFormatter = nil;
    if (dueDateFormatter == nil) {
        dueDateFormatter = [[NSDateFormatter alloc] init];
        [dueDateFormatter setDateFormat:@"yyyy.MM.dd."];
    }
    
    NSString *dueDateString = [dueDateFormatter stringFromDate:date];
    NSDate *dueDate = [dueDateFormatter dateFromString:dueDateString];

    //emlekezteto napjanak megvalasztasa
    NSDate *notificationDate;
    
    if ([name isEqualToString:@"Aznap"]) {
        notificationDate = dueDate;
    } else if ([name isEqualToString:@"Egy nappal előtte"]) {
        notificationDate = [NSDate dateWithTimeInterval:ONE_DAY_BEFORE sinceDate:dueDate];
    } else if ([name isEqualToString:@"Két nappal előtte"]) {
        notificationDate = [NSDate dateWithTimeInterval:2*ONE_DAY_BEFORE sinceDate:dueDate];
    } else if ([name isEqualToString:@"Három nappal előtte"]) {
        notificationDate = [NSDate dateWithTimeInterval:3*ONE_DAY_BEFORE sinceDate:dueDate];
    } else if ([name isEqualToString:@"Egy héttel előtte"]) {
        notificationDate = [NSDate dateWithTimeInterval:7*ONE_DAY_BEFORE sinceDate:dueDate];
    } else if ([name isEqualToString:@"Két héttel előtte"]) {
        notificationDate = [NSDate dateWithTimeInterval:14*ONE_DAY_BEFORE sinceDate:dueDate];
    } else NSLog(@"Error defining notification type from name: %@", name);
    
    //emlekezteto formatuma
    NSDateFormatter *notificationFormatter = nil;
    if (notificationFormatter == nil) {
        notificationFormatter = [[NSDateFormatter alloc] init];
        [notificationFormatter setDateFormat:@"yyyy.MM.dd. HH:mm:ss"];
    }
    
    //emlekezteto datumahoz az idopont hozzarendelese
    NSString *eventString = [NSString stringWithFormat:@"%@ 08:00:00", [dueDateFormatter stringFromDate:notificationDate]];
    NSDate *eventDate = [notificationFormatter dateFromString:eventString];
    
    //emlekezteto letrehozasa
    notification.fireDate = eventDate;
    notification.alertAction = nil;
    notification.alertBody = body;
    notification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    NSLog(@"Notification with body: %@ is added: %@", body, notification);
}

@end
