//
//  mapPopupViewController.m
//  Invite
//
//  Created by Dhammini on 4/27/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import "mapPopupViewController.h"

@interface mapPopupViewController ()

@end

@implementation mapPopupViewController

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
    
    self.latitude = [[self.event objectForKey:@"geoPoint"] latitude];
    self.longitude = [[self.event objectForKey:@"geoPoint"] longitude];
    self.location = CLLocationCoordinate2DMake(self.latitude, self.longitude);
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.location, 800, 800);
    
    //MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.location.coordinate, 800, 800);
    
    [self.staticMapView setRegion:[self.staticMapView regionThatFits:region] animated:YES];
    
    // Add an annotation
    point = [[MKPointAnnotation alloc] init];
    //    point.coordinate = mapView.centerCoordinate;
    point.coordinate = self.location;
    point.title = @"Event takes place at here!";
    point.subtitle = @"I'm here at the moment";
    
    //remove duplicating annotations
    if([[self.staticMapView annotations]count] > 1){
        [self.staticMapView removeAnnotations:self.staticMapView.annotations];
    }
    
    // add an annotation in the middle of the map
    [self.staticMapView addAnnotation:point];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
