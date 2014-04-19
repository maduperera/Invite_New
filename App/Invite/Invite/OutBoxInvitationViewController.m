//
//  OutBoxInvitationViewController.m
//  Invite
//
//  Created by Madusha Perera on 4/19/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import "OutBoxInvitationViewController.h"
#import "StaticMapViewViewController.h"
#import "QRViewController.h"


@interface OutBoxInvitationViewController ()

@end

@implementation OutBoxInvitationViewController
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
    
    
    self.eventStatus.onTintColor = [UIColor blueColor];
    
    [[self navigationItem] setTitle:[self.event objectForKey:@"title"]];
    
    self.lblStatus.text = @"Cancel the event";

    
    //self.invitationAddress.text = [self.event objectForKey:@"address"];
    self.invitationFrom.text = [NSString stringWithFormat:@"%@ %@", [self.event objectForKey:@"startTime"], @"GMT+5:30"];
    self.invitationTo.text = [self.event objectForKey:@"endTime"];
    self.invitationContactNo.text =[NSString stringWithFormat:@"%@: %@", @"Contact", [self.event objectForKey:@"contactNo"]];
    self.invitationDate.text = [self.event objectForKey:@"eventDate"];
    
    self.latitude = [[self.event objectForKey:@"geoPoint"] latitude];
    self.longitude = [[self.event objectForKey:@"geoPoint"] longitude];
    self.location = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    
    //add gesture recognizer to the map view to be able to select and push a new view controller
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnMap:)];
    //[tap setNumberOfTapsRequired:1];
    //[self.invitationMap addGestureRecognizer: tap];
    
    self.eventLocationAddress.text =[NSString stringWithFormat:@"%@: %@", @"Location", [self.event objectForKey:@"address"]];
    
    
    
    //Create an animation with pulsating effect
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    theAnimation.duration=1.0;
    theAnimation.repeatCount= 1;
    theAnimation.autoreverses=YES;
    theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
    theAnimation.toValue=[NSNumber numberWithFloat:0.1];
    // theAnimation.beginTime = CACurrentMediaTime();
    
    
    
    CABasicAnimation *animationEventOrganizer;
    animationEventOrganizer=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animationEventOrganizer.duration=1.0;
    animationEventOrganizer.repeatCount= 1;
    animationEventOrganizer.autoreverses=YES;
    animationEventOrganizer.fromValue=[NSNumber numberWithFloat:1.0];
    animationEventOrganizer.toValue=[NSNumber numberWithFloat:0.1];
    animationEventOrganizer.beginTime = CACurrentMediaTime()+2.0;
    
    CABasicAnimation *animationEventLocation;
    animationEventLocation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animationEventLocation.duration=1.0;
    animationEventLocation.repeatCount= 1;
    animationEventLocation.autoreverses=YES;
    animationEventLocation.fromValue=[NSNumber numberWithFloat:1.0];
    animationEventLocation.toValue=[NSNumber numberWithFloat:0.1];
    animationEventLocation.beginTime = CACurrentMediaTime()+3.0;
    
    
    
    [self.phoneCalender.layer addAnimation:theAnimation forKey:@"animateOpacity"];
    [self.eventOrganizer.layer addAnimation:animationEventOrganizer forKey:@"animateOpacity"];
    [self.eventLocation.layer addAnimation:animationEventLocation forKey:@"animateOpacity"];
    
    
    
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    
    [self.eventLocation addGestureRecognizer: tap];
    [self.eventLocation setUserInteractionEnabled:YES];
    
    
    
    // ---- QR Code test --------------------------------
    //
    //    NSArray *temp = [[NSArray alloc] init];
    //    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    //
    //
    //    [dict setValue:[self.event objectForKey:@"title"] forKey:@"title"];
    //    [dict setValue:[self.event objectForKey:@"address"] forKey:@"address"];
    //    [dict setValue:[self.event objectForKey:@"startTime"] forKey:@"startTime"];
    //    [dict setValue:[self.event objectForKey:@"endTime"] forKey:@"endTime"];
    //    [dict setValue:[self.event objectForKey:@"contactNo"] forKey:@"contactNo"];
    //    [dict setValue:[self.event objectForKey:@"eventDate"] forKey:@"eventDate"];
    //    [dict setValue:[self.event objectForKey:@"contactNo"] forKey:@"contactNo"];
    //    NSNumber *lat = [NSNumber numberWithDouble:[[self.event objectForKey:@"geoPoint"] latitude]];
    //    NSNumber *lon = [NSNumber numberWithDouble:[[self.event objectForKey:@"geoPoint"] longitude]];
    //    [dict setValue:[lat stringValue]  forKey:@"latitude"];
    //    [dict setValue:[lon stringValue]  forKey:@"longitude"];
    //
    //    //Check the results
    //    NSLog(@"PFObject Info: %@", self.event);
    //    NSLog(@"dict Info: %@", dict);
    //
    //        NSError *error;
    //        NSString *qrCodeString = @"";
    //        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
    //                                                           options:NSJSONWritingPrettyPrinted
    //                                                            error:&error];
    //
    //        if (! jsonData) {
    //            NSLog(@"Got an error: %@", error);
    //        } else {
    //            qrCodeString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //        }
    //    UIImage *image = [self quickResponseImageForString:qrCodeString withDimension:182];
    //
    //    //set the image
    //    [self.qrCodeImageView setImage: image];
    //
    //
    //    // ---------------------------------
    //
    //
    //    NSString *jsonString = qrCodeString;
    //    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    //    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    //    NSLog(@"deode json : %@", json);
    //    NSLog(@"latitude : %@",[json objectForKey:@"latitude"]);
    //
    //
    //    // ---- QR COde Test Ends ------------------------------------
    //
    
    
    // ----------------- setting background image -------------------
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"5S-background_1136*640_4.png"]]];
        
    } else {
        // code for 3.5-inch screen
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
            //Retina Display
            [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"4-background_960*640_4.png"]]];
        } else {
            //Non - Retina Display
            [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"4-background_480*320_4.png"]]];
        }
    }
    
    
    
}



//
//void freeRawData(void *info, const void *data, size_t size) {
//    free((unsigned char *)data);
//}
//
//- (UIImage *)quickResponseImageForString:(NSString *)dataString withDimension:(int)imageWidth {
//
//    QRcode *resultCode = QRcode_encodeString([dataString UTF8String], 0, QR_ECLEVEL_L, QR_MODE_8, 1);
//
//    unsigned char *pixels = (*resultCode).data;
//    int width = (*resultCode).width;
//    int len = width * width;
//
//    if (imageWidth < width)
//        imageWidth = width;
//
//    // Set bit-fiddling variables
//    int bytesPerPixel = 4;
//    int bitsPerPixel = 8 * bytesPerPixel;
//    int bytesPerLine = bytesPerPixel * imageWidth;
//    int rawDataSize = bytesPerLine * imageWidth;
//
//    int pixelPerDot = imageWidth / width;
//    int offset = (int)((imageWidth - pixelPerDot * width) / 2);
//
//    // Allocate raw image buffer
//    unsigned char *rawData = (unsigned char*)malloc(rawDataSize);
//    memset(rawData, 0xFF, rawDataSize);
//
//    // Fill raw image buffer with image data from QR code matrix
//    int i;
//    for (i = 0; i < len; i++) {
//        char intensity = (pixels[i] & 1) ? 0 : 0xFF;
//
//        int y = i / width;
//        int x = i - (y * width);
//
//        int startX = pixelPerDot * x * bytesPerPixel + (bytesPerPixel * offset);
//        int startY = pixelPerDot * y + offset;
//        int endX = startX + pixelPerDot * bytesPerPixel;
//        int endY = startY + pixelPerDot;
//
//        int my;
//        for (my = startY; my < endY; my++) {
//            int mx;
//            for (mx = startX; mx < endX; mx += bytesPerPixel) {
//                rawData[bytesPerLine * my + mx    ] = intensity;    //red
//                rawData[bytesPerLine * my + mx + 1] = intensity;    //green
//                rawData[bytesPerLine * my + mx + 2] = intensity;    //blue
//                rawData[bytesPerLine * my + mx + 3] = 255;          //alpha
//            }
//        }
//    }
//
//    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, rawData, rawDataSize, (CGDataProviderReleaseDataCallback)&freeRawData);
//    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
//    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
//    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
//    CGImageRef imageRef = CGImageCreate(imageWidth, imageWidth, 8, bitsPerPixel, bytesPerLine, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
//
//    UIImage *quickResponseImage = [UIImage imageWithCGImage:imageRef];
//
//    CGImageRelease(imageRef);
//    CGColorSpaceRelease(colorSpaceRef);
//    CGDataProviderRelease(provider);
//    QRcode_free(resultCode);
//
//    return quickResponseImage;
//}



// handle tap even on map view
-(void) handleTapOnMap:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        StaticMapViewViewController *mapController = [self.storyboard instantiateViewControllerWithIdentifier:@"StaticMap"];
        mapController.event = self.event;
        [self.navigationController pushViewController:mapController animated:YES];
    }
}


-(void)viewDidAppear:(BOOL)animated{
    
}

-(void)viewWillAppear:(BOOL)animated{

    if([self.event objectForKey:@"isCancelled"]==[NSNumber numberWithBool:FALSE]){
        self.eventCancelSwitch.on = NO;
    }else{
        self.eventCancelSwitch.on = YES;
    }
    
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


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue: %@", segue.identifier);
    if ([segue.identifier isEqualToString:@"viewQR"]) {
        QRViewController *qrViewController = segue.destinationViewController;
        qrViewController.invitation = self.event;
    }
    
}
- (IBAction)cancelEvent:(id)sender {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    
    if (self.eventCancelSwitch.on) {
        
        //update the isCancelled field to TRUE of the specific event in Event table
        [query getObjectInBackgroundWithId:[self.event objectId] block:^(PFObject *event, NSError *error) {
            event[@"isCancelled"] = [NSNumber numberWithBool:TRUE];
            [event saveInBackground];
        }];
    } else {
        //update the isCancelled field to FALSE of the specific event in Event table
        [query getObjectInBackgroundWithId:[self.event objectId] block:^(PFObject *event, NSError *error) {
            event[@"isCancelled"] = [NSNumber numberWithBool:FALSE];
            [event saveInBackground];
        }];
    }
    
}
@end
