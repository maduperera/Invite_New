//
//  ComposeNewInviteViewController.h
//  Invite
//
//  Created by Madusha Perera on 3/28/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MapKit/MapKit.h>
#import "ComposerDelegate.h"



@interface ComposeNewInviteViewController : UIViewController<UITextFieldDelegate, ABPeoplePickerNavigationControllerDelegate, MKMapViewDelegate, ComposerDelegate, MKReverseGeocoderDelegate>

@property (weak, nonatomic) IBOutlet UITextField *event_title;
@property (weak, nonatomic) IBOutlet UITextField *event_start_time;
@property (weak, nonatomic) IBOutlet UITextField *event_end_time;
@property (weak, nonatomic) IBOutlet UITextField *event_date;
@property (weak, nonatomic) IBOutlet UITextField *event_address;
@property (weak, nonatomic) IBOutlet UITextField *event_contatctNo;
@property (weak, nonatomic) IBOutlet UITextField *event_to;
@property (weak, nonatomic) IBOutlet MKMapView *map;

@property(strong,nonatomic) PFGeoPoint *geoPoint;
@property(weak, nonatomic) PFObject *templateObj;
@property(weak,nonatomic) NSArray *usersWithSMSOnly;
@property(weak,nonatomic) NSArray *usersWithEmail;
@property(weak, nonatomic) IBOutlet UIButton *SendButton;
@property(assign,nonatomic) CLLocationCoordinate2D location;

- (IBAction)pickStartTime:(id)sender;
- (IBAction)pickStartTime:(id)sender;
- (IBAction)pickEndTime:(id)sender;
- (IBAction)barBtnCancel:(id)sender;
- (IBAction)barBtnSend:(id)sender;


- (IBAction)cancel:(id)sender;
- (IBAction)send:(id)sender;
- (IBAction)pickDate:(id)sender;
- (IBAction)addReciever:(id)sender;

@end
