//
//  ScannerViewController.h
//  Invite
//
//  Created by Madusha Perera on 3/25/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface ScannerViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *scan;
@property (nonatomic) BOOL isReading;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

-(BOOL)startReading;
-(void)stopReading;
-(void)loadBeepSound;
-(void)addToInbox: (NSString*)eventID;
-(BOOL)isValidInvitation: (NSString*)eventID;

- (IBAction)startStopReading:(id)sender;



@end
