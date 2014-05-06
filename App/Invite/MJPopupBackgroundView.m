//
//  MJPopupBackgroundView.m
//  watched
//
//  Created by Martin Juhasz on 18.06.12.
//  Copyright (c) 2012 martinjuhasz.de. All rights reserved.
//

#import "MJPopupBackgroundView.h"
#import "AppDelegate.h"

@implementation MJPopupBackgroundView


- (void)drawRect:(CGRect)rect
{
    //CGContextRef context = UIGraphicsGetCurrentContext();
//    size_t locationsCount = 2;
//    CGFloat locations[2] = {0.0f, 1.0f};
//    CGFloat colors[8] = {0.3f,0.3f,0.3f,0.3f,0.3f,0.3f,0.3f,0.3f};
//    
  //  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  //  CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
  //  CGColorSpaceRelease(colorSpace);
    
  //  CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
 //   float radius = MIN(self.bounds.size.width , self.bounds.size.height) ;
//    CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
//    CGGradientRelease(gradient);
    
    //Get a UIImage from the UIView
    AppDelegate *sharedObject = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIImage *viewImg = [sharedObject getCurrentScreen];
    
//    //Blur the UIImage with a CIFilter
//    CIImage *imageToBlur = [CIImage imageWithCGImage:viewImage.CGImage];
//    CIFilter *gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
//    [gaussianBlurFilter setValue:imageToBlur forKey: @"inputImage"];
//    [gaussianBlurFilter setValue:[NSNumber numberWithFloat: 10] forKey: @"inputRadius"];
//    CIImage *resultImage = [gaussianBlurFilter valueForKey: @"outputImage"];
//    UIImage *endImage = [[UIImage alloc] initWithCIImage:resultImage];
//    
//    //Place the UIImage in a UIImageView
//    UIImageView *newView = [[UIImageView alloc] initWithFrame:self.bounds];
//    newView.image = endImage;
//    [endImage drawAtPoint:CGPointMake(0, 0)];
//    
//    //CGContextDrawImage(context, rect, endImage.CGImage);
//   // UIGraphicsEndImageContext();
    
    
    
    //Blur the image
    CIImage *blurImg = [CIImage imageWithCGImage:viewImg.CGImage];
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CIFilter *clampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
    [clampFilter setValue:blurImg forKey:@"inputImage"];
    [clampFilter setValue:[NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)] forKey:@"inputTransform"];
    
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
    [gaussianBlurFilter setValue:clampFilter.outputImage forKey: @"inputImage"];
    [gaussianBlurFilter setValue:[NSNumber numberWithFloat:2.9] forKey:@"inputRadius"];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImg = [context createCGImage:gaussianBlurFilter.outputImage fromRect:[blurImg extent]];
    UIImage *outputImg = [UIImage imageWithCGImage:cgImg];
    
    //Add UIImageView to current view.
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.viewImage.bounds];
//    imgView.image = outputImg;
//    [self.view addSubview:imgView];
    
    
    CGRect cropRect = CGRectMake(0, 0, 320, 460);
    CGImageRef imageRef = CGImageCreateWithImageInRect([outputImg CGImage], cropRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    [croppedImage drawAtPoint:CGPointMake(0, 65)];
}

- (void) setImage{

    UIApplication *appDelegate =[UIApplication sharedApplication];
    
}


@end
