//
//  UIImage+KSDCrop.m
//  zaime
//
//  Created by 1528 MAC on 14-8-27.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import "UIImage+KSDCrop.h"

@implementation UIImage (KSDCrop)
+ (UIImage *)croppedImageWithImage :(UIImage*)originalImage :(CGRect)cropRect
{
    
    CGAffineTransform rotateTransform = CGAffineTransformIdentity;
    
    switch (originalImage.imageOrientation) {
        case UIImageOrientationDown:
            rotateTransform = CGAffineTransformRotate(rotateTransform, M_PI);
            rotateTransform = CGAffineTransformTranslate(rotateTransform, -originalImage.size.width, -originalImage.size.height);
            break;
            
        case UIImageOrientationLeft:
            rotateTransform = CGAffineTransformRotate(rotateTransform, M_PI_2);
            rotateTransform = CGAffineTransformTranslate(rotateTransform, 0.0, -originalImage.size.height);
            break;
            
        case UIImageOrientationRight:
            rotateTransform = CGAffineTransformRotate(rotateTransform, -M_PI_2);
            rotateTransform = CGAffineTransformTranslate(rotateTransform, -originalImage.size.width, 0.0);
            break;
            
        default:
            break;
    }
    
    CGRect rotatedCropRect = CGRectApplyAffineTransform(cropRect, rotateTransform);
    
    CGImageRef croppedImage = CGImageCreateWithImageInRect([originalImage CGImage], rotatedCropRect);
    UIImage *result = [UIImage imageWithCGImage:croppedImage scale:[UIScreen mainScreen].scale orientation:originalImage.imageOrientation];
    CGImageRelease(croppedImage);
    
    return result;
}
@end
