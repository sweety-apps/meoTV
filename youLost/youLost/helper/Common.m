//
//  Common.m
//  youLost
//
//  Created by 1528 MAC on 14-9-8.
//  Copyright (c) 2014年 ksd. All rights reserved.
//

#import "Common.h"

@implementation Common
#import "SharedInstanceGCD.h"
SHARED_INSTANCE_GCD_USING_BLOCK(^{
    return [[self alloc]init];
})
@end
