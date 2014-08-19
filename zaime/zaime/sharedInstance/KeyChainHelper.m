//
//  KeyChainHelper.m
//  yoforchinese
//
//  Created by NPHD on 14-8-5.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "KeyChainHelper.h"
#import "KeychainItemWrapper.h"
#import "config.h"
@implementation KeyChainHelper

SHARED_INSTANCE_GCD_USING_BLOCK(^{
    return [[self alloc]init];
})
- (void)reset
{
    KeychainItemWrapper *wapper = [[KeychainItemWrapper alloc]initWithIdentifier:keychainGroup accessGroup:nil];
    [wapper resetKeychainItem];
}
- (void)saveAccount :(NSString*)acc
{
    KeychainItemWrapper *wapper = [[KeychainItemWrapper alloc]initWithIdentifier:keychainGroup accessGroup:nil];
    [wapper setObject:acc forKey:(__bridge id)(kSecAttrAccount)];
}
- (void)savePass :(NSString*)pass
{
    
    KeychainItemWrapper *wapper = [[KeychainItemWrapper alloc]initWithIdentifier:keychainGroup accessGroup:nil];
    [wapper setObject:pass forKey:(__bridge id)(kSecValueData)];
}
- (NSString*)getAccount
{
    KeychainItemWrapper *wapper = [[KeychainItemWrapper alloc]initWithIdentifier:keychainGroup accessGroup:nil];
    return [wapper objectForKey:(__bridge id)(kSecAttrAccount)];
}
- (NSString*)getPass
{
    KeychainItemWrapper *wapper = [[KeychainItemWrapper alloc]initWithIdentifier:keychainGroup accessGroup:nil];
    return [wapper objectForKey:(__bridge id)(kSecValueData)];
}
@end
