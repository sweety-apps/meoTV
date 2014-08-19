//
//  Common.m
//  zaime
//
//  Created by 1528 MAC on 14-8-14.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import "Common.h"
#import "SharedInstanceGCD.h"

@implementation Common
@synthesize username=_username;


SHARED_INSTANCE_GCD_USING_BLOCK(^{
    return [[self alloc]init];
})

@end
