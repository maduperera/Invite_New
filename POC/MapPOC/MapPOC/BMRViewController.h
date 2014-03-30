//
//  BMRViewController.h
//  MapPOC
//
//  Created by Madusha Perera on 3/30/14.
//  Copyright (c) 2014 Madusha Perera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface BMRViewController : UIViewController <MKMapViewDelegate, MKReverseGeocoderDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(weak,nonatomic)MKPointAnnotation *centerAnnotation;
@end
