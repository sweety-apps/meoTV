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
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       BOSImageResizeOperation *op = [[BOSImageResizeOperation alloc]initWithImage:image];
       [op resizeToFitWithinSize:size];
       [op start];
       UIImage *result = [op result];
       dispatch_async(dispatch_get_main_queue(), ^{
           if(handler)
           {
               handler(result);
           }
       });
   });
    
}
@end
