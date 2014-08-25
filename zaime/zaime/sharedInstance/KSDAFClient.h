//
//  AFAppDotNetAPIClient.h
//  zaime
//
//  Created by 1528 MAC on 14-8-8.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface KSDAFClient : AFHTTPSessionManager

+ (instancetype)sharedClient;
- (NSURLSessionDownloadTask*)downLoadFile :(NSString *)url;

@end
