//
//  KSDImageStack.h
//  zaime
//
//  Created by 1528 MAC on 14-8-29.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSDImageStack : NSObject
{
    UIImageView *stack;
}

@property (strong, nonatomic) CIContext *context;
@property (strong, nonatomic) CIFilter *filter;
@property (strong, nonatomic) CIImage *beginImage;
+ (instancetype)sharedInstance;
- (void)transform :(UIImage*)image :(float)value :(void(^)(UIView *result))result;
@end
