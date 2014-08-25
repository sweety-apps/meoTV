//
//  KSDImageResize.h
//  zaime
//
//  Created by 1528 MAC on 14-8-25.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSDImageResize : NSObject

+ (instancetype)sharedInstance;
- (void)resizeWithImage :(UIImage*)image size:(CGSize)size handler:(void(^)(UIImage* result))handler;
@end
