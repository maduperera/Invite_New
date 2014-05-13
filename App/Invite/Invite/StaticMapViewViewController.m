//
//  StaticMapViewViewController.m
//  Invite
//
//  Created by Madusha Perera on 4/1/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import "StaticMapViewViewController.h"

@interface StaticMapViewViewController ()

@end



#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0)
#define kBaseUrl @"http://maps.googleapis.com/maps/api/directions/json?"
#define kBaseUrl2 @"http://maps.google.com/maps/api/geocode/json?"


@implementation StaticMapViewViewController

MKPointAnnotation *point;
CLLocationManager *locationManager;
NSDictionary *dictRouteInfo;
BOOL isVisible;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.latitude = [[self.event objectForKey:@"geoPoint"] latitude];
    self.longitude = [[self.event objectForKey:@"geoPoint"] longitude];
    self.location = CLLocationCoordinate2DMake(self.latitude, self.longitude);
	// Do any additional setup after loading the view.
    
    
    
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.location, 800, 800);
    
    [self.staticMapView setRegion:[self.staticMapView regionThatFits:region] animated:YES];
    
    // Add an annotation
    point = [[MKPointAnnotation alloc] init];
    //    point.coordinate = mapView.centerCoordinate;
    point.coordinate = self.location;
    point.title = @"Event takes place at here!";
    point.subtitle = @"I'm here at the moment";
    
//    //remove duplicating annotations
//    if([[self.staticMapView annotations]count] > 1){
//        [self.staticMapView removeAnnotations:self.staticMapView.annotations];
//    }
    
    // add an annotation in the middle of the map
//    [self.staticMapView addAnnotation:point];
    
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    
//    _startPoint = @"6.9270786,79.861243"; //lat,lonv -> colombo
//    _endPoint = @"7.1894643,79.858734"; //lat,lon -> negombo
    _travelMode = UICGTravelModeDriving;
    self.staticMapView.delegate = self;
    
    
// _startPoint = [NSString stringWithFormat:@"%@,%@",
//     [[NSNumber numberWithDouble:[[[self.theMapView userLocation] location] coordinate].latitude] stringValue],
//     [[NSNumber numberWithDouble:[[[self.theMapView userLocation] location] coordinate].longitude] stringValue]];
    
 _endPoint =   [NSString stringWithFormat:@"%@,%@",
     [[NSNumber numberWithDouble: self.location.latitude ] stringValue],
    [[NSNumber numberWithDouble: self.location.longitude ] stringValue]];
    
    
//    dispatch_async(kBgQueue, ^{
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        NSString *strUrl;
//        
//        if (_wayPoints.count>0) {
//            strUrl= [NSString stringWithFormat:@"%@origin=%@&destination=%@&sensor=true&waypoints=optimize:true",kBaseUrl,_startPoint,_endPoint];
//            for (NSString *strViaPoint in _wayPoints) {
//                strUrl=[strUrl stringByAppendingFormat:@"|via:%@",strViaPoint];
//            }
//        }
//        else
//        {
//            strUrl=[NSString stringWithFormat:@"%@origin=%@&destination=%@&sensor=true",kBaseUrl,_startPoint,_endPoint];
//        }
//        
//        if (_travelMode==UICGTravelModeWalking) {
//            strUrl=[strUrl stringByAppendingFormat:@"&mode=walking"];
//            //            strUrl=[NSString stringWithFormat:@"%@origin=%@&destination=%@&sensor=true&mode=walking",kBaseUrl,_startPoint,_endPoint];
//        }
//        NSLog(@"%@",strUrl);
//        strUrl=[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSData *data =[NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]];
//        
//        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
//    });
    

    
    
}

-(void)viewDidAppear:(BOOL)animated{
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.location, 800, 800);
//    
    //MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.location.coordinate, 800, 800);
    
//    [self.staticMapView setRegion:[self.staticMapView regionThatFits:region] animated:YES];
//    
//    // Add an annotation
//    point = [[MKPointAnnotation alloc] init];
//    //    point.coordinate = mapView.centerCoordinate;
//    point.coordinate = self.location;
//    point.title = @"Event takes place at here!";
//    point.subtitle = @"I'm here at the moment";
//    
//    //remove duplicating annotations
//    if([[self.staticMapView annotations]count] > 1){
//        [self.staticMapView removeAnnotations:self.staticMapView.annotations];
//    }
//    
//    // add an annotation in the middle of the map
//    [self.staticMapView addAnnotation:point];
//    
//    
//    locationManager = [[CLLocationManager alloc] init];
//    locationManager.delegate = self;
//    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
//    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
//    [locationManager startUpdatingLocation];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    
    // stop listening to the location updates
    [locationManager stopUpdatingLocation];
    
    NSLog(@"Value: %f", newLocation.coordinate.latitude);
    
    
    _startPoint =   [NSString stringWithFormat:@"%@,%@",
                   [[NSNumber numberWithDouble: newLocation.coordinate.latitude ] stringValue],
                   [[NSNumber numberWithDouble: newLocation.coordinate.longitude ] stringValue]];
    
    
    dispatch_async(kBgQueue, ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSString *strUrl;
        
        if (_wayPoints.count>0) {
            strUrl= [NSString stringWithFormat:@"%@origin=%@&destination=%@&sensor=true&waypoints=optimize:true",kBaseUrl,_startPoint,_endPoint];
            for (NSString *strViaPoint in _wayPoints) {
                strUrl=[strUrl stringByAppendingFormat:@"|via:%@",strViaPoint];
            }
        }
        else
        {
            strUrl=[NSString stringWithFormat:@"%@origin=%@&destination=%@&sensor=true",kBaseUrl,_startPoint,_endPoint];
        }
        
        if (_travelMode==UICGTravelModeWalking) {
            strUrl=[strUrl stringByAppendingFormat:@"&mode=walking"];
            //            strUrl=[NSString stringWithFormat:@"%@origin=%@&destination=%@&sensor=true&mode=walking",kBaseUrl,_startPoint,_endPoint];
        }
        NSLog(@"%@",strUrl);
        strUrl=[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *data =[NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]];
        
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });

    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    
}



- (void)getLocation:(NSData *)responseData {
    
    NSError* error;
    
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    NSArray *results=[json objectForKey:@"results"];
    
    NSString * City_lat  =[[json valueForKeyPath:@"results.geometry.location.lat"] objectAtIndex:0];//objectAtIndex:0];
    NSString * City_lon  =[[json valueForKeyPath:@"results.geometry.location.lat"] objectAtIndex:0];//objectAtIndex:0];
    
    NSLog(@"City latitude, longitude :%@,%@",City_lat, City_lon);
    
}


#pragma mark - json parser

- (void)fetchedData:(NSData *)responseData {
    NSError* error;
   
    // stop listening to the location updates
    [locationManager stopUpdatingLocation];

    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    NSArray *arrRouts=[json objectForKey:@"routes"];
    if ([arrRouts isKindOfClass:[NSArray class]]&&arrRouts.count==0) {
        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"didn't find direction" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alrt show];
        
        // if the route can not be dispayed the event location is shown without any route
         [self.staticMapView addAnnotation:point];
        return;
    }
    NSArray *arrDistance =[[[json valueForKeyPath:@"routes.legs.steps.distance.text"] objectAtIndex:0]objectAtIndex:0];
    NSString *totalDuration = [[[json valueForKeyPath:@"routes.legs.duration.text"] objectAtIndex:0]objectAtIndex:0];
    NSString *totalDistance = [[[json valueForKeyPath:@"routes.legs.distance.text"] objectAtIndex:0]objectAtIndex:0];
    NSArray *arrDescription =[[[json valueForKeyPath:@"routes.legs.steps.html_instructions"] objectAtIndex:0] objectAtIndex:0];
    dictRouteInfo=[NSDictionary dictionaryWithObjectsAndKeys:totalDistance,@"totalDistance",totalDuration,@"totalDuration",arrDistance ,@"distance",arrDescription,@"description", nil];
    
    NSArray* arrpolyline = [[[json valueForKeyPath:@"routes.legs.steps.polyline.points"] objectAtIndex:0] objectAtIndex:0]; //2
    double srcLat=[[[[json valueForKeyPath:@"routes.legs.start_location.lat"] objectAtIndex:0] objectAtIndex:0] doubleValue];
    double srcLong=[[[[json valueForKeyPath:@"routes.legs.start_location.lng"] objectAtIndex:0] objectAtIndex:0] doubleValue];
    double destLat=[[[[json valueForKeyPath:@"routes.legs.end_location.lat"] objectAtIndex:0] objectAtIndex:0] doubleValue];
    double destLong=[[[[json valueForKeyPath:@"routes.legs.end_location.lng"] objectAtIndex:0] objectAtIndex:0] doubleValue];
    CLLocationCoordinate2D sourceCordinate = CLLocationCoordinate2DMake(srcLat, srcLong);
    CLLocationCoordinate2D destCordinate = CLLocationCoordinate2DMake(destLat, destLong);
    
    [self addAnnotationSrcAndDestination:sourceCordinate :destCordinate];
    //    NSArray *steps=[[aary objectAtIndex:0]valueForKey:@"steps"];
    
    //    replace lines with this may work
    
    NSMutableArray *polyLinesArray =[[NSMutableArray alloc]initWithCapacity:0];
    
    for (int i = 0; i < [arrpolyline count]; i++)
    {
        NSString* encodedPoints = [arrpolyline objectAtIndex:i] ;
        MKPolyline *route = [self polylineWithEncodedString:encodedPoints];
        [polyLinesArray addObject:route];
    }
    
    [_staticMapView addOverlays:polyLinesArray];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - add annotation on source and destination

-(void)addAnnotationSrcAndDestination :(CLLocationCoordinate2D )srcCord :(CLLocationCoordinate2D)destCord
{
    MKPointAnnotation *sourceAnnotation = [[MKPointAnnotation alloc]init];
    MKPointAnnotation *destAnnotation = [[MKPointAnnotation alloc]init];
    sourceAnnotation.coordinate=srcCord;
    destAnnotation.coordinate=destCord;
    sourceAnnotation.title=_startPoint;
    
    destAnnotation.title=_endPoint;
    
    [self.staticMapView addAnnotation:sourceAnnotation];
    [self.staticMapView addAnnotation:destAnnotation];
    
    MKCoordinateRegion region;
    
    MKCoordinateSpan span;
    span.latitudeDelta=2;
    span.latitudeDelta=2;
    region.center=srcCord;
    region.span=span;
    CLGeocoder *geocoder= [[CLGeocoder alloc]init];
    for (NSString *strVia in _wayPoints) {
        [geocoder geocodeAddressString:strVia completionHandler:^(NSArray *placemarks, NSError *error) {
            if ([placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                CLLocation *location = placemark.location;
                //                CLLocationCoordinate2D coordinate = location.coordinate;
                MKPointAnnotation *viaAnnotation = [[MKPointAnnotation alloc]init];
                viaAnnotation.coordinate=location.coordinate;
                [_staticMapView addAnnotation:viaAnnotation];
                //                NSLog(@"%@",placemarks);
            }
            
        }];
    }
    
    _staticMapView.region=region;
}

#pragma mark - decode map polyline

- (MKPolyline *)polylineWithEncodedString:(NSString *)encodedString {
    const char *bytes = [encodedString UTF8String];
    NSUInteger length = [encodedString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger idx = 0;
    
    NSUInteger count = length / 4;
    CLLocationCoordinate2D *coords = calloc(count, sizeof(CLLocationCoordinate2D));
    NSUInteger coordIdx = 0;
    
    float latitude = 0;
    float longitude = 0;
    while (idx < length) {
        char byte = 0;
        int res = 0;
        char shift = 0;
        
        do {
            byte = bytes[idx++] - 63;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLat = ((res & 1) ? ~(res >> 1) : (res >> 1));
        latitude += deltaLat;
        
        shift = 0;
        res = 0;
        
        do {
            byte = bytes[idx++] - 0x3F;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLon = ((res & 1) ? ~(res >> 1) : (res >> 1));
        longitude += deltaLon;
        
        float finalLat = latitude * 1E-5;
        float finalLon = longitude * 1E-5;
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(finalLat, finalLon);
        coords[coordIdx++] = coord;
        
        if (coordIdx == count) {
            NSUInteger newCount = count + 10;
            coords = realloc(coords, newCount * sizeof(CLLocationCoordinate2D));
            count = newCount;
        }
    }
    
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coords count:coordIdx];
    free(coords);
    
    return polyline;
}
#pragma mark - map overlay
- (MKPolylineRenderer *)mapView:(MKMapView *)mapView
             rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer *overlayView = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    
    //    MKPolylineView *overlayView = [[MKPolylineView alloc] initWithOverlay:overlay];
    overlayView.lineWidth = 2;
    overlayView.strokeColor = [UIColor purpleColor];
    overlayView.fillColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1f];
    return overlayView;
    
}

#pragma mark - map annotation
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if (annotation==_staticMapView.userLocation) {
        return nil;
    }
    static NSString *annotaionIdentifier=@"annotationIdentifier";
    MKPinAnnotationView *aView=(MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:annotaionIdentifier ];
    if (aView==nil) {
        
        aView=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:annotaionIdentifier];
        aView.pinColor = MKPinAnnotationColorRed;
        aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        //        aView.image=[UIImage imageNamed:@"arrow"];
        aView.animatesDrop=TRUE;
        aView.canShowCallout = YES;
        aView.calloutOffset = CGPointMake(-5, 5);
       
        // animate to the location by zooming
         MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.location, 800, 800);
        [_staticMapView setRegion:region animated:YES];
        
    }
	
	return aView;
}
- (void)viewDidUnload
{
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}







@end
