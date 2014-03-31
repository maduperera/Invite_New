//
//  BMRViewController.m
//  MapPOC
//
//  Created by Madusha Perera on 3/30/14.
//  Copyright (c) 2014 Madusha Perera. All rights reserved.
//

#import "BMRViewController.h"

@interface BMRViewController ()

@end

@implementation BMRViewController
//MKReverseGeocoder *reverseGeocoder;
NSMutableArray* arrNotification;
MKPointAnnotation *point;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
//    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    // Add an annotation
    point = [[MKPointAnnotation alloc] init];
//    [point ]
    point.coordinate = mapView.centerCoordinate;;
    point.title = @"Darg to the place you want!";
    point.subtitle = @"I'm here at the moment";
    self.centerAnnotation = point;
    
    [self.mapView addAnnotation:self.centerAnnotation];
   // [self.mapView addAnnotation:point];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    self.centerAnnotation.coordinate = mapView.centerCoordinate;
    self.centerAnnotation.subtitle = [NSString stringWithFormat:@"%f, %f", self.centerAnnotation.coordinate.latitude, self.centerAnnotation.coordinate.longitude];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    //[self.mapView removeAnnotation:point];
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *reuseId = @"pin";
    MKPinAnnotationView *pav = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (pav == nil)
    {
        pav = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        pav.draggable = YES;
        pav.canShowCallout = YES;
    }
    else
    {
        pav.annotation = annotation;
    }
    
    return pav;
}



@end
