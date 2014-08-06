//
//  KeyChainHelper.h
//  yoforchinese
//
//  Created by NPHD on 14-8-5.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SharedInstanceGCD.h"
@interface KeyChainHelper : NSObject
+ (instancetype)sharedInstance;
- (void)reset;
- (void)saveAccount :(NSString*)acc;
- (void)savePass :(NSString*)pass;
- (NSString*)getAccount;
- (NSString*)getPass;
@end