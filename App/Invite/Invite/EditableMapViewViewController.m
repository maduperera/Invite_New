//
//  EditableMapViewViewController.m
//  Invite
//
//  Created by Madusha Perera on 3/31/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import "EditableMapViewViewController.h"

@interface EditableMapViewViewController ()

@end

@implementation EditableMapViewViewController

NSMutableArray* arrNotification;
MKPointAnnotation *point;

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
	// Do any additional setup after loading the view.
     self.editableMapView.delegate = self;
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
    [self.editableMapView setRegion:[self.editableMapView regionThatFits:region] animated:YES];
    
    // Add an annotation
    point = [[MKPointAnnotation alloc] init];
    point.coordinate = mapView.centerCoordinate;;
    point.title = @"Darg to the place you want!";
    point.subtitle = @"I'm here at the moment";
    self.centerAnnotation = point;
    
    
    //remove duplicating annotations
    if([[mapView annotations]count] > 1){
        NSInteger toRemoveCount = mapView.annotations.count;
        NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:toRemoveCount];
        for (id annotation in mapView.annotations)
            if (annotation != mapView.userLocation)
                [toRemove addObject:annotation];
        [mapView removeAnnotations:toRemove];
    }

    // add an annotation in the middle of the map
    [self.editableMapView addAnnotation:self.centerAnnotation];
    
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
