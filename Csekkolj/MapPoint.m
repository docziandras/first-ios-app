//
//  MapPoint.m
//  GooglePlaces
//
//  Created by András Dóczi on 2013.02.21..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import "MapPoint.h"

@implementation MapPoint

- (id)initWithName:(NSString *)name address:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate
{
    if (self = [super init]) {
        _name = [name copy];
        _address = [address copy];
        _coordinate = coordinate;
    }
    
    return self;
}

- (NSString *)title
{
    if ([_name isKindOfClass:[NSNull class]])
        return @"Unknown charge";
    else
        return _name;
}

- (NSString *)subtitle
{
    return _address;
}

@end
