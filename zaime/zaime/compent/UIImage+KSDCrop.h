//
//  UIImage+KSDCrop.h
//  zaime
//
//  Created by 1528 MAC on 14-8-27.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (KSDCrop)
+ (UIImage *)croppedImageWithImage :(UIImage*)originalImage :(CGRect)cropRect;
@end
