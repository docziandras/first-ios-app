//
//  MapViewController.h
//  GooglePlaces
//
//  Created by András Dóczi on 2013.02.19..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapPoint.h"

#define GOOGLE_API_KEY @"AIzaSyBfrEXOwbD0FmmmpbnfilvX8lCEdgc1tiE"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate/*, UIGestureRecognizerDelegate*/>

{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentCenter;
    int currentViewingDistance;
    BOOL firstLaunch;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
