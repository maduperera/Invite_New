//
//  InvitationViewController.h
//  Invite
//
//  Created by Madusha Perera on 3/29/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "qrencode.h"

@interface InvitationViewController : UIViewController<MKMapViewDelegate, MKReverseGeocoderDelegate>

@property(nonatomic,weak) PFObject *event;
@property (weak, nonatomic) IBOutlet UILabel *invitationTitle;
@property (weak, nonatomic) IBOutlet UITextView *invitationAddress;
@property (weak, nonatomic) IBOutlet UILabel *invitationDate;
@property (weak, nonatomic) IBOutlet UILabel *invitationFrom;
@property (weak, nonatomic) IBOutlet UILabel *invitationTo;
@property (weak, nonatomic) IBOutlet UILabel *invitationContactNo;
@property (weak, nonatomic) IBOutlet MKMapView *invitationMap;
@property(assign,nonatomic) CLLocationCoordinate2D location;
@property (readwrite) CLLocationDegrees latitude;
@property (readwrite) CLLocationDegrees longitude;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UISwitch *eventCancelSwitch;

- (IBAction)cancel:(id)sender;

//@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;

@property (weak, nonatomic) IBOutlet UIImageView *eventLocation;
@property (weak, nonatomic) IBOutlet UITextView *eventLocationAddress;
@property (weak, nonatomic) IBOutlet UIImageView *eventOrganizer;
@property (weak, nonatomic) IBOutlet UIImageView *phoneCalender;
@property (weak, nonatomic) IBOutlet UISwitch *eventStatus;

@end
