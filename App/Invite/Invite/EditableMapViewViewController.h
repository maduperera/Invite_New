//
//  EditableMapViewViewController.h
//  Invite
//
//  Created by Madusha Perera on 3/31/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface EditableMapViewViewController : UIViewController<MKMapViewDelegate, MKReverseGeocoderDelegate>

@property(weak,nonatomic)MKPointAnnotation *centerAnnotation;
@property (weak, nonatomic) IBOutlet MKMapView *editableMapView;

@end
