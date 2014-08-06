//
//  Common.m
//  yoforchinese
//
//  Created by NPHD on 14-8-4.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "Common.h"
#import "SharedInstanceGCD.h"
@implementation Common

SHARED_INSTANCE_GCD_USING_BLOCK(^{
    return [[self alloc]init];
})
@end
