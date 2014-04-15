//
//  StaticMapViewViewController.h
//  Invite
//
//  Created by Madusha Perera on 4/1/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ComposerDelegate.h"
#import "BlurViewController.h"


@interface StaticMapViewViewController : BlurViewController

@property(weak,nonatomic)MKPointAnnotation *centerAnnotation;
@property(weak,nonatomic) id<ComposerDelegate> delegate;
@property(weak,nonatomic) PFObject *event;
@property(assign,nonatomic) CLLocationCoordinate2D location;
@property (readwrite) CLLocationDegrees latitude;
@property (readwrite) CLLocationDegrees longitude;
@property (weak, nonatomic) IBOutlet MKMapView *staticMapView;

@end
