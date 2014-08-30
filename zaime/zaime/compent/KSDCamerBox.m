//
//  KSDCamerBox.m
//  zaime
//
//  Created by 1528 MAC on 14-8-27.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import "KSDCamerBox.h"

@implementation KSDCamerBox

- (id)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        UIView *top = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, ([[UIScreen mainScreen] bounds].size.height-[[UIScreen mainScreen] bounds].size.width)/2.f)];
        top.backgroundColor = [UIColor blackColor];
        top.alpha = 0.5;
        [self addSubview:top];
        
        UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-top.frame.size.height, [[UIScreen mainScreen] bounds].size.width, ([[UIScreen mainScreen] bounds].size.height-[[UIScreen mainScreen] bounds].size.width)/2.f)];
        bottom.backgroundColor = [UIColor blackColor];
        bottom.alpha = 0.5;
        [self addSubview:bottom];
    }
    return self;
}


@end
