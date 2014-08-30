//
//  KSDImageStack.m
//  zaime
//
//  Created by 1528 MAC on 14-8-29.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import "KSDImageStack.h"
#import "SharedInstanceGCD.h"
#import "KSDImageResize.h"
@implementation KSDImageStack
SHARED_INSTANCE_GCD_USING_BLOCK(^{
    return [[self alloc]init];
})
- (id)init
{
    self = [super init];
    if(self)
    {
        self.context = [CIContext contextWithOptions: nil];
        self.filter = [CIFilter filterWithName:@"CIStraightenFilter"];
        stack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
        
    }
    return self;
}
- (void)transform :(UIImage*)image :(float)value :(void(^)(UIView *result))aresult
{
 
        CGSize dest = CGSizeZero;
        float kAvatarSize = 160;
        if(image.size.width > image.size.height)
        {
            dest.height = kAvatarSize;
            dest.width = image.size.width/(image.size.height/kAvatarSize);
        }else
        {
            dest.width = kAvatarSize;
            dest.height = image.size.height/(image.size.width/kAvatarSize);
        }
        [[KSDImageResize sharedInstance] resizeWithImage:image size:dest handler:^(UIImage *result) {
            
            self.beginImage = [CIImage imageWithCGImage:result.CGImage];
            [self.filter setValue:self.beginImage forKey:kCIInputImageKey];
            [self.filter setValue:[NSNumber numberWithFloat:0.2] forKey:@"inputAngle"];
            
            // 得到过滤后的图片
            CIImage *outputImage = [self.filter outputImage];
            // 转换图片
            CGImageRef cgimg = [self.context createCGImage:outputImage fromRect:[outputImage extent]];
            UIImage *newImg = [UIImage imageWithCGImage:cgimg];
            [stack setImage:newImg];
            CGImageRelease(cgimg);
            if(aresult)
            {
                aresult(stack);
            }
        }];

    
   
}
@end
