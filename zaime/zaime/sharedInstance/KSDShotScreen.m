//
//  shotScreenModel.m
//  zaime
//
//  Created by 1528 MAC on 14-8-14.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import "KSDShotScreen.h"
#import "SharedInstanceGCD.h"
@implementation KSDShotScreen

SHARED_INSTANCE_GCD_USING_BLOCK(^{
    return [[self alloc]init];
})
//根据 rect 截屏
-(UIImage*)captureView:(UIView *)theView frame:(CGRect)fra
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef ref = CGImageCreateWithImageInRect(img.CGImage, fra);
    UIImage *i = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
    return i;
}

@end


