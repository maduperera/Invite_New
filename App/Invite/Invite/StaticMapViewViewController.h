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

typedef enum UICGTravelModes {
	UICGTravelModeDriving, // G_TRAVEL_MODE_DRIVING
	UICGTravelModeWalking  // G_TRAVEL_MODE_WALKING
} UICGTravelModes;



@interface StaticMapViewViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate ,MKAnnotation ,MKOverlay>

@property(weak,nonatomic)MKPointAnnotation *centerAnnotation;
@property(weak,nonatomic) id<ComposerDelegate> delegate;
@property(weak,nonatomic) PFObject *event;
@property(assign,nonatomic) CLLocationCoordinate2D location;
@property (readwrite) CLLocationDegrees latitude;
@property (readwrite) CLLocationDegrees longitude;
@property (weak, nonatomic) IBOutlet MKMapView *staticMapView;
-(MKPolyline *)polylineWithEncodedString:(NSString *)encodedString ;
-(void)addAnnotationSrcAndDestination :(CLLocationCoordinate2D )srcCord :(CLLocationCoordinate2D)destCord;

@property (nonatomic, retain) NSString *startPoint;
@property (nonatomic, retain) NSString *endPoint;
@property (nonatomic, retain) NSArray *wayPoints;
@property (nonatomic) UICGTravelModes travelMode;
@end
