//
//  InvitationViewController.m
//  Invite
//
//  Created by Madusha Perera on 3/29/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import "InvitationViewController.h"
#import "StaticMapViewViewController.h"


@interface InvitationViewController ()

@end

@implementation InvitationViewController
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
    self.invitationTitle.text = [self.event objectForKey:@"title"];
    self.invitationAddress.text = [self.event objectForKey:@"address"];
    self.invitationFrom.text = [self.event objectForKey:@"startTime"];
    self.invitationTo.text = [self.event objectForKey:@"endTime"];
    self.invitationContactNo.text = [self.event objectForKey:@"contactNo"];
    self.invitationDate.text = [self.event objectForKey:@"eventDate"];
  
    self.latitude = [[self.event objectForKey:@"geoPoint"] latitude];
    self.longitude = [[self.event objectForKey:@"geoPoint"] longitude];
    self.location = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    
    //add gesture recognizer to the map view to be able to select and push a new view controller
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnMap:)];
    [tap setNumberOfTapsRequired:1];
    [self.invitationMap addGestureRecognizer: tap];

}

// handle tap even on map view
-(void) handleTapOnMap:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        StaticMapViewViewController *mapController = [self.storyboard instantiateViewControllerWithIdentifier:@"StaticMap"];
        mapController.event = self.event;
        [self.navigationController pushViewController:mapController animated:YES];
    }
}


-(void)viewDidAppear:(BOOL)animated{

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.location, 800, 800);
    
    //MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.location.coordinate, 800, 800);
    
    [self.invitationMap setRegion:[self.invitationMap regionThatFits:region] animated:YES];
    
    // Add an annotation
    point = [[MKPointAnnotation alloc] init];
    //    point.coordinate = mapView.centerCoordinate;
    point.coordinate = self.location;
    point.title = @"Event takes place at here!";
    point.subtitle = @"I'm here at the moment";
    
    //remove duplicating annotations
    if([[self.invitationMap annotations]count] > 1){
        [self.invitationMap removeAnnotations:self.invitationMap.annotations];
    }
    
    // add an annotation in the middle of the map
    [self.invitationMap addAnnotation:point];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    NSLog(@"prepareForSegue: %@", segue.identifier);
//       if ([segue.identifier isEqualToString:@"toStaticMap"]) {
//        StaticMapViewViewController *staticMap = segue.destinationViewController;
//        staticMap.event = self.event;
//        [staticMap viewDidLoad];
//    }
//    
//}

@end
