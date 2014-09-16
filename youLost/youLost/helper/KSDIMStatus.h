//
//  KSDIMStatus.h
//  zaime
//
//  Created by 1528 MAC on 14-8-22.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
@interface KSDIMStatus : AFHTTPSessionManager
+ (instancetype)sharedClient;
- (void)isUserOnline :(NSString*)username :(void(^)(BOOL isOnline))complete :(void(^)(NSError *error))fail;
@end
