//
//  ScannerViewController.m
//  Invite
//
//  Created by Madusha Perera on 3/25/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import "ScannerViewController.h"
#import "InBoxInvitationViewController.h"


@interface ScannerViewController ()

@end

@implementation ScannerViewController

NSString *currentUserEmail;
NSString *currentUserInBoxTableName;
NSString *currentUserEmailWithOnlyAlhpaCharaters;



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
	_isReading = NO;
    _captureSession = nil;
    [self loadBeepSound];
    [self startReading];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}



- (BOOL)startReading {
    NSError *error;
    
    // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
    // as the media type parameter.
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Get an instance of the AVCaptureDeviceInput class using the previous device object.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        // If any error occurs, simply log the description of it and don't continue any more.
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    // Initialize the captureSession object.
    _captureSession = [[AVCaptureSession alloc] init];
    // Set the input device on the capture session.
    [_captureSession addInput:input];
    
    
    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    
    // Start video capture.
    [_captureSession startRunning];
    
    return YES;
}


-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    // Check if the metadataObjects array is not nil and it contains at least one object.
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        // Get the metadata object.
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            // If the found metadata is equal to the QR code metadata 
            // stop reading and change the bar button item's title and the flag's value.
            // Everything is done on the main thread.
            
            // send the scanned string value to check whether its a valid invitation and if so add to the inbox
            [self performSelectorOnMainThread:@selector(addToInbox) withObject:[metadataObj stringValue] waitUntilDone:NO];
            
            [_scan performSelectorOnMainThread:@selector(setTitle:) withObject:@"Start!" waitUntilDone:NO];
            
            _isReading = NO;
            
            // If the audio player is not nil, then play the sound effect.
            if (_audioPlayer) {
                [_audioPlayer play];
            }
        }
    }
}


-(void)loadBeepSound{
    // Get the path to the beep.mp3 file and convert it to a NSURL object.
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    
    NSError *error;
    
    // Initialize the audio player object using the NSURL object previously set.
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        // If the audio player cannot be initialized then log a message.
        NSLog(@"Could not play beep file.");
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        // If the audio player was successfully initialized then load it in memory.
        [_audioPlayer prepareToPlay];
    }
}



-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    
    [_videoPreviewLayer removeFromSuperlayer];
}


-(void)addToInbox: (NSString*)eventID {

    
    // check whether this event exists in event table
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query getObjectInBackgroundWithId:eventID block:^(PFObject *event, NSError *error) {
        
        if (!error) {
            
            // if it exists in the event table check whether this event is already in the inbox table
            // get the email of cuurent user
            currentUserEmail = [[PFUser currentUser] objectForKey:@"email"];
            
            //create receiver_in_box table name
            currentUserEmailWithOnlyAlhpaCharaters = [currentUserEmail stringByReplacingOccurrencesOfString:@"@"withString:@""];
            currentUserEmailWithOnlyAlhpaCharaters = [currentUserEmailWithOnlyAlhpaCharaters stringByReplacingOccurrencesOfString:@"."withString:@""];
            
            //get the receiver inbox table name -> receiveremailwithout'@'and'.'_in_box
            currentUserInBoxTableName = [NSString stringWithFormat:@"%@_%@", currentUserEmailWithOnlyAlhpaCharaters, @"in_box"];
            
            
            PFQuery *query = [PFQuery queryWithClassName:currentUserInBoxTableName];
            [query getObjectInBackgroundWithId:eventID block:^(PFObject *inBoxEvent, NSError *error) {
                
                if (!error && (inBoxEvent[@"isDeleted"] = [NSNumber numberWithBool:TRUE])) {
                    
                    //get current date - time
                    NSDate *currDate = [NSDate date];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                    [dateFormatter setDateFormat:@"dd.MM.YY HH:mm:ss"];
                    NSString *dateString = [dateFormatter stringFromDate:currDate];
                    
                    // add the new event to the inBox
                    PFObject *event = [PFObject objectWithClassName:currentUserInBoxTableName];
                    [event setObject:eventID forKey:@"eventID"];
                    [event setObject:dateString forKey:@"dateSent"];
                    [event setObject:[NSNumber numberWithBool:FALSE] forKey:@"isDeleted"];
                    [event setObject:[NSNumber numberWithBool:TRUE] forKey:@"isPending"];
                    
                    //save to receiver_in_box table
                    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (!error) {
                            NSLog(@"data written to the inbox successfully");
                            //stop scanning
                            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
                            
                            // show the added event
                            [self performSelectorOnMainThread:@selector(showEvent) withObject:eventID waitUntilDone:NO];
                            
                        }else{
                            
                        }
                    }];
                
                }else if(!error && (inBoxEvent[@"isDeleted"] = [NSNumber numberWithBool:FALSE])){
                        // if it exists in the inbox without being deleted dont add the event otherwise it will add duplicate event
                }else{
                }
                
            }];
            
        }else{
            
        }
        
    }];
    
}


-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"view will disappear");
    [self stopReading];
}


-(void)showEvent: (NSString*)eventID{
    
    // get the object from inbox
    PFQuery *query = [PFQuery queryWithClassName:currentUserInBoxTableName];
    [query getObjectInBackgroundWithId:eventID block:^(PFObject *inboxEvent, NSError *error) {
       
        // show the event
        if(!error){
            InBoxInvitationViewController *inboxController = [self.storyboard instantiateViewControllerWithIdentifier:@"inboxInvitation"];
            inboxController.event = inboxEvent;
            NSLog(@"event name pushed : %@", [inboxController.event objectForKey:@"title"]);
            [self.navigationController pushViewController:inboxController animated:YES];

        }
        
    }];
}



@end
