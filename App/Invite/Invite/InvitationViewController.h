//
//  InvitationViewController.h
//  Invite
//
//  Created by Madusha Perera on 3/29/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface InvitationViewController : UIViewController<MKMapViewDelegate, MKReverseGeocoderDelegate>

@property(nonatomic,weak) PFObject *event;
@property (weak, nonatomic) IBOutlet UILabel *invitationTitle;
@property (weak, nonatomic) IBOutlet UILabel *invitationAddress;
@property (weak, nonatomic) IBOutlet UILabel *invitationDate;
@property (weak, nonatomic) IBOutlet UILabel *invitationFrom;
@property (weak, nonatomic) IBOutlet UILabel *invitationTo;
@property (weak, nonatomic) IBOutlet UILabel *invitationContactNo;
@property (weak, nonatomic) IBOutlet MKMapView *invitationMap;
@property(assign,nonatomic) CLLocationCoordinate2D location;
@property (readwrite) CLLocationDegrees latitude;
@property (readwrite) CLLocationDegrees longitude;


@end
