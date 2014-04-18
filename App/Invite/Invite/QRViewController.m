//
//  QRViewController.m
//  Invite
//
//  Created by Madusha Perera on 4/11/14.
//  Copyright (c) 2014 Dhammini Fernando. All rights reserved.
//

#import "QRViewController.h"

@interface QRViewController ()

@end

@implementation QRViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    NSArray *temp = [[NSArray alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    
    [dict setValue:[self.invitation objectForKey:@"title"] forKey:@"title"];
    [dict setValue:[self.invitation objectForKey:@"address"] forKey:@"address"];
    [dict setValue:[self.invitation objectForKey:@"startTime"] forKey:@"startTime"];
    [dict setValue:[self.invitation objectForKey:@"endTime"] forKey:@"endTime"];
    [dict setValue:[self.invitation objectForKey:@"contactNo"] forKey:@"contactNo"];
    [dict setValue:[self.invitation objectForKey:@"eventDate"] forKey:@"eventDate"];
    [dict setValue:[self.invitation objectForKey:@"contactNo"] forKey:@"contactNo"];
    NSNumber *lat = [NSNumber numberWithDouble:[[self.invitation objectForKey:@"geoPoint"] latitude]];
    NSNumber *lon = [NSNumber numberWithDouble:[[self.invitation objectForKey:@"geoPoint"] longitude]];
    [dict setValue:[lat stringValue]  forKey:@"latitude"];
    [dict setValue:[lon stringValue]  forKey:@"longitude"];
    
    //Check the results
    NSLog(@"PFObject Info: %@", self.invitation);
    NSLog(@"dict Info: %@", dict);
    
    NSError *error;
    NSString *qrCodeString = @"";
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        qrCodeString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    UIImage *image = [self quickResponseImageForString:qrCodeString withDimension:182];
    
    //set the image
    [self.qrView setImage: image];
    
    
    // ---------------------------------
    
    
    NSString *jsonString = qrCodeString;
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"deode json : %@", json);
    NSLog(@"latitude : %@",[json objectForKey:@"latitude"]);

}
    
    
-(void)viewDidAppear:(BOOL)animated{
}



void freeRawData(void *info, const void *data, size_t size) {
    free((unsigned char *)data);
}

- (UIImage *)quickResponseImageForString:(NSString *)dataString withDimension:(int)imageWidth {
    
    QRcode *resultCode = QRcode_encodeString([dataString UTF8String], 0, QR_ECLEVEL_L, QR_MODE_8, 1);
    
    unsigned char *pixels = (*resultCode).data;
    int width = (*resultCode).width;
    int len = width * width;
    
    if (imageWidth < width)
        imageWidth = width;
    
    // Set bit-fiddling variables
    int bytesPerPixel = 4;
    int bitsPerPixel = 8 * bytesPerPixel;
    int bytesPerLine = bytesPerPixel * imageWidth;
    int rawDataSize = bytesPerLine * imageWidth;
    
    int pixelPerDot = imageWidth / width;
    int offset = (int)((imageWidth - pixelPerDot * width) / 2);
    
    // Allocate raw image buffer
    unsigned char *rawData = (unsigned char*)malloc(rawDataSize);
    memset(rawData, 0xFF, rawDataSize);
    
    // Fill raw image buffer with image data from QR code matrix
    int i;
    for (i = 0; i < len; i++) {
        char intensity = (pixels[i] & 1) ? 0 : 0xFF;
        
        int y = i / width;
        int x = i - (y * width);
        
        int startX = pixelPerDot * x * bytesPerPixel + (bytesPerPixel * offset);
        int startY = pixelPerDot * y + offset;
        int endX = startX + pixelPerDot * bytesPerPixel;
        int endY = startY + pixelPerDot;
        
        int my;
        for (my = startY; my < endY; my++) {
            int mx;
            for (mx = startX; mx < endX; mx += bytesPerPixel) {
                rawData[bytesPerLine * my + mx    ] = intensity;    //red
                rawData[bytesPerLine * my + mx + 1] = intensity;    //green
                rawData[bytesPerLine * my + mx + 2] = intensity;    //blue
                rawData[bytesPerLine * my + mx + 3] = 255;          //alpha
            }
        }
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, rawData, rawDataSize, (CGDataProviderReleaseDataCallback)&freeRawData);
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef imageRef = CGImageCreate(imageWidth, imageWidth, 8, bitsPerPixel, bytesPerLine, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
    UIImage *quickResponseImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    QRcode_free(resultCode);
    
    return quickResponseImage;
}




@end
