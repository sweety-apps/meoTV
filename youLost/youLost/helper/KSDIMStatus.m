//
//  KSDIMStatus.m
//  zaime
//
//  Created by 1528 MAC on 14-8-22.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import "KSDIMStatus.h"
static NSString * const AFAppDotNetAPIBaseURLString = @"http://192.168.1.117:3000";
@implementation KSDIMStatus

+ (instancetype)sharedClient {
    static KSDIMStatus *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[KSDIMStatus alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sharedClient.responseSerializer.acceptableContentTypes=  [NSSet setWithObjects:@"application/json", @"text/html", @"text/plain",@"image/jpeg", nil];
        
    });
    
    return _sharedClient;
}
- (void)isUserOnline :(NSString*)username :(void(^)(BOOL isOnline))complete :(void(^)(NSError *error))fail
{
    [self GET:[NSString stringWithFormat:@"/plugins/presence/status?jid=%@@127.0.0.1&type=text",username] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *resdata = responseObject;
        NSString *str =  [[NSString alloc]initWithData:resdata encoding:NSUTF8StringEncoding];
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        if(str.length > 0 && [str isEqualToString:@"Unavailable"])
        {
            complete(NO);
        }else
        {
            complete(YES);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if(fail)
        {
            fail(error);
        }
    }];
}
@end
