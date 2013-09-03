//
//  MapViewController.m
//  GooglePlaces
//
//  Created by András Dóczi on 2013.02.19..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//
//
//  Az iOS API hibája miatt a mapview:regionDidChangeAnimated: delegált
//  metódus esetenként nem hívódik meg, ha a felhasználó interakcióba lép
//  a térképpel. A hibát többen jelentették, és regisztálták is. Egy javaslat
//  a megoldásra, ha explicit módon deklarálunk gesztusérzékelőket, amely
//  esetemben szintén nem vezetett eredményre. A vonatkozó kódot kommentben
//  bent hagytam a forrásban.
//
//  A hiba azt eredményezi, hogy a térképfunkció jelenleg fix pozícióra
//  működik, amelyet futtatáskor a Debug Area területről lehet szimulálni.
//  A szimulált pozíciót tartalmazó .gpx fájl része a projektnek. A térképpel
//  való interakció során keresni kívánt lokációk számított helyét szintén
//  kommentben tartalmazza a forráskód.

#import "MapViewController.h"

@interface MapViewController ()

- (IBAction)locationArrowPressed:(UIButton *)sender;
- (IBAction)mapTypeButtonPressed:(UIBarButtonItem *)sender;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    /*if (NSFoundationVersionNumber >= 678.58){
        
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureCaptured:)];
        pinch.delegate = self;
        [_mapView addGestureRecognizer:pinch];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureCaptured:)];
        pan.delegate = self;
        [_mapView addGestureRecognizer:pan];
    }*/
    
    self.mapView.delegate = self;
    [self.mapView setShowsUserLocation:YES];
    
    locationManager = [[CLLocationManager alloc] init];
    
    [locationManager setDelegate:self];
    
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    firstLaunch = YES;
    [self queryGooglePlaces];
}

- (IBAction)refreshButtonPressed:(id)sender
{
    [self queryGooglePlaces];
}

- (IBAction)mapTypeButtonPressed:(UIBarButtonItem *)sender
{
    if (self.mapView.mapType == MKMapTypeStandard) {
        self.mapView.mapType = MKMapTypeSatellite;
        sender.title = @"Hibrid";
    } else if (self.mapView.mapType == MKMapTypeSatellite) {
        self.mapView.mapType = MKMapTypeHybrid;
        sender.title = @"Térkép";
    } else {
        self.mapView.mapType = MKMapTypeStandard;
        sender.title = @"Műhold";
    }
}

- (IBAction)locationArrowPressed:(UIButton *)sender
{
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate, 1000, 1000) animated:YES];
}

- (void)queryGooglePlaces
{
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=47.089119,17.905064&radius=1000&types=%@&sensor=true&key=%@", @"post_office", GOOGLE_API_KEY];
    //NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&types=%@&sensor=true&key=%@", currentCenter.latitude, currentCenter.longitude, [NSString stringWithFormat:@"%i", currentViewingDistance], @"post_office", GOOGLE_API_KEY];
    
    NSLog(@"Latitude: %f", currentCenter.latitude);
    NSLog(@"Longitude: %f", currentCenter.longitude);
    NSLog(@"Zoom level: %i", currentViewingDistance);
    
    NSURL *googleRequestURL = [NSURL URLWithString:url];
    
    dispatch_async(kBgQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

#pragma mark - MKMapViewDelegate methods
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    //CLLocationCoordinate2D center = [mv centerCoordinate];
    MKCoordinateRegion region;
    
    //if (firstLaunch) {
        region = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate, 1000, 1000);
        firstLaunch = NO;
    /*} else {
        region =  MKCoordinateRegionMakeWithDistance(center, currentViewingDistance, currentViewingDistance);
    }*/
    
    [mv setRegion:region animated:YES];
}

- (void)mapview:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    MKMapRect currentView = self.mapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(currentView), MKMapRectGetMidY(currentView));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(currentView), MKMapRectGetMidY(currentView));
    
    NSLog(@"East map point: %f,%f", eastMapPoint.x, eastMapPoint.y);
    NSLog(@"West map point: %f,%f", westMapPoint.x, westMapPoint.y);
    
    
    currentViewingDistance = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    currentCenter = self.mapView.centerCoordinate;
    NSLog(@"Region changed to %f,%f", currentCenter.latitude, currentCenter.longitude);
    
}

- (void)fetchedData:(NSData *)responseData
{
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:kNilOptions
                                                           error:&error];
    
    NSArray *places = [json objectForKey:@"results"];
    
    NSLog(@"Google Data: %@", places);
    
    [self plotPositions:places];
}

- (void)plotPositions:(NSArray *)data
{
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        if ([annotation isKindOfClass:[MapPoint class]]) {
            [self.mapView removeAnnotation:annotation];
        }
    }
    
    for (int i=0; i<[data count]; i++) {
        NSDictionary *place = [data objectAtIndex:i];
        NSDictionary *geo = [place objectForKey:@"geometry"];
        NSDictionary *location = [geo objectForKey:@"location"];
        NSString *name = [place objectForKey:@"name"];
        NSString *vicinity = [place objectForKey:@"vicinity"];
        
        CLLocationCoordinate2D placeCoordinates;
        placeCoordinates.latitude = [[location objectForKey:@"lat"] doubleValue];
        placeCoordinates.longitude = [[location objectForKey:@"lng"] doubleValue];
        
        MapPoint *placeObject = [[MapPoint alloc] initWithName:name address:vicinity coordinate:placeCoordinates];
        
        [self.mapView addAnnotation:placeObject];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *identifier = @"MapPoint";
    
    if ([annotation isKindOfClass:[MapPoint class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        return annotationView;
    }
    
    return nil;
}

/*#pragma mark - UIGestureRecognizerDelegate methods

- (void)pinchGestureCaptured:(UIPinchGestureRecognizer*)gesture{
    if(UIGestureRecognizerStateEnded == gesture.state){
        //aktualis nagyitas szamitasa a terkep legnyugatibb es legkeletibb pontjaibol
        MKMapRect currentView = self.mapView.visibleMapRect;
        MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(currentView), MKMapRectGetMidY(currentView));
        MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(currentView), MKMapRectGetMidY(currentView));
        
        NSLog(@"East map point: %f,%f", eastMapPoint.x, eastMapPoint.y);
        NSLog(@"West map point: %f,%f", westMapPoint.x, westMapPoint.y);
        
        
        currentViewingDistance = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
        currentCenter = self.mapView.centerCoordinate;
        NSLog(@"Region changed to %f,%f", currentCenter.latitude, currentCenter.longitude);
    }
}

- (void)panGestureCaptured:(UIPanGestureRecognizer*)gesture{
    if(UIGestureRecognizerStateEnded == gesture.state){
        
        
        NSLog(@"panGestureCaptured ended");
        //aktualis nagyitas szamitasa a terkep legnyugatibb es legkeletibb pontjaibol
        MKMapRect currentView = self.mapView.visibleMapRect;
        MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(currentView), MKMapRectGetMidY(currentView));
        MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(currentView), MKMapRectGetMidY(currentView));
        
        NSLog(@"East map point: %f,%f", eastMapPoint.x, eastMapPoint.y);
        NSLog(@"West map point: %f,%f", westMapPoint.x, westMapPoint.y);
        
        
        currentViewingDistance = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
        currentCenter = self.mapView.centerCoordinate;
        NSLog(@"Region changed to %f,%f", currentCenter.latitude, currentCenter.longitude);    }
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:   (UITouch *)touch{
    return YES;
}
*/
@end
