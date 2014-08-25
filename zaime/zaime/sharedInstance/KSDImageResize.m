//
//  KSDImageResize.m
//  zaime
//
//  Created by 1528 MAC on 14-8-25.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import "KSDImageResize.h"
#import "SharedInstanceGCD.h"
#import "BOSImageResizeOperation.h"

@implementation KSDImageResize
SHARED_INSTANCE_GCD_USING_BLOCK(^{
    return [[self alloc]init];
})
- (void)resizeWithImage:(UIImage *)image size:(CGSize)size handler:(void (^)(UIImage *))handler
{
   
    BACK(^{
        BOSImageResizeOperation *op = [[BOSImageResizeOperation alloc]initWithImage:image];
        [op resizeToFitWithinSize:size];
        [op start];
        UIImage *result = [op result];
        MAIN(^{
            if(handler)
            {
                handler(result);
            }
        });
    });
}
@end
