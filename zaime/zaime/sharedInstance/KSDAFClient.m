//
//  AFAppDotNetAPIClient.m
//  zaime
//
//  Created by 1528 MAC on 14-8-8.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import "KSDAFClient.h"

static NSString * const AFAppDotNetAPIBaseURLString = @"http://yo.meme-da.com/";

@implementation KSDAFClient

+ (instancetype)sharedClient {
    static KSDAFClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[KSDAFClient alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient.requestSerializer = [[AFJSONRequestSerializer alloc]init];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
    });
    
    return _sharedClient;
}
- (NSURLSessionDownloadTask*)downLoadFile:(NSString *)url
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    __block NSURLSessionDownloadTask *task = [self downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        doc = [doc stringByAppendingPathComponent:@"12.gif"];
        return [NSURL URLWithString:doc];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
 
        NSLog(@"%@",filePath);
    }];
    
    [task resume];
    
    return task;
}

@end
